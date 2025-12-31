import 'package:flutter/material.dart';

class AppTextStyles {
  static const String notoKufiArabic = 'Noto Kufi Arabic';
  static const String elgharib = 'Elgharib';
  static const String hafsSmart = 'Hafs Smart';

  static const TextStyle notoKufiArabicHeading24 = TextStyle(
    fontFamily: notoKufiArabic,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle notoKufiArabicHeading20 = TextStyle(
    fontFamily: notoKufiArabic,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle notoKufiArabicBody13Medium = TextStyle(
    fontFamily: notoKufiArabic,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle elgharibStyle = TextStyle(
    fontFamily: elgharib,
    fontSize: 16,
  );

  static const TextStyle hafsSmartStyle = TextStyle(
    fontFamily: hafsSmart,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );
}
