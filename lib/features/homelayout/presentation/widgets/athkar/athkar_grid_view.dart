import 'package:flutter/material.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../data/mocks/athkar_mock_data.dart';
import '../../../data/models/athkar_category_model.dart';
import '../../../data/models/athkar_detail_args.dart';
import '../../../data/models/thikr_item_model.dart';
import 'athkar_category_card_widget.dart';
import 'athkar_header_widget.dart';

class AthkarGridView extends StatelessWidget {
  const AthkarGridView({super.key});

  void _onCategoryTap(BuildContext context, AthkarCategoryModel category) {
    if (category.type == AthkarCategoryType.sebha) {
      context.pushNamed(AppRoutes.sebha);
    } else if (category.isGuide) {
      context.pushNamed(AppRoutes.istikhara);
    } else {
      List<ThikrItemModel> items;
      switch (category.type) {
        case AthkarCategoryType.morning:
          items = AthkarMockData.morningAthkar;
          break;
        case AthkarCategoryType.evening:
          items = AthkarMockData.eveningAthkar;
          break;
        case AthkarCategoryType.sleep:
          items = AthkarMockData.sleepAthkar;
          break;
        case AthkarCategoryType.afterPrayer:
          items = AthkarMockData.afterPrayerAthkar;
          break;
        case AthkarCategoryType.misc:
          items = AthkarMockData.miscAthkar;
          break;
        default:
          items = AthkarMockData.morningAthkar;
          break;
      }

      context.pushNamed(
        AppRoutes.athkarDetail,
        extra: AthkarDetailArgs(
          title: category.titleResolver(context.strings),
          items: items,
          categoryType: category.type,
          categoryId: category.categoryId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = AthkarMockData.categories;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          const AthkarHeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return AthkarCategoryCardWidget(
                    category: category,
                    onTap: () => _onCategoryTap(context, category),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ARCHIVED ORIGINAL ATHKAR GRID VIEW CODE
// ==========================================
// class AthkarGridView extends StatelessWidget {
//   const AthkarGridView({super.key});
// 
//   void _onCategoryTap(BuildContext context, AthkarCategoryModel category) {
//     if (category.isGuide) {
//       context.pushNamed(AppRoutes.istikhara);
//     } else {
//       context.pushNamed(
//         AppRoutes.athkarDetail,
//         extra: category.titleResolver(context.strings),
//       );
//     }
//   }
// 
//   @override
//   Widget build(BuildContext context) {
//     final categories = AthkarMockData.categories;
//     final isDark = context.isDark;
// 
//     return Scaffold(
//       backgroundColor: isDark
//           ? AppColors.darkBackground
//           : AppColors.lightBackground,
//       body: Column(
//         children: [
//           const AthkarHeaderWidget(),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//               child: GridView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: categories.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16.w,
//                   mainAxisSpacing: 16.h,
//                   childAspectRatio: 1,
//                 ),
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return AthkarCategoryCardWidget(
//                     category: category,
//                     onTap: () => _onCategoryTap(context, category),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

