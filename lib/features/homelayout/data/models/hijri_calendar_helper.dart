import 'hijri_date_model.dart';
import 'islamic_event_raw_model.dart';
import 'occasion_item_model.dart';

class HijriCalendarHelper {
  static const List<String> hijriMonthsAr = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  static const List<String> hijriMonthsEn = [
    'Muharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' al-Thani',
    'Jumada al-Awwal',
    'Jumada al-Thani',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  static const List<String> gregorianMonthsAr = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static const List<String> gregorianMonthsEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<int> hijriMonthLengths = [
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
  ];

  static String getHijriMonthName(int monthNumber, {required String language}) {
    final idx = (monthNumber - 1).clamp(0, 11);
    return language == 'ar' ? hijriMonthsAr[idx] : hijriMonthsEn[idx];
  }

  static String getGregorianMonthName(
    int monthNumber, {
    required String language,
  }) {
    final idx = (monthNumber - 1).clamp(0, 11);
    return language == 'ar' ? gregorianMonthsAr[idx] : gregorianMonthsEn[idx];
  }

  /// Calculates days from start of Hijri year to given month and day
  static int _hijriDayOfYear(int month, int day) {
    int sum = 0;
    for (int i = 0; i < month - 1; i++) {
      sum += hijriMonthLengths[i];
    }
    return sum + day;
  }

  /// Calculates occasions list from current Hijri date
  static List<OccasionItemModel> calculateOccasions(
    HijriDateModel currentHijri, {
    required String language,
    DateTime? now,
  }) {
    final isArabic = language == 'ar';
    final currentDate = now ?? DateTime.now();

    final curMonth = currentHijri.monthNumber;
    final curDay = currentHijri.dayNumber;
    final curYear = currentHijri.yearNumber;
    final curDayOfYear = _hijriDayOfYear(curMonth, curDay);

    final result = <OccasionItemModel>[];

    for (final raw in IslamicEventRawModel.allEvents) {
      int targetYear = curYear;
      final rawDayOfYear = _hijriDayOfYear(raw.month, raw.day);

      int dayDifference = rawDayOfYear - curDayOfYear;
      if (dayDifference < 0) {
        // Event is in the next Hijri year
        targetYear = curYear + 1;
        dayDifference += 354;
      }

      final targetDateTime = currentDate.add(Duration(days: dayDifference));

      final title = isArabic ? raw.nameAr : raw.nameEn;
      final description = isArabic ? raw.descriptionAr : raw.descriptionEn;
      final monthName = getHijriMonthName(raw.month, language: language);
      final hijriDateStr =
          '${raw.day} $monthName $targetYear ${isArabic ? 'هـ' : 'AH'}';

      final gregMonthName = getGregorianMonthName(
        targetDateTime.month,
        language: language,
      );
      final gregorianDateStr =
          '${targetDateTime.day} $gregMonthName ${targetDateTime.year}';

      result.add(
        OccasionItemModel(
          id: raw.id,
          title: title,
          gregorianDate: gregorianDateStr,
          hijriDate: hijriDateStr,
          daysRemaining: dayDifference,
          description: description,
          iconType: raw.iconType,
          targetDateTime: targetDateTime,
          hijriMonth: raw.month,
          hijriDay: raw.day,
          hijriYear: targetYear,
        ),
      );
    }

    // Sort ascending by days remaining
    result.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return result;
  }

  /// Generates a calendar grid for a given Hijri month
  /// [startWeekday]: 0 for Friday, 1 for Saturday, 2 for Sunday, etc.
  static List<CalendarGridCell> generateHijriMonthGrid({
    required int monthNumber,
    required int yearNumber,
    required int activeDay,
    int startWeekdayOffset = 0,
  }) {
    final idx = (monthNumber - 1).clamp(0, 11);
    final daysInCurrentMonth = hijriMonthLengths[idx];
    final prevMonthIdx = (idx - 1 + 12) % 12;
    final daysInPrevMonth = hijriMonthLengths[prevMonthIdx];

    final cells = <CalendarGridCell>[];

    // Leading days from previous month
    final leadingCount = startWeekdayOffset % 7;
    for (int i = leadingCount - 1; i >= 0; i--) {
      cells.add(
        CalendarGridCell(
          dayNumber: daysInPrevMonth - i,
          isCurrentMonth: false,
          isActive: false,
        ),
      );
    }

    // Days in current month
    for (int day = 1; day <= daysInCurrentMonth; day++) {
      cells.add(
        CalendarGridCell(
          dayNumber: day,
          isCurrentMonth: true,
          isActive: day == activeDay,
        ),
      );
    }

    // Trailing days from next month to complete rows (multiples of 7)
    final trailingCount = (7 - (cells.length % 7)) % 7;
    for (int day = 1; day <= trailingCount; day++) {
      cells.add(
        CalendarGridCell(
          dayNumber: day,
          isCurrentMonth: false,
          isActive: false,
        ),
      );
    }

    return cells;
  }

  /// Generates a calendar grid for a given Gregorian month
  static List<CalendarGridCell> generateGregorianMonthGrid({
    required int year,
    required int month,
    required int activeDay,
  }) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final daysInPrevMonth = DateTime(year, month, 0).day;

    // Convert weekday (Monday=1, Sunday=7) to Friday-first (Friday=0, Saturday=1, Sunday=2, Monday=3, etc.)
    // Friday (5) -> 0, Saturday (6) -> 1, Sunday (7) -> 2, Monday (1) -> 3, Tuesday (2) -> 4, Wednesday (3) -> 5, Thursday (4) -> 6
    final startOffset = (firstDayOfMonth.weekday + 2) % 7;

    final cells = <CalendarGridCell>[];

    // Previous month days
    for (int i = startOffset - 1; i >= 0; i--) {
      cells.add(
        CalendarGridCell(
          dayNumber: daysInPrevMonth - i,
          isCurrentMonth: false,
          isActive: false,
        ),
      );
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      cells.add(
        CalendarGridCell(
          dayNumber: day,
          isCurrentMonth: true,
          isActive: day == activeDay,
        ),
      );
    }

    // Next month days
    final trailing = (7 - (cells.length % 7)) % 7;
    for (int day = 1; day <= trailing; day++) {
      cells.add(
        CalendarGridCell(
          dayNumber: day,
          isCurrentMonth: false,
          isActive: false,
        ),
      );
    }

    return cells;
  }
}

class CalendarGridCell {
  final int dayNumber;
  final bool isCurrentMonth;
  final bool isActive;

  const CalendarGridCell({
    required this.dayNumber,
    required this.isCurrentMonth,
    required this.isActive,
  });
}
