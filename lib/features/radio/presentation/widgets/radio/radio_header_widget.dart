import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';

class RadioHeaderWidget extends StatelessWidget {
  final VoidCallback onBack;

  const RadioHeaderWidget({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 12.h,
        bottom: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryDarkBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 20.0,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              12.hor,
              Text(
                context.strings.radio,
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkSurface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(
                  Icons.radio_rounded,
                  color: AppColors.accentGold,
                  size: 22.0,
                ),
              ),
            ],
          ),
          12.ver,
          Text(
            context.strings.radioSubtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
