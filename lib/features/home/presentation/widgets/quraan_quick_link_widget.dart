import 'package:flutter/material.dart';
import 'package:hojaty/core/constants/assets.dart';
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
          // color: context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(
              Assets.quraanCard,
            ), // Placeholder or assuming asset exists, handling locally if not
            fit: BoxFit.cover,
            // opacity: 0.2,
          ),
        ),
      ),
    );
  }
}
