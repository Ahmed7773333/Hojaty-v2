import 'package:flutter/material.dart';
import 'screen_util_like.dart';
import '../../main.dart'; // To access AnaOsalyApp.navigatorKey

class SnackbarHelper {
  static void showSuccess(BuildContext? context, {required String message}) {
    final ctx = context ?? AnaOsalyApp.navigatorKey.currentContext;
    if (ctx == null) return;

    _showCustomSnackbar(
      context: ctx,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(BuildContext? context, {required String message}) {
    final ctx = context ?? AnaOsalyApp.navigatorKey.currentContext;
    if (ctx == null) return;

    _showCustomSnackbar(
      context: ctx,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_outline,
    );
  }

  static void showInfo(BuildContext? context, {required String message}) {
    final ctx = context ?? AnaOsalyApp.navigatorKey.currentContext;
    if (ctx == null) return;

    _showCustomSnackbar(
      context: ctx,
      message: message,
      backgroundColor: Colors.blue.shade600,
      icon: Icons.info_outline,
    );
  }

  static void _showCustomSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24.r),
            12.hor,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      margin: EdgeInsets.only(
        bottom: 24.h,
        left: 20.w,
        right: 20.w,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
