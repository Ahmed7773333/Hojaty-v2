import 'occasion_item_model.dart';

class IslamicEventRawModel {
  final String id;
  final int month;
  final int day;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final OccasionIconType iconType;

  const IslamicEventRawModel({
    required this.id,
    required this.month,
    required this.day,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.iconType,
  });

  static const List<IslamicEventRawModel> allEvents = [
    IslamicEventRawModel(
      id: 'islamic_new_year',
      month: 1,
      day: 1,
      nameAr: 'رأس السنة الهجرية',
      nameEn: 'Islamic New Year',
      descriptionAr: 'بداية العام الهجري الجديد',
      descriptionEn: 'Beginning of new Hijri year',
      iconType: OccasionIconType.calendar,
    ),
    IslamicEventRawModel(
      id: 'ashura',
      month: 1,
      day: 10,
      nameAr: 'يوم عاشوراء',
      nameEn: 'Day of Ashura',
      descriptionAr:
          'يوم يُستحب صومه، إحياءً لذكرى وقائع متعددة في التاريخ الإسلامي',
      descriptionEn:
          'Recommended fasting day, commemorating various events in Islamic history',
      iconType: OccasionIconType.sparkle,
    ),
    IslamicEventRawModel(
      id: 'prophet_birthday',
      month: 3,
      day: 12,
      nameAr: 'المولد النبوي الشريف',
      nameEn: 'Mawlid an-Nabi',
      descriptionAr:
          'ذكرى مولد النبي محمد ﷺ (ملاحظة: تختلف مظاهر الاحتفاء به بين العلماء والمجتمعات)',
      descriptionEn:
          'Birth of Prophet Muhammad (PBUH). Note: observance varies among scholars and communities.',
      iconType: OccasionIconType.prophetBirthday,
    ),
    IslamicEventRawModel(
      id: 'isra_and_miraj',
      month: 7,
      day: 27,
      nameAr: 'الإسراء والمعراج',
      nameEn: 'Isra and Mi\'raj',
      descriptionAr: 'ذكرى رحلة الإسراء والمعراج للنبي محمد ﷺ',
      descriptionEn: 'Night Journey of Prophet Muhammad (PBUH)',
      iconType: OccasionIconType.sparkle,
    ),
    IslamicEventRawModel(
      id: 'mid_shaban',
      month: 8,
      day: 15,
      nameAr: 'ليلة النصف من شعبان',
      nameEn: 'Mid-Sha\'ban',
      descriptionAr: 'ليلة البراءة ومغفرة الذنوب',
      descriptionEn: 'Night of Forgiveness (Laylat al-Bara\'ah)',
      iconType: OccasionIconType.sparkle,
    ),
    IslamicEventRawModel(
      id: 'start_of_ramadan',
      month: 9,
      day: 1,
      nameAr: 'بداية شهر رمضان',
      nameEn: 'Start of Ramadan',
      descriptionAr: 'بداية شهر الصيام المبارك',
      descriptionEn: 'Beginning of holy month of fasting',
      iconType: OccasionIconType.sparkle,
    ),
    IslamicEventRawModel(
      id: 'laylat_al_qadr_window',
      month: 9,
      day: 21,
      nameAr: 'بدء تحري ليلة القدر',
      nameEn: 'Laylat al-Qadr window begins',
      descriptionAr:
          'تُلتمس ليلة القدر في الليالي الوترية من العشر الأواخر من رمضان (21، 23، 25، 27، أو 29)، وتُرجى غالبًا في ليلة 27',
      descriptionEn:
          'Night of Power is in the odd nights of the last 10 days of Ramadan (21st, 23rd, 25th, 27th, or 29th). Most commonly observed on the 27th.',
      iconType: OccasionIconType.sparkle,
    ),
    IslamicEventRawModel(
      id: 'eid_al_fitr',
      month: 10,
      day: 1,
      nameAr: 'عيد الفطر',
      nameEn: 'Eid al-Fitr',
      descriptionAr: 'عيد الفطر المبارك وانتهاء شهر الصيام',
      descriptionEn: 'Festival of Breaking the Fast',
      iconType: OccasionIconType.sparkle,
    ),
    IslamicEventRawModel(
      id: 'hajj_begins',
      month: 12,
      day: 8,
      nameAr: 'بداية مناسك الحج (يوم التروية)',
      nameEn: 'Hajj begins',
      descriptionAr: 'انطلاق مناسك الحج السنوي إلى مكة المكرمة',
      descriptionEn: 'Start of the annual pilgrimage to Mecca',
      iconType: OccasionIconType.sheep,
    ),
    IslamicEventRawModel(
      id: 'day_of_arafah',
      month: 12,
      day: 9,
      nameAr: 'يوم عرفة',
      nameEn: 'Day of Arafah',
      descriptionAr: 'أعظم أيام الحج (الركن الأعظم)، ويُستحب صومه لغير الحاج',
      descriptionEn:
          'Most important day of Hajj. Recommended fasting day for non-pilgrims.',
      iconType: OccasionIconType.sheep,
    ),
    IslamicEventRawModel(
      id: 'eid_al_adha',
      month: 12,
      day: 10,
      nameAr: 'عيد الأضحى',
      nameEn: 'Eid al-Adha',
      descriptionAr: 'يوم النحر وعيد الأضحى المبارك',
      descriptionEn: 'Festival of Sacrifice',
      iconType: OccasionIconType.sheep,
    ),
  ];
}
