import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../prayers/data/models/prayers/prayers_helper.dart';

class PrayersBackgroundWidget extends StatelessWidget {
  const PrayersBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, DateTime>>(
      future: PrayersHelper().getTodayPrayerTimes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final prayers = snapshot.data!;
        return FutureBuilder<MapEntry<String, DateTime>?>(
          future: PrayersHelper().getNextPrayerTime(prayers),
          builder: (context, nextSnapshot) {
            final nextPrayer = nextSnapshot.data?.key;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              color: context.colors.surface, // Background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header/Date could go here
                  const SizedBox(height: 60), // Space for top header
                  ...prayers.entries.map((entry) {
                    final isNext = entry.key == nextPrayer;
                    return _PrayerItem(
                      name: entry.key,
                      time: entry.value,
                      isNext: isNext,
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PrayerItem extends StatelessWidget {
  final String name;
  final DateTime time;
  final bool isNext;

  const _PrayerItem({
    required this.name,
    required this.time,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: isNext ? context.colors.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: isNext
            ? Border.all(color: context.colors.primary, width: 1.5)
            : Border.all(
                color: context.colors.outlineVariant.withValues(alpha: 0.5),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext
                  ? context.colors.onPrimaryContainer
                  : context.colors.onSurface,
            ),
          ),
          Text(
            PrayersHelper.formatTimeTo12Hour(time),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext
                  ? context.colors.onPrimaryContainer
                  : context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
