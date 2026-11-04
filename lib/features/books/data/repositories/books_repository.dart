import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/utils/play_asset_delivery_service.dart';
import '../models/book_collection_model.dart';
import '../models/book_download_state.dart';
import '../models/book_info_model.dart';

class BooksRepository {
  final Map<String, BookCollectionModel> _memoryCache = {};

  Future<String?> _resolveBookFilePath(BookInfoModel book) async {
    // 1. Check Play Asset Delivery path on Android
    final packPath = await PlayAssetDeliveryService.getAssetPackPath(book.assetPackName);
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
    final devPath = 'android/${book.assetPackName}/src/main/assets/${book.assetName}';
    final devFile = File(devPath);
    if (await devFile.exists()) return devFile.path;

    return null;
  }

  Future<BookDownloadProgress> checkBookStatus(BookInfoModel book) async {
    final path = await _resolveBookFilePath(book);
    if (path != null) {
      return BookDownloadProgress(
        bookId: book.id,
        status: BookDownloadStatus.downloaded,
        progress: 1.0,
        localFilePath: path,
      );
    }

    final info = await PlayAssetDeliveryService.getAssetPackStatus(book.assetPackName);
    if (info.isDownloaded && info.assetsPath != null) {
      final f = File('${info.assetsPath}/${book.assetName}');
      if (await f.exists()) {
        return BookDownloadProgress(
          bookId: book.id,
          status: BookDownloadStatus.downloaded,
          progress: 1.0,
          localFilePath: f.path,
        );
      }
    }

    return BookDownloadProgress(
      bookId: book.id,
      status: BookDownloadStatus.notDownloaded,
      progress: 0.0,
    );
  }

  Future<Map<String, BookDownloadProgress>> checkAllBooksStatus() async {
    final Map<String, BookDownloadProgress> result = {};
    for (final book in BookInfoModel.allBooks) {
      result[book.id] = await checkBookStatus(book);
    }
    return result;
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
      progress: 0.0,
    );

    final controller = StreamController<BookDownloadProgress>();

    late final StreamSubscription sub;
    sub = PlayAssetDeliveryService.downloadProgressStream.listen(
      (info) async {
        if (info.packName == book.assetPackName) {
          if (info.status == AssetPackStateStatus.completed ||
              (info.assetsPath != null && info.assetsPath!.isNotEmpty)) {
            final fPath = '${info.assetsPath}/${book.assetName}';
            controller.add(
              BookDownloadProgress(
                bookId: book.id,
                status: BookDownloadStatus.downloaded,
                progress: 1.0,
                bytesDownloaded: info.totalBytes,
                totalBytes: info.totalBytes,
                localFilePath: fPath,
              ),
            );
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

    final started = await PlayAssetDeliveryService.startDownload(book.assetPackName);
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
    _memoryCache.remove(book.id);
    try {
      final path = await _resolveBookFilePath(book);
      if (path != null) {
        final f = File(path);
        if (await f.exists()) {
          await f.delete();
          return true;
        }
      }
      return false;
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

    final file = File(path);
    if (!await file.exists()) {
      throw Exception('Book file does not exist at $path');
    }

    final jsonString = await file.readAsString();
    final collection = await compute(_parseBookCollectionJson, jsonString);
    _memoryCache[book.id] = collection;
    return collection;
  }
}

BookCollectionModel _parseBookCollectionJson(String jsonString) {
  final Map<String, dynamic> decoded = jsonDecode(jsonString) as Map<String, dynamic>;
  return BookCollectionModel.fromJson(decoded);
}

