import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hojaty/features/hifz/data/datasources/hifz_local_dao.dart';
import 'package:hojaty/features/hifz/data/models/reciter_registry.dart';
import 'package:hojaty/features/hifz/domain/entities/cached_audio_entry.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';
import 'package:hojaty/features/hifz/engine/hifz_platform_channel.dart';
import 'package:path_provider/path_provider.dart';

/// Atomic offline-first audio cache manager with EveryAyah -> Islamic Network
/// fallback, sliding-window prefetching, and 150 MB -> 120 MB LRU eviction.
class AudioCacheManager {
  static const int minValidMp3Bytes = 2048;
  static const int maxUnpinnedCacheBytes = 150 * 1024 * 1024;
  static const int targetUnpinnedCacheBytes = 120 * 1024 * 1024;
  static const int maxConcurrentDownloads = 3;

  final Dio dio;
  final HifzLocalDao localDao;

  Directory? _baseDir;
  bool _backupExcluded = false;
  bool _evicting = false;
  final Map<String, Future<String>> _inFlight = {};

  AudioCacheManager({
    required this.dio,
    required this.localDao,
  });

  Future<Directory> _getBaseDir() async {
    if (_baseDir != null) return _baseDir!;
    final supportDir = await getApplicationSupportDirectory();
    final dir = Directory('${supportDir.path}/hifz_audio');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    if (!_backupExcluded) {
      _backupExcluded = true;
      await HifzPlatformChannel.excludeFromBackup(dir.path);
    }
    _baseDir = dir;
    return dir;
  }

  static String buildCacheKey(String reciterId, int surah, int ayah) {
    final sss = GlobalAyahMapper.padThree(surah);
    final aaa = GlobalAyahMapper.padThree(ayah);
    return '${reciterId}_$sss$aaa';
  }

  Future<File> _fileFor(String reciterId, int surah, int ayah) async {
    final base = await _getBaseDir();
    final reciterDir = Directory('${base.path}/$reciterId');
    if (!reciterDir.existsSync()) {
      reciterDir.createSync(recursive: true);
    }
    final sss = GlobalAyahMapper.padThree(surah);
    final aaa = GlobalAyahMapper.padThree(ayah);
    return File('${reciterDir.path}/$sss$aaa.mp3');
  }

  /// Returns a valid local MP3 file path, downloading atomically if absent.
  Future<String> getOrDownload({
    required Reciter reciter,
    required int surah,
    required int ayah,
    required AudioQuality quality,
    bool isPinned = false,
    CancelToken? cancelToken,
  }) async {
    final file = await _fileFor(reciter.id, surah, ayah);
    final cacheKey = buildCacheKey(reciter.id, surah, ayah);

    if (file.existsSync() && file.lengthSync() > minValidMp3Bytes) {
      unawaited(localDao.touchCacheEntry(cacheKey, DateTime.now()));
      return file.path;
    }

    final existing = _inFlight[cacheKey];
    if (existing != null) {
      return existing;
    }

    final future = _downloadWithFallback(
      file: file,
      cacheKey: cacheKey,
      reciter: reciter,
      surah: surah,
      ayah: ayah,
      quality: quality,
      isPinned: isPinned,
      cancelToken: cancelToken,
    );
    _inFlight[cacheKey] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(cacheKey);
    }
  }

  Future<String> _downloadWithFallback({
    required File file,
    required String cacheKey,
    required Reciter reciter,
    required int surah,
    required int ayah,
    required AudioQuality quality,
    required bool isPinned,
    CancelToken? cancelToken,
  }) async {
    final primaryUrl = ReciterRegistry.primaryUrl(
      reciter,
      surah,
      ayah,
      quality,
    );
    final globalId = GlobalAyahMapper.toGlobalAyahId(surah, ayah);
    final fallbackUrl = ReciterRegistry.fallbackUrl(reciter, globalId, quality);

    final primaryOk = await _attemptAtomicDownload(
      url: primaryUrl,
      targetFile: file,
      timeout: const Duration(seconds: 5),
      cancelToken: cancelToken,
    );

    if (!primaryOk) {
      final fallbackOk = await _attemptAtomicDownload(
        url: fallbackUrl,
        targetFile: file,
        timeout: const Duration(seconds: 10),
        cancelToken: cancelToken,
      );
      if (!fallbackOk) {
        throw DioException(
          requestOptions: RequestOptions(path: fallbackUrl),
          message: 'Failed to download ayah $surah:$ayah from primary & fallback',
        );
      }
    }

    final sizeBytes = file.lengthSync();
    await localDao.upsertCacheEntry(
      CachedAudioEntry(
        cacheKey: cacheKey,
        reciterId: reciter.id,
        surahId: surah,
        fileSizeBytes: sizeBytes,
        isPinned: isPinned,
        lastAccessedAt: DateTime.now(),
      ),
    );

    if (!isPinned) {
      unawaited(_evictLruIfNeeded());
    }

    return file.path;
  }

  Future<bool> _attemptAtomicDownload({
    required String url,
    required File targetFile,
    required Duration timeout,
    CancelToken? cancelToken,
  }) async {
    final tmpFile = File('${targetFile.path}.tmp');
    try {
      if (tmpFile.existsSync()) {
        tmpFile.deleteSync();
      }
      final response = await dio.download(
        url,
        tmpFile.path,
        cancelToken: cancelToken,
        options: Options(
          receiveTimeout: timeout,
          sendTimeout: timeout,
          validateStatus: (status) => status == 200,
        ),
      );
      if (response.statusCode != 200 ||
          !tmpFile.existsSync() ||
          tmpFile.lengthSync() <= minValidMp3Bytes) {
        if (tmpFile.existsSync()) {
          tmpFile.deleteSync();
        }
        return false;
      }
      if (targetFile.existsSync()) {
        targetFile.deleteSync();
      }
      tmpFile.renameSync(targetFile.path);
      return true;
    } on DioException catch (e) {
      if (tmpFile.existsSync()) {
        tmpFile.deleteSync();
      }
      if (CancelToken.isCancel(e)) rethrow;
      return false;
    } catch (_) {
      if (tmpFile.existsSync()) {
        tmpFile.deleteSync();
      }
      return false;
    }
  }

  /// Concurrently pre-fetches up to [windowSize] ayahs with bounded concurrency (3).
  Future<void> prefetchWindow({
    required Reciter reciter,
    required List<int> globalAyahIds,
    required AudioQuality quality,
    int windowSize = 3,
  }) async {
    if (globalAyahIds.isEmpty) return;
    final targets = globalAyahIds.take(windowSize).toList(growable: false);
    final chunks = <List<int>>[];
    for (int i = 0; i < targets.length; i += maxConcurrentDownloads) {
      final end = (i + maxConcurrentDownloads).clamp(0, targets.length);
      chunks.add(targets.sublist(i, end));
    }

    for (final chunk in chunks) {
      await Future.wait(
        chunk.map((globalId) async {
          try {
            final mapped = GlobalAyahMapper.fromGlobalAyahId(globalId);
            await getOrDownload(
              reciter: reciter,
              surah: mapped.surah,
              ayah: mapped.ayah,
              quality: quality,
            );
          } catch (_) {
            // Prefetch failures are non-fatal; handled on active step.
          }
        }),
      );
    }
  }

  /// Downloads and pins an entire surah for offline memorization.
  Future<void> downloadSurah({
    required Reciter reciter,
    required int surahId,
    required AudioQuality quality,
    required void Function(int completed, int total) onProgress,
    CancelToken? cancelToken,
  }) async {
    final total = GlobalAyahMapper.surahAyahCount(surahId);
    int completed = 0;
    onProgress(0, total);

    int nextAyah = 1;
    Future<void> worker() async {
      while (nextAyah <= total) {
        if (cancelToken?.isCancelled ?? false) return;
        final ayah = nextAyah++;
        await getOrDownload(
          reciter: reciter,
          surah: surahId,
          ayah: ayah,
          quality: quality,
          isPinned: true,
          cancelToken: cancelToken,
        );
        completed++;
        onProgress(completed, total);
      }
    }

    await Future.wait(
      List.generate(maxConcurrentDownloads, (_) => worker()),
    );
  }

  /// Returns cache status for each global ayah ID in [globalAyahIds].
  Future<Map<int, AudioCacheStatus>> getCacheStatuses(
    Reciter reciter,
    List<int> globalAyahIds,
  ) async {
    final result = <int, AudioCacheStatus>{};
    for (final globalId in globalAyahIds) {
      final mapped = GlobalAyahMapper.fromGlobalAyahId(globalId);
      final file = await _fileFor(reciter.id, mapped.surah, mapped.ayah);
      final isCached =
          file.existsSync() && file.lengthSync() > minValidMp3Bytes;
      result[globalId] =
          isCached ? AudioCacheStatus.cached : AudioCacheStatus.notCached;
    }
    return result;
  }

  /// Checks synchronously if an ayah file is already cached on disk.
  Future<bool> isAyahCached(Reciter reciter, int surah, int ayah) async {
    final file = await _fileFor(reciter.id, surah, ayah);
    return file.existsSync() && file.lengthSync() > minValidMp3Bytes;
  }

  Future<void> _evictLruIfNeeded() async {
    if (_evicting) return;
    _evicting = true;
    try {
      int totalUnpinned = await localDao.getTotalCachedBytes(isPinned: false);
      if (totalUnpinned <= maxUnpinnedCacheBytes) return;

      final entries = await localDao.getUnpinnedEntriesOldestFirst();
      final base = await _getBaseDir();
      final deletedKeys = <String>[];

      for (final entry in entries) {
        if (totalUnpinned <= targetUnpinnedCacheBytes) break;
        final parts = entry.cacheKey.split('_');
        if (parts.length >= 2) {
          final code = parts.last;
          final reciterId = entry.reciterId;
          final file = File('${base.path}/$reciterId/$code.mp3');
          if (file.existsSync()) {
            try {
              file.deleteSync();
            } catch (_) {}
          }
        }
        totalUnpinned -= entry.fileSizeBytes;
        deletedKeys.add(entry.cacheKey);
      }

      if (deletedKeys.isNotEmpty) {
        await localDao.deleteCacheKeys(deletedKeys);
      }
    } finally {
      _evicting = false;
    }
  }

  /// Deletes all unpinned temporary cache files.
  Future<void> clearUnpinnedCache() async {
    final entries = await localDao.getUnpinnedEntriesOldestFirst();
    final base = await _getBaseDir();
    for (final entry in entries) {
      final parts = entry.cacheKey.split('_');
      if (parts.length >= 2) {
        final code = parts.last;
        final file = File('${base.path}/${entry.reciterId}/$code.mp3');
        if (file.existsSync()) {
          try {
            file.deleteSync();
          } catch (_) {}
        }
      }
    }
    await localDao.deleteUnpinnedEntries();
  }

  /// Deletes all cached audio files for a specific reciter + surah.
  Future<void> deleteSurahCache(String reciterId, int surahId) async {
    final entries = await localDao.getEntriesForSurah(reciterId, surahId);
    final base = await _getBaseDir();
    for (final entry in entries) {
      final parts = entry.cacheKey.split('_');
      if (parts.length >= 2) {
        final code = parts.last;
        final file = File('${base.path}/$reciterId/$code.mp3');
        if (file.existsSync()) {
          try {
            file.deleteSync();
          } catch (_) {}
        }
      }
    }
    await localDao.deleteEntriesForSurah(reciterId, surahId);
  }
}

