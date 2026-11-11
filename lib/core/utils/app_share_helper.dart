import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'extensions/context_extensions.dart';

class AppShareHelper {
  AppShareHelper._();

  static const String androidPackageName = 'com.wolfdev.hojaty';
  static const String androidPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=$androidPackageName';
  // ponytail: temporary iOS App Store ID until published on App Store, migrate via real App Store ID
  static const String iosAppStoreId = '0000000000';
  // ponytail: temporary iOS link until published on App Store, migrate via real App Store ID link
  static const String iosAppStoreUrl =
      'https://apps.apple.com/app/id$iosAppStoreId';
  static const String companyWebsiteUrl = 'https://saddaq.com';

  static String get appStoreUrl {
    if (Platform.isIOS) {
      return iosAppStoreUrl;
    }
    return androidPlayStoreUrl;
  }

  static Future<void> shareApp(BuildContext context) async {
    final strings = context.strings;
    final message = '''
${strings.shareAppMessage}

${strings.downloadAppPrompt}:
$appStoreUrl

${strings.developedByPrompt}:
$companyWebsiteUrl
'''
        .trim();

    final box = context.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        text: message,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
