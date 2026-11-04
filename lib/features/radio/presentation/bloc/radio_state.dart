import 'package:equatable/equatable.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/reciter_model.dart';

enum RadioStatus {
  initial,
  loading,
  success,
  failure,
}

class RadioState extends Equatable {
  final RadioStatus status;
  final List<ReciterModel> reciters;
  final List<ReciterModel> filteredReciters;
  final List<ReciterModel> recitersAr;
  final List<ReciterModel> recitersEn;
  final List<PlaylistModel> playlists;
  final String searchQuery;
  final String? errorMessage;

  const RadioState({
    this.status = RadioStatus.initial,
    this.reciters = const [],
    this.filteredReciters = const [],
    this.recitersAr = const [],
    this.recitersEn = const [],
    this.playlists = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  PlaylistModel? get favoritesPlaylist {
    for (final playlist in playlists) {
      if (playlist.id == 'favorites_playlist') return playlist;
    }
    return null;
  }

  PlaylistModel? get downloadsPlaylist {
    for (final playlist in playlists) {
      if (playlist.id == 'downloads_playlist') return playlist;
    }
    return null;
  }

  bool isFavorite(int surahId, String reciterName) {
    final fav = favoritesPlaylist;
    if (fav == null) return false;
    return fav.items.any(
      (item) => item.surahId == surahId && item.reciterName == reciterName,
    );
  }

  RadioState copyWith({
    RadioStatus? status,
    List<ReciterModel>? reciters,
    List<ReciterModel>? filteredReciters,
    List<ReciterModel>? recitersAr,
    List<ReciterModel>? recitersEn,
    List<PlaylistModel>? playlists,
    String? searchQuery,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RadioState(
      status: status ?? this.status,
      reciters: reciters ?? this.reciters,
      filteredReciters: filteredReciters ?? this.filteredReciters,
      recitersAr: recitersAr ?? this.recitersAr,
      recitersEn: recitersEn ?? this.recitersEn,
      playlists: playlists ?? this.playlists,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        reciters,
        filteredReciters,
        recitersAr,
        recitersEn,
        playlists,
        searchQuery,
        errorMessage,
      ];
}
