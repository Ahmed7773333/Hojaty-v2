import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/radio/data/models/surah_audio_args.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';

class HojatyAiAudioActionCardWidget extends StatelessWidget {
  final AiToolActionResultModel action;

  const HojatyAiAudioActionCardWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final res = action.result;
    final isLiveStream = res['type'] == 'live_stream';
    final title = isLiveStream
        ? (res['title'] as String? ?? 'إذاعة القرآن الكريم')
        : 'سورة ${res['surahName'] ?? ''}';
    final subtitle = isLiveStream
        ? 'بث مباشر'
        : (res['reciterName'] as String? ?? 'الشيخ عبد الباسط عبد الصمد');

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightCardUnselected,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLiveStream ? Icons.radio_outlined : Icons.music_note_outlined,
              color: isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark,
              size: 22.r,
            ),
          ),
          12.hor,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.ver,
                Text(
                  subtitle,
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
          8.hor,
          StreamBuilder<bool>(
            stream: RadioAudioPlayerService().playerStateStream.map((s) => s.playing),
            initialData: RadioAudioPlayerService().isPlaying,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              return IconButton(
                onPressed: () {
                  if (isPlaying) {
                    RadioAudioPlayerService().pause();
                  } else {
                    RadioAudioPlayerService().play();
                  }
                },
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.accentGoldDark,
                  size: 32.r,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              final currentArgs = RadioAudioPlayerService().currentArgs;
              if (currentArgs != null) {
                context.pushNamed(AppRoutes.surahAudio, extra: currentArgs);
              } else if (!isLiveStream) {
                final surahNum = (res['surahNumber'] as num?)?.toInt() ?? 1;
                final fallbackArgs = SurahAudioArgs(
                  surahNumber: surahNum,
                  surahNameAr: res['surahName'] as String? ?? 'الفاتحة',
                  surahNameEn: 'Al-Fatiha',
                  reciterName: subtitle,
                  reciterLetter: subtitle.isNotEmpty ? subtitle[0] : 'ع',
                  serverUrl: 'https://server7.mp3quran.net/basit/',
                );
                context.pushNamed(AppRoutes.surahAudio, extra: fallbackArgs);
              }
            },
            icon: Icon(
              Icons.open_in_new_rounded,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}

