import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';

class PlaylistsHeaderWidget extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCreateNew;

  const PlaylistsHeaderWidget({
    super.key,
    required this.onBack,
    required this.onCreateNew,
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
              context.strings.playlists,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onCreateNew,
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.accentGold,
              size: 28.0,
            ),
          ),
        ],
      ),
    );
  }
}
