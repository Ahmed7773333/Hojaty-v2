import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/datasources/local/settings_search_index.dart';
import 'package:hojaty/features/homelayout/data/models/azan_audio_item_model.dart';
import 'package:hojaty/features/homelayout/data/services/azan_audio_service.dart';
import 'package:hojaty/features/homelayout/domain/entities/setting_search_item.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_library_banner_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_madhab_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_permissions_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_prayer_toggle_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_test_button_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_time_offsets_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_type_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/pre_adhan_reminder_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_search_bar_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/shared/highlightable_section_widget.dart';

class AdhanSettingsTabView extends StatefulWidget {
  final String? initialHighlightSectionKey;

  const AdhanSettingsTabView({
    super.key,
    this.initialHighlightSectionKey,
  });

  @override
  State<AdhanSettingsTabView> createState() => _AdhanSettingsTabViewState();
}

class _AdhanSettingsTabViewState extends State<AdhanSettingsTabView> {
  List<AzanAudioItemModel> _loadedAzans = [];

  final Map<String, GlobalKey> _sectionKeys = {
    SettingsSearchIndex.keyAdhanTest: GlobalKey(),
    SettingsSearchIndex.keyAdhanLibrary: GlobalKey(),
    SettingsSearchIndex.keyAdhanType: GlobalKey(),
    SettingsSearchIndex.keyPreAdhanReminder: GlobalKey(),
    SettingsSearchIndex.keyAdhanPermissions: GlobalKey(),
    SettingsSearchIndex.keyAdhanMadhab: GlobalKey(),
    SettingsSearchIndex.keyAdhanOffsets: GlobalKey(),
    SettingsSearchIndex.keyAdhanPerPrayer: GlobalKey(),
  };

  String? _highlightedSectionKey;
  int _highlightTrigger = 0;

  @override
  void initState() {
    super.initState();
    _loadAzansMetadata();
    final initialKey = widget.initialHighlightSectionKey;
    if (initialKey != null && initialKey.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollAndHighlight(initialKey);
        }
      });
    }
  }

  Future<void> _loadAzansMetadata() async {
    try {
      final items = await injector<AzanAudioService>().loadAllAzans();
      if (mounted) {
        setState(() {
          _loadedAzans = items;
        });
      }
    } catch (_) {}
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
    _scrollAndHighlight(item.routeOrSectionKey);
  }

  String _getSoundTitle(BuildContext context, String soundId) {
    switch (soundId) {
      case 'makkah':
        return context.strings.adhanMakkah;
      case 'madinah':
        return context.strings.adhanMadinah;
      case 'azan':
        return context.strings.adhanAlafasy;
      default:
        final found = _loadedAzans.where((a) => a.id == soundId).firstOrNull;
        return found?.title ?? soundId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSearchBarWidget(
                adhanTabOnly: true,
                onResultSelected: _onSearchResultSelected,
              ),
              16.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyAdhanTest],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey == SettingsSearchIndex.keyAdhanTest,
                  highlightTrigger: _highlightTrigger,
                  child: AdhanTestButtonWidget(
                    onTap: () {
                      context.read<HomelayoutBloc>().add(
                        const SendTestNotificationEvent(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.strings.adhanTestNotificationSent,
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ),
              18.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyAdhanLibrary],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey ==
                      SettingsSearchIndex.keyAdhanLibrary,
                  highlightTrigger: _highlightTrigger,
                  child: const AdhanLibraryBannerCardWidget(),
                ),
              ),
              18.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyAdhanType],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey == SettingsSearchIndex.keyAdhanType,
                  highlightTrigger: _highlightTrigger,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.strings.prayerNotificationTypeSection,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                      12.ver,
                      AdhanTypeCardWidget(
                        title: context.strings.fullAdhanTitle,
                        subtitle: context.strings.fullAdhanDesc,
                        isSelected: state.adhanSettings.isFullAdhan,
                        onTap: () {
                          context.read<HomelayoutBloc>().add(
                            const ChangeAdhanTypeEvent(true),
                          );
                        },
                      ),
                      10.ver,
                      AdhanTypeCardWidget(
                        title: context.strings.shortAlertTitle,
                        subtitle: context.strings.shortAlertDesc,
                        isSelected: !state.adhanSettings.isFullAdhan,
                        onTap: () {
                          context.read<HomelayoutBloc>().add(
                            const ChangeAdhanTypeEvent(false),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              18.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyPreAdhanReminder],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey ==
                      SettingsSearchIndex.keyPreAdhanReminder,
                  highlightTrigger: _highlightTrigger,
                  child: const PreAdhanReminderCardWidget(),
                ),
              ),
              18.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyAdhanPermissions],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey ==
                      SettingsSearchIndex.keyAdhanPermissions,
                  highlightTrigger: _highlightTrigger,
                  child: const AdhanPermissionsCardWidget(),
                ),
              ),
              18.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyAdhanMadhab],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey ==
                      SettingsSearchIndex.keyAdhanMadhab,
                  highlightTrigger: _highlightTrigger,
                  child: const AdhanMadhabCardWidget(),
                ),
              ),
              18.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyAdhanOffsets],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey ==
                      SettingsSearchIndex.keyAdhanOffsets,
                  highlightTrigger: _highlightTrigger,
                  child: const AdhanTimeOffsetsCardWidget(),
                ),
              ),
              20.ver,
              KeyedSubtree(
                key: _sectionKeys[SettingsSearchIndex.keyAdhanPerPrayer],
                child: HighlightableSectionWidget(
                  isHighlighted:
                      _highlightedSectionKey ==
                      SettingsSearchIndex.keyAdhanPerPrayer,
                  highlightTrigger: _highlightTrigger,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardUnselected
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorderUnselected
                            : AppColors.lightBorderUnselected,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Column(
                      children: List.generate(state.prayerTimes.length, (
                        index,
                      ) {
                        final prayer = state.prayerTimes[index];
                        final soundId = state.adhanSettings.getSoundForPrayer(
                          prayer.type,
                        );
                        final soundTitle = _getSoundTitle(context, soundId);

                        return Column(
                          children: [
                            AdhanPrayerToggleWidget(
                              prayer: prayer,
                              soundTitle: soundTitle,
                              onToggle: (val) {
                                context.read<HomelayoutBloc>().add(
                                  TogglePrayerNotificationEvent(prayer.type),
                                );
                              },
                              onSelectSound: () {
                                context.pushNamed(
                                  AppRoutes.adhanSoundsLibrary,
                                  extra: prayer.type,
                                );
                              },
                            ),
                            if (index < state.prayerTimes.length - 1)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: isDark
                                    ? AppColors.darkBorderUnselected.withValues(
                                        alpha: 0.5,
                                      )
                                    : AppColors.lightBorderUnselected
                                          .withValues(alpha: 0.6),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
              24.ver,
            ],
          ),
        );
      },
    );
  }
}
