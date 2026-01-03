import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../prayers/data/models/prayers/prayers_helper.dart';
import '../../../prayers/presentation/widgets/live_counter.dart';
import '../providers/prayer_times_provider.dart';

/// Header widget showing the next prayer with countdown timer.
/// Does NOT animate - stays fixed at top.
class NextPrayerHeaderWidget extends StatelessWidget {
  final double sheetPosition;

  const NextPrayerHeaderWidget({super.key, this.sheetPosition = 0.0});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        // Only show for today when we have next prayer data
        if (provider.nextPrayer == null) {
          // Show minimal header when on different day
          // if (!provider.isToday) {
          //   return _buildDateOnlyHeader(context, provider);
          // }
          return const SizedBox.shrink();
        }

        final nextPrayerName = provider.nextPrayer!.key;
        final nextPrayerTime = provider.nextPrayer!.value;

        return Container(
          // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            // Warm gradient instead of blue
            gradient: const LinearGradient(
              colors: [
                AppColor.goldLight,
                Color(0xFFFFF3E0), // Warmer orange-cream
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.goldAccent.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColor.goldAccent.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Prayer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.strings.nextPrayer,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColor.onTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextPrayerName,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkCard,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Time & Countdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    PrayersHelper.formatTimeTo12Hour(nextPrayerTime),
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.darkCard.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LiveTimerDisplay(
                      end: nextPrayerTime,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColor.darkCard,
                        fontWeight: FontWeight.w600,
                      ),
                      prefix: context.strings.remaining,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
