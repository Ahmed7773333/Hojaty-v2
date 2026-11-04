import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/playlist_item_model.dart';
import '../../models/playlist_model.dart';
import '../../models/reciter_model.dart';
import 'radio_local_data_source.dart';

class RadioLocalDataSourceImpl implements RadioLocalDataSource {
  static const String _boxName = 'radio_data_box';
  static const String _keyPlaylists = 'user_playlists_json';
  static const String favoritesId = 'favorites_playlist';
  static const String downloadsId = 'downloads_playlist';

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  @override
  Future<List<ReciterModel>?> getCachedReciters(String language) async {
    try {
      final box = await _getBox();
      final key = 'reciters_${language.toLowerCase()}';
      final raw = box.get(key) as String?;
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded
            .map((e) => ReciterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> cacheReciters(String language, List<ReciterModel> reciters) async {
    try {
      final box = await _getBox();
      final key = 'reciters_${language.toLowerCase()}';
      final encoded = jsonEncode(reciters.map((e) => e.toJson()).toList());
      await box.put(key, encoded);
    } catch (_) {}
  }

  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    try {
      final box = await _getBox();
      final raw = box.get(_keyPlaylists) as String?;
      List<PlaylistModel> playlists = [];
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        playlists = decoded
            .map((e) => PlaylistModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (!playlists.any((p) => p.id == favoritesId)) {
        playlists.insert(
          0,
          const PlaylistModel(
            id: favoritesId,
            name: 'المفضلة',
            isSystem: true,
            items: [],
          ),
        );
      }

      if (!playlists.any((p) => p.id == downloadsId)) {
        playlists.insert(
          playlists.length >= 2 ? 1 : playlists.length,
          const PlaylistModel(
            id: downloadsId,
            name: 'التسجيلات المحملة',
            isSystem: true,
            items: [],
          ),
        );
      }

      // Validate downloaded files still exist on disk
      final downloadsIndex = playlists.indexWhere((p) => p.id == downloadsId);
      if (downloadsIndex != -1) {
        final downloads = playlists[downloadsIndex];
        if (downloads.items.isNotEmpty) {
          final dir = await getApplicationDocumentsDirectory();
          final radioDir = Directory('${dir.path}/radio_downloads');
          final validItems = <PlaylistItemModel>[];
          if (await radioDir.exists()) {
            for (final item in downloads.items) {
              final sanitized = item.reciterName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
              final file = File('${radioDir.path}/${sanitized}_${item.surahId}.mp3');
              if (await file.exists() && await file.length() > 0) {
                validItems.add(item);
              }
            }
          }
          if (validItems.length != downloads.items.length) {
            playlists[downloadsIndex] = downloads.copyWith(items: validItems);
            await _savePlaylists(playlists);
          }
        }
      }

      return playlists;
    } catch (_) {}

    return const [
      PlaylistModel(id: favoritesId, name: 'المفضلة', isSystem: true, items: []),
      PlaylistModel(id: downloadsId, name: 'التسجيلات المحملة', isSystem: true, items: []),
    ];
  }

  Future<void> _savePlaylists(List<PlaylistModel> playlists) async {
    final box = await _getBox();
    final encoded = jsonEncode(playlists.map((e) => e.toJson()).toList());
    await box.put(_keyPlaylists, encoded);
  }

  @override
  Future<void> createPlaylist(String name) async {
    final playlists = await getPlaylists();
    final newId = 'playlist_${DateTime.now().millisecondsSinceEpoch}';
    final updated = [
      ...playlists,
      PlaylistModel(id: newId, name: name, isSystem: false, items: const []),
    ];
    await _savePlaylists(updated);
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    final playlists = await getPlaylists();
    final updated = playlists.where((p) => p.id != playlistId || p.isSystem).toList();
    await _savePlaylists(updated);
  }

  @override
  Future<void> addToPlaylist(String playlistId, PlaylistItemModel item) async {
    final playlists = await getPlaylists();
    final updated = playlists.map((p) {
      if (p.id == playlistId) {
        if (!p.items.any((e) => e.surahId == item.surahId && e.reciterName == item.reciterName)) {
          return p.copyWith(items: [...p.items, item]);
        }
      }
      return p;
    }).toList();
    await _savePlaylists(updated);
  }

  @override
  Future<void> removeFromPlaylist({
    required String playlistId,
    required int surahId,
    required String reciterName,
  }) async {
    final playlists = await getPlaylists();
    final updated = playlists.map((p) {
      if (p.id == playlistId) {
        final filteredItems = p.items
            .where((e) => !(e.surahId == surahId && e.reciterName == reciterName))
            .toList();
        return p.copyWith(items: filteredItems);
      }
      return p;
    }).toList();
    await _savePlaylists(updated);
  }

  @override
  Future<bool> isFavorite({
    required int surahId,
    required String reciterName,
  }) async {
    final playlists = await getPlaylists();
    final fav = playlists.firstWhere(
      (p) => p.id == favoritesId,
      orElse: () => const PlaylistModel(id: favoritesId, name: 'المفضلة', isSystem: true, items: []),
    );
    return fav.items.any((e) => e.surahId == surahId && e.reciterName == reciterName);
  }

  @override
  Future<void> toggleFavorite(PlaylistItemModel item) async {
    final isFav = await isFavorite(surahId: item.surahId, reciterName: item.reciterName);
    if (isFav) {
      await removeFromPlaylist(
        playlistId: favoritesId,
        surahId: item.surahId,
        reciterName: item.reciterName,
      );
    } else {
      await addToPlaylist(favoritesId, item);
    }
  }
}

