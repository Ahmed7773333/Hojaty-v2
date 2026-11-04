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
}
