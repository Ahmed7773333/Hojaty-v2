import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:upgrader/upgrader.dart';

/// Dynamic Arabic/English localization for optional in-app store update alerts.
class AppUpgraderMessages extends UpgraderMessages {
  AppUpgraderMessages({super.code});

  @override
  String? message(UpgraderMessage messageKey) {
    final isAr = (UserHiveHelper.getUser()?.language ?? 'ar') == 'ar';
    if (isAr) {
      switch (messageKey) {
        case UpgraderMessage.title:
          return 'تحديث جديد متاح';
        case UpgraderMessage.body:
          return 'يتوفر إصدار جديد من تطبيق حچتي على المتجر. يمكنك التحديث الآن للاستفادة من أحدث التحسينات.';
        case UpgraderMessage.prompt:
          return 'هل ترغب في التحديث الآن؟';
        case UpgraderMessage.buttonTitleUpdate:
          return 'تحديث الآن';
        case UpgraderMessage.buttonTitleLater:
          return 'لاحقاً';
        case UpgraderMessage.buttonTitleIgnore:
          return 'تجاهل';
        case UpgraderMessage.releaseNotes:
          return 'ما الجديد في هذا الإصدار';
      }
    }

    switch (messageKey) {
      case UpgraderMessage.title:
        return 'New Update Available';
      case UpgraderMessage.body:
        return 'A newer version of Hojaty is available on the store. You can update now to enjoy the latest improvements.';
      case UpgraderMessage.prompt:
        return 'Would you like to update now?';
      case UpgraderMessage.buttonTitleUpdate:
        return 'Update Now';
      case UpgraderMessage.buttonTitleLater:
        return 'Later';
      case UpgraderMessage.buttonTitleIgnore:
        return 'Ignore';
      case UpgraderMessage.releaseNotes:
        return 'Release Notes';
    }
  }
}
