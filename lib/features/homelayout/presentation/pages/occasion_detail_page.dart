import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/occasion_item_model.dart';
import '../widgets/occasions/occasion_detail_about_card_widget.dart';
import '../widgets/occasions/occasion_detail_dates_card_widget.dart';
import '../widgets/occasions/occasion_detail_header_widget.dart';

class OccasionDetailPage extends StatelessWidget {
  final OccasionItemModel occasion;

  const OccasionDetailPage({
    super.key,
    required this.occasion,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
