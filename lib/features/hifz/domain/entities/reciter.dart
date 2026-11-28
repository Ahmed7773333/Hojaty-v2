import 'package:equatable/equatable.dart';

/// Supported audio bitrates for Hifz recitations.
enum AudioQuality { kbps64, kbps128 }

/// Memorization reciter configuration with EveryAyah + Islamic Network fallback.
class Reciter extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String everyAyahFolder128;
  final String? everyAyahFolder64;
  final String islamicNetEdition;

  const Reciter({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.everyAyahFolder128,
    this.everyAyahFolder64,
    required this.islamicNetEdition,
  });

  bool get supports64Kbps => everyAyahFolder64 != null;

  String resolveEveryAyahFolder(AudioQuality quality) {
    if (quality == AudioQuality.kbps64 && everyAyahFolder64 != null) {
      return everyAyahFolder64!;
    }
    return everyAyahFolder128;
  }

  String localizedName(bool isArabic) => isArabic ? nameAr : nameEn;

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        everyAyahFolder128,
        everyAyahFolder64,
        islamicNetEdition,
      ];
}

