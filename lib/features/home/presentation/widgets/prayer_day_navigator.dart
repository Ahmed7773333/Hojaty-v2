import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../providers/prayer_times_provider.dart';

/// Widget that displays day navigation controls for prayer times.
/// Shows left/right arrows, current date, and a "Today" button when not on today.
class PrayerDayNavigator extends StatelessWidget {
  const PrayerDayNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Day Button
              _NavigationButton(
                icon: Icons.chevron_left, // RTL: right arrow goes to previous
                onPressed: provider.dayOffset > -15
                    ? () => provider.goToPreviousDay()
                    : null,
                tooltip: 'اليوم السابق',
              ),

              // Date Display with Today Button
              Expanded(
                child: GestureDetector(
                  onTap: provider.isToday ? null : () => provider.goToToday(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        provider.formattedDate,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!provider.isToday) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'العودة لليوم',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Next Day Button
              _NavigationButton(
                icon: Icons.chevron_right, // RTL: left arrow goes to next
                onPressed: provider.dayOffset < 15
                    ? () => provider.goToNextDay()
                    : null,
                tooltip: 'اليوم التالي',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  const _NavigationButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEnabled
                  ? AppColor.goldAccent.withValues(alpha: 0.2)
                  : context.colors.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
            ),
            child: Icon(
              icon,
              color: isEnabled
                  ? context.colors.onPrimaryContainer
                  : context.colors.onSurface.withValues(alpha: 0.3),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
