import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/hojaty_ai_mock_data.dart';
import 'hojaty_ai_starter_chip_widget.dart';

class HojatyAiEmptyStateWidget extends StatelessWidget {
  final ValueChanged<String> onSelectStarter;

  const HojatyAiEmptyStateWidget({
    super.key,
    required this.onSelectStarter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          16.ver,
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accentGold.withValues(alpha: 0.4),
                width: 2.0,
              ),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: isDark
                  ? AppColors.accentGoldLight
                  : AppColors.accentGoldDark,
              size: 34.r,
            ),
          ),
          16.ver,
          Text(
            context.strings.hojatyAiEmptyTitle,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
          8.ver,
          Text(
            context.strings.hojatyAiEmptySubtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 13.sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          24.ver,
          Column(
            children: HojatyAiMockData.starterPrompts.map((prompt) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: HojatyAiStarterChipWidget(
                  text: prompt,
                  onTap: onSelectStarter,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

