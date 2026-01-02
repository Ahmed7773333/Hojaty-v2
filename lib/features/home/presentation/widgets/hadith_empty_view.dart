import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';

class HadithEmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;

  const HadithEmptyView({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Center(child: Text(message, style: context.textTheme.bodyLarge));
  }
}
