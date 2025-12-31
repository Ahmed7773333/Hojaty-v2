import 'package:hive/hive.dart';

part 'playlist_item.g.dart';

@HiveType(typeId: 10)
class PlaylistItem extends HiveObject {
  @HiveField(0)
  final int surahId;

  @HiveField(1)
  final String surahNameAr;

  @HiveField(2)
  final String surahNameEn;

  @HiveField(3)
  final String reciterName;

  @HiveField(4)
  final String reciterLetter;

  @HiveField(5)
  final String serverUrl;

  @HiveField(6)
  final String? reciterId;

  PlaylistItem({
    required this.surahId,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.reciterName,
    required this.reciterLetter,
    required this.serverUrl,
    this.reciterId,
  });
}
