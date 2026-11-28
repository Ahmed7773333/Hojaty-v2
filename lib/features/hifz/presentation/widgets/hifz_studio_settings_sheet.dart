import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_state.dart';
import 'package:material_ui/material_ui.dart';

class HifzStudioSettingsSheet extends StatelessWidget {
  const HifzStudioSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<HifzSessionCubit, HifzSessionState>(
          builder: (context, state) {
            final cubit = context.read<HifzSessionCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.hifzPauseSettingsTitle,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                14.ver,
                RadioListTile<PauseMode>(
                  value: PauseMode.dynamicDuration,
                  groupValue: state.pauseMode,
                  activeColor: AppColors.accentGold,
                  title: Text(context.strings.hifzPauseDynamic),
                  onChanged: (mode) {
                    if (mode != null) cubit.setPauseMode(mode);
                  },
                ),
                RadioListTile<PauseMode>(
                  value: PauseMode.fixed,
                  groupValue: state.pauseMode,
                  activeColor: AppColors.accentGold,
                  title: Text(
                    context.strings.hifzPauseFixed(state.fixedPauseSeconds),
                  ),
                  onChanged: (mode) {
                    if (mode != null) cubit.setPauseMode(mode);
                  },
                ),
                if (state.pauseMode == PauseMode.fixed)
                  Slider(
                    value: state.fixedPauseSeconds.toDouble(),
                    min: 3,
                    max: 15,
                    divisions: 12,
                    activeColor: AppColors.accentGold,
                    label: '${state.fixedPauseSeconds}s',
                    onChanged: (v) => cubit.setFixedPauseSeconds(v.round()),
                  ),
                12.ver,
                Text(
                  context.strings.hifzAudioQuality,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                8.ver,
                SegmentedButton<AudioQuality>(
                  segments: [
                    ButtonSegment<AudioQuality>(
                      value: AudioQuality.kbps64,
                      label: Text(context.strings.hifzQuality64),
                    ),
                    ButtonSegment<AudioQuality>(
                      value: AudioQuality.kbps128,
                      label: Text(context.strings.hifzQuality128),
                    ),
                  ],
                  selected: {state.audioQuality},
                  onSelectionChanged: (sel) {
                    if (sel.isNotEmpty) cubit.setAudioQuality(sel.first);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

