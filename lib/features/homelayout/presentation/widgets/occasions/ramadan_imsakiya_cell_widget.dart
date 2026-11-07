import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class RamadanImsakiyaCellWidget extends StatelessWidget {
  final String text;
  final int flex;
  final bool isHeader;
  final bool isHighlighted;

  const RamadanImsakiyaCellWidget({
    super.key,
    required this.text,
    required this.flex,
    this.isHeader = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final Color textColor;
    if (isHeader) {
      textColor = AppColors.white;
    } else if (isHighlighted) {
      textColor =
          isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark;
    } else {
      textColor =
          isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    }

    final baseStyle = isHeader
        ? context.textTheme.bodySmall
        : context.textTheme.labelSmall;

    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: baseStyle?.copyWith(
          color: textColor,
          fontWeight: (isHeader || isHighlighted)
              ? FontWeight.w700
              : FontWeight.w600,
          fontSize: isHeader ? 11.5.sp : 10.sp,
        ),
      ),
    );
  }
}

