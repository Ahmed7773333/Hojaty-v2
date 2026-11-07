import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../quran/constants/quran_text_helper.dart';
import '../../data/models/reciter_model.dart';
import '../../domain/repositories/radio_repository.dart';
import '../../domain/usecases/get_reciters_usecase.dart';
import 'radio_event.dart';
import 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  final GetRecitersUseCase getRecitersUseCase;
  final RadioRepository repository;

  RadioBloc({
    required this.getRecitersUseCase,
    required this.repository,
  }) : super(const RadioState()) {
    on<LoadRadioEvent>(_onLoadRadio);
    on<SearchRecitersEvent>(_onSearchReciters);
    on<LoadPlaylistsEvent>(_onLoadPlaylists);
    on<CreatePlaylistEvent>(_onCreatePlaylist);
    on<DeletePlaylistEvent>(_onDeletePlaylist);
    on<AddToPlaylistEvent>(_onAddToPlaylist);
    on<RemoveFromPlaylistEvent>(_onRemoveFromPlaylist);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadRadio(
    LoadRadioEvent event,
    Emitter<RadioState> emit,
  ) async {
    emit(state.copyWith(status: RadioStatus.loading, clearErrorMessage: true));

    final (arResult, enResult, playlistsResult) = await (
      getRecitersUseCase(language: 'ar'),
      getRecitersUseCase(language: 'eng'),
      repository.getPlaylists(),
    ).wait;

    List<ReciterModel> arList = [];
    List<ReciterModel> enList = [];
    String? errorMessage;

    arResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => arList = data,
    );

    enResult.fold(
      (failure) => errorMessage ??= failure.message,
      (data) => enList = data,
    );

    final playlists = playlistsResult.fold(
      (_) => state.playlists,
      (data) => data,
    );

    if (errorMessage != null && arList.isEmpty && enList.isEmpty) {
      emit(
        state.copyWith(
          status: RadioStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      return;
    }

    final isAr = event.language == 'ar';
    final displayList = isAr ? arList : enList;
    _buildSearchIndex(displayList, arList, enList);

    emit(
      state.copyWith(
        status: RadioStatus.success,
        recitersAr: arList,
        recitersEn: enList,
        reciters: displayList,
        filteredReciters: displayList,
        playlists: playlists,
        searchQuery: '',
      ),
    );
  }

  final Map<int, String> _searchNormalizedNames = {};

  void _buildSearchIndex(
    List<ReciterModel> display,
    List<ReciterModel> ar,
    List<ReciterModel> en,
  ) {
    _searchNormalizedNames.clear();
    final arMap = {for (final r in ar) r.id: r.name};
    final enMap = {for (final r in en) r.id: r.name};

    for (final r in display) {
      final buffer = StringBuffer();
      if (r.name != null) buffer.write(' ${_normalize(r.name!)}');
      if (r.letter != null) buffer.write(' ${_normalize(r.letter!)}');

      final arName = arMap[r.id];
      if (arName != null && arName != r.name) {
        buffer.write(' ${_normalize(arName)}');
      }

      final enName = enMap[r.id];
      if (enName != null && enName != r.name) {
        buffer.write(' ${_normalize(enName)}');
      }

      _searchNormalizedNames[r.id??0] = buffer.toString();
    }
  }

  void _onSearchReciters(
    SearchRecitersEvent event,
    Emitter<RadioState> emit,
  ) {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(
        state.copyWith(
          filteredReciters: state.reciters,
          searchQuery: '',
        ),
      );
      return;
    }

    final normalizedQuery = _normalize(query);

    if (_searchNormalizedNames.isEmpty && state.reciters.isNotEmpty) {
      _buildSearchIndex(state.reciters, state.recitersAr, state.recitersEn);
    }

    final filtered = state.reciters.where((displayReciter) {
      final cached = _searchNormalizedNames[displayReciter.id];
      if (cached != null) {
        return cached.contains(normalizedQuery);
      }
      return _matches(displayReciter.name, normalizedQuery) ||
          _matches(displayReciter.letter, normalizedQuery);
    }).toList();

    emit(
      state.copyWith(
        filteredReciters: filtered,
        searchQuery: query,
      ),
    );
  }

  Future<void> _onLoadPlaylists(
    LoadPlaylistsEvent event,
    Emitter<RadioState> emit,
  ) async {
    final result = await repository.getPlaylists();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (playlists) => emit(state.copyWith(playlists: playlists)),
    );
  }

  Future<void> _onCreatePlaylist(
    CreatePlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    final result = await repository.createPlaylist(event.name);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => add(const LoadPlaylistsEvent()),
    );
  }

  Future<void> _onDeletePlaylist(
    DeletePlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    final result = await repository.deletePlaylist(event.playlistId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => add(const LoadPlaylistsEvent()),
    );
  }

  Future<void> _onAddToPlaylist(
    AddToPlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    final result = await repository.addToPlaylist(event.playlistId, event.item);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => add(const LoadPlaylistsEvent()),
    );
  }

  Future<void> _onRemoveFromPlaylist(
    RemoveFromPlaylistEvent event,
    Emitter<RadioState> emit,
  ) async {
    final result = await repository.removeFromPlaylist(
      playlistId: event.playlistId,
      surahId: event.surahId,
      reciterName: event.reciterName,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => add(const LoadPlaylistsEvent()),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RadioState> emit,
  ) async {
    final result = await repository.toggleFavorite(event.item);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => add(const LoadPlaylistsEvent()),
    );
  }

  String _normalize(String text) {
    return QuranTextHelper.normalizeArabic(text).toLowerCase();
  }

  bool _matches(String? text, String normalizedQuery) {
    if (text == null || text.isEmpty) return false;
    return _normalize(text).contains(normalizedQuery);
  }
}

