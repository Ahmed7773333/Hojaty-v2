import 'package:flutter/material.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../qibla/presentation/widgets/kaaba_icon_widget.dart';

class HomeQiblaBannerWidget extends StatelessWidget {
  const HomeQiblaBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.qibla),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primaryDarkSurface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.35),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.accentGold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const KaabaIconWidget(size: 22),
            ),
            12.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.strings.qiblaBannerTitle,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                  2.ver,
                  Text(
                    context.strings.qiblaBannerSubtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12.r,
                color: AppColors.accentGoldLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

