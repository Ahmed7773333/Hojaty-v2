import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/utils/play_asset_delivery_service.dart';
import '../models/rag_chunk_model.dart';

class _ScoredChunkId {
  final int id;
  final double similarity;

  const _ScoredChunkId({required this.id, required this.similarity});
}

class _IsolateSearchPayload {
  final String binPath;
  final Float32List queryVector;
  final double minSimilarity;
  final int topK;

  const _IsolateSearchPayload({
    required this.binPath,
    required this.queryVector,
    required this.minSimilarity,
    required this.topK,
  });
}

class RagDatabaseService {
  Database? _database;
  String? _embeddingsBinPath;
  bool _isInitializing = false;

  /// Initializes the SQLite database and ensures the binary embeddings index is ready.
  Future<void> init() async {
    if (_database != null && _database!.isOpen && _embeddingsBinPath != null) {
      return;
    }

    if (_isInitializing) {
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }

    _isInitializing = true;
    try {
      final dbPath = await _resolveDatabasePath();
      _database = await openDatabase(dbPath, readOnly: true);

      final databasesDir = await getDatabasesPath();
      final binPath = p.join(databasesDir, 'hojaty_embeddings.bin');
      _embeddingsBinPath = binPath;

      await _ensureEmbeddingsBinaryIndex(binPath);
      debugPrint('RagDatabaseService: Ready with DB ($dbPath) and binary index ($binPath)');
    } catch (e, st) {
      debugPrint('RagDatabaseService initialization error: $e\n$st');
    } finally {
      _isInitializing = false;
    }
  }

  Future<String> _resolveDatabasePath() async {
    if (kDebugMode) {
      return _resolveDebugDatabasePath();
    } else {
      return _resolveProductionDatabasePath();
    }
  }

  /// PRODUCTION RESOLUTION:
  /// Strictly relies on Play Asset Delivery (:hojaty_rag) and local production assets.
  /// Never attempts to read or touch assets/debug/.
  Future<String> _resolveProductionDatabasePath() async {
    debugPrint('RagDatabaseService [PROD]: Resolving database via Play Asset Delivery...');

    // 1. Direct installed asset pack path via Play Asset Delivery
    final packPath = await PlayAssetDeliveryService.getAssetPackPath('hojaty_rag');
    if (packPath != null && packPath.isNotEmpty) {
      final packFile = File(p.join(packPath, 'hojaty_rag.db'));
      if (await packFile.exists()) {
        debugPrint('RagDatabaseService [PROD]: Found DB in Play Asset Delivery: ${packFile.path}');
        return packFile.path;
      }
    }

    // 2. Check asset pack status (handles cases where assetsPath is reported by Play Core state)
    final info = await PlayAssetDeliveryService.getAssetPackStatus('hojaty_rag');
    if (info.isDownloaded && info.assetsPath != null && info.assetsPath!.isNotEmpty) {
      final packFile = File(p.join(info.assetsPath!, 'hojaty_rag.db'));
      if (await packFile.exists()) {
        debugPrint('RagDatabaseService [PROD]: Found DB via Asset Delivery Status: ${packFile.path}');
        return packFile.path;
      }
    }

    // 3. Fallback for release testing on non-Play environments (e.g. desktop/local release run)
    final directProdFile = File('android/hojaty_rag/src/main/assets/hojaty_rag.db');
    if (await directProdFile.exists()) {
      debugPrint('RagDatabaseService [PROD]: Found DB in local production module: ${directProdFile.path}');
      return directProdFile.path;
    }

    // 4. If asset pack is on-demand and download is needed
    if (!info.isDownloaded && Platform.isAndroid) {
      debugPrint('RagDatabaseService [PROD]: Asset pack "hojaty_rag" is not yet downloaded. Requesting download...');
      final started = await PlayAssetDeliveryService.startDownload('hojaty_rag');
      if (started) {
        final completer = Completer<String>();
        late StreamSubscription sub;
        sub = PlayAssetDeliveryService.downloadProgressStream.listen((event) async {
          if (event.packName == 'hojaty_rag') {
            if (event.isDownloaded && event.assetsPath != null) {
              final packFile = File(p.join(event.assetsPath!, 'hojaty_rag.db'));
              if (await packFile.exists() && !completer.isCompleted) {
                completer.complete(packFile.path);
              }
            } else if (event.status == AssetPackStateStatus.failed ||
                event.status == AssetPackStateStatus.canceled) {
              if (!completer.isCompleted) {
                completer.completeError(
                  Exception('Failed to download hojaty_rag pack (code: ${event.errorCode})'),
                );
              }
            }
          }
        });

        try {
          return await completer.future.timeout(
            const Duration(minutes: 5),
            onTimeout: () => throw TimeoutException('Asset pack download timed out'),
          );
        } finally {
          await sub.cancel();
        }
      }
    }

    throw Exception('RagDatabaseService [PROD]: hojaty_rag.db not found in Play Asset Delivery!');
  }

  /// DEBUG RESOLUTION:
  /// Strictly used in debug mode (kDebugMode) during development and testing.
  /// Copies assets/debug/hojaty_rag.db to local app databases directory.
  Future<String> _resolveDebugDatabasePath() async {
    debugPrint('RagDatabaseService [DEBUG]: Resolving database for local debug...');
    final databasesDir = await getDatabasesPath();
    final targetPath = p.join(databasesDir, 'hojaty_rag.db');
    final targetFile = File(targetPath);

    if (await targetFile.exists() && await targetFile.length() > 10 * 1024 * 1024) {
      debugPrint('RagDatabaseService [DEBUG]: Using cached debug DB at: $targetPath');
      return targetPath;
    }

    await targetFile.parent.create(recursive: true);

    const assetCandidates = ['assets/debug/hojaty_rag.db'];
    for (final assetPath in assetCandidates) {
      try {
        final byteData = await rootBundle.load(assetPath);
        final buffer = byteData.buffer;
        await targetFile.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
          flush: true,
        );
        debugPrint('RagDatabaseService [DEBUG]: Copied DB from Flutter asset: $assetPath');
        return targetPath;
      } catch (_) {}
    }

    // Direct filesystem fallback if running standalone tests or scripts
    final directDebugFile = File('assets/debug/hojaty_rag.db');
    if (await directDebugFile.exists()) {
      debugPrint('RagDatabaseService [DEBUG]: Using direct debug file at: ${directDebugFile.path}');
      return directDebugFile.path;
    }

    throw Exception('RagDatabaseService [DEBUG]: Could not find hojaty_rag.db in assets/debug/!');
  }

  /// Builds the local binary embeddings index file in small, safe batches to avoid Android JVM heap OOM.
  /// Each record: 4-byte uint32 ID + 2048-byte Float32List (2052 bytes total).
  Future<void> _ensureEmbeddingsBinaryIndex(String binPath) async {
    final binFile = File(binPath);
    // If the binary index file exists and is larger than 10MB, it is already built
    if (await binFile.exists() && await binFile.length() > 10 * 1024 * 1024) {
      debugPrint('RagDatabaseService: Using existing binary index (${(await binFile.length() / (1024 * 1024)).toStringAsFixed(1)} MB)');
      return;
    }

    debugPrint('RagDatabaseService: Building binary embeddings index in safe batches...');
    final tempFile = File('$binPath.tmp');
    if (await tempFile.exists()) await tempFile.delete();
    final sink = tempFile.openWrite(mode: FileMode.writeOnly);

    try {
      // 2000 rows = ~4MB across MethodChannel, completely safe for Android JVM
      const int batchSize = 2000;
      int offset = 0;
      int totalProcessed = 0;

      while (true) {
        final rows = await _database!.rawQuery(
          'SELECT id, embedding FROM chunks LIMIT ? OFFSET ?',
          [batchSize, offset],
        );

        if (rows.isEmpty) break;

        final builder = BytesBuilder(copy: false);
        for (final row in rows) {
          final id = (row['id'] as num?)?.toInt();
          final rawBlob = row['embedding'];
          if (id != null && rawBlob is Uint8List && rawBlob.lengthInBytes >= 2048) {
            final idBytes = Uint8List(4)
              ..buffer.asByteData().setUint32(0, id, Endian.little);
            builder.add(idBytes);
            builder.add(rawBlob.sublist(0, 2048));
            totalProcessed++;
          }
        }

        sink.add(builder.takeBytes());
        offset += rows.length;
        if (rows.length < batchSize) break;
      }

      await sink.flush();
      await sink.close();
      await tempFile.rename(binPath);
      debugPrint('RagDatabaseService: Successfully indexed $totalProcessed records to $binPath');
    } catch (e, st) {
      debugPrint('RagDatabaseService: Error building binary index: $e\n$st');
      try {
        await sink.close();
      } catch (_) {}
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// Searches the database for the Top [topK] chunks with similarity >= [minSimilarity].
  /// Runs inside a background Isolate.run(...) reading from the binary index file,
  /// avoiding MethodChannel overhead and keeping UI at 60/120 FPS.
  Future<List<RagChunkModel>> searchTopK(
    List<double> queryVector, {
    int topK = 6,
    double minSimilarity = 0.40,
  }) async {
    await init();
    final db = _database;
    final binPath = _embeddingsBinPath;

    if (db == null || binPath == null || queryVector.length != 512) {
      return const [];
    }

    final binFile = File(binPath);
    if (!await binFile.exists()) {
      return const [];
    }

    final queryFloats = Float32List.fromList(queryVector);

    final payload = _IsolateSearchPayload(
      binPath: binPath,
      queryVector: queryFloats,
      minSimilarity: minSimilarity,
      topK: topK,
    );

    final List<_ScoredChunkId> topScored = await Isolate.run(
      () => _isolateVectorSearch(payload),
    );

    if (topScored.isEmpty) {
      return const [];
    }

    final idList = topScored.map((s) => s.id).toList();
    final placeholders = List.filled(idList.length, '?').join(',');
    final rows = await db.rawQuery(
      'SELECT id, category, source_title, reference, content FROM chunks WHERE id IN ($placeholders)',
      idList,
    );

    final scoreMap = {for (final s in topScored) s.id: s.similarity};
    final models = <RagChunkModel>[];

    for (final row in rows) {
      final id = (row['id'] as num?)?.toInt() ?? 0;
      final score = scoreMap[id] ?? 0.0;
      models.add(RagChunkModel.fromMap(row, similarity: score));
    }

    models.sort((a, b) => b.similarity.compareTo(a.similarity));
    return models;
  }

  /// Background Isolate worker: reads binary index and performs cosine similarity search.
  static List<_ScoredChunkId> _isolateVectorSearch(_IsolateSearchPayload payload) {
    final file = File(payload.binPath);
    if (!file.existsSync()) return const [];

    final bytes = file.readAsBytesSync();
    final query = payload.queryVector;
    final minSimilarity = payload.minSimilarity;
    final topK = payload.topK;

    double queryNormSq = 0.0;
    for (int i = 0; i < 512; i++) {
      final v = query[i];
      queryNormSq += v * v;
    }
    final queryNorm = math.sqrt(queryNormSq);
    if (queryNorm <= 0.0) return const [];

    final candidates = <_ScoredChunkId>[];
    final totalRecords = bytes.lengthInBytes ~/ 2052;
    final view = ByteData.sublistView(bytes);

    for (int i = 0; i < totalRecords; i++) {
      final offset = i * 2052;
      final id = view.getUint32(offset, Endian.little);

      final chunkVector = bytes.buffer.asFloat32List(
        bytes.offsetInBytes + offset + 4,
        512,
      );

      double dot = 0.0;
      double chunkNormSq = 0.0;
      for (int j = 0; j < 512; j++) {
        final q = query[j];
        final c = chunkVector[j];
        dot += q * c;
        chunkNormSq += c * c;
      }

      final chunkNorm = math.sqrt(chunkNormSq);
      if (chunkNorm <= 0.0) continue;

      final similarity = dot / (queryNorm * chunkNorm);
      if (similarity >= minSimilarity) {
        candidates.add(_ScoredChunkId(id: id, similarity: similarity));
      }
    }

    candidates.sort((a, b) => b.similarity.compareTo(a.similarity));
    if (candidates.length > topK) {
      return candidates.sublist(0, topK);
    }
    return candidates;
  }

  /// Fallback search by keywords directly in SQLite when offline or embedding API is unreachable.
  Future<List<RagChunkModel>> searchByKeywords(
    String query, {
    int limit = 6,
  }) async {
    await init();
    final db = _database;
    if (db == null) return const [];

    final stopWords = {
      'من',
      'إلى',
      'عن',
      'على',
      'في',
      'مع',
      'هذا',
      'هذه',
      'تم',
      'كان',
      'أو',
      'ثم',
      'ما',
      'هو',
      'هي',
      'أن',
      'إن',
      'هل',
      'لا',
      'لم',
      'لن',
      'كيف',
      'ماذا',
      'اريد',
      'أريد',
      'عايز',
      'بدي',
      'ممكن',
      'لو',
      'سمحت',
    };

    final rawTokens = query
        .replaceAll(RegExp(r'[^\u0621-\u064A0-9a-zA-Z\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.length >= 3 && !stopWords.contains(t))
        .take(5)
        .toList();

    final tokens = <String>{};
    for (final t in rawTokens) {
      tokens.add(t);
      if (t.startsWith('ال') && t.length >= 4) {
        tokens.add(t.substring(2));
      }
    }

    if (tokens.isEmpty) {
      final rows = await db.rawQuery(
        'SELECT id, category, source_title, reference, content FROM chunks LIMIT ?',
        [limit],
      );
      return rows
          .map((r) => RagChunkModel.fromMap(r, similarity: 0.50))
          .toList();
    }

    final tokenList = tokens.take(6).toList();
    final whereClauses = tokenList.map((_) => 'content LIKE ?').join(' OR ');
    final args = tokenList.map((t) => '%$t%').toList();
    args.add('$limit');

    final rows = await db.rawQuery(
      'SELECT id, category, source_title, reference, content FROM chunks WHERE $whereClauses LIMIT ?',
      args,
    );

    return rows.map((r) => RagChunkModel.fromMap(r, similarity: 0.50)).toList();
  }

  Future<void> dispose() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
