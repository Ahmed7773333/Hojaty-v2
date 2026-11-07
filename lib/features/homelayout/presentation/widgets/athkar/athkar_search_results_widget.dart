import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/athkar_category_model.dart';
import 'athkar_all_categories_list_widget.dart';
import 'athkar_empty_search_widget.dart';
import 'athkar_section_header_widget.dart';

class AthkarSearchResultsWidget extends StatelessWidget {
  final List<AthkarCategoryModel> results;
  final ValueChanged<AthkarCategoryModel> onCategoryTap;
  final VoidCallback onClear;

  const AthkarSearchResultsWidget({
    super.key,
    required this.results,
    required this.onCategoryTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return AthkarEmptySearchWidget(onClear: onClear);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AthkarSectionHeaderWidget(
            title: context.strings.searchResults,
            badgeText: '${results.length}',
          ),
          12.ver,
          AthkarAllCategoriesListWidget(
            categories: results,
            onCategoryTap: onCategoryTap,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

