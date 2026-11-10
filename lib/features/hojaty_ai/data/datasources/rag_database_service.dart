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

class _ChunkEmbeddingRecord {
  final int id;
  final Uint8List embedding;

  const _ChunkEmbeddingRecord({
    required this.id,
    required this.embedding,
  });
}

class _ScoredChunkId {
  final int id;
  final double similarity;

  const _ScoredChunkId({
    required this.id,
    required this.similarity,
  });
}

class _IsolateSearchPayload {
  final Float32List queryVector;
  final List<_ChunkEmbeddingRecord> records;
  final double minSimilarity;
  final int topK;

  const _IsolateSearchPayload({
    required this.queryVector,
    required this.records,
    required this.minSimilarity,
    required this.topK,
  });
}

class RagDatabaseService {
  Database? _database;
  List<_ChunkEmbeddingRecord>? _cachedEmbeddings;
  bool _isInitializing = false;

  /// Initializes the SQLite database and caches embeddings for fast isolate search.
  Future<void> init() async {
    if (_database != null && _database!.isOpen) return;
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
      await _loadEmbeddingsCache();
      debugPrint('RagDatabaseService: Successfully opened DB at $dbPath with ${_cachedEmbeddings?.length ?? 0} chunks cached');
    } catch (e, st) {
      debugPrint('RagDatabaseService initialization error: $e\n$st');
    } finally {
      _isInitializing = false;
    }
  }

  Future<String> _resolveDatabasePath() async {
    final databasesDir = await getDatabasesPath();
    final targetPath = p.join(databasesDir, 'hojaty_rag.db');
    final targetFile = File(targetPath);

    if (await targetFile.exists() && await targetFile.length() > 1024 * 1024) {
      return targetPath;
    }

    await targetFile.parent.create(recursive: true);

    // 1. Check Flutter Asset (assets/debug/hojaty_rag.db or assets/hojaty_rag.db)
    final assetCandidates = [
      'assets/debug/hojaty_rag.db',
      'assets/hojaty_rag.db',
    ];

    for (final assetPath in assetCandidates) {
      try {
        final byteData = await rootBundle.load(assetPath);
        final buffer = byteData.buffer;
        await targetFile.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
          flush: true,
        );
        debugPrint('RagDatabaseService: Copied database from Flutter asset: $assetPath');
        return targetPath;
      } catch (_) {}
    }

    // 2. Check Play Asset Delivery on Android
    try {
      final packPath = await PlayAssetDeliveryService.getAssetPackPath('hojaty_rag');
      if (packPath != null && packPath.isNotEmpty) {
        final packFile = File(p.join(packPath, 'hojaty_rag.db'));
        if (await packFile.exists()) {
          return packFile.path;
        }
      }
    } catch (e) {
      debugPrint('RagDatabaseService: PlayAssetDelivery check skipped: $e');
    }

    // 3. Check App Documents directory fallback
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final docsFile = File(p.join(docsDir.path, 'hojaty_rag.db'));
      if (await docsFile.exists()) {
        return docsFile.path;
      }
    } catch (_) {}

    // 4. Check local development / source repository path
    final devCandidates = [
      'assets/debug/hojaty_rag.db',
      'android/hojaty_rag/src/main/assets/hojaty_rag.db',
    ];

    for (final devPath in devCandidates) {
      final devFile = File(devPath);
      if (await devFile.exists()) {
        try {
          await devFile.copy(targetPath);
          return targetPath;
        } catch (_) {
          return devFile.path;
        }
      }
    }

    // If still not found, return targetPath (openDatabase will handle or fail gracefully)
    return targetPath;
  }

  Future<void> _loadEmbeddingsCache() async {
    if (_database == null) return;
    try {
      final rows = await _database!.query(
        'chunks',
        columns: ['id', 'embedding'],
      );

      final records = <_ChunkEmbeddingRecord>[];
      for (final row in rows) {
        final id = (row['id'] as num?)?.toInt();
        final rawBlob = row['embedding'];
        if (id != null && rawBlob is Uint8List && rawBlob.lengthInBytes >= 2048) {
          records.add(_ChunkEmbeddingRecord(id: id, embedding: rawBlob));
        }
      }
      _cachedEmbeddings = records;
    } catch (e) {
      debugPrint('RagDatabaseService: Error loading embeddings cache: $e');
    }
  }

  /// Searches the database for the Top [topK] chunks with similarity >= [minSimilarity].
  /// Runs the 512-float cosine similarity calculation in a background Isolate.run(...)
  /// ensuring 60/120 FPS on the main UI thread.
  Future<List<RagChunkModel>> searchTopK(
    List<double> queryVector, {
    int topK = 6,
    double minSimilarity = 0.40,
  }) async {
    await init();
    final db = _database;
    final cached = _cachedEmbeddings;

    if (db == null || cached == null || cached.isEmpty || queryVector.length != 512) {
      return const [];
    }

    final queryFloats = Float32List.fromList(queryVector);

    final payload = _IsolateSearchPayload(
      queryVector: queryFloats,
      records: cached,
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

    // Sort models descending by similarity
    models.sort((a, b) => b.similarity.compareTo(a.similarity));
    return models;
  }

  /// Fallback search by keywords directly in SQLite when offline or embedding API is unreachable.
  Future<List<RagChunkModel>> searchByKeywords(String query, {int limit = 6}) async {
    await init();
    final db = _database;
    if (db == null) return const [];

    final stopWords = {
      'من', 'إلى', 'عن', 'على', 'في', 'مع', 'هذا', 'هذه', 'تم', 'كان', 'أو',
      'ثم', 'ما', 'هو', 'هي', 'أن', 'إن', 'هل', 'لا', 'لم', 'لن', 'كيف', 'ماذا'
    };

    final tokens = query
        .replaceAll(RegExp(r'[^\u0621-\u064A0-9a-zA-Z\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.length >= 3 && !stopWords.contains(t))
        .take(5)
        .toList();

    if (tokens.isEmpty) {
      final rows = await db.rawQuery(
        'SELECT id, category, source_title, reference, content FROM chunks LIMIT ?',
        [limit],
      );
      return rows.map((r) => RagChunkModel.fromMap(r, similarity: 0.50)).toList();
    }

    final whereClauses = tokens.map((_) => 'content LIKE ?').join(' OR ');
    final args = tokens.map((t) => '%$t%').toList();
    args.add('$limit');

    final rows = await db.rawQuery(
      'SELECT id, category, source_title, reference, content FROM chunks WHERE $whereClauses LIMIT ?',
      args,
    );

    return rows.map((r) => RagChunkModel.fromMap(r, similarity: 0.50)).toList();
  }

  static List<_ScoredChunkId> _isolateVectorSearch(_IsolateSearchPayload payload) {
    final query = payload.queryVector;
    final records = payload.records;
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

    for (final record in records) {
      final blob = record.embedding;
      final Float32List chunkVector = blob.buffer.asFloat32List(
        blob.offsetInBytes,
        blob.lengthInBytes ~/ 4,
      );

      if (chunkVector.length < 512) continue;

      double dot = 0.0;
      double chunkNormSq = 0.0;

      for (int i = 0; i < 512; i++) {
        final q = query[i];
        final c = chunkVector[i];
        dot += q * c;
        chunkNormSq += c * c;
      }

      final chunkNorm = math.sqrt(chunkNormSq);
      if (chunkNorm <= 0.0) continue;

      final similarity = dot / (queryNorm * chunkNorm);

      if (similarity >= minSimilarity) {
        candidates.add(_ScoredChunkId(id: record.id, similarity: similarity));
      }
    }

    candidates.sort((a, b) => b.similarity.compareTo(a.similarity));

    if (candidates.length > topK) {
      return candidates.sublist(0, topK);
    }
    return candidates;
  }

  Future<void> dispose() async {
    _cachedEmbeddings = null;
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
