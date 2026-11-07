import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../config/routes/app_router.dart';
import '../../core/di/injector.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/extensions/context_extensions.dart';
import '../../core/utils/screen_util_like.dart';
import '../../features/radio/data/models/surah_audio_args.dart';
import '../../features/radio/services/radio_audio_player_service.dart';

class AppMiniPlayerWidget extends StatefulWidget {
  const AppMiniPlayerWidget({super.key});

  @override
  State<AppMiniPlayerWidget> createState() => _AppMiniPlayerWidgetState();
}

class _AppMiniPlayerWidgetState extends State<AppMiniPlayerWidget> {
  late final RadioAudioPlayerService _playerService;

  @override
  void initState() {
    super.initState();
    _playerService = injector<RadioAudioPlayerService>();
  }

  void _onTapMiniPlayer() {
    final args = _playerService.currentArgs;
    if (args != null) {
      context.pushNamed(AppRoutes.surahAudio, extra: args);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return StreamBuilder<SurahAudioArgs?>(
      stream: _playerService.currentArgsStream,
      initialData: _playerService.currentArgs,
      builder: (context, argsSnapshot) {
        return StreamBuilder<PlayerState>(
          stream: _playerService.playerStateStream,
          builder: (context, playerSnapshot) {
            final hasActive = _playerService.hasActiveTrack;
            if (!hasActive) {
              return const SizedBox.shrink();
            }

            final isPlaying = playerSnapshot.data?.playing ?? false;
            final surahName = _playerService.currentSurahName ??
                context.strings.quranFehres;
            final reciterName = _playerService.currentReciterName ?? '';

            return Container(
              margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 8.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _onTapMiniPlayer,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.audiotrack_rounded,
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
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (reciterName.isNotEmpty) ...[
                                2.ver,
                                Text(
                                  reciterName,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (isPlaying) {
                              _playerService.pause();
                            } else {
                              _playerService.play();
                            }
                          },
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
                          onPressed: () => _playerService.stop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                            size: 20.r,
                            semanticLabel: context.strings.delete,
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
      },
    );
  }
}

