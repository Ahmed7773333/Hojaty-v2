import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class SettingsPageHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SettingsPageHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          spacing: 6.w,
          children: [
            IconButton(
              onPressed: () => context.pop(),
          
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 18.r,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22.sp,
                    ),
                  ),
                  if (subtitle != null) ...[
                    4.ver,
                    Text(
                      subtitle!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.darkTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
