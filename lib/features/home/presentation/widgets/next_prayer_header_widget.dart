import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../prayers/data/models/prayers/prayers_helper.dart';
import '../../../prayers/presentation/widgets/live_counter.dart';

class NextPrayerHeaderWidget extends StatelessWidget {
  const NextPrayerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, DateTime>>(
      future: PrayersHelper().getTodayPrayerTimes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return FutureBuilder<MapEntry<String, DateTime>?>(
          future: PrayersHelper().getNextPrayerTime(snapshot.data!),
          builder: (context, nextSnapshot) {
            if (!nextSnapshot.hasData || nextSnapshot.data == null) {
              return const SizedBox.shrink();
            }

            final nextPrayerName = nextSnapshot.data!.key;
            final nextPrayerTime = nextSnapshot.data!.value;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.strings.nextPrayer,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nextPrayerName,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        PrayersHelper.formatTimeTo12Hour(nextPrayerTime),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LiveTimerDisplay(
                        end: nextPrayerTime,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                        prefix: context.strings.remaining,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
