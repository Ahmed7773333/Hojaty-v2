import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../models/playlist_item.dart';
import '../../models/playlist_model.dart';

class PlaylistsLocalDataSource {
  static const String _boxName = 'playlists_box';
  static const String _favoritesId = 'favorites_playlist';

  Future<void> init() async {
    try {
      if (!Hive.isAdapterRegistered(10)) {
        Hive.registerAdapter(PlaylistItemAdapter());
      }
      if (!Hive.isAdapterRegistered(11)) {
        Hive.registerAdapter(PlaylistModelAdapter());
      }
      await Hive.openBox<PlaylistModel>(_boxName);
    } catch (e) {
      debugPrint('Error opening $_boxName: $e');
      await Hive.deleteBoxFromDisk(_boxName);
      await Hive.openBox<PlaylistModel>(_boxName);
    }

    // Ensure Favorites playlist exists
    final box = Hive.box<PlaylistModel>(_boxName);
    if (!box.containsKey(_favoritesId)) {
      await box.put(
        _favoritesId,
        PlaylistModel(
          id: _favoritesId,
          name: 'Favorites',
          isSystem: true,
          items: [],
        ),
      );
    }
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    final box = Hive.box<PlaylistModel>(_boxName);
    return box.values.toList();
  }

  Future<void> createPlaylist(String name) async {
    final box = Hive.box<PlaylistModel>(_boxName);
    final id = const Uuid().v4();
    final playlist = PlaylistModel(
      id: id,
      name: name,
      isSystem: false,
      items: [],
    );
    await box.put(id, playlist);
  }

  Future<void> addToPlaylist(String playlistId, PlaylistItem item) async {
    final box = Hive.box<PlaylistModel>(_boxName);
    final playlist = box.get(playlistId);
    if (playlist != null) {
      // Avoid duplicates
      if (!playlist.items.any(
        (e) => e.surahId == item.surahId && e.reciterName == item.reciterName,
      )) {
        playlist.items.add(item);
        playlist.save();
      }
    }
  }

  Future<void> removeFromPlaylist(String playlistId, PlaylistItem item) async {
    final box = Hive.box<PlaylistModel>(_boxName);
    final playlist = box.get(playlistId);
    if (playlist != null) {
      playlist.items.removeWhere(
        (e) => e.surahId == item.surahId && e.reciterName == item.reciterName,
      );
      playlist.save();
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    final box = Hive.box<PlaylistModel>(_boxName);
    await box.delete(playlistId);
  }

  Future<List<PlaylistItem>> getDownloads() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      if (!dir.existsSync()) return [];

      final files = dir.listSync();
      final List<PlaylistItem> downloads = [];

      for (var file in files) {
        if (file.path.endsWith('.mp3')) {
          final filename = file.uri.pathSegments.last;
          // Expected format: "{reciterName}_{surahId}.mp3"
          final parts = filename.replaceAll('.mp3', '').split('_');
          if (parts.length >= 2) {
            final reciterName = parts[0];
            final surahIdStr = parts[1];
            final surahId = int.tryParse(surahIdStr);

            if (surahId != null) {
              final surahInfo = AppConstants.surahMap[surahId];

              downloads.add(
                PlaylistItem(
                  surahId: surahId,
                  surahNameAr: surahInfo?.name ?? "Surah $surahId",
                  surahNameEn: surahInfo?.englishName ?? "Surah $surahId",
                  reciterName: reciterName,
                  reciterLetter: reciterName.isNotEmpty ? reciterName[0] : '?',
                  serverUrl: file.path,
                ),
              );
            }
          }
        }
      }
      return downloads;
    } catch (e) {
      debugPrint("Error getting downloads: $e");
      return [];
    }
  }
}
