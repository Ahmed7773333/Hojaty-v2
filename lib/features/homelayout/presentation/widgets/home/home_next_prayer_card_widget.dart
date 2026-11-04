import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayers_helper.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';
import '../occasions/live_timer_display.dart';

class HomeNextPrayerCardWidget extends StatefulWidget {
  const HomeNextPrayerCardWidget({super.key});

  @override
  State<HomeNextPrayerCardWidget> createState() =>
      _HomeNextPrayerCardWidgetState();
}

class _HomeNextPrayerCardWidgetState extends State<HomeNextPrayerCardWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    const helper = PrayersHelper(coordinates: GeoCoordinates.cairo);
    final activeWindow = helper.getActivePrayerWindow(now);
    final nextPrayerInfo = helper.getNextPrayerInfo(now);

    final isPostAdhan = activeWindow != null && activeWindow.isPostAdhan;

    final prayerName = PrayersHelper.getPrayerName(
      isPostAdhan ? activeWindow.type : nextPrayerInfo.nextType,
      language: lang,
    );

    final formattedTime = PrayersHelper.formatTimeTo12Hour(
      isPostAdhan ? activeWindow.prayerTime : nextPrayerInfo.nextTime,
      language: lang,
    );

    final cardTitle = isPostAdhan
        ? context.strings.currentPrayerBadge
        : context.strings.nextPrayerTitle;

    final targetTime =
        isPostAdhan ? activeWindow.windowEnd : nextPrayerInfo.nextTime;

    final progress = isPostAdhan
        ? PrayersHelper.calculatePrayerProgress(
            now: now,
            previousTime: activeWindow.prayerTime,
            nextTime: activeWindow.windowEnd,
          )
        : PrayersHelper.calculatePrayerProgress(
            now: now,
            previousTime: nextPrayerInfo.previousTime,
            nextTime: nextPrayerInfo.nextTime,
          );

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.12),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardTitle,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isPostAdhan
                              ? AppColors.accentGoldLight
                              : AppColors.darkTextSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      2.ver,
                      Text(
                        prayerName,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 26.sp,
                        ),
                      ),
                      2.ver,
                      Text(
                        formattedTime,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkTextSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        context.strings.nextPrayerRemaining,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.accentGoldLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      4.ver,
                      LiveTimerDisplay(
                        end: targetTime,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 24.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              16.ver,
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: SizedBox(
                  height: 4.h,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.primaryDarkSurface,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accentGold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// ARCHIVED ORIGINAL HOME NEXT PRAYER CODE
// ==========================================
// Widget _archivedOriginalBuild(BuildContext context) {
//   final lang = Localizations.localeOf(context).languageCode;
//   final now = DateTime.now();
//   const helper = PrayersHelper(coordinates: GeoCoordinates.cairo);
//   final activeWindow = helper.getActivePrayerWindow(now);
//   if (activeWindow == null) return const SizedBox.shrink();
//   return const SizedBox.shrink();
// }

