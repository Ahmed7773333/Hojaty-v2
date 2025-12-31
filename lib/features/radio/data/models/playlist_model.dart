import 'package:hive/hive.dart';
import 'playlist_item.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 11)
class PlaylistModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isSystem;

  @HiveField(3)
  final List<PlaylistItem> items;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.isSystem,
    required this.items,
  });
}
