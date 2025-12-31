import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/playlist_model.dart';
import '../../data/datasources/local/playlists_local_data_source.dart';
import '../../data/models/readers_response.dart';
import '../../domain/usecases/get_reciters_usecase.dart';
import 'radio_event.dart';
import 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  final GetRecitersUseCase getReciters;
  final PlaylistsLocalDataSource playlistsDataSource;

  RadioBloc({required this.getReciters, required this.playlistsDataSource})
    : super(const RadioState()) {
    on<LoadRadioEvent>(_onLoad);
    on<SearchRecitersEvent>(_onSearch);

    // Playlist Events
    on<LoadPlaylistsEvent>(_onLoadPlaylists);
    on<CreatePlaylistEvent>(_onCreatePlaylist);
    on<DeletePlaylistEvent>(_onDeletePlaylist);
    on<AddToPlaylistEvent>(_onAddToPlaylist);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<RemoveFromPlaylistEvent>(_onRemoveFromPlaylist);
  }

  FutureOr<void> _onLoad(LoadRadioEvent event, Emitter<RadioState> emit) async {
    emit(state.copyWith(status: RadioStatus.loading));

    // Fetch BOTH Arabic and English lists
    // We already hold logic in Repo to fetch both if missing, but getReciters only returns one.
    // We need to explicitly ask for both to populate our state for search.

    final results = await Future.wait([
      getReciters(language: 'ar'),
      getReciters(language: 'eng'),
    ]);

    final arResult = results[0];
    final enResult = results[1];

    // Check purely for failure in the primary language request?
    // Or if either fails? Let's be robust.

    List<Reciters> arList = [];
    List<Reciters> enList = [];
    String? errorMessage;

    arResult.fold(
      (l) => errorMessage = l.message,
      (r) => arList = r.reciters ?? [],
    );

    enResult.fold(
      (l) => errorMessage = l
          .message, // Overwrite, assuming if one fails potentially both might or we care about connectivity
      (r) => enList = r.reciters ?? [],
    );

    if (errorMessage != null && arList.isEmpty && enList.isEmpty) {
      emit(state.copyWith(status: RadioStatus.error, message: errorMessage));
      return;
    }

    // Determine which one to display based on event.language
    // (User might have passed 'en' or 'ar')
    // Note: API uses 'eng', app uses 'en' usually.
    final isAr = event.language == 'ar';
    final displayList = isAr ? arList : enList;

    // Fallback: if display list is empty but other isn't, maybe show other?
    // For now strict.

    emit(
      state.copyWith(
        status: RadioStatus.loaded,
        recitersAr: arList,
        recitersEn: enList,
        reciters: displayList,
        filteredReciters: displayList,
      ),
    );
  }

  void _onSearch(SearchRecitersEvent event, Emitter<RadioState> emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredReciters: state.reciters));
      return;
    }

    final query = _normalize(event.query);

    // We filter the *display* list (state.reciters), but we use the *auxiliary* lists to check for matches.
    // Since lists should be strictly aligned by ID or content, we can try to find by ID.
    // Optimization: Create a map for the "other" language? Or just iterate.
    // Given list size (~200?), iteration is fine.

    final filtered = state.reciters.where((displayReciter) {
      // 1. Check Display Name
      if (_matches(displayReciter.name, query)) return true;
      if (_matches(displayReciter.letter, query)) return true; // Letter too?

      // 2. Check "Other" Language Name
      // Find the reciter in the other list with the same ID
      // If display is AR, check EN list. etc.
      // But we have both lists in state.

      // Let's check matches in BOTH lists for this ID.
      final id = displayReciter.id;
      if (id == null) return false;

      // Check Arabic List
      final arReciter = state.recitersAr.firstWhere(
        (element) => element.id == id,
        orElse: () => Reciters(id: -1),
      );
      if (arReciter.id != -1 && _matches(arReciter.name, query)) return true;

      // Check English List
      final enReciter = state.recitersEn.firstWhere(
        (element) => element.id == id,
        orElse: () => Reciters(id: -1),
      );
      if (enReciter.id != -1 && _matches(enReciter.name, query)) return true;

      return false;
    }).toList();

    emit(state.copyWith(filteredReciters: filtered));
  }

  bool _matches(String? text, String query) {
    if (text == null) return false;
    return _normalize(text).contains(query);
  }

  // Playlist Handlers

  Future<void> _onLoadPlaylists(
    LoadPlaylistsEvent event,
    Emitter<RadioState> emit,
  ) async {
    emit(state.copyWith(playlistsStatus: PlaylistsStatus.loading));
    try {
      await playlistsDataSource.init();
      final playlists = await playlistsDataSource.getPlaylists();
      final downloads = await playlistsDataSource.getDownloads();

      final downloadsPlaylist = PlaylistModel(
        id: 'downloads_playlist',
        name: 'Downloads',
        isSystem: true,
        items: downloads,
      );

      emit(
        state.copyWith(
          playlistsStatus: PlaylistsStatus.loaded,
          playlists: playlists,
          downloadsPlaylist: downloadsPlaylist,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          playlistsStatus: PlaylistsStatus.error,
          playlistErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreatePlaylist(
    CreatePlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    try {
      await playlistsDataSource.createPlaylist(event.name);
      add(LoadPlaylistsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          playlistsStatus: PlaylistsStatus.error,
          playlistErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeletePlaylist(
    DeletePlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    try {
      await playlistsDataSource.deletePlaylist(event.playlistId);
      add(LoadPlaylistsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          playlistsStatus: PlaylistsStatus.error,
          playlistErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddToPlaylist(
    AddToPlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    try {
      await playlistsDataSource.addToPlaylist(event.playlistId, event.item);
      add(LoadPlaylistsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          playlistsStatus: PlaylistsStatus.error,
          playlistErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RadioState> emit,
  ) async {
    try {
      if (state.isFavorite(event.item.surahId, event.item.reciterName)) {
        await playlistsDataSource.removeFromPlaylist(
          'favorites_playlist',
          event.item,
        );
      } else {
        await playlistsDataSource.addToPlaylist(
          'favorites_playlist',
          event.item,
        );
      }
      add(LoadPlaylistsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          playlistsStatus: PlaylistsStatus.error,
          playlistErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRemoveFromPlaylist(
    RemoveFromPlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    try {
      await playlistsDataSource.removeFromPlaylist(
        event.playlistId,
        event.item,
      );
      add(LoadPlaylistsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          playlistsStatus: PlaylistsStatus.error,
          playlistErrorMessage: e.toString(),
        ),
      );
    }
  }

  String _normalize(String text) {
    // Basic Normalization
    String normalized = text.toLowerCase();

    // Arabic Normalization
    // Remove Tashkeel
    normalized = normalized.replaceAll(RegExp(r'[\u064B-\u065F]'), '');
    // Unify Alifs
    normalized = normalized.replaceAll(RegExp(r'[أإآ]'), 'ا');
    // Unify Taa Marbuta
    normalized = normalized.replaceAll('ة', 'ه');
    // Unify Ya
    normalized = normalized.replaceAll('ى', 'ي');

    return normalized;
  }
}
