import 'package:flutter/material.dart';

class AppColor {
  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS - Inspired by Islamic architecture & manuscripts
  // ═══════════════════════════════════════════════════════════════════════════

  // Primary backgrounds - Warm parchment tones
  static const Color primaryColor = Color(0xFFFAF7F2); // Warm cream (parchment)
  static const Color bgColor = Color(0xFFF8F4ED); // Light parchment background
  static const Color surfaceColor = Color(0xFFF5EFE6); // Warm beige surface

  // Text colors - Deep, warm tones
  static const Color secondaryColor = Color(
    0xFF3D2B1F,
  ); // Deep brown (ink color)
  static const Color onPrimary = Color(0xFF2C1810); // Rich brown text
  static const Color onSecondary = Color(0xFF4A3728); // Medium brown
  static const Color onTertiary = Color(0xFF8B7355); // Muted brown (inactive)

  // Accent colors - Traditional Islamic palette
  static const Color tealPrimary = Color(
    0xFF1A7F7E,
  ); // Islamic teal (primary accent)
  static const Color tealLight = Color(0xFFE0F2F1); // Light teal background
  static const Color goldAccent = Color(0xFFC9A227); // Mosque dome gold
  static const Color goldLight = Color(0xFFFFF8E1); // Light gold tint

  // Legacy green colors (for compatibility)
  static const Color greenLink = Color(0xFF2E8B6F); // Emerald green
  static const Color greenSoft = Color(0xFFE8F5E9); // Soft sage

  // Progress & UI elements
  static const Color progressBarColor = Color(0xFFE8DFD0); // Warm tan

  // Error / Alerts
  static const Color error = Color(0xFFB00020);
  static const Color redAccent = Color(0xFFE57373);

  // Special pages
  static const Color quranPage = Color.fromARGB(255, 242, 229, 199);
  static const Color greenPage = Color(0xFFE8F5E9);

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME COLORS - Elegant, warm darkness
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color darkBackground = Color(0xFF1A1A1F); // Deep charcoal
  static const Color darkSurface = Color(0xFF252528); // Warm dark surface
  static const Color darkCard = Color(0xFF2D2D32); // Card background
  static const Color darkTeal = Color(0xFF2E8B6F); // Muted teal for dark mode
  static const Color darkGold = Color(0xFFB8942E); // Muted gold
  static const Color darkTextPrimary = Color(0xFFF5F0E8); // Warm off-white
  static const Color darkTextSecondary = Color(0xFFB8A898); // Muted tan
}
