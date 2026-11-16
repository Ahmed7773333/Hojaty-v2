import 'dart:convert';
import 'dart:io';
import 'package:hojaty/features/books/data/models/book_collection_model.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';

void main() {
  print('Starting verification of debug books in assets/debug/ ...');

  final books = BookInfoModel.allBooks;
  assert(books.length == 18, 'Expected 18 books defined in BookInfoModel.allBooks');

  for (final book in books) {
    final assetPath = 'assets/debug/${book.assetName}';
    final file = File(assetPath);
    assert(file.existsSync(), 'Book file does not exist at $assetPath');

    final jsonString = file.readAsStringSync();
    assert(jsonString.isNotEmpty, 'Book JSON file at $assetPath is empty');

    final dynamic decoded = jsonDecode(jsonString);
    final BookCollectionModel collection;
    if (decoded is List) {
      collection = BookCollectionModel.fromDuaaList(decoded);
    } else {
      collection = BookCollectionModel.fromJson(decoded as Map<String, dynamic>);
    }

    assert(collection.titleAr.isNotEmpty, 'Arabic title should not be empty for ${book.id}');
    assert(collection.hadiths.isNotEmpty, 'Hadiths should not be empty for ${book.id}');

    print('✓ [${book.id}] Verified ${collection.titleAr} (${collection.hadiths.length} hadiths, ${collection.chapters.length} chapters)');
  }

  print('\nAll 18 debug books successfully verified in assets/debug/!');
}
