import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_type_card_widget.dart';

class AdhanMadhabCardWidget extends StatelessWidget {
  const AdhanMadhabCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.adhanSettings.asrMadhab != curr.adhanSettings.asrMadhab,
      builder: (context, state) {
        final selected = state.adhanSettings.asrMadhab;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.strings.adhanMadhabSectionTitle,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
            10.ver,
            AdhanTypeCardWidget(
              title: context.strings.adhanMadhabShafiTitle,
              subtitle: context.strings.adhanMadhabShafiSubtitle,
              isSelected: selected == AsrMadhab.shafi,
              onTap: () {
                context.read<HomelayoutBloc>().add(
                  const ChangeAsrMadhabEvent(AsrMadhab.shafi),
                );
              },
            ),
            10.ver,
            AdhanTypeCardWidget(
              title: context.strings.adhanMadhabHanafiTitle,
              subtitle: context.strings.adhanMadhabHanafiSubtitle,
              isSelected: selected == AsrMadhab.hanafi,
              onTap: () {
                context.read<HomelayoutBloc>().add(
                  const ChangeAsrMadhabEvent(AsrMadhab.hanafi),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
