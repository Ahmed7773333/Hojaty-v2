import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_category_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/athkar/athkar_category_card_widget.dart';

class AthkarDailyGridWidget extends StatelessWidget {
  final List<AthkarCategoryModel> dailyCategories;
  final ValueChanged<AthkarCategoryModel> onCategoryTap;

  const AthkarDailyGridWidget({
    super.key,
    required this.dailyCategories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: dailyCategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final category = dailyCategories[index];
        return AthkarCategoryCardWidget(
          category: category,
          onTap: () => onCategoryTap(category),
        );
      },
    );
  }
}
