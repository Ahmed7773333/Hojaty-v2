import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

enum AdhanFilterType { all, builtIn, downloaded }

class AdhanLibraryFilterChipsWidget extends StatelessWidget {
  final AdhanFilterType selectedFilter;
  final ValueChanged<AdhanFilterType> onSelectFilter;
  final int allCount;
  final int builtInCount;
  final int downloadedCount;

  const AdhanLibraryFilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onSelectFilter,
    required this.allCount,
    required this.builtInCount,
    required this.downloadedCount,
  });

  String _getLabel(BuildContext context, AdhanFilterType type) {
    switch (type) {
      case AdhanFilterType.all:
        return '${context.strings.adhanFilterAll} ($allCount)';
      case AdhanFilterType.builtIn:
        return '${context.strings.adhanFilterBuiltIn} ($builtInCount)';
      case AdhanFilterType.downloaded:
        return '${context.strings.adhanFilterDownloaded} ($downloadedCount)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AdhanFilterType.values.map((type) {
          final isSelected = selectedFilter == type;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: ChoiceChip(
              label: Text(
                _getLabel(context, type),
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.sp,
                  color: isSelected
                      ? AppColors.white
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primaryDarkBackground,
              backgroundColor: isDark
                  ? AppColors.darkCardUnselected
                  : AppColors.lightSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryDarkBackground
                      : (isDark
                            ? AppColors.darkBorderUnselected
                            : AppColors.lightBorderUnselected),
                ),
              ),
              showCheckmark: false,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              onSelected: (_) => onSelectFilter(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}
