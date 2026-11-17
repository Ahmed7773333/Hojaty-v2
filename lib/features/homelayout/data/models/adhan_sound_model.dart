import 'package:equatable/equatable.dart';

enum AdhanSoundIconType {
  makkah,
  madinah,
  mic,
  bell,
}

class AdhanSoundModel extends Equatable {
  final String id;
  final String title;
  final AdhanSoundIconType iconType;
  final String audioAsset;
  final String rawResource;

  const AdhanSoundModel({
    required this.id,
    required this.title,
    required this.iconType,
    required this.audioAsset,
    required this.rawResource,
  });

  @override
  List<Object?> get props => [id, title, iconType, audioAsset, rawResource];
}

