import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:asset_delivery/asset_delivery.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../models/book_models.dart';
import '../models/azkar_models.dart';

class BookRepository {
  static const String _boxName = 'downloaded_books';

  static const List<BookInfo> nineBooks = [
    BookInfo(
      id: 'bukhari',
      titleKey: 'book_bukhari',
      assetName: 'bukhari.json',
      assetPackName: 'book_bukhari',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'muslim',
      titleKey: 'book_muslim',
      assetName: 'muslim.json',
      assetPackName: 'book_muslim',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'nasai',
      titleKey: 'book_nasai',
      assetName: 'nasai.json',
      assetPackName: 'book_nasai',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'abudawud',
      titleKey: 'book_abudawud',
      assetName: 'abudawud.json',
      assetPackName: 'book_abudawud',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'tirmidhi',
      titleKey: 'book_tirmidhi',
      assetName: 'tirmidhi.json',
      assetPackName: 'book_tirmidhi',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'ibnmajah',
      titleKey: 'book_ibnmajah',
      assetName: 'ibnmajah.json',
      assetPackName: 'book_ibnmajah',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'malik',
      titleKey: 'book_malik',
      assetName: 'malik.json',
      assetPackName: 'book_malik',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'ahmed',
      titleKey: 'book_ahmed',
      assetName: 'ahmed.json',
      assetPackName: 'book_ahmed',
      category: BookCategory.nineBooks,
    ),
    BookInfo(
      id: 'darimi',
      titleKey: 'book_darimi',
      assetName: 'darimi.json',
      assetPackName: 'book_darimi',
      category: BookCategory.nineBooks,
    ),
  ];

  static const List<BookInfo> otherBooks = [
    BookInfo(
      id: '13',
      titleKey: 'book_riyad',
      assetName: 'riyad_assalihin.json',
      assetPackName: 'book_riyad',
      category: BookCategory.other,
    ),
    BookInfo(
      id: '14',
      titleKey: 'book_bulugh',
      assetName: 'bulugh_almaram.json',
      assetPackName: 'book_bulugh',
      category: BookCategory.other,
    ),
    BookInfo(
      id: '15',
      titleKey: 'book_mishkat',
      assetName: 'mishkat_almasabih.json',
      assetPackName: 'book_mishkat',
      category: BookCategory.other,
    ),
    BookInfo(
      id: '16',
      titleKey: 'book_adab',
      assetName: 'aladab_almufrad.json',
      assetPackName: 'book_adab',
      category: BookCategory.other,
    ),
    BookInfo(
      id: '17',
      titleKey: 'book_shamail',
      assetName: 'shamail_muhammadiyah.json',
      assetPackName: 'book_shamail',
      category: BookCategory.other,
    ),
  ];

  static const List<BookInfo> fortyBooks = [
    BookInfo(
      id: 'nawawi40',
      titleKey: 'book_nawawi40',
      assetName: 'nawawi40.json',
      assetPackName: 'book_nawawi40',
      category: BookCategory.forties,
    ),
    BookInfo(
      id: 'qudsi40',
      titleKey: 'book_qudsi40',
      assetName: 'qudsi40.json',
      assetPackName: 'book_qudsi40',
      category: BookCategory.forties,
    ),
    BookInfo(
      id: 'shahwaliullah40',
      titleKey: 'book_shahwaliullah40',
      assetName: 'shahwaliullah40.json',
      assetPackName: 'book_shahwaliullah40',
      category: BookCategory.forties,
    ),
  ];

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  Future<bool> isBookDownloaded(String bookId) async {
    final box = await _getBox();
    return box.containsKey(bookId);
  }

  Future<void> downloadBook(BookInfo book) async {
    try {
      // Trigger fetch. On Android this initiates download.
      // We assume on-demand needs fetch.
      await AssetDelivery.fetch(book.assetPackName);

      // Wait for path to be available.
      // Simple poll logic for safety, as fetch return doesn't guarantee completion in all plugin versions.
      String? assetPackPath;
      for (int i = 0; i < 20; i++) {
        assetPackPath = await AssetDelivery.getAssetPackPath(
          assetPackName: book.assetPackName,
          count: 1,
          namingPattern: '',
          fileExtension: 'json',
        );
        if (assetPackPath != null) break;
        await Future.delayed(const Duration(seconds: 1));
      }

      if (assetPackPath == null) {
        throw ServerException(
          message: 'Asset pack not downloaded yet. Please try again.',
        );
      }

      final file = File('$assetPackPath/${book.assetName}');
      if (!file.existsSync()) {
        throw ServerException(message: 'Book file not found in asset pack.');
      }

      final jsonString = await file.readAsString();

      // Validate JSON
      json.decode(jsonString);

      final box = await _getBox();
      await box.put(book.id, jsonString);
    } catch (e) {
      throw ServerException(message: 'Failed to download book: $e');
    }
  }

  Future<BookCollection> getBook(String bookId) async {
    final box = await _getBox();
    final jsonString = box.get(bookId);

    if (jsonString == null) {
      throw CacheException(message: 'Book not found');
    }

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return BookCollection.fromJson(jsonMap);
    } catch (e) {
      throw CacheException(message: 'Failed to parse book data: $e');
    }
  }

  Future<List<AdhkarCategory>> getAdhkar() async {
    try {
      // Fast-follow: should be available.
      // Trigger fetch just in case to ensure it's mounted/ready if supported.
      await AssetDelivery.fetch('book_adhkar');

      final assetPackPath = await AssetDelivery.getAssetPackPath(
        assetPackName: 'book_adhkar',
        count: 1,
        namingPattern: '',
        fileExtension: 'json',
      );

      if (assetPackPath == null) {
        throw ServerException(message: 'Adhkar module not ready.');
      }

      final file = File('$assetPackPath/adhkar.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => AdhkarCategory.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: 'Failed to load Adhkar: $e');
    }
  }

  Future<List<DuaaCategory>> getDuaas() async {
    try {
      await AssetDelivery.fetch('book_duaa');

      final assetPackPath = await AssetDelivery.getAssetPackPath(
        assetPackName: 'book_duaa',
        count: 1,
        namingPattern: '',
        fileExtension: 'json',
      );

      if (assetPackPath == null) {
        throw ServerException(message: 'Duaa module not ready.');
      }

      final file = File(
        '$assetPackPath/100-duaa-from-the-book-and-authentic-sunnah.json',
      );
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => DuaaCategory.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: 'Failed to load Duaas: $e');
    }
  }

  Future<void> ensureEssentialBooksDownloaded() async {
    try {
      // Trigger fetches for both essential modules
      await Future.wait([
        AssetDelivery.fetch('book_adhkar'),
        AssetDelivery.fetch('book_duaa'),
      ]);

      // Wait for them to be ready
      await Future.wait([
        _waitForAssetPack('book_adhkar'),
        _waitForAssetPack('book_duaa'),
      ]);
    } catch (e) {
      // Log or handle error, but don't block app start completely if possible,
      // though user requested them to be downloaded on first time.
      debugPrint('Error downloading essential books: $e');
      rethrow;
    }
  }

  Future<void> _waitForAssetPack(String assetPackName) async {
    String? assetPackPath;
    for (int i = 0; i < 60; i++) {
      // Wait up to 60 seconds
      assetPackPath = await AssetDelivery.getAssetPackPath(
        assetPackName: assetPackName,
        count: 1,
        namingPattern: '',
        fileExtension: 'json',
      );
      if (assetPackPath != null) return;
      await Future.delayed(const Duration(seconds: 1));
    }
    throw ServerException(message: 'Timeout waiting for $assetPackName');
  }
}
