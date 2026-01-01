import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/routes/app_router.dart';

class QuraanQuickLinkWidget extends StatelessWidget {
  const QuraanQuickLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.quraan);
      },
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          // image: const DecorationImage(
          //   image: AssetImage(
          //     'assets/images/quran_bg.png',
          //   ), // Placeholder or assuming asset exists, handling locally if not
          //   fit: BoxFit.cover,
          //   opacity: 0.2,
          // ),
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book_rounded, size: 40), // Placeholder icon
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.strings.holyQuran,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onPrimaryContainer,
                  ),
                ),
                Text(
                  context.strings.dailyWird,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.colors.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
