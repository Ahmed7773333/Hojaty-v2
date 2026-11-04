import '../../core/utils/app_colors.dart';
import '../../features/homelayout/data/models/adhan_setting_model.dart';
import '../../features/homelayout/data/models/banner_model.dart';
import '../../features/homelayout/data/models/notification_item_model.dart';
import '../../features/homelayout/data/models/prayer_time_model.dart';
import '../../features/homelayout/data/models/quick_access_model.dart';
import '../../l10n/app_localizations.dart';

class HomeMockData {
  static List<PrayerTimeModel> get prayerTimes => const [
        PrayerTimeModel(
          type: PrayerType.fajr,
          time: '04:48',
          isNotificationEnabled: false,
          isCurrent: false,
          isNext: false,
          startWindow: '05:15ص',
          endWindow: '05:35ص',
        ),
        PrayerTimeModel(
          type: PrayerType.dhuhr,
          time: '12:59',
          isNotificationEnabled: true,
          isCurrent: false,
          isNext: false,
          startWindow: '01:15م',
          endWindow: '01:35م',
        ),
        PrayerTimeModel(
          type: PrayerType.asr,
          time: '04:36',
          isNotificationEnabled: true,
          isCurrent: false,
          isNext: false,
          startWindow: '01:15م',
          endWindow: '01:35م',
        ),
        PrayerTimeModel(
          type: PrayerType.maghrib,
          time: '07:37',
          isNotificationEnabled: true,
          isCurrent: false,
          isNext: false,
          startWindow: '01:15م',
          endWindow: '01:35م',
        ),
        PrayerTimeModel(
          type: PrayerType.isha,
          time: '09:00',
          isNotificationEnabled: true,
          isCurrent: false,
          isNext: false,
          startWindow: '01:15م',
          endWindow: '01:35م',
        ),
      ];

  static List<QuickAccessModel> get quickAccessItems => [
        QuickAccessModel(
          type: QuickAccessType.quran,
          titleResolver: (s) => (s as AppLocalizations).quranKareem,
          subtitleResolver: (s) => (s as AppLocalizations).continueReading,
        ),
        QuickAccessModel(
          type: QuickAccessType.athkar,
          titleResolver: (s) => (s as AppLocalizations).athkar,
          subtitleResolver: (s) => (s as AppLocalizations).morningAthkar,
        ),
        QuickAccessModel(
          type: QuickAccessType.occasions,
          titleResolver: (s) => (s as AppLocalizations).occasions,
          subtitleResolver: (s) => (s as AppLocalizations).hijriCalendar,
        ),
        QuickAccessModel(
          type: QuickAccessType.radio,
          titleResolver: (s) => (s as AppLocalizations).radio,
          subtitleResolver: (s) => (s as AppLocalizations).radioSubtitle,
        ),
        QuickAccessModel(
          type: QuickAccessType.books,
          titleResolver: (s) => (s as AppLocalizations).hadithBooksTitle,
          subtitleResolver: (s) => (s as AppLocalizations).hadithBooksSubtitle,
        ),
      ];

  static List<NotificationItemModel> get notifications => const [
        NotificationItemModel(
          id: '1',
          title: 'حان وقت صلاة المغرب',
          body: 'وقت صلاة المغرب: 06:46 م — القاهرة، مصر',
          timeAgo: 'منذ 5 دقائق',
          iconType: NotificationIconType.prayer,
          stripeColor: AppColors.primaryDark,
        ),
        NotificationItemModel(
          id: '2',
          title: 'مناسبة قادمة: يوم عرفة',
          body: 'يوم عرفة بعد 12 يومًا — 9 ذو الحجة 1447 هـ',
          timeAgo: 'منذ ساعة',
          iconType: NotificationIconType.occasion,
          stripeColor: AppColors.accentGoldDark,
        ),
        NotificationItemModel(
          id: '3',
          title: 'أذكار الصباح',
          body: 'لا تنسَ أذكار الصباح، ابدأ يومك بذكر الله',
          timeAgo: 'منذ 3 ساعات',
          iconType: NotificationIconType.athkar,
          stripeColor: AppColors.primaryDark,
        ),
        NotificationItemModel(
          id: '4',
          title: 'حان وقت صلاة العصر',
          body: 'وقت صلاة العصر: 03:18 م — القاهرة، مصر',
          timeAgo: 'منذ 4 ساعات',
          iconType: NotificationIconType.prayer,
          stripeColor: AppColors.primaryDarkBorder,
        ),
      ];

  static const AdhanSettingModel defaultAdhanSettings = AdhanSettingModel();

  static List<BannerModel> get banners => const [
        BannerModel(
          id: '1',
          link: 'https://anaosaly.com/special-offer',
          imageLink: 'https://api.anaosaly.com/storage/banners/banner_1.png',
        ),
        BannerModel(
          id: '2',
          link: 'https://anaosaly.com/ramadan',
          imageLink: 'https://api.anaosaly.com/storage/banners/banner_2.png',
        ),
      ];
}

