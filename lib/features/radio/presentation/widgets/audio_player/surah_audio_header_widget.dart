import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';

class SurahAudioHeaderWidget extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;

  const SurahAudioHeaderWidget({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onBack,
    required this.onToggleFavorite,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 12.h,
        bottom: 16.h,
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
      child: Row(
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
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onShare,
            icon: const Icon(
              Icons.share_rounded,
              color: AppColors.white,
              size: 22.0,
            ),
          ),
          IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite ? const Color(0xFFEF4444) : AppColors.white,
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }
}
