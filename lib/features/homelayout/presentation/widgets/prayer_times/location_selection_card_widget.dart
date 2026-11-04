import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class LocationSelectionCardWidget extends StatelessWidget {
  final List<String> cities;
  final String selectedCity;
  final ValueChanged<String> onSelect;

  const LocationSelectionCardWidget({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Column(
        children: List.generate(cities.length, (index) {
          final city = cities[index];
          final isSelected = city == selectedCity;

          return Column(
            children: [
              InkWell(
                onTap: () => onSelect(city),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: isSelected
                                ? AppColors.primaryDark
                                : (isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted),
                            size: 20.r,
                          ),
                          12.hor,
                          Text(
                            city,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      if (isSelected)
                        Container(
                          width: 22.r,
                          height: 22.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryDarkBackground,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColors.white,
                            size: 14.r,
                          ),
                        )
                      else
                        const SizedBox(width: 22),
                    ],
                  ),
                ),
              ),
              if (index < cities.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark
                      ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                      : AppColors.lightBorderUnselected.withValues(alpha: 0.6),
                ),
            ],
          );
        }),
      ),
    );
  }
}
