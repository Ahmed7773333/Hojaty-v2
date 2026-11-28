import 'dart:async';

import 'package:hojaty/features/hifz/domain/entities/ayah_mastery.dart';
import 'package:hojaty/features/hifz/domain/entities/cached_audio_entry.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_plan.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/domain/entities/surah_cache_summary.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Offline-first SQLite DAO for all Hifz persistence tables (`hifz.db`).
class HifzLocalDao {
  static const String _dbName = 'hifz.db';
  static const int _dbVersion = 1;

  Database? _db;
  final StreamController<void> _changesController =
      StreamController<void>.broadcast();

  Stream<void> get onDataChanged => _changesController.stream;

  void _notifyChanged() {
    if (!_changesController.isClosed) {
      _changesController.add(null);
    }
  }

  Future<Database> get _database async {
    if (_db != null && _db!.isOpen) return _db!;
    final databasesPath = await getDatabasesPath();
    final dbPath = p.join(databasesPath, _dbName);
    _db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hifz_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        track_key TEXT,
        title TEXT NOT NULL,
        surah_id INTEGER NOT NULL,
        start_global_ayah INTEGER NOT NULL,
        end_global_ayah INTEGER NOT NULL,
        current_global_ayah INTEGER NOT NULL,
        daily_target_ayahs INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ayah_mastery (
        global_ayah_id INTEGER PRIMARY KEY,
        mastery_level INTEGER NOT NULL,
        last_reviewed_at INTEGER NOT NULL,
        next_review_at INTEGER NOT NULL,
        lapse_count INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_ayah_mastery_next_review ON ayah_mastery (next_review_at)',
    );

    await db.execute('''
      CREATE TABLE hifz_activity_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_id INTEGER,
        date_ymd TEXT NOT NULL,
        ayahs_memorized INTEGER NOT NULL DEFAULT 0,
        ayahs_reviewed INTEGER NOT NULL DEFAULT 0,
        listening_seconds INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_hifz_activity_date_ymd ON hifz_activity_logs (date_ymd)',
    );

    await db.execute('''
      CREATE TABLE cached_audio_entries (
        cache_key TEXT PRIMARY KEY,
        reciter_id TEXT NOT NULL,
        surah_id INTEGER NOT NULL,
        file_size_bytes INTEGER NOT NULL,
        is_pinned INTEGER NOT NULL DEFAULT 0,
        last_accessed_at INTEGER NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_cached_audio_reciter ON cached_audio_entries (reciter_id)',
    );
    await db.execute(
      'CREATE INDEX idx_cached_audio_surah ON cached_audio_entries (surah_id)',
    );
    await db.execute(
      'CREATE INDEX idx_cached_audio_accessed ON cached_audio_entries (last_accessed_at)',
    );

    await db.execute('''
      CREATE TABLE hifz_preferences (
        pref_key TEXT PRIMARY KEY,
        pref_value TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Reserved for future schema migrations.
  }

  // ---------------------------------------------------------------------------
  // Plans
  // ---------------------------------------------------------------------------

  HifzPlan _planFromRow(Map<String, Object?> row) {
    return HifzPlan(
      id: (row['id'] as num).toInt(),
      trackKey: row['track_key'] as String?,
      title: row['title'] as String,
      surahId: (row['surah_id'] as num).toInt(),
      startGlobalAyah: (row['start_global_ayah'] as num).toInt(),
      endGlobalAyah: (row['end_global_ayah'] as num).toInt(),
      currentGlobalAyah: (row['current_global_ayah'] as num).toInt(),
      dailyTargetAyahs: (row['daily_target_ayahs'] as num).toInt(),
      isActive: ((row['is_active'] as num?)?.toInt() ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (row['created_at'] as num).toInt(),
      ),
    );
  }

  Future<HifzPlan?> getActivePlan() async {
    final db = await _database;
    final rows = await db.query(
      'hifz_plans',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _planFromRow(rows.first);
  }

  Future<List<HifzPlan>> getAllPlans() async {
    final db = await _database;
    final rows = await db.query('hifz_plans', orderBy: 'id DESC');
    return rows.map(_planFromRow).toList(growable: false);
  }

  Future<HifzPlan> createPlan(HifzPlan plan, {bool setAsActive = true}) async {
    final db = await _database;
    late HifzPlan inserted;
    await db.transaction((txn) async {
      if (setAsActive) {
        await txn.update('hifz_plans', {'is_active': 0});
      }
      final id = await txn.insert('hifz_plans', {
        'track_key': plan.trackKey,
        'title': plan.title,
        'surah_id': plan.surahId,
        'start_global_ayah': plan.startGlobalAyah,
        'end_global_ayah': plan.endGlobalAyah,
        'current_global_ayah': plan.currentGlobalAyah,
        'daily_target_ayahs': plan.dailyTargetAyahs,
        'is_active': setAsActive ? 1 : (plan.isActive ? 1 : 0),
        'created_at': plan.createdAt.millisecondsSinceEpoch,
      });
      inserted = plan.copyWith(id: id, isActive: setAsActive || plan.isActive);
    });
    _notifyChanged();
    return inserted;
  }

  Future<void> setActivePlan(int planId) async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.update('hifz_plans', {'is_active': 0});
      await txn.update(
        'hifz_plans',
        {'is_active': 1},
        where: 'id = ?',
        whereArgs: [planId],
      );
    });
    _notifyChanged();
  }

  Future<void> updatePlanProgress(int planId, int newCurrentGlobalAyah) async {
    final db = await _database;
    await db.update(
      'hifz_plans',
      {'current_global_ayah': newCurrentGlobalAyah},
      where: 'id = ?',
      whereArgs: [planId],
    );
    _notifyChanged();
  }

  Future<void> deletePlan(int planId) async {
    final db = await _database;
    await db.delete('hifz_plans', where: 'id = ?', whereArgs: [planId]);
    _notifyChanged();
  }

  // ---------------------------------------------------------------------------
  // Ayah Mastery (Leitner 5-Box)
  // ---------------------------------------------------------------------------

  AyahMastery _masteryFromRow(Map<String, Object?> row) {
    return AyahMastery(
      globalAyahId: (row['global_ayah_id'] as num).toInt(),
      masteryLevel: (row['mastery_level'] as num).toInt(),
      lastReviewedAt: DateTime.fromMillisecondsSinceEpoch(
        (row['last_reviewed_at'] as num).toInt(),
      ),
      nextReviewAt: DateTime.fromMillisecondsSinceEpoch(
        (row['next_review_at'] as num).toInt(),
      ),
      lapseCount: (row['lapse_count'] as num).toInt(),
    );
  }

  Future<List<AyahMastery>> getDueReviews({DateTime? asOf}) async {
    final db = await _database;
    final cutoff = (asOf ?? DateTime.now()).millisecondsSinceEpoch;
    final rows = await db.query(
      'ayah_mastery',
      where: 'next_review_at <= ?',
      whereArgs: [cutoff],
      orderBy: 'next_review_at ASC, global_ayah_id ASC',
    );
    return rows.map(_masteryFromRow).toList(growable: false);
  }

  Future<AyahMastery?> getMastery(int globalAyahId) async {
    final db = await _database;
    final rows = await db.query(
      'ayah_mastery',
      where: 'global_ayah_id = ?',
      whereArgs: [globalAyahId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _masteryFromRow(rows.first);
  }

  Future<void> upsertMastery(AyahMastery mastery) async {
    final db = await _database;
    await db.insert(
      'ayah_mastery',
      {
        'global_ayah_id': mastery.globalAyahId,
        'mastery_level': mastery.masteryLevel,
        'last_reviewed_at': mastery.lastReviewedAt.millisecondsSinceEpoch,
        'next_review_at': mastery.nextReviewAt.millisecondsSinceEpoch,
        'lapse_count': mastery.lapseCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notifyChanged();
  }

  Future<void> upsertMasteryBatch(List<AyahMastery> entries) async {
    if (entries.isEmpty) return;
    final db = await _database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final m in entries) {
        batch.insert(
          'ayah_mastery',
          {
            'global_ayah_id': m.globalAyahId,
            'mastery_level': m.masteryLevel,
            'last_reviewed_at': m.lastReviewedAt.millisecondsSinceEpoch,
            'next_review_at': m.nextReviewAt.millisecondsSinceEpoch,
            'lapse_count': m.lapseCount,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
    _notifyChanged();
  }

  // ---------------------------------------------------------------------------
  // Activity Logs & Streaks
  // ---------------------------------------------------------------------------

  Future<void> logActivity({
    int? planId,
    required String dateYmd,
    int ayahsMemorizedDelta = 0,
    int ayahsReviewedDelta = 0,
    int listeningSecondsDelta = 0,
  }) async {
    final db = await _database;
    await db.transaction((txn) async {
      final existing = await txn.query(
        'hifz_activity_logs',
        where: 'date_ymd = ?',
        whereArgs: [dateYmd],
        limit: 1,
      );
      if (existing.isEmpty) {
        await txn.insert('hifz_activity_logs', {
          'plan_id': planId,
          'date_ymd': dateYmd,
          'ayahs_memorized': ayahsMemorizedDelta,
          'ayahs_reviewed': ayahsReviewedDelta,
          'listening_seconds': listeningSecondsDelta,
        });
      } else {
        final row = existing.first;
        final id = (row['id'] as num).toInt();
        await txn.update(
          'hifz_activity_logs',
          {
            'plan_id': planId ?? row['plan_id'],
            'ayahs_memorized':
                ((row['ayahs_memorized'] as num?)?.toInt() ?? 0) +
                    ayahsMemorizedDelta,
            'ayahs_reviewed':
                ((row['ayahs_reviewed'] as num?)?.toInt() ?? 0) +
                    ayahsReviewedDelta,
            'listening_seconds':
                ((row['listening_seconds'] as num?)?.toInt() ?? 0) +
                    listeningSecondsDelta,
          },
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    });
    _notifyChanged();
  }

  static String formatYmd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<int> getStreakDays({DateTime? asOf}) async {
    final db = await _database;
    final rows = await db.query(
      'hifz_activity_logs',
      columns: ['date_ymd'],
      where: 'ayahs_memorized > 0 OR ayahs_reviewed > 0 OR listening_seconds > 30',
      orderBy: 'date_ymd DESC',
    );
    if (rows.isEmpty) return 0;

    final activeDates = rows
        .map((r) => r['date_ymd'] as String)
        .toSet();

    final today = asOf ?? DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);
    var cursor = activeDates.contains(formatYmd(todayDay))
        ? todayDay
        : todayDay.subtract(const Duration(days: 1));

    int streak = 0;
    while (activeDates.contains(formatYmd(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // ---------------------------------------------------------------------------
  // Cached Audio Entries (LRU & Storage Manager)
  // ---------------------------------------------------------------------------

  CachedAudioEntry _cacheFromRow(Map<String, Object?> row) {
    return CachedAudioEntry(
      cacheKey: row['cache_key'] as String,
      reciterId: row['reciter_id'] as String,
      surahId: (row['surah_id'] as num).toInt(),
      fileSizeBytes: (row['file_size_bytes'] as num).toInt(),
      isPinned: ((row['is_pinned'] as num?)?.toInt() ?? 0) == 1,
      lastAccessedAt: DateTime.fromMillisecondsSinceEpoch(
        (row['last_accessed_at'] as num).toInt(),
      ),
    );
  }

  Future<void> upsertCacheEntry(CachedAudioEntry entry) async {
    final db = await _database;
    await db.insert(
      'cached_audio_entries',
      {
        'cache_key': entry.cacheKey,
        'reciter_id': entry.reciterId,
        'surah_id': entry.surahId,
        'file_size_bytes': entry.fileSizeBytes,
        'is_pinned': entry.isPinned ? 1 : 0,
        'last_accessed_at': entry.lastAccessedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notifyChanged();
  }

  Future<void> touchCacheEntry(String cacheKey, DateTime accessedAt) async {
    final db = await _database;
    await db.update(
      'cached_audio_entries',
      {'last_accessed_at': accessedAt.millisecondsSinceEpoch},
      where: 'cache_key = ?',
      whereArgs: [cacheKey],
    );
  }

  Future<int> getTotalCachedBytes({bool? isPinned}) async {
    final db = await _database;
    final whereClause =
        isPinned == null ? '' : 'WHERE is_pinned = ${isPinned ? 1 : 0}';
    final rows = await db.rawQuery(
      'SELECT COALESCE(SUM(file_size_bytes), 0) AS total FROM cached_audio_entries $whereClause',
    );
    return (rows.first['total'] as num?)?.toInt() ?? 0;
  }

  Future<List<CachedAudioEntry>> getUnpinnedEntriesOldestFirst() async {
    final db = await _database;
    final rows = await db.query(
      'cached_audio_entries',
      where: 'is_pinned = ?',
      whereArgs: [0],
      orderBy: 'last_accessed_at ASC',
    );
    return rows.map(_cacheFromRow).toList(growable: false);
  }

  Future<List<CachedAudioEntry>> getEntriesForSurah(
    String reciterId,
    int surahId,
  ) async {
    final db = await _database;
    final rows = await db.query(
      'cached_audio_entries',
      where: 'reciter_id = ? AND surah_id = ?',
      whereArgs: [reciterId, surahId],
    );
    return rows.map(_cacheFromRow).toList(growable: false);
  }

  Future<List<SurahCacheSummary>> getCachedSurahSummaries() async {
    final db = await _database;
    final rows = await db.rawQuery('''
      SELECT
        reciter_id,
        surah_id,
        COUNT(*) AS ayah_count,
        COALESCE(SUM(file_size_bytes), 0) AS total_bytes,
        MIN(is_pinned) AS all_pinned
      FROM cached_audio_entries
      GROUP BY reciter_id, surah_id
      ORDER BY surah_id ASC, reciter_id ASC
    ''');
    return rows
        .map(
          (r) => SurahCacheSummary(
            reciterId: r['reciter_id'] as String,
            surahId: (r['surah_id'] as num).toInt(),
            ayahCount: (r['ayah_count'] as num).toInt(),
            totalBytes: (r['total_bytes'] as num).toInt(),
            isFullyPinned: ((r['all_pinned'] as num?)?.toInt() ?? 0) == 1,
          ),
        )
        .toList(growable: false);
  }

  Future<void> deleteCacheKeys(List<String> keys) async {
    if (keys.isEmpty) return;
    final db = await _database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final key in keys) {
        batch.delete(
          'cached_audio_entries',
          where: 'cache_key = ?',
          whereArgs: [key],
        );
      }
      await batch.commit(noResult: true);
    });
    _notifyChanged();
  }

  Future<void> deleteEntriesForSurah(String reciterId, int surahId) async {
    final db = await _database;
    await db.delete(
      'cached_audio_entries',
      where: 'reciter_id = ? AND surah_id = ?',
      whereArgs: [reciterId, surahId],
    );
    _notifyChanged();
  }

  Future<void> deleteUnpinnedEntries() async {
    final db = await _database;
    await db.delete(
      'cached_audio_entries',
      where: 'is_pinned = ?',
      whereArgs: [0],
    );
    _notifyChanged();
  }

  // ---------------------------------------------------------------------------
  // Session Preferences
  // ---------------------------------------------------------------------------

  Future<HifzSessionConfig> loadSessionConfig() async {
    final db = await _database;
    final rows = await db.query('hifz_preferences');
    final map = <String, String>{
      for (final row in rows)
        row['pref_key'] as String: row['pref_value'] as String,
    };

    const defaults = HifzSessionConfig();
    return HifzSessionConfig(
      reciterId: map['reciter_id'] ?? defaults.reciterId,
      audioQuality: map['audio_quality'] == AudioQuality.kbps64.name
          ? AudioQuality.kbps64
          : AudioQuality.kbps128,
      ayahRepeatCount:
          int.tryParse(map['ayah_repeat_count'] ?? '') ??
              defaults.ayahRepeatCount,
      rangeRepeatCount:
          int.tryParse(map['range_repeat_count'] ?? '') ??
              defaults.rangeRepeatCount,
      cumulativeChaining: map['cumulative_chaining'] != null
          ? map['cumulative_chaining'] == '1'
          : defaults.cumulativeChaining,
      pauseToRepeat: map['pause_to_repeat'] != null
          ? map['pause_to_repeat'] == '1'
          : defaults.pauseToRepeat,
      pauseMode: map['pause_mode'] == PauseMode.fixed.name
          ? PauseMode.fixed
          : PauseMode.dynamicDuration,
      fixedPauseSeconds:
          int.tryParse(map['fixed_pause_seconds'] ?? '') ??
              defaults.fixedPauseSeconds,
      playbackSpeed:
          double.tryParse(map['playback_speed'] ?? '') ??
              defaults.playbackSpeed,
    );
  }

  Future<void> saveSessionConfig(HifzSessionConfig config) async {
    final db = await _database;
    final pairs = <String, String>{
      'reciter_id': config.reciterId,
      'audio_quality': config.audioQuality.name,
      'ayah_repeat_count': config.ayahRepeatCount.toString(),
      'range_repeat_count': config.rangeRepeatCount.toString(),
      'cumulative_chaining': config.cumulativeChaining ? '1' : '0',
      'pause_to_repeat': config.pauseToRepeat ? '1' : '0',
      'pause_mode': config.pauseMode.name,
      'fixed_pause_seconds': config.fixedPauseSeconds.toString(),
      'playback_speed': config.playbackSpeed.toString(),
    };

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final entry in pairs.entries) {
        batch.insert(
          'hifz_preferences',
          {'pref_key': entry.key, 'pref_value': entry.value},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> dispose() async {
    await _changesController.close();
    await _db?.close();
    _db = null;
  }
}

