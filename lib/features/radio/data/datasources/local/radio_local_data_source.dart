import '../../models/playlist_item_model.dart';
import '../../models/playlist_model.dart';
import '../../models/reciter_model.dart';

abstract class RadioLocalDataSource {
  Future<List<ReciterModel>?> getCachedReciters(String language);
  Future<void> cacheReciters(String language, List<ReciterModel> reciters);
  Future<List<PlaylistModel>> getPlaylists();
  Future<void> createPlaylist(String name);
  Future<void> deletePlaylist(String playlistId);
  Future<void> addToPlaylist(String playlistId, PlaylistItemModel item);
  Future<void> removeFromPlaylist({
    required String playlistId,
    required int surahId,
    required String reciterName,
  });
  Future<bool> isFavorite({
    required int surahId,
    required String reciterName,
  });
  Future<void> toggleFavorite(PlaylistItemModel item);
}

