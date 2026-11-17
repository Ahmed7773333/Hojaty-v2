import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/quran/constants/mushaf_page_image_resolver.dart';
import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/presentation/widgets/mushaf_night_mode_page_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_page_placeholder_widget.dart';

class QuranPageImageWidget extends StatelessWidget {
  final int pageNumber;
  final String? basePath;
  final QiratType qirat;

  const QuranPageImageWidget({
    super.key,
    required this.pageNumber,
    this.basePath,
    this.qirat = QiratType.hafs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor = isDark
        ? AppColors.mushafNightBackground
        : AppColors.mushafLightBackground;
    final imageProvider = MushafPageImageResolver.resolve(
      pageNumber,
      basePath: basePath,
      qirat: qirat,
    );

    if (isDark) {
      return ColoredBox(
        color: backgroundColor,
        child: MushafNightModePageWidget(
          imageProvider: imageProvider,
          pageNumber: pageNumber,
        ),
      );
    }

    return ColoredBox(
      color: backgroundColor,
      child: Image(
        image: imageProvider,
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return QuranPagePlaceholderWidget(pageNumber: pageNumber);
        },
      ),
    );
  }
}
