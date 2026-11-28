import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_backdrop.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_state.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_cubit.dart';
import 'package:hojaty/features/hifz/presentation/screens/audio_storage_sheet.dart';
import 'package:hojaty/features/hifz/presentation/screens/track_setup_sheet.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_curated_tracks_carousel.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_empty_plan_card.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_hero_plan_card.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_hub_header.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_quick_loop_banner.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_review_radar_card.dart';
import 'package:material_ui/material_ui.dart';

class HifzHubScreen extends StatelessWidget {
  const HifzHubScreen({super.key});

  Future<void> _openStudioForRange(
    BuildContext context, {
    required int startGlobalAyah,
    required int endGlobalAyah,
    int? planId,
    bool isReviewSession = false,
    bool startInTestingMode = false,
  }) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    await context.read<HifzSessionCubit>().startSession(
          startGlobalAyah: startGlobalAyah,
          endGlobalAyah: endGlobalAyah,
          planId: planId,
          isReviewSession: isReviewSession,
          startInTestingMode: startInTestingMode,
          autoPlay: !startInTestingMode,
          isArabic: isArabic,
        );
    if (!context.mounted) return;
    await context.pushNamed(AppRoutes.hifzStudio);
  }

  void _openTrackSetup(BuildContext context, {required bool isQuickLoop}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => TrackSetupSheet(isQuickLoop: isQuickLoop),
    );
  }

  void _openStorageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => const AudioStorageSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: LiquidGlassBackdrop(
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<HifzHubCubit, HifzHubState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: HifzHubHeader(
                      streakDays: state.streakDays,
                      onOpenStorage: () => _openStorageSheet(context),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      8.h,
                      20.w,
                      24.h + MediaQuery.paddingOf(context).bottom,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (state.activePlan != null)
                          HifzHeroPlanCard(
                            plan: state.activePlan!,
                            onStartToday: () => _openStudioForRange(
                              context,
                              startGlobalAyah:
                                  state.activePlan!.todayStartGlobalAyah,
                              endGlobalAyah:
                                  state.activePlan!.todayEndGlobalAyah,
                              planId: state.activePlan!.id,
                            ),
                            onTestMemorization: () => _openStudioForRange(
                              context,
                              startGlobalAyah:
                                  state.activePlan!.todayStartGlobalAyah,
                              endGlobalAyah:
                                  state.activePlan!.todayEndGlobalAyah,
                              planId: state.activePlan!.id,
                              startInTestingMode: true,
                            ),
                          )
                        else
                          HifzEmptyPlanCard(
                            onCreateCustomPlan: () =>
                                _openTrackSetup(context, isQuickLoop: false),
                          ),
                        if (state.dueReviews.isNotEmpty) ...[
                          16.ver,
                          HifzReviewRadarCard(
                            dueCount: state.dueReviews.length,
                            estimatedMinutes: state.dueEstimatedMinutes,
                            surahNames: isArabic
                                ? state.dueSurahNamesAr
                                : state.dueSurahNamesEn,
                            onReviewNow: () {
                              final firstDue = state.dueReviews.first;
                              final lastDue = state.dueReviews
                                  .take(10)
                                  .last;
                              _openStudioForRange(
                                context,
                                startGlobalAyah: firstDue.globalAyahId,
                                endGlobalAyah:
                                    lastDue.globalAyahId >= firstDue.globalAyahId
                                        ? lastDue.globalAyahId
                                        : firstDue.globalAyahId,
                                isReviewSession: true,
                                startInTestingMode: true,
                              );
                            },
                          ),
                        ],
                        20.ver,
                        HifzCuratedTracksCarousel(
                          tracks: state.curatedTracks,
                          activeTrackKey: state.activePlan?.trackKey,
                          onSelectTrack: (track) => context
                              .read<HifzHubCubit>()
                              .startCuratedTrack(track, isArabic: isArabic),
                          onCustomPlanTap: () =>
                              _openTrackSetup(context, isQuickLoop: false),
                        ),
                        20.ver,
                        HifzQuickLoopBanner(
                          onTap: () =>
                              _openTrackSetup(context, isQuickLoop: true),
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

