import 'package:flutter/material.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/thikr_item_model.dart';
import 'thikr_counter_button_widget.dart';
import 'thikr_nav_controls_widget.dart';
import 'thikr_requirement_card_widget.dart';
import 'thikr_text_card_widget.dart';

class ThikrPageContentWidget extends StatelessWidget {
  final ThikrItemModel thikr;
  final int currentCount;
  final bool isCompleted;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onTapCounter;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onReset;

  const ThikrPageContentWidget({
    super.key,
    required this.thikr,
    required this.currentCount,
    required this.isCompleted,
    required this.hasPrevious,
    required this.hasNext,
    required this.onTapCounter,
    required this.onPrevious,
    required this.onNext,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          12.ver,
          ThikrTextCardWidget(thikr: thikr),
          16.ver,
          ThikrRequirementCardWidget(
            requiredCount: thikr.requiredCount,
            currentCount: currentCount,
          ),
          32.ver,
          ThikrCounterButtonWidget(
            currentCount: currentCount,
            isCompleted: isCompleted,
            onTap: onTapCounter,
          ),
          24.ver,
          ThikrNavControlsWidget(
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            onPrevious: onPrevious,
            onNext: onNext,
            onReset: onReset,
          ),
          20.ver,
        ],
      ),
    );
  }
}
