import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';

class HadithErrorView extends StatelessWidget {
  final Object? error;

  const HadithErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: context.colors.error,
          ),
          const SizedBox(height: 16),
          Text(
            // Using a generic error string from context if available, or fallback
            'Error: $error',
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
