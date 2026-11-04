import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_event.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_state.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'radio_reciter_tile_widget.dart';

class RadioRecitersListWidget extends StatelessWidget {
  const RadioRecitersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return BlocBuilder<RadioBloc, RadioState>(
      builder: (context, state) {
        if (state.status == RadioStatus.loading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: const CircularProgressIndicator(
                color: AppColors.accentGold,
              ),
            ),
          );
        }

        if (state.status == RadioStatus.failure && state.reciters.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.r,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                  12.ver,
                  Text(
                    state.errorMessage ?? context.strings.noRecitersFound,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  16.ver,
                  CustomElevatedButton(
                    text: context.strings.radio,
                    width: 140.w,
                    height: 44.h,
                    onPressed: () {
                      final lang = Localizations.localeOf(context).languageCode;
                      context.read<RadioBloc>().add(
                        LoadRadioEvent(language: lang),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        final reciters = state.filteredReciters;
        if (reciters.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                context.strings.noRecitersFound,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reciters.length,
          separatorBuilder: (_, __) => 8.ver,
          itemBuilder: (context, index) {
            return RadioReciterTileWidget(reciter: reciters[index]);
          },
        );
      },
    );
  }
}
