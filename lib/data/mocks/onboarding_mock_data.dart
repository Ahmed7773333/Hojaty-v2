import '../../features/onboarding/data/models/onboarding_item_model.dart';
import '../../l10n/app_localizations.dart';

class OnboardingMockData {
  static List<OnboardingItemModel> get items => const [
        OnboardingItemModel(
          index: 0,
          iconType: OnboardingIconType.prayerTimes,
          subtitleResolver: _getSlide1Subtitle,
          titleResolver: _getSlide1Title,
          descriptionResolver: _getSlide1Desc,
        ),
        OnboardingItemModel(
          index: 1,
          iconType: OnboardingIconType.quranAthkar,
          subtitleResolver: _getSlide2Subtitle,
          titleResolver: _getSlide2Title,
          descriptionResolver: _getSlide2Desc,
        ),
        // OnboardingItemModel(
        //   index: 2,
        //   iconType: OnboardingIconType.anaOsaly,
        //   subtitleResolver: _getSlide3Subtitle,
        //   titleResolver: _getSlide3Title,
        //   descriptionResolver: _getSlide3Desc,
        // ),
        OnboardingItemModel(
          index: 2,
          iconType: OnboardingIconType.hijriCalendar,
          subtitleResolver: _getSlide4Subtitle,
          titleResolver: _getSlide4Title,
          descriptionResolver: _getSlide4Desc,
        ),
      ];

  static String _getSlide1Subtitle(dynamic s) =>
      (s as AppLocalizations).onboardingSlide1Subtitle;
  static String _getSlide1Title(dynamic s) =>
      (s as AppLocalizations).onboardingSlide1Title;
  static String _getSlide1Desc(dynamic s) =>
      (s as AppLocalizations).onboardingSlide1Desc;

  static String _getSlide2Subtitle(dynamic s) =>
      (s as AppLocalizations).onboardingSlide2Subtitle;
  static String _getSlide2Title(dynamic s) =>
      (s as AppLocalizations).onboardingSlide2Title;
  static String _getSlide2Desc(dynamic s) =>
      (s as AppLocalizations).onboardingSlide2Desc;

  static String _getSlide3Subtitle(dynamic s) =>
      (s as AppLocalizations).onboardingSlide3Subtitle;
  static String _getSlide3Title(dynamic s) =>
      (s as AppLocalizations).onboardingSlide3Title;
  static String _getSlide3Desc(dynamic s) =>
      (s as AppLocalizations).onboardingSlide3Desc;

  static String _getSlide4Subtitle(dynamic s) =>
      (s as AppLocalizations).onboardingSlide4Subtitle;
  static String _getSlide4Title(dynamic s) =>
      (s as AppLocalizations).onboardingSlide4Title;
  static String _getSlide4Desc(dynamic s) =>
      (s as AppLocalizations).onboardingSlide4Desc;
}
