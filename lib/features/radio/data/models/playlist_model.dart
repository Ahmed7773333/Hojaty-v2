import 'package:equatable/equatable.dart';
import 'playlist_item_model.dart';

class PlaylistModel extends Equatable {
  final String id;
  final String name;
  final bool isSystem;
  final List<PlaylistItemModel> items;

  const PlaylistModel({
    required this.id,
    required this.name,
    this.isSystem = false,
    this.items = const [],
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isSystem: json['isSystem'] as bool? ?? false,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PlaylistItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isSystem': isSystem,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  PlaylistModel copyWith({
    String? id,
    String? name,
    bool? isSystem,
    List<PlaylistItemModel>? items,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSystem: isSystem ?? this.isSystem,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, name, isSystem, items];
}

