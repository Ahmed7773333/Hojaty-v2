import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../providers/prayer_times_provider.dart';
import 'prayer_day_navigator.dart';
import 'prayer_time_row.dart';

/// Background widget displaying all prayer times for the selected day.
/// Uses PrayerTimesProvider for data and supports day navigation.
class PrayersBackgroundWidget extends StatelessWidget {
  const PrayersBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.currentPrayerTimes == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final prayers = provider.currentPrayerTimes;
        if (prayers == null) {
          return Center(
            child: Text('لا توجد بيانات', style: context.textTheme.bodyLarge),
          );
        }

        // Determine next prayer (only relevant for today)
        String? nextPrayerName;
        if (provider.isToday && provider.nextPrayer != null) {
          nextPrayerName = provider.nextPrayer!.key;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? AppColor.darkCard
                  : AppColor.primaryColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: context.isDarkMode ? 0.3 : 0.08,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: context.isDarkMode
                    ? AppColor.darkGold.withValues(alpha: 0.3)
                    : AppColor.goldAccent.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Header with day navigator
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: context.isDarkMode
                          ? [
                              AppColor.darkSurface,
                              AppColor.darkSurface.withValues(alpha: 0.8),
                            ]
                          : [
                              AppColor.goldLight,
                              AppColor.goldLight.withValues(alpha: 0.5),
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        'مواقيت الصلاة',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Day Navigator
                      const PrayerDayNavigator(),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: context.isDarkMode
                      ? AppColor.darkGold.withValues(alpha: 0.2)
                      : AppColor.goldAccent.withValues(alpha: 0.15),
                ),

                // Prayer Times List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: prayers.length,
                    itemBuilder: (context, index) {
                      final entry = prayers.entries.elementAt(index);
                      final isNext = entry.key == nextPrayerName;

                      return PrayerTimeRow(
                        name: entry.key,
                        time: entry.value,
                        isNext: isNext,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
