import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/playlist_item_model.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/reciter_model.dart';

abstract class RadioRepository {
  Future<Either<Failure, List<ReciterModel>>> getReciters({required String language});
  Future<Either<Failure, List<PlaylistModel>>> getPlaylists();
  Future<Either<Failure, void>> createPlaylist(String name);
  Future<Either<Failure, void>> deletePlaylist(String playlistId);
  Future<Either<Failure, void>> addToPlaylist(String playlistId, PlaylistItemModel item);
  Future<Either<Failure, void>> removeFromPlaylist({
    required String playlistId,
    required int surahId,
    required String reciterName,
  });
  Future<Either<Failure, bool>> isFavorite({
    required int surahId,
    required String reciterName,
  });
  Future<Either<Failure, void>> toggleFavorite(PlaylistItemModel item);
}

