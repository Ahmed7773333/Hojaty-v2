import 'package:flutter/material.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../prayers/data/models/prayers/prayers_helper.dart';

/// Individual prayer time row with animation support.
/// Displays prayer name and time with highlighting for next prayer.
class PrayerTimeRow extends StatelessWidget {
  final String name;
  final DateTime time;
  final bool isNext;
  final double animationValue; // 0.0 to 1.0 for animation control

  const PrayerTimeRow({
    super.key,
    required this.name,
    required this.time,
    this.isNext = false,
    this.animationValue = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: isNext
            ? (context.isDarkMode
                  ? AppColor.darkTeal.withValues(alpha: 0.2)
                  : AppColor.goldLight)
            : (context.isDarkMode
                  ? AppColor.darkSurface
                  : AppColor.primaryColor),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNext
              ? (context.isDarkMode ? AppColor.darkTeal : AppColor.goldAccent)
              : context.colors.outlineVariant.withValues(alpha: 0.4),
          width: isNext ? 1.5 : 1,
        ),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: context.isDarkMode
                      ? AppColor.darkTeal.withValues(alpha: 0.3)
                      : AppColor.goldAccent.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Prayer Name with Icon
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isNext
                      ? (context.isDarkMode
                            ? AppColor.darkTeal.withValues(alpha: 0.3)
                            : AppColor.goldAccent.withValues(alpha: 0.2))
                      : (context.isDarkMode
                            ? AppColor.darkCard
                            : AppColor.surfaceColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getPrayerIcon(name),
                  size: 18,
                  color: isNext
                      ? (context.isDarkMode
                            ? AppColor.darkTextPrimary
                            : AppColor.darkCard)
                      : (context.isDarkMode
                            ? AppColor.darkTextSecondary
                            : AppColor.onTertiary),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                  color: isNext
                      ? (context.isDarkMode
                            ? AppColor.darkTextPrimary
                            : AppColor.secondaryColor)
                      : context.colors.onSurface,
                ),
              ),
            ],
          ),

          // Time Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isNext
                  ? context.colors.primary.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              PrayersHelper.formatTimeTo12Hour(time),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                color: isNext
                    ? (context.isDarkMode
                          ? AppColor.darkTextPrimary
                          : AppColor.darkCard)
                    : (context.isDarkMode
                          ? AppColor.darkTextSecondary
                          : AppColor.onTertiary),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return Icons.nightlight_round;
      case 'الشروق':
        return Icons.wb_twilight;
      case 'الظهر':
        return Icons.wb_sunny;
      case 'العصر':
        return Icons.sunny;
      case 'المغرب':
        return Icons.nights_stay;
      case 'العشاء':
        return Icons.bedtime;
      default:
        return Icons.access_time;
    }
  }
}
