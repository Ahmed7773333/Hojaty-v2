import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class SalawatSoundCardWidget extends StatefulWidget {
  const SalawatSoundCardWidget({super.key});

  @override
  State<SalawatSoundCardWidget> createState() => _SalawatSoundCardWidgetState();
}

class _SalawatSoundCardWidgetState extends State<SalawatSoundCardWidget> {
  late final AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      final playing =
          state.playing && state.processingState != ProcessingState.completed;
      setState(() {
        _isPlaying = playing;
      });
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    try {
      if (_isPlaying) {
        await _player.stop();
      } else {
        await _player.setAudioSource(
          AudioSource.asset(
            'assets/audio/salli_ala_muhammad.wav',
            tag: const MediaItem(
              id: 'salawat_preview_audio',
              title: 'الصلاة على النبي ﷺ',
              artist: 'تطبيق أنا أصلي',
            ),
          ),
        );
        await _player.play();
      }
    } catch (e) {
      log('Error playing Salawat preview audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBadgeInner
                      : AppColors.lightCardSelected,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  size: 20.r,
                  color: AppColors.accentGold,
                ),
              ),
              12.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            context.strings.salawatSoundName,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        8.hor,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkBadgeOuter
                                : AppColors.primaryDark.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            context.strings.salawatSoundDuration,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.accentGold
                                  : AppColors.primaryDark,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    2.ver,
                    Text(
                      context.strings.salawatSoundDesc,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              8.hor,
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleAudio,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: _isPlaying
                          ? AppColors.accentGold
                          : (isDark
                              ? AppColors.white.withValues(alpha: 0.08)
                              : AppColors.primaryDark.withValues(alpha: 0.08)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      size: 22.r,
                      color: _isPlaying
                          ? AppColors.primaryDark
                          : (isDark ? AppColors.white : AppColors.primaryDark),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

