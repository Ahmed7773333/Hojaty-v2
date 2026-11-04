import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/qirat_type.dart';
import 'quran_page_placeholder_widget.dart';

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

    File? pageFile;
    if (basePath != null && basePath!.isNotEmpty) {
      final fFolder = File('$basePath/${qirat.folderName}/$pageNumber.png');
      final fDirect = File('$basePath/$pageNumber.png');
      final fHafsFallback = File('$basePath/pages-hafs/$pageNumber.png');

      if (fFolder.existsSync()) {
        pageFile = fFolder;
      } else if (fDirect.existsSync()) {
        pageFile = fDirect;
      } else if (fHafsFallback.existsSync()) {
        pageFile = fHafsFallback;
      }
    }

    final Widget imageWidget = pageFile != null
        ? Image.file(
            pageFile,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return QuranPagePlaceholderWidget(pageNumber: pageNumber);
            },
          )
        : Image.asset(
            'assets/images/${qirat.folderName}/$pageNumber.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return QuranPagePlaceholderWidget(pageNumber: pageNumber);
            },
          );

    return Container(
      color: isDark ? AppColors.darkBackground : const Color(0xFFFFFDF5),
      child: Center(
        child: imageWidget,
      ),
    );
  }
}
