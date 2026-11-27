// ignore_for_file: unused_field

import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/app_share_helper.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/rate_app_helper.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_backdrop.dart';
import 'package:hojaty/features/homelayout/data/datasources/local/settings_search_index.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_times_route_args.dart';
import 'package:hojaty/features/homelayout/domain/entities/setting_search_item.dart';
import 'package:hojaty/features/homelayout/presentation/pages/app_info_content_page.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/liquid_glass_settings_tile_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/salawat_settings_tile_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_adhan_shortcut_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_app_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_header_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_qr_button_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_search_bar_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_section_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_tile_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/theme_settings_tile_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/shared/highlightable_section_widget.dart';

class SettingsTabView extends StatefulWidget {
  const SettingsTabView({super.key});

  @override
  State<SettingsTabView> createState() => _SettingsTabViewState();
}

class _SettingsTabViewState extends State<SettingsTabView> {
  late bool _prayerAlerts;
  late bool _generalNotifications;
  late bool _occasionsNotifications;
  late bool _athkarNotifications;

  final Map<String, GlobalKey> _sectionKeys = {
    SettingsSearchIndex.keySettingsAdhanShortcut: GlobalKey(),
    SettingsSearchIndex.keySettingsSalawat: GlobalKey(),
    SettingsSearchIndex.keySettingsThemeLanguage: GlobalKey(),
    SettingsSearchIndex.keySettingsAbout: GlobalKey(),
  };

  String? _highlightedSectionKey;
  int _highlightTrigger = 0;

  @override
  void initState() {
    super.initState();
    _prayerAlerts = UserHiveHelper.getPrayerAlertsEnabled();
    _generalNotifications = UserHiveHelper.getGeneralNotificationsEnabled();
    _occasionsNotifications = UserHiveHelper.getOccasionsNotificationsEnabled();
    _athkarNotifications = UserHiveHelper.getAthkarNotificationsEnabled();
  }

  void _scrollAndHighlight(String sectionKey) {
    final key = _sectionKeys[sectionKey];
    if (key == null) return;

    setState(() {
      _highlightedSectionKey = sectionKey;
      _highlightTrigger++;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = key.currentContext;
      if (targetContext != null && targetContext.mounted) {
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeInOut,
          alignment: 0.15,
        );
      }
    });
  }

  void _onSearchResultSelected(SettingSearchItem item) {
    switch (item.destination) {
      case SettingSearchDestination.adhanSettingsTab:
        context.pushNamed(
          AppRoutes.prayerTimes,
          extra: PrayerTimesRouteArgs(
            initialTabIndex: 1,
            highlightSectionKey: item.routeOrSectionKey,
          ),
        );
      case SettingSearchDestination.locationSettingsPage:
        context.pushNamed(AppRoutes.locationSettings);
      case SettingSearchDestination.adhanSoundsLibraryPage:
        context.pushNamed(AppRoutes.adhanSoundsLibrary);
      case SettingSearchDestination.salawatSettingsPage:
        context.pushNamed(AppRoutes.salawatSettings);
      case SettingSearchDestination.themeSettingsPage:
        context.pushNamed(AppRoutes.themeSettings);
      case SettingSearchDestination.languageSettingsPage:
        context.pushNamed(AppRoutes.languageSettings);
      case SettingSearchDestination.settingsTab:
        _scrollAndHighlight(item.routeOrSectionKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: LiquidGlassBackdrop(
        child: Column(
          children: [
          const SettingsHeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20.w,
                16.h,
                20.w,
                16.h + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                children: [
                  SettingsSearchBarWidget(
                    onResultSelected: _onSearchResultSelected,
                  ),
                  16.ver,
                  const SettingsAppCardWidget(),
                  18.ver,
                  KeyedSubtree(
                    key: _sectionKeys[
                        SettingsSearchIndex.keySettingsAdhanShortcut],
                    child: HighlightableSectionWidget(
                      isHighlighted:
                          _highlightedSectionKey ==
                          SettingsSearchIndex.keySettingsAdhanShortcut,
                      highlightTrigger: _highlightTrigger,
                      child: const SettingsAdhanShortcutCardWidget(),
                    ),
                  ),
                  18.ver,
                  KeyedSubtree(
                    key: _sectionKeys[SettingsSearchIndex.keySettingsSalawat],
                    child: HighlightableSectionWidget(
                      isHighlighted:
                          _highlightedSectionKey ==
                          SettingsSearchIndex.keySettingsSalawat,
                      highlightTrigger: _highlightTrigger,
                      child: SettingsSectionCardWidget(
                        title: context.strings.salawatSectionTitle,
                        children: const [SalawatSettingsTileWidget()],
                      ),
                    ),
                  ),
                  18.ver,
                  KeyedSubtree(
                    key: _sectionKeys[
                        SettingsSearchIndex.keySettingsThemeLanguage],
                    child: HighlightableSectionWidget(
                      isHighlighted:
                          _highlightedSectionKey ==
                          SettingsSearchIndex.keySettingsThemeLanguage,
                      highlightTrigger: _highlightTrigger,
                      child: SettingsSectionCardWidget(
                        title: context.strings.languageAndThemeSection,
                        children: [
                          const ThemeSettingsTileWidget(),
                          const LiquidGlassSettingsTileWidget(),
                          SettingsTileWidget(
                            title: context.strings.languageLabel,
                            subtitle: UserHiveHelper.getUser()?.language == 'en'
                                ? context.strings.englishLanguage
                                : context.strings.arabicLanguage,
                            onTap: () {
                              context.pushNamed(AppRoutes.languageSettings);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  18.ver,
                  KeyedSubtree(
                    key: _sectionKeys[SettingsSearchIndex.keySettingsAbout],
                    child: HighlightableSectionWidget(
                      isHighlighted:
                          _highlightedSectionKey ==
                          SettingsSearchIndex.keySettingsAbout,
                      highlightTrigger: _highlightTrigger,
                      child: SettingsSectionCardWidget(
                        title: context.strings.aboutAppSection,
                        children: [
                          SettingsTileWidget(
                            title: context.strings.shareApp,
                            trailing: const SettingsQrButtonWidget(),
                            onTap: () {
                              AppShareHelper.shareApp(context);
                            },
                          ),
                          SettingsTileWidget(
                            title: context.strings.rateAppLabel,
                            onTap: () {
                              RateAppHelper.openStoreForRating();
                            },
                          ),
                          SettingsTileWidget(
                            title: context.strings.privacyPolicyLabel,
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.appInfoContent,
                                extra: {
                                  'contentType': AppContentType.privacyPolicy,
                                  'title': context.strings.privacyPolicyLabel,
                                  'content':
                                      context.strings.privacyPolicyContent,
                                },
                              );
                            },
                          ),
                          SettingsTileWidget(
                            title: context.strings.termsAndConditionsLabel,
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.appInfoContent,
                                extra: {
                                  'contentType':
                                      AppContentType.termsAndConditions,
                                  'title':
                                      context.strings.termsAndConditionsLabel,
                                  'content': context
                                      .strings
                                      .termsAndConditionsContent,
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  28.ver,
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
