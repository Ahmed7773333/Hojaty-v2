import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/assets.dart';
import '../../../data/models/quick_access_model.dart';

class QuickAccessIconWidget extends StatelessWidget {
  final QuickAccessType type;

  const QuickAccessIconWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case QuickAccessType.quran:
        return SvgPicture.asset(Assets.quranQuickAccessIcon);
      case QuickAccessType.athkar:
        return Image.asset(Assets.azkharQuickAccessIcon);
      case QuickAccessType.occasions:
        return SvgPicture.asset(Assets.occasionsQuickAccessIcon);
      case QuickAccessType.prayerTimes:
        return SvgPicture.asset(Assets.prayerScheduleQuickAccessIcon);
      case QuickAccessType.radio:
        return const Icon(
          Icons.radio_rounded,
          color: Color(0xFFD4AF37),
          size: 26,
        );
      case QuickAccessType.books:
        return const Icon(
          Icons.menu_book_rounded,
          color: Color(0xFFD4AF37),
          size: 26,
        );
    }
  }
}
