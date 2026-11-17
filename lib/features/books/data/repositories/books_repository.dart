import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hojaty/core/utils/play_asset_delivery_service.dart';
import 'package:hojaty/features/books/data/models/book_collection_model.dart';
import 'package:hojaty/features/books/data/models/book_download_state.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BooksRepository {
  final Map<String, BookCollectionModel> _memoryCache = {};
  final Map<String, BookDownloadProgress> _cachedStatuses = {};

  Map<String, BookDownloadProgress> get cachedStatuses =>
      Map.unmodifiable(_cachedStatuses);

  Future<String?> _resolveBookFilePath(BookInfoModel book) async {
    // 0. Check debug mode asset in assets/debug/ or assets/debug/elbaz/
    if (kDebugMode) {
      final candidates = [
        'assets/debug/${book.assetName}',
        'assets/debug/elbaz/${book.assetName}',
      ];
      for (final candidate in candidates) {
        try {
          await rootBundle.load(candidate);
          return candidate;
        } catch (_) {
          final debugFile = File(candidate);
          if (await debugFile.exists()) return candidate;
        }
      }
    }

    // 1. Check Play Asset Delivery path on Android
    final packPath = await PlayAssetDeliveryService.getAssetPackPath(
      book.assetPackName,
    );
    if (packPath != null && packPath.isNotEmpty) {
      final f = File('$packPath/${book.assetName}');
      if (await f.exists()) return f.path;
    }

    // 2. Check App Documents directory /books/
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final localFile = File('${docsDir.path}/books/${book.assetName}');
      if (await localFile.exists()) return localFile.path;
    } catch (_) {}

    // 3. Check dev / source directory fallback if running locally
    final devPath =
        'android/${book.assetPackName}/src/main/assets/${book.assetName}';
    final devFile = File(devPath);
    if (await devFile.exists()) return devFile.path;

    return null;
  }

  Future<String?> resolvePdfFilePath(BookInfoModel book) async {
    if (!book.hasPdf) return null;
    final pdfName = book.pdfAssetName!;

    // 0. Check debug mode asset in assets/debug/elbaz/ or assets/debug/
    if (kDebugMode) {
      final candidates = [
        'assets/debug/elbaz/$pdfName',
        'assets/debug/$pdfName',
      ];
      for (final candidate in candidates) {
        final f = File(candidate);
        if (await f.exists()) return f.path;
        try {
          await rootBundle.load(candidate);
          return candidate;
        } catch (_) {}
      }
    }

    // 1. Check Play Asset Delivery path on Android
    final packPath = await PlayAssetDeliveryService.getAssetPackPath(
      book.assetPackName,
    );
    if (packPath != null && packPath.isNotEmpty) {
      final f = File('$packPath/$pdfName');
      if (await f.exists()) return f.path;
    }

    // 2. Check App Documents directory /books/
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final localFile = File('${docsDir.path}/books/$pdfName');
      if (await localFile.exists()) return localFile.path;
    } catch (_) {}

    // 3. Check dev / source directory fallback if running locally
    final devPath = 'android/${book.assetPackName}/src/main/assets/$pdfName';
    final devFile = File(devPath);
    if (await devFile.exists()) return devFile.path;

    return null;
  }

  Future<File?> getOrExtractPdfFile(BookInfoModel book) async {
    if (!book.hasPdf) return null;
    final resolved = await resolvePdfFilePath(book);
    if (resolved == null) return null;

    if (resolved.startsWith('assets/')) {
      try {
        final fileOnDisk = File(resolved);
        if (await fileOnDisk.exists()) return fileOnDisk;

        final byteData = await rootBundle.load(resolved);
        final tempDir = await getTemporaryDirectory();
        final cacheDir = Directory('${tempDir.path}/books_pdf');
        if (!await cacheDir.exists()) {
          await cacheDir.create(recursive: true);
        }
        final cachedFile = File('${cacheDir.path}/${book.pdfAssetName!}');
        await cachedFile.writeAsBytes(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
        );
        return cachedFile;
      } catch (e) {
        log('Error extracting PDF asset: $e');
        return null;
      }
    } else {
      final f = File(resolved);
      return (await f.exists()) ? f : null;
    }
  }

  Future<bool> openBookPdf(BookInfoModel book) async {
    final file = await getOrExtractPdfFile(book);
    if (file == null || !await file.exists()) {
      return false;
    }

    if (Platform.isAndroid) {
      final opened = await PlayAssetDeliveryService.openPdf(file.path);
      if (opened) return true;
      try {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(file.path)], text: book.titleAr),
        );
        return true;
      } catch (_) {
        return false;
      }
    } else if (Platform.isWindows) {
      try {
        await Process.run('cmd', ['/c', 'start', '', file.path]);
        return true;
      } catch (_) {
        return false;
      }
    } else if (Platform.isMacOS) {
      try {
        await Process.run('open', [file.path]);
        return true;
      } catch (_) {
        return false;
      }
    } else if (Platform.isLinux) {
      try {
        await Process.run('xdg-open', [file.path]);
        return true;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  Future<BookDownloadProgress> checkBookStatus(BookInfoModel book) async {
    final path = await _resolveBookFilePath(book);
    if (path != null) {
      final status = BookDownloadProgress(
        bookId: book.id,
        status: BookDownloadStatus.downloaded,
        progress: 1.0,
        localFilePath: path,
      );
      _cachedStatuses[book.id] = status;
      return status;
    }

    final info = await PlayAssetDeliveryService.getAssetPackStatus(
      book.assetPackName,
    );
    if (info.isDownloaded && info.assetsPath != null) {
      final f = File('${info.assetsPath}/${book.assetName}');
      if (await f.exists()) {
        final status = BookDownloadProgress(
          bookId: book.id,
          status: BookDownloadStatus.downloaded,
          progress: 1.0,
          localFilePath: f.path,
        );
        _cachedStatuses[book.id] = status;
        return status;
      }
    }

    final status = BookDownloadProgress(bookId: book.id);
    _cachedStatuses[book.id] = status;
    return status;
  }

  Future<Map<String, BookDownloadProgress>> checkAllBooksStatus() async {
    final results = await Future.wait(
      BookInfoModel.allBooks.map((book) async {
        final status = await checkBookStatus(book);
        return MapEntry(book.id, status);
      }),
    );
    final map = Map.fromEntries(results);
    _cachedStatuses.addAll(map);
    return map;
  }

  Stream<BookDownloadProgress> downloadBook(BookInfoModel book) async* {
    final initial = await checkBookStatus(book);
    if (initial.status == BookDownloadStatus.downloaded) {
      yield initial;
      return;
    }

    yield BookDownloadProgress(
      bookId: book.id,
      status: BookDownloadStatus.downloading,
    );

    final controller = StreamController<BookDownloadProgress>();

    late final StreamSubscription sub;
    sub = PlayAssetDeliveryService.downloadProgressStream.listen(
      (info) async {
        if (info.packName == book.assetPackName) {
          if (info.status == AssetPackStateStatus.completed ||
              (info.assetsPath != null && info.assetsPath!.isNotEmpty)) {
            final fPath = '${info.assetsPath}/${book.assetName}';
            final status = BookDownloadProgress(
              bookId: book.id,
              status: BookDownloadStatus.downloaded,
              progress: 1.0,
              bytesDownloaded: info.totalBytes,
              totalBytes: info.totalBytes,
              localFilePath: fPath,
            );
            _cachedStatuses[book.id] = status;
            controller.add(status);
            await sub.cancel();
            await controller.close();
          } else if (info.status == AssetPackStateStatus.failed) {
            controller.add(
              BookDownloadProgress(
                bookId: book.id,
                status: BookDownloadStatus.failed,
                errorMessage: 'Download failed',
              ),
            );
            await sub.cancel();
            await controller.close();
          } else {
            controller.add(
              BookDownloadProgress(
                bookId: book.id,
                status: BookDownloadStatus.downloading,
                progress: info.progress,
                bytesDownloaded: info.bytesDownloaded,
                totalBytes: info.totalBytes,
              ),
            );
          }
        }
      },
      onError: (e) {
        controller.add(
          BookDownloadProgress(
            bookId: book.id,
            status: BookDownloadStatus.failed,
            errorMessage: e.toString(),
          ),
        );
        controller.close();
      },
    );

    final started = await PlayAssetDeliveryService.startDownload(
      book.assetPackName,
    );
    if (!started) {
      await sub.cancel();
      yield BookDownloadProgress(
        bookId: book.id,
        status: BookDownloadStatus.failed,
        errorMessage: 'Failed to initiate download',
      );
      return;
    }

    yield* controller.stream;
  }

  Future<bool> deleteBook(BookInfoModel book) async {
    if (kDebugMode) return false;
    _memoryCache.remove(book.id);
    _cachedStatuses[book.id] = BookDownloadProgress(bookId: book.id);
    try {
      // 1. Remove from Play Asset Delivery on Android
      await PlayAssetDeliveryService.removeAssetPack(book.assetPackName);

      // 2. Remove any local documents directory file
      try {
        final docsDir = await getApplicationDocumentsDirectory();
        final localFile = File('${docsDir.path}/books/${book.assetName}');
        if (await localFile.exists()) {
          await localFile.delete();
        }
        if (book.hasPdf) {
          final localPdf = File('${docsDir.path}/books/${book.pdfAssetName!}');
          if (await localPdf.exists()) {
            await localPdf.delete();
          }
          final tempDir = await getTemporaryDirectory();
          final cachedPdf = File(
            '${tempDir.path}/books_pdf/${book.pdfAssetName!}',
          );
          if (await cachedPdf.exists()) {
            await cachedPdf.delete();
          }
        }
      } catch (_) {}

      // 3. Delete any local resolved path (avoid dev assets)
      final path = await _resolveBookFilePath(book);
      if (path != null && !path.startsWith('android/')) {
        final f = File(path);
        if (await f.exists()) {
          await f.delete();
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<BookCollectionModel> getBookContent(BookInfoModel book) async {
    if (_memoryCache.containsKey(book.id)) {
      return _memoryCache[book.id]!;
    }

    final path = await _resolveBookFilePath(book);
    if (path == null) {
      throw Exception('Book file not found. Please download it first.');
    }

    String jsonString;
    if (path.startsWith('assets/')) {
      try {
        jsonString = await rootBundle.loadString(path);
      } catch (_) {
        final file = File(path);
        if (await file.exists()) {
          jsonString = await file.readAsString();
        } else {
          throw Exception('Book asset not found at $path');
        }
      }
    } else {
      final file = File(path);
      if (!await file.exists()) {
        throw Exception('Book file does not exist at $path');
      }
      jsonString = await file.readAsString();
    }

    final collection = await compute(_parseBookCollectionJson, jsonString);
    _memoryCache[book.id] = collection;
    return collection;
  }
}

BookCollectionModel _parseBookCollectionJson(String jsonString) {
  final dynamic decoded = jsonDecode(jsonString);
  if (decoded is List) {
    return BookCollectionModel.fromDuaaList(decoded);
  }
  return BookCollectionModel.fromJson(decoded as Map<String, dynamic>);
}
