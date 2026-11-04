import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/radio_repository.dart';
import '../datasources/local/radio_local_data_source.dart';
import '../datasources/remote/radio_remote_data_source.dart';
import '../models/playlist_item_model.dart';
import '../models/playlist_model.dart';
import '../models/reciter_model.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioRemoteDataSource remoteDataSource;
  final RadioLocalDataSource localDataSource;

  const RadioRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ReciterModel>>> getReciters({
    required String language,
  }) async {
    try {
      final apiLanguage = language == 'en' ? 'eng' : language;
      final cached = await localDataSource.getCachedReciters(apiLanguage);
      if (cached != null && cached.isNotEmpty) {
        return Right(cached);
      }

      // Fetch both Arabic and English to support bilingual search and offline
      final results = await Future.wait([
        remoteDataSource.getReciters(language: 'ar'),
        remoteDataSource.getReciters(language: 'eng'),
      ]);

      final arData = results[0];
      final enData = results[1];

      if (arData.isNotEmpty) await localDataSource.cacheReciters('ar', arData);
      if (enData.isNotEmpty) await localDataSource.cacheReciters('eng', enData);

      final result = apiLanguage == 'eng' ? enData : arData;
      return Right(result.isNotEmpty ? result : (arData.isNotEmpty ? arData : enData));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaylistModel>>> getPlaylists() async {
    try {
      final playlists = await localDataSource.getPlaylists();
      return Right(playlists);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPlaylist(String name) async {
    try {
      await localDataSource.createPlaylist(name);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlaylist(String playlistId) async {
    try {
      await localDataSource.deletePlaylist(playlistId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToPlaylist(
    String playlistId,
    PlaylistItemModel item,
  ) async {
    try {
      await localDataSource.addToPlaylist(playlistId, item);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromPlaylist({
    required String playlistId,
    required int surahId,
    required String reciterName,
  }) async {
    try {
      await localDataSource.removeFromPlaylist(
        playlistId: playlistId,
        surahId: surahId,
        reciterName: reciterName,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite({
    required int surahId,
    required String reciterName,
  }) async {
    try {
      final fav = await localDataSource.isFavorite(
        surahId: surahId,
        reciterName: reciterName,
      );
      return Right(fav);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(PlaylistItemModel item) async {
    try {
      await localDataSource.toggleFavorite(item);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

