import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../config/theme/app_theme.dart';
import '../../../../../core/local/user_hive_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_share_helper.dart';
import '../../../../../core/utils/rate_app_helper.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import '../../pages/app_info_content_page.dart';
import 'settings_app_card_widget.dart';
import 'settings_header_widget.dart';
import 'settings_section_card_widget.dart';
import 'settings_switch_tile_widget.dart';
import 'settings_tile_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _prayerAlerts = UserHiveHelper.getPrayerAlertsEnabled();
    _generalNotifications = UserHiveHelper.getGeneralNotificationsEnabled();
    _occasionsNotifications = UserHiveHelper.getOccasionsNotificationsEnabled();
    _athkarNotifications = UserHiveHelper.getAthkarNotificationsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          const SettingsHeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  const SettingsAppCardWidget(),
                  18.ver,
                  // SettingsSectionCardWidget(
                  //   title: context.strings.locationAndGovSection,
                  //   children: [
                  //     SettingsTileWidget(
                  //       title: context.strings.currentLocationLabel,
                  //       subtitle: context.strings.cairoLocation,
                  //       onTap: () {
                  //         context.pushNamed(AppRoutes.locationSettings);
                  //       },
                  //     ),
                  //     SettingsTileWidget(
                  //       title: context.strings.governorateLabel,
                  //       subtitle: context.strings.cairoGov,
                  //       onTap: () {
                  //         context.pushNamed(AppRoutes.locationSettings);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // 18.ver,
                  SettingsSectionCardWidget(
                    title: context.strings.prayerTimesAndAdhanSection,
                    children: [
                      // SettingsTileWidget(
                      //   title: context.strings.prayerTimesCalcSettings,
                      //   subtitle: context.strings.egyptSurveyAuthority,
                      //   onTap: () {
                      //     context.pushNamed(
                      //       AppRoutes.prayerCalculationSettings,
                      //     );
                      //   },
                      // ),
                      SettingsTileWidget(
                        title: context.strings.notificationTypeLabel,
                        subtitle: context.strings.fullAdhanTitle,
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.prayerCalculationSettings,
                          );
                        },
                      ),
                      SettingsSwitchTileWidget(
                        title: context.strings.prayerAlertsLabel,
                        value: _prayerAlerts,
                        onChanged: (val) {
                          setState(() => _prayerAlerts = val);
                          context.read<HomelayoutBloc>().add(
                            TogglePrayerAlertsEvent(val),
                          );
                        },
                      ),
                    ],
                  ),
                  18.ver,
                  // SettingsSectionCardWidget(
                  //   title: context.strings.notificationsSection,
                  //   children: [
                  //     SettingsSwitchTileWidget(
                  //       title: context.strings.generalNotificationsLabel,
                  //       value: _generalNotifications,
                  //       onChanged: (val) {
                  //         setState(() => _generalNotifications = val);
                  //         context.read<HomelayoutBloc>().add(
                  //           ToggleGeneralNotificationsEvent(val),
                  //         );
                  //       },
                  //     ),
                  //     SettingsSwitchTileWidget(
                  //       title: context.strings.occasionsNotificationsLabel,
                  //       value: _occasionsNotifications,
                  //       onChanged: (val) {
                  //         setState(() => _occasionsNotifications = val);
                  //         context.read<HomelayoutBloc>().add(
                  //           ToggleOccasionsNotificationsEvent(val),
                  //         );
                  //       },
                  //     ),
                  //     SettingsSwitchTileWidget(
                  //       title: context.strings.athkarNotificationsLabel,
                  //       value: _athkarNotifications,
                  //       onChanged: (val) {
                  //         setState(() => _athkarNotifications = val);
                  //         context.read<HomelayoutBloc>().add(
                  //           ToggleAthkarNotificationsEvent(val),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // // 18.ver,
                  // SettingsSectionCardWidget(
                  //   title: context.strings.fontSection,
                  //   children: [
                  //     SettingsTileWidget(
                  //       title: context.strings.fontSizeLabel,
                  //       subtitle: '24',
                  //       onTap: () {
                  //         context.pushNamed(AppRoutes.fontSettings);
                  //       },
                  //     ),
                  //     SettingsTileWidget(
                  //       title: context.strings.fontTypeLabel,
                  //       subtitle: context.strings.naskhFont,
                  //       onTap: () {
                  //         context.pushNamed(AppRoutes.fontTypeSettings);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  18.ver,
                  SettingsSectionCardWidget(
                    title: context.strings.languageAndThemeSection,
                    children: [
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: AppTheme.themeModeNotifier,
                        builder: (context, mode, _) {
                          return SettingsSwitchTileWidget(
                            title: context.strings.darkModeLabel,
                            value: mode == ThemeMode.dark,
                            onChanged: (val) {
                              AppTheme.toggleTheme();
                            },
                          );
                        },
                      ),
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
                  18.ver,
                  SettingsSectionCardWidget(
                    title: context.strings.aboutAppSection,
                    children: [
                      SettingsTileWidget(
                        title: context.strings.shareApp,
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
                              'content': context.strings.privacyPolicyContent,
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
                              'contentType': AppContentType.termsAndConditions,
                              'title': context.strings.termsAndConditionsLabel,
                              'content':
                                  context.strings.termsAndConditionsContent,
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  28.ver,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
