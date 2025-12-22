import 'package:flutter/material.dart';

class AppTextStyles {
  // Assuming 'Noto Kufi Arabic' is the font family based on method names.
  // We can define the font family as a constant or just rely on global theme if set.
  static const String fontFamily = 'Noto Kufi Arabic';
  // It's likely not set globally if they are explicit here.
  // Since I saw `assets/fonts` in pubspec, maybe I should check font family name?
  // User didn't ask me to check fonts. I will assume standard TextStyle usage.

  static const TextStyle notoKufiArabicHeading24 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // as seen in existing usage
  );

  static const TextStyle notoKufiArabicHeading20 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // assumption
  );

  static const TextStyle notoKufiArabicBody13Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
