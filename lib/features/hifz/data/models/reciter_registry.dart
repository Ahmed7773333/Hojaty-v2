import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';

/// Registry of memorization reciters with EveryAyah primary and Islamic Network fallback URLs.
class ReciterRegistry {
  const ReciterRegistry._();

  static const Reciter husaryMuallim = Reciter(
    id: 'husary_muallim',
    nameAr: 'محمود خليل الحصري (المعلم)',
    nameEn: 'Al-Husary (Muallim)',
    everyAyahFolder128: 'Husary_Muallim_128kbps',
    islamicNetEdition: 'ar.husarymujawwad',
  );

  static const Reciter husaryMurattal = Reciter(
    id: 'husary_64',
    nameAr: 'محمود خليل الحصري (مرتل)',
    nameEn: 'Al-Husary (Murattal)',
    everyAyahFolder128: 'Husary_128kbps',
    everyAyahFolder64: 'Husary_64kbps',
    islamicNetEdition: 'ar.husary',
  );

  static const Reciter minshawiMurattal = Reciter(
    id: 'minshawi_128',
    nameAr: 'محمد صديق المنشاوي (مرتل)',
    nameEn: 'Al-Minshawi (Murattal)',
    everyAyahFolder128: 'Minshawy_Murattal_128kbps',
    islamicNetEdition: 'ar.minshawi',
  );

  static const Reciter alafasy = Reciter(
    id: 'alafasy_128',
    nameAr: 'مشاري راشد العفاسي',
    nameEn: 'Mishary Alafasy',
    everyAyahFolder128: 'Alafasy_128kbps',
    everyAyahFolder64: 'Alafasy_64kbps',
    islamicNetEdition: 'ar.alafasy',
  );

  static const List<Reciter> all = <Reciter>[
    husaryMuallim,
    husaryMurattal,
    minshawiMurattal,
    alafasy,
  ];

  static Reciter byId(String id) {
    for (final reciter in all) {
      if (reciter.id == id) return reciter;
    }
    return husaryMuallim;
  }

  static String primaryUrl(
    Reciter reciter,
    int surah,
    int ayah,
    AudioQuality quality,
  ) {
    final folder = reciter.resolveEveryAyahFolder(quality);
    final sss = GlobalAyahMapper.padThree(surah);
    final aaa = GlobalAyahMapper.padThree(ayah);
    return 'https://everyayah.com/data/$folder/$sss$aaa.mp3';
  }

  static String fallbackUrl(
    Reciter reciter,
    int globalAyahId,
    AudioQuality quality,
  ) {
    final bitrate = quality == AudioQuality.kbps64 ? 64 : 128;
    return 'https://cdn.islamic.network/quran/audio/$bitrate/${reciter.islamicNetEdition}/$globalAyahId.mp3';
  }
}

