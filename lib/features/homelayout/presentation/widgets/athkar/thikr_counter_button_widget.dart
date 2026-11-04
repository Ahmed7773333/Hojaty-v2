import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class ThikrCounterButtonWidget extends StatelessWidget {
  final int currentCount;
  final bool isCompleted;
  final VoidCallback onTap;

  const ThikrCounterButtonWidget({
    super.key,
    required this.currentCount,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(140.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 140.r,
          height: 140.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? const Color(0xFF2E6B4F)
                : AppColors.primaryDarkBackground,
            boxShadow: [
              BoxShadow(
                color:
                    (isCompleted
                            ? const Color(0xFF2E6B4F)
                            : AppColors.primaryDarkBackground)
                        .withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check_rounded, color: AppColors.white, size: 54.r)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$currentCount',
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 38.sp,
                        ),
                      ),
                      Text(
                        context.strings.tapLabel,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.darkTextSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
