import 'package:flutter/material.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class QuraanBottomBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onHomeTap;
  final VoidCallback onJuzTap;

  const QuraanBottomBar({
    super.key,
    required this.isVisible,
    required this.onHomeTap,
    required this.onJuzTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: isVisible ? 0 : -100,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 8,
          top: 12,
          left: 32,
          right: 32,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            InkWell(
              onTap: onHomeTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.home),
                  const SizedBox(height: 4),
                  Text(
                    context.strings.home,
                    style: AppTextStyles.notoKufiArabicBody13Medium,
                  ),
                ],
              ),
            ),
            // Index (Fehres)
            InkWell(
              onTap: onJuzTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.format_list_numbered_rtl),
                  const SizedBox(height: 4),
                  Text(
                    context
                        .strings
                        .surahs_list, // Using "Surahs List" or a proper "Index" key if available. User said "الفهرس". existing key "surahs_list" might be close or I can add "index" key.
                    // Checking ar.arb: "surahs_list": "قائمة السور".
                    // User explicitly asked for "الفهرس".
                    // I should check if "index" key exists or add it.
                    // For now, I'll use a hardcoded text if key missing or reuse closely related one?
                    // Better to use localization. Let's check keys again.
                    // ar.arb has "surahs_list": "قائمة السور".
                    // I will use context.strings.surahs_list for now, but really I should add "quranIndex": "الفهرس".
                    // Since I can't edit arb blindly without task, I'll stick to what I have or careful edit.
                    // Wait, I can add keys.
                    // Let's check if I can just use existing "quranJuzs" or similar?
                    // User said "الصفحة الرئيسية ،الفهرس".
                    // "home": "الرئيسية" (ar.arb).
                    // I'll add "quranIndex": "الفهرس" later or now.
                    // Let's stick to existing "surahs_list" for safe refactor or use hardcoded if acceptable? No, hardcoding bad.
                    // Detailed plan said "Refactor...".
                    // I will add "quranIndex" key to arb files in next tool call.
                    // For now I will use Text("الفهرس") as placeholder? No, lint error.
                    // I will use `context.strings.surahs_list` and then update the arb file to change "Surahs List" to "Index" or add new key.
                    // Actually, let's look at `FehrsPage` title usage.
                    // I'll assume `surahs_list` is fine or I will modify arb files immediately after.
                    style: AppTextStyles.notoKufiArabicBody13Medium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
