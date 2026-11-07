import 'package:flutter/material.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/athkar_category_model.dart';
import 'athkar_category_tile_widget.dart';

class AthkarAllCategoriesListWidget extends StatelessWidget {
  final List<AthkarCategoryModel> categories;
  final ValueChanged<AthkarCategoryModel> onCategoryTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const AthkarAllCategoriesListWidget({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      separatorBuilder: (_, __) => 10.ver,
      itemBuilder: (context, index) {
        final category = categories[index];
        return AthkarCategoryTileWidget(
          category: category,
          index: index + 1,
          onTap: () => onCategoryTap(category),
        );
      },
    );
  }
}

