import '../../features/homelayout/data/models/occasion_item_model.dart';

class OccasionsMockData {
  static const OccasionItemModel nextOccasion = OccasionItemModel(
    id: 'prophet_birthday',
    title: 'المولد النبوي',
    gregorianDate: '25 أغسطس 2026',
    hijriDate: '9 ذو الحجة 1447',
    daysRemaining: 10,
    description: 'المولد النبوى هو يوم مولد النبي محمد صلى الله عليه وسلم',
    iconType: OccasionIconType.prophetBirthday,
  );

  static List<OccasionItemModel> get occasionsList => const [
    OccasionItemModel(
      id: 'eid_al_adha',
      title: 'عيد الأضحى',
      gregorianDate: '25 أغسطس 2026',
      hijriDate: '10 ذو الحجة 1447',
      daysRemaining: 25,
      description:
          'عيد الأضحى المبارك أحد العيدين عند المسلمين ويوافق يوم 10 ذو الحجة.',
      iconType: OccasionIconType.sheep,
    ),
    OccasionItemModel(
      id: 'hijri_new_year',
      title: 'رأس السنة الهجرية',
      gregorianDate: '25 أغسطس 2026',
      hijriDate: '1 محرم 1448',
      daysRemaining: 220,
      description: 'اليوم الأول من شهر محرم، بداية العام الهجري الجديد.',
      iconType: OccasionIconType.calendar,
    ),
    OccasionItemModel(
      id: 'ashura',
      title: 'عاشوراء',
      gregorianDate: '25 أغسطس 2026',
      hijriDate: '10 محرم 1448',
      daysRemaining: 100,
      description: 'اليوم العاشر من شهر محرم، يوم نجاة موسى عليه السلام.',
      iconType: OccasionIconType.sparkle,
    ),
  ];

  static const String ramadanCountdown = '60:15:20';
}
