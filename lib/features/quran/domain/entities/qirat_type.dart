import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

enum QiratType {
  hafs,
  douri,
  qalon,
  shubah,
  warsh;

  bool get isAvailable => true;

  int get approximateSizeMb {
    switch (this) {
      case QiratType.hafs:
        return 140;
      case QiratType.douri:
        return 72;
      case QiratType.qalon:
        return 71;
      case QiratType.shubah:
        return 72;
      case QiratType.warsh:
        return 69;
    }
  }

  String get assetPackName {
    switch (this) {
      case QiratType.hafs:
        return 'quran_hafs';
      case QiratType.douri:
        return 'quran_douri';
      case QiratType.qalon:
        return 'quran_qalon';
      case QiratType.shubah:
        return 'quran_shubah';
      case QiratType.warsh:
        return 'quran_warsh';
    }
  }

  String get folderName {
    switch (this) {
      case QiratType.hafs:
        return 'pages-hafs';
      case QiratType.douri:
        return 'pages-douri';
      case QiratType.qalon:
        return 'pages-qalon';
      case QiratType.shubah:
        return 'pages-shubah';
      case QiratType.warsh:
        return 'pages-warsh';
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case QiratType.hafs:
        return context.strings.qirat_hafs;
      case QiratType.douri:
        return context.strings.qirat_douri;
      case QiratType.qalon:
        return context.strings.qirat_qalon;
      case QiratType.shubah:
        return context.strings.qirat_shubah;
      case QiratType.warsh:
        return context.strings.qirat_warsh;
    }
  }

  Color get themeColor {
    switch (this) {
      case QiratType.hafs:
        return const Color(0xFF5BA37E); // Soft Sage Green (#B5D8C3 inspired)
      case QiratType.qalon:
        return const Color(0xFF2E9CD3); // Ocean / Sky Blue (#67C7F3 inspired)
      case QiratType.shubah:
        return const Color(0xFFE2833F); // Warm Terracotta / Peach (#FDB885 inspired)
      case QiratType.warsh:
        return const Color(0xFF9E6B97); // Elegant Lilac / Mauve (#C7A1C2 inspired)
      case QiratType.douri:
        return const Color(0xFFB59353); // Sand Gold / Ochre (#CDB081 inspired)
    }
  }
}
