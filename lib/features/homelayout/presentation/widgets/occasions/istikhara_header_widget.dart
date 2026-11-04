import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class IstikharaHeaderWidget extends StatelessWidget {
  const IstikharaHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          spacing: 12,
          children: [
            IconButton(
              onPressed: () => context.pop(),
     
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 18.r,
              ),
            ),
            Text(
              context.strings.salatAlIstikhara,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
