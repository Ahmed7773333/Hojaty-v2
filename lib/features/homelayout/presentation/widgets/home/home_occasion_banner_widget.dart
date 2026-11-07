import 'package:hojaty/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import '../../bloc/homelayout_state.dart';

class HomeOccasionBannerWidget extends StatelessWidget {
  const HomeOccasionBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.nextOccasion != curr.nextOccasion,
      builder: (context, state) {
        final nextOccasion = state.nextOccasion;
        if (nextOccasion == null) {
          return const SizedBox.shrink();
        }

        final bannerText = context.strings.upcomingOccasionBanner(
          nextOccasion.title,
          nextOccasion.daysRemaining,
        );

        return GestureDetector(
          onTap: () {
            context.read<HomelayoutBloc>().add(
              const ChangeBottomNavTabEvent(3),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.accentGold.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(Assets.crescentIcon),
                8.hor,
                Flexible(
                  child: Text(
                    bannerText,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.accentGoldLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
