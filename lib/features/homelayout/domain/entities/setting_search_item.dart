import 'package:equatable/equatable.dart';

enum SettingSearchDestination {
  adhanSettingsTab,
  settingsTab,
  locationSettingsPage,
  adhanSoundsLibraryPage,
  salawatSettingsPage,
  themeSettingsPage,
  languageSettingsPage,
}

class SettingSearchItem extends Equatable {
  final String id;
  final String titleAr;
  final String titleEn;
  final String breadcrumbAr;
  final String breadcrumbEn;
  final List<String> synonymsAndTags;
  final String routeOrSectionKey;
  final SettingSearchDestination destination;

  const SettingSearchItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.breadcrumbAr,
    required this.breadcrumbEn,
    required this.synonymsAndTags,
    required this.routeOrSectionKey,
    required this.destination,
  });

  String localizedTitle(String languageCode) =>
      languageCode == 'en' ? titleEn : titleAr;

  String localizedBreadcrumb(String languageCode) =>
      languageCode == 'en' ? breadcrumbEn : breadcrumbAr;

  @override
  List<Object?> get props => [
        id,
        titleAr,
        titleEn,
        breadcrumbAr,
        breadcrumbEn,
        synonymsAndTags,
        routeOrSectionKey,
        destination,
      ];
}
