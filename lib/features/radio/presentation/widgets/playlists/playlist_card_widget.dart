import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/data/models/playlist_model.dart';
import 'package:flutter/material.dart';

class PlaylistCardWidget extends StatelessWidget {
  final PlaylistModel playlist;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const PlaylistCardWidget({
    super.key,
    required this.playlist,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isFavorites = playlist.id == 'favorites_playlist';
    final isDownloads = playlist.id == 'downloads_playlist';

    final String displayName;
    final Color iconBgColor;
    final Color iconColor;
    final IconData iconData;

    if (isFavorites) {
      displayName = context.strings.favorites;
      iconBgColor = const Color(0xFFEF4444).withValues(alpha: 0.15);
      iconColor = const Color(0xFFEF4444);
      iconData = Icons.favorite_rounded;
    } else if (isDownloads) {
      displayName = context.strings.downloadedAudios;
      iconBgColor = isDark
          ? AppColors.darkCardSelected
          : AppColors.lightCardSelected;
      iconColor = AppColors.accentGold;
      iconData = Icons.download_done_rounded;
    } else {
      displayName = playlist.name;
      iconBgColor = isDark
          ? AppColors.primaryDarkSurface
          : AppColors.accentGoldExtraLight;
      iconColor = AppColors.accentGold;
      iconData = Icons.queue_music_rounded;
    }

    return Material(
      color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(iconData, color: iconColor, size: 26.r),
              ),
              16.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.ver,
                    Text(
                      '${playlist.items.length} ${context.strings.listenToSurah}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!playlist.isSystem && onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFEF4444),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
