import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class PrayerTimesHeaderWidget extends StatelessWidget {
  const PrayerTimesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              spacing: 12.w,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.white,
                    size: 18.r,
                  ),
                ),
                Text(
                  context.strings.fullPrayerTimesTitle,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(width: 25),
              ],
            ),

            // 12.ver,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.location_on_outlined,
            //             size: 14.r,
            //             color: AppColors.darkTextSecondary,
            //           ),
            //           4.hor,
            //           Flexible(
            //             child: Text(
            //               context.strings.prayerTimesAddress,
            //               textAlign: TextAlign.end,
            //               style: context.textTheme.bodySmall?.copyWith(
            //                 color: AppColors.darkTextSecondary,
            //                 fontSize: 11.sp,
            //               ),
            //               maxLines: 1,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     6.hor,
            //     InkWell(
            //       onTap: () {},
            //       child: Text(
            //         context.strings.changeLocation,
            //         style: context.textTheme.bodySmall?.copyWith(
            //           color: AppColors.accentGoldLight,
            //           fontWeight: FontWeight.w600,
            //           fontSize: 12.sp,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
