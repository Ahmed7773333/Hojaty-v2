import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'radio_speed_picker_dialog.dart';

class RadioAudioControlsWidget extends StatelessWidget {
  final RadioAudioPlayerService playerService;

  const RadioAudioControlsWidget({super.key, required this.playerService});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => playerService.skipToPrevious(),
              icon: const Icon(Icons.skip_previous_rounded),
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              iconSize: 30.r,
            ),
            IconButton(
              onPressed: () => playerService.seekBackward(10),
              icon: const Icon(Icons.replay_10_rounded),
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              iconSize: 28.r,
            ),
            StreamBuilder<PlayerState>(
              stream: playerService.playerStateStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data?.playing ?? false;
                return Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentGold,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        playerService.pause();
                      } else {
                        playerService.play();
                      }
                    },
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppColors.primaryDarkBackground,
                      size: 36.r,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () => playerService.seekForward(10),
              icon: const Icon(Icons.forward_10_rounded),
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              iconSize: 28.r,
            ),
            IconButton(
              onPressed: () => playerService.skipToNext(),
              icon: const Icon(Icons.skip_next_rounded),
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              iconSize: 30.r,
            ),
          ],
        ),
        10.ver,
        StreamBuilder<double>(
          stream: playerService.speedStream,
          builder: (context, snapshot) {
            final speed = snapshot.data ?? playerService.currentSpeed;
            return TextButton(
              onPressed: () {
                context.showDialogRoute(
                  builder: RadioSpeedPickerDialog(
                    currentSpeed: speed,
                    onSpeedSelected: (newSpeed) =>
                        playerService.setSpeed(newSpeed),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightCardSelected,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
              child: Text(
                '${speed}x',
                style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
