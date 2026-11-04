import 'package:equatable/equatable.dart';
import '../../data/models/playlist_item_model.dart';

abstract class RadioEvent extends Equatable {
  const RadioEvent();

  @override
  List<Object?> get props => [];
}

class LoadRadioEvent extends RadioEvent {
  final String language;

  const LoadRadioEvent({required this.language});

  @override
  List<Object?> get props => [language];
}

class SearchRecitersEvent extends RadioEvent {
  final String query;

  const SearchRecitersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadPlaylistsEvent extends RadioEvent {
  const LoadPlaylistsEvent();
}

class CreatePlaylistEvent extends RadioEvent {
  final String name;

  const CreatePlaylistEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class DeletePlaylistEvent extends RadioEvent {
  final String playlistId;

  const DeletePlaylistEvent(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}

class AddToPlaylistEvent extends RadioEvent {
  final String playlistId;
  final PlaylistItemModel item;

  const AddToPlaylistEvent({
    required this.playlistId,
    required this.item,
  });

  @override
  List<Object?> get props => [playlistId, item];
}

class RemoveFromPlaylistEvent extends RadioEvent {
  final String playlistId;
  final int surahId;
  final String reciterName;

  const RemoveFromPlaylistEvent({
    required this.playlistId,
    required this.surahId,
    required this.reciterName,
  });

  @override
  List<Object?> get props => [playlistId, surahId, reciterName];
}

class ToggleFavoriteEvent extends RadioEvent {
  final PlaylistItemModel item;

  const ToggleFavoriteEvent(this.item);

  @override
  List<Object?> get props => [item];
}

