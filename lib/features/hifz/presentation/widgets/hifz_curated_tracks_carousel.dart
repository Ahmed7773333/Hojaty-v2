import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_curated_track_card.dart';
import 'package:material_ui/material_ui.dart';

class HifzCuratedTracksCarousel extends StatelessWidget {
  final List<CuratedTrack> tracks;
  final String? activeTrackKey;
  final ValueChanged<CuratedTrack> onSelectTrack;
  final VoidCallback onCustomPlanTap;

  const HifzCuratedTracksCarousel({
    super.key,
    required this.tracks,
    required this.activeTrackKey,
    required this.onSelectTrack,
    required this.onCustomPlanTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.strings.hifzCuratedTracks,
                style: context.textTheme.titleLarge?.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onCustomPlanTap,
              style: TextButton.styleFrom(
                foregroundColor:
                    isDark ? AppColors.accentGold : AppColors.primaryDark,
              ),
              icon: Icon(Icons.add_rounded, size: 18.r),
              label: Text(context.strings.hifzCustomPlan),
            ),
          ],
        ),
        10.ver,
        SizedBox(
          height: 152.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tracks.length,
            separatorBuilder: (_, _) => 12.hor,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return HifzCuratedTrackCard(
                track: track,
                isActive: track.trackKey == activeTrackKey,
                onTap: () => onSelectTrack(track),
              );
            },
          ),
        ),
      ],
    );
  }
}

