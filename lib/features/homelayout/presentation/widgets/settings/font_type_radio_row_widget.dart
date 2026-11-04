import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/font_type_model.dart';

class FontTypeRadioRowWidget extends StatelessWidget {
  final FontTypeModel fontType;
  final bool isSelected;
  final VoidCallback onTap;

  const FontTypeRadioRowWidget({
    super.key,
    required this.fontType,
    required this.isSelected,
    required this.onTap,
  });

  String _getFontTitle(BuildContext context) {
    switch (fontType.id) {
      case 'uthmani':
        return context.strings.uthmaniFont;
      case 'amiri':
        return context.strings.amiriFont;
      case 'naskh':
      default:
        return context.strings.naskhFont;
    }
  }

  String _getFontSubtitle(BuildContext context) {
    switch (fontType.id) {
      case 'uthmani':
        return context.strings.uthmaniFontDesc;
      case 'amiri':
        return context.strings.amiriFontDesc;
      case 'naskh':
      default:
        return context.strings.naskhFontDesc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getFontTitle(context),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  4.ver,
                  Text(
                    _getFontSubtitle(context),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            12.hor,
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
                      : (isDark
                            ? AppColors.darkBorderUnselected
                            : AppColors.lightBorderUnselected),
                  width: 2.0,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.r,
                        height: 12.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.accentGold
                              : AppColors.primaryDark,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
