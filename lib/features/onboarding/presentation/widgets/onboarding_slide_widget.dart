import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/onboarding_item_model.dart';
import 'onboarding_badge_widget.dart';
import 'onboarding_content_widget.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingSlideWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingBadgeWidget(iconType: item.iconType),
          48.ver,
          OnboardingContentWidget(
            subtitle: item.subtitleResolver(context.strings),
            title: item.titleResolver(context.strings),
            description: item.descriptionResolver(context.strings),
          ),
        ],
      ),
    );
  }
}
