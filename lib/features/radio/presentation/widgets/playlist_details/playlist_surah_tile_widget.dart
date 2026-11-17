import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/data/models/playlist_item_model.dart';
import 'package:flutter/material.dart';

class PlaylistSurahTileWidget extends StatelessWidget {
  final PlaylistItemModel item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const PlaylistSurahTileWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final surahName = isAr ? item.surahNameAr : item.surahNameEn;

    return Material(
      color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.accentGoldExtraLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${item.surahId}',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              14.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.ver,
                    Text(
                      item.reciterName,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.accentGoldExtraLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.accentGold,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
