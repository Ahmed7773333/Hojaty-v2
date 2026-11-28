import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_state.dart';
import 'package:material_ui/material_ui.dart';

class HifzMiniPlayer extends StatelessWidget {
  const HifzMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<HifzSessionCubit, HifzSessionState>(
      builder: (context, state) {
        if (!state.hasActiveSession || !state.isMinimized) {
          return const SizedBox.shrink();
        }

        final activeAyah = state.activeAyahContent;
        final isPlaying = state.phase == SessionPhase.playing ||
            state.phase == SessionPhase.pausingForRepeat;
        final surahName = activeAyah == null
            ? context.strings.hifzTitle
            : (isArabic ? activeAyah.surahNameAr : activeAyah.surahNameEn);
        final subtitle = activeAyah == null
            ? state.reciter.localizedName(isArabic)
            : '${context.strings.hifzAyahRange(activeAyah.ayahNumber, activeAyah.ayahNumber)} • ${state.reciter.localizedName(isArabic)}';

        return LiquidGlassContainer(
          borderRadius: BorderRadius.circular(22.r),
          margin: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 8.h),
          fallbackDecoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.45),
            ),
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {
                context.read<HifzSessionCubit>().restoreSession();
                context.pushNamed(AppRoutes.hifzStudio);
              },
              borderRadius: BorderRadius.circular(22.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        color: AppColors.accentGold,
                        size: 20.r,
                      ),
                    ),
                    10.hor,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            surahName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          2.ver,
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<HifzSessionCubit>().togglePlayPause(),
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        size: 28.r,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<HifzSessionCubit>().stopSession(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        size: 20.r,
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

