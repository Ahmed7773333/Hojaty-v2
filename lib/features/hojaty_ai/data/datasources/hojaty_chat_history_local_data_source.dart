import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/chat_session_model.dart';

class HojatyChatHistoryLocalDataSource {
  static const String _boxName = 'hojaty_ai_history_box';
  static const String _activeSessionKey = 'active_session_id';
  static const String _sessionPrefix = 'session_';

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  /// Returns all saved chat sessions ordered from newest to oldest.
  Future<List<ChatSessionModel>> getAllSessions() async {
    try {
      final box = await _getBox();
      final sessions = <ChatSessionModel>[];

      for (final key in box.keys) {
        if (key is String && key.startsWith(_sessionPrefix)) {
          final raw = box.get(key);
          if (raw is String && raw.isNotEmpty) {
            final decoded = jsonDecode(raw);
            if (decoded is Map<String, dynamic>) {
              sessions.add(ChatSessionModel.fromJson(decoded));
            }
          }
        }
      }

      sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return sessions;
    } catch (e) {
      debugPrint('HojatyChatHistoryLocalDataSource.getAllSessions error: $e');
      return const [];
    }
  }

  /// Loads a single session by [sessionId], or null if not found.
  Future<ChatSessionModel?> getSession(String sessionId) async {
    try {
      final box = await _getBox();
      final raw = box.get('$_sessionPrefix$sessionId');
      if (raw is String && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return ChatSessionModel.fromJson(decoded);
        }
      }
      return null;
    } catch (e) {
      debugPrint('HojatyChatHistoryLocalDataSource.getSession error: $e');
      return null;
    }
  }

  /// Saves or updates a [session] locally.
  Future<void> saveSession(ChatSessionModel session) async {
    try {
      final box = await _getBox();
      await box.put(
        '$_sessionPrefix${session.id}',
        jsonEncode(session.toJson()),
      );
    } catch (e) {
      debugPrint('HojatyChatHistoryLocalDataSource.saveSession error: $e');
    }
  }

  /// Deletes a single session from local storage.
  Future<void> deleteSession(String sessionId) async {
    try {
      final box = await _getBox();
      await box.delete('$_sessionPrefix$sessionId');
      final activeId = box.get(_activeSessionKey);
      if (activeId == sessionId) {
        await box.delete(_activeSessionKey);
      }
    } catch (e) {
      debugPrint('HojatyChatHistoryLocalDataSource.deleteSession error: $e');
    }
  }

  /// Deletes all saved chat sessions.
  Future<void> clearAllSessions() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      debugPrint('HojatyChatHistoryLocalDataSource.clearAllSessions error: $e');
    }
  }

  /// Gets the ID of the last active session.
  Future<String?> getActiveSessionId() async {
    try {
      final box = await _getBox();
      final value = box.get(_activeSessionKey);
      return value is String ? value : null;
    } catch (_) {
      return null;
    }
  }

  /// Sets or clears the last active session ID.
  Future<void> setActiveSessionId(String? sessionId) async {
    try {
      final box = await _getBox();
      if (sessionId == null) {
        await box.delete(_activeSessionKey);
      } else {
        await box.put(_activeSessionKey, sessionId);
      }
    } catch (_) {}
  }
}

