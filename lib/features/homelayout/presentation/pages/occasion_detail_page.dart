import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/occasion_item_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/occasion_detail_about_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/occasion_detail_dates_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/occasion_detail_header_widget.dart';

class OccasionDetailPage extends StatelessWidget {
  final OccasionItemModel occasion;

  const OccasionDetailPage({super.key, required this.occasion});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          OccasionDetailHeaderWidget(occasion: occasion),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  OccasionDetailDatesCardWidget(occasion: occasion),
                  14.ver,
                  OccasionDetailAboutCardWidget(occasion: occasion),
                  24.ver,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
