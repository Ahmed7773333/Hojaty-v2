import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:flutter/material.dart';

class RadioProgressBarWidget extends StatelessWidget {
  final RadioAudioPlayerService playerService;

  const RadioProgressBarWidget({super.key, required this.playerService});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return StreamBuilder<Duration?>(
      stream: playerService.durationStream,
      builder: (context, durationSnapshot) {
        final totalDuration = durationSnapshot.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: playerService.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final maxMs = totalDuration.inMilliseconds > 0
                ? totalDuration.inMilliseconds.toDouble()
                : 1.0;
            final currentMs = position.inMilliseconds
                .clamp(0, totalDuration.inMilliseconds)
                .toDouble();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.h,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                    activeTrackColor: AppColors.accentGold,
                    inactiveTrackColor: isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected,
                    thumbColor: AppColors.accentGold,
                    overlayColor: AppColors.accentGold.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: currentMs.clamp(0.0, maxMs),
                    min: 0.0,
                    max: maxMs,
                    onChanged: totalDuration > Duration.zero
                        ? (val) {
                            playerService.seek(
                              Duration(milliseconds: val.toInt()),
                            );
                          }
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        _formatDuration(totalDuration),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
