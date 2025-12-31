import 'package:equatable/equatable.dart';
import '../../data/models/playlist_item.dart';

abstract class RadioEvent extends Equatable {
  const RadioEvent();

  @override
  List<Object> get props => [];
}

class LoadRadioEvent extends RadioEvent {
  final String language;
  const LoadRadioEvent({this.language = 'ar'});

  @override
  List<Object> get props => [language];
}

class SearchRecitersEvent extends RadioEvent {
  final String query;
  const SearchRecitersEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LoadPlaylistsEvent extends RadioEvent {}

class CreatePlaylistEvent extends RadioEvent {
  final String name;

  const CreatePlaylistEvent(this.name);

  @override
  List<Object> get props => [name];
}

class DeletePlaylistEvent extends RadioEvent {
  final String playlistId;

  const DeletePlaylistEvent(this.playlistId);

  @override
  List<Object> get props => [playlistId];
}

class AddToPlaylistEvent extends RadioEvent {
  final String playlistId;
  final PlaylistItem item;

  const AddToPlaylistEvent({required this.playlistId, required this.item});

  @override
  List<Object> get props => [playlistId, item];
}

class ToggleFavoriteEvent extends RadioEvent {
  final PlaylistItem item;

  const ToggleFavoriteEvent(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveFromPlaylistEvent extends RadioEvent {
  final String playlistId;
  final PlaylistItem item;

  const RemoveFromPlaylistEvent({required this.playlistId, required this.item});

  @override
  List<Object> get props => [playlistId, item];
}
