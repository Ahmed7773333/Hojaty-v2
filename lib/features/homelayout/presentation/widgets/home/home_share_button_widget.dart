import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_share_helper.dart';
import '../../../../../../core/utils/screen_util_like.dart';

class HomeShareButtonWidget extends StatelessWidget {
  const HomeShareButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => AppShareHelper.shareApp(context),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.white.withValues(alpha: 0.12),
        padding: EdgeInsets.all(10.r),
        shape: const CircleBorder(),
      ),
      icon: Icon(
        Icons.share_rounded,
        size: 18.r,
        color: AppColors.white,
      ),
    );
  }
}
