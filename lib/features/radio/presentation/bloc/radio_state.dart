import 'package:equatable/equatable.dart';
import '../../data/models/readers_response.dart';
import '../../data/models/playlist_model.dart';

enum RadioStatus { initial, loading, loaded, error }

enum PlaylistsStatus { initial, loading, loaded, error }

class RadioState extends Equatable {
  const RadioState({
    this.status = RadioStatus.initial,
    this.message = '',
    this.reciters = const [],
    this.filteredReciters = const [],
    this.recitersAr = const [],
    this.recitersEn = const [],
    this.playlistsStatus = PlaylistsStatus.initial,
    this.playlists = const [],
    this.downloadsPlaylist,
    this.playlistErrorMessage = '',
  });

  final RadioStatus status;
  final String message;
  final List<Reciters> reciters; // Display list
  final List<Reciters> filteredReciters; // Filtered display list
  final List<Reciters> recitersAr; // Full Arabic list for search
  final List<Reciters> recitersEn; // Full English list for search

  final PlaylistsStatus playlistsStatus;
  final List<PlaylistModel> playlists;
  final PlaylistModel? downloadsPlaylist;
  final String playlistErrorMessage;

  bool isFavorite(int surahId, String reciterName) {
    try {
      final favorites = playlists.firstWhere(
        (p) => p.id == 'favorites_playlist',
      );
      return favorites.items.any(
        (item) => item.surahId == surahId && item.reciterName == reciterName,
      );
    } catch (_) {
      return false;
    }
  }

  RadioState copyWith({
    RadioStatus? status,
    String? message,
    List<Reciters>? reciters,
    List<Reciters>? filteredReciters,
    List<Reciters>? recitersAr,
    List<Reciters>? recitersEn,
    PlaylistsStatus? playlistsStatus,
    List<PlaylistModel>? playlists,
    PlaylistModel? downloadsPlaylist,
    String? playlistErrorMessage,
  }) {
    return RadioState(
      status: status ?? this.status,
      message: message ?? this.message,
      reciters: reciters ?? this.reciters,
      filteredReciters: filteredReciters ?? this.filteredReciters,
      recitersAr: recitersAr ?? this.recitersAr,
      recitersEn: recitersEn ?? this.recitersEn,
      playlistsStatus: playlistsStatus ?? this.playlistsStatus,
      playlists: playlists ?? this.playlists,
      downloadsPlaylist: downloadsPlaylist ?? this.downloadsPlaylist,
      playlistErrorMessage: playlistErrorMessage ?? this.playlistErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    reciters,
    filteredReciters,
    recitersAr,
    recitersEn,
    playlistsStatus,
    playlists,
    downloadsPlaylist,
    playlistErrorMessage,
  ];
}
