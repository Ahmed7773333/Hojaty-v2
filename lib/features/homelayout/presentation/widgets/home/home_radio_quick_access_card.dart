import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:just_audio/just_audio.dart';

class HomeRadioQuickAccessCard extends StatelessWidget {
  const HomeRadioQuickAccessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final playerService = injector<RadioAudioPlayerService>();

    return StreamBuilder<PlayerState>(
      stream: playerService.playerStateStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.playing ?? false;
        final hasActive = playerService.hasActiveTrack;
        final isLiveActive = hasActive && isPlaying;

        final displayTitle =
            isLiveActive && playerService.currentSurahName != null
            ? playerService.currentSurahName!
            : context.strings.radio;

        // final displaySubtitle =
        //     isLiveActive && playerService.currentReciterName != null
        //     ? playerService.currentReciterName!
        //     : context.strings.radioSubtitle;

        return LiquidGlassContainer(
          variant: LiquidGlassSurfaceVariant.card,
          borderRadius: BorderRadius.circular(20.r),
          fallbackDecoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {
                context.pushNamed(AppRoutes.radio);
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.radio_rounded,
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.accentGoldDark,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
                10.ver,
                Text(
                  context.strings.radio,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.ver,
                Text(
                  displayTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                ],
              ),
              ),
            ),
          ),
        );
      },
    );
  }
}
