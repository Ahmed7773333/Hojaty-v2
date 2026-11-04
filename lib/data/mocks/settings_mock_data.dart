import '../../features/homelayout/data/models/adhan_sound_model.dart';
import '../../features/homelayout/data/models/calculation_method_model.dart';
import '../../features/homelayout/data/models/font_type_model.dart';

class SettingsMockData {
  static List<FontTypeModel> get fontTypes => const [
        FontTypeModel(
          id: 'naskh',
          title: 'نسخ',
          subtitle: 'خط واضح ومريح للقراءة',
        ),
        FontTypeModel(
          id: 'uthmani',
          title: 'عثماني',
          subtitle: 'الرسم العثماني المعتمد للمصحف',
        ),
        FontTypeModel(
          id: 'amiri',
          title: 'أميري',
          subtitle: 'خط عربي كلاسيكي أصيل',
        ),
      ];

  static List<CalculationMethodModel> get calculationMethods => const [
        CalculationMethodModel(
          id: 'mwl',
          title: 'رابطة العالم الإسلامي',
          subtitle: 'الأكثر شيوعًا في مصر والدول العربية',
        ),
        CalculationMethodModel(
          id: 'isna',
          title: 'الجمعية الإسلامية لأمريكا الشمالية',
          subtitle: 'ISNA',
        ),
        CalculationMethodModel(
          id: 'egypt',
          title: 'الهيئة المصرية العامة للمساحة',
          subtitle: 'موصى بها في مصر',
        ),
        CalculationMethodModel(
          id: 'umm_al_qura',
          title: 'أم القرى، مكة المكرمة',
          subtitle: 'المملكة العربية السعودية',
        ),
        CalculationMethodModel(
          id: 'karachi',
          title: 'جامعة العلوم الإسلامية، كراتشي',
          subtitle: 'باكستان وأفغانستان والهند',
        ),
      ];

  static List<AdhanSoundModel> get adhanSounds => const [
        AdhanSoundModel(
          id: 'makkah',
          title: 'أذان مكة المكرمة',
          iconType: AdhanSoundIconType.makkah,
          audioAsset: 'assets/audio/makka azan.mp3',
          rawResource: 'makka_azan',
        ),
        AdhanSoundModel(
          id: 'madinah',
          title: 'أذان المدينة المنورة',
          iconType: AdhanSoundIconType.madinah,
          audioAsset: 'assets/audio/madina azan.mp3',
          rawResource: 'madina_azan',
        ),
        AdhanSoundModel(
          id: 'azan',
          title: 'الأذان التقليدي',
          iconType: AdhanSoundIconType.mic,
          audioAsset: 'assets/audio/azan.mp3',
          rawResource: 'azan',
        ),
      ];

  static List<String> get cities => const [
        'القاهرة، مصر',
        'الجيزة، مصر',
        'الإسكندرية، مصر',
        'مكة المكرمة، السعودية',
        'المدينة المنورة، السعودية',
        'الرياض، السعودية',
        'دبي، الإمارات',
        'عمان، الأردن',
        'الدوحة، قطر',
      ];
}
