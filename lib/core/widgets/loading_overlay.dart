import 'dart:ui';
import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/extensions/context_extensions.dart';

class LoadingOverlay extends StatelessWidget {
  final String? message;
  final double? progress;

  const LoadingOverlay({super.key, this.message, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  color: context.colors.primary,
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: AppTextStyles.notoKufiArabicBody13Medium.copyWith(
                      color: context.colors.onSurface,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
