import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/athkar_category_model.dart';
import 'asma_allah_banner_card_widget.dart';
import 'athkar_all_categories_list_widget.dart';
import 'athkar_daily_grid_widget.dart';
import 'athkar_section_header_widget.dart';

class AthkarMainContentWidget extends StatelessWidget {
  final List<AthkarCategoryModel> dailyCategories;
  final List<AthkarCategoryModel> allCategories;
  final ValueChanged<AthkarCategoryModel> onCategoryTap;

  const AthkarMainContentWidget({
    super.key,
    required this.dailyCategories,
    required this.allCategories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AsmaAllahBannerCardWidget(),
          18.ver,
          AthkarSectionHeaderWidget(
            title: context.strings.dailyAthkar,
            badgeText: '${dailyCategories.length}',
          ),
          12.ver,
          AthkarDailyGridWidget(
            dailyCategories: dailyCategories,
            onCategoryTap: onCategoryTap,
          ),
          24.ver,
          AthkarSectionHeaderWidget(
            title: context.strings.hisnAlMuslim,
            badgeText: context.strings.allAthkarCount(allCategories.length),
          ),
          12.ver,
          AthkarAllCategoriesListWidget(
            categories: allCategories,
            onCategoryTap: onCategoryTap,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          24.ver,
        ],
      ),
    );
  }
}

