import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class QuranPagePlaceholderWidget extends StatelessWidget {
  final int pageNumber;

  const QuranPagePlaceholderWidget({
    super.key,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Text(
        '${context.strings.quranPageLabel} $pageNumber',
        style: context.textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
