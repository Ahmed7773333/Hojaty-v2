import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/homelayout/presentation/widgets/shared/rate_app_dialog.dart';
import '../local/user_hive_helper.dart';
import 'app_share_helper.dart';

/// Handles daily rate-app prompt throttling and store listing redirection.
class RateAppHelper {
  RateAppHelper._();

  static String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  static bool shouldPromptToday() {
    if (UserHiveHelper.getHasRatedApp()) {
      return false;
    }
    final lastDate = UserHiveHelper.getLastRatePromptDate();
    return lastDate != _todayKey();
  }

  static void markPromptedToday() {
    UserHiveHelper.setLastRatePromptDate(_todayKey());
  }

  static void markAsRated() {
    UserHiveHelper.setHasRatedApp(true);
  }

  static Future<void> openStoreForRating() async {
    markAsRated();
    try {
      await InAppReview.instance.openStoreListing(
        appStoreId: AppShareHelper.iosAppStoreId,
      );
    } catch (_) {
      final uri = Uri.parse(AppShareHelper.appStoreUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> maybeShowDailyRateDialog(BuildContext context) async {
    if (!shouldPromptToday() || !context.mounted) return;
    markPromptedToday();
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const RateAppDialog(),
    );
  }
}

