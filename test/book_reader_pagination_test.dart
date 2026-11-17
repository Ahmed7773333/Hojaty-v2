import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hojaty/features/books/data/models/book_collection_model.dart';
import 'package:hojaty/features/books/domain/utils/book_paginator.dart';

void main() {
  debugPrint('Running BookPaginator self-check...');

  // Test 1: Nawawi 40 (single chapter)
  final nawawiJson = File('assets/debug/nawawi40.json').readAsStringSync();
  final nawawiCollection = BookCollectionModel.fromJson(
    jsonDecode(nawawiJson) as Map<String, dynamic>,
  );
  final nawawiResult = BookPaginator.paginate(collection: nawawiCollection);

  assert(nawawiResult.pages.isNotEmpty, 'Nawawi pages should not be empty');
  assert(
    nawawiResult.hadithPages.length == nawawiCollection.hadiths.length,
    'All hadiths must be mapped to pages',
  );
  assert(
    nawawiResult.chapterStartPages.isNotEmpty,
    'Chapter start page must be recorded',
  );
  debugPrint(
    '✓ Verified Nawawi 40: ${nawawiCollection.hadiths.length} hadiths -> ${nawawiResult.pages.length} pages',
  );

  // Test 2: Multi-chapter book (Bukhari: 7,277 hadiths)
  final bukhariJson = File('assets/debug/bukhari.json').readAsStringSync();
  final bukhariCollection = BookCollectionModel.fromJson(
    jsonDecode(bukhariJson) as Map<String, dynamic>,
  );
  final bukhariResult = BookPaginator.paginate(collection: bukhariCollection);

  assert(
    bukhariResult.pages.length > 1000,
    'Bukhari should have thousands of pages',
  );
  assert(
    bukhariResult.hadithPages.length == bukhariCollection.hadiths.length,
    'All Bukhari hadiths must be mapped',
  );
  assert(
    bukhariResult.chapterStartPages.length == bukhariCollection.chapters.length,
    'All chapters must have start page',
  );
  debugPrint(
    '✓ Verified Bukhari: ${bukhariCollection.hadiths.length} hadiths -> ${bukhariResult.pages.length} pages across ${bukhariResult.chapterStartPages.length} chapters',
  );

  // Test 3: Scoped Chapter Pagination (e.g. Chapter 1 of Bukhari)
  final ch1 = bukhariCollection.chapters.first;
  final scopedResult = BookPaginator.paginate(
    collection: bukhariCollection,
    scopedChapterId: ch1.id,
  );
  final ch1Hadiths = bukhariCollection.hadiths
      .where((h) => h.chapterId == ch1.id)
      .length;

  assert(scopedResult.pages.isNotEmpty, 'Scoped pages should not be empty');
  assert(
    scopedResult.hadithPages.length == ch1Hadiths,
    'Scoped hadiths count mismatch',
  );
  debugPrint(
    '✓ Verified Scoped chapter ${ch1.id}: $ch1Hadiths hadiths -> ${scopedResult.pages.length} pages',
  );

  debugPrint('\nAll BookPaginator checks passed successfully!');
}
