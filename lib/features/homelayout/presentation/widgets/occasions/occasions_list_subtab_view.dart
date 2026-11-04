import 'package:hojaty/features/homelayout/presentation/widgets/occasions/occasion_hero_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../data/mocks/occasions_mock_data.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';
import 'occasion_item_row_widget.dart';

class OccasionsListSubtabView extends StatelessWidget {
  const OccasionsListSubtabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        final allOccasions = state.occasionsList.isNotEmpty
            ? state.occasionsList
            : OccasionsMockData.occasionsList;

        final nextOccasion =
            state.nextOccasion ??
            (allOccasions.isNotEmpty
                ? allOccasions.first
                : OccasionsMockData.nextOccasion);

        // List shows subsequent upcoming occasions (or full list if 1 item)
        final upcomingList = allOccasions.length > 1
            ? allOccasions.skip(1).toList()
            : allOccasions;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OccasionHeroCardWidget(
                occasion: nextOccasion,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.occasionDetail,
                    extra: nextOccasion,
                  );
                },
              ),
              20.ver,
              Text(
                context.strings.upcomingOccasionsList,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              12.ver,
              ...upcomingList.map(
                (occasion) => OccasionItemRowWidget(
                  occasion: occasion,
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.occasionDetail,
                      extra: occasion,
                    );
                  },
                ),
              ),
              24.ver,
            ],
          ),
        );
      },
    );
  }
}

// =========================================================================
// ARCHIVED ORIGINAL OCCASIONS LIST SUBTAB VIEW
// =========================================================================
// class OccasionsListSubtabView extends StatelessWidget {
//   const OccasionsListSubtabView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final nextOccasion = OccasionsMockData.nextOccasion;
//     final occasions = OccasionsMockData.occasionsList;
//     final isDark = context.isDark;
//
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           OccasionHeroCardWidget(
//             occasion: nextOccasion,
//             onTap: () {
//               context.pushNamed(AppRoutes.occasionDetail, extra: nextOccasion);
//             },
//           ),
//           20.ver,
//           Text(
//             context.strings.upcomingOccasionsList,
//             style: context.textTheme.bodyMedium?.copyWith(
//               color: isDark
//                   ? AppColors.darkTextSecondary
//                   : AppColors.lightTextSecondary,
//               fontWeight: FontWeight.w600,
//               fontSize: 13.sp,
//             ),
//           ),
//           12.ver,
//           ...occasions.map(
//             (occasion) => OccasionItemRowWidget(
//               occasion: occasion,
//               onTap: () {
//                 context.pushNamed(AppRoutes.occasionDetail, extra: occasion);
//               },
//             ),
//           ),
//           24.ver,
//         ],
//       ),
//     );
//   }
// }
