import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_tool_registry.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_category_model.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_detail_args.dart';

class HojatyAiStatusActionCardWidget extends StatelessWidget {
  final AiToolActionResultModel action;

  const HojatyAiStatusActionCardWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final strings = context.strings;
    final text = action.displayText ??
        (action.isSuccess
            ? strings.hojatyAiActionDone
            : strings.hojatyAiActionFailed);

    IconData iconData = Icons.check_circle_outline_rounded;
    String buttonText = strings.hojatyAiActionView;
    String? targetRoute;
    Object? routeArgs;

    switch (action.toolName) {
      case HojatyToolRegistry.toolControlSebhaCounter:
        iconData = Icons.touch_app_outlined;
        buttonText = strings.hojatyAiActionSebha;
        targetRoute = AppRoutes.sebha;
        break;
      case HojatyToolRegistry.toolOpenQiblaCompass:
        iconData = Icons.explore_outlined;
        buttonText = strings.hojatyAiActionQibla;
        targetRoute = AppRoutes.qibla;
        break;
      case HojatyToolRegistry.toolOpenAthkarCategory:
        iconData = Icons.auto_stories_outlined;
        buttonText = strings.hojatyAiActionAthkar;
        targetRoute = AppRoutes.athkarDetail;
        final typeName = action.result['type'] as String? ?? 'morning';
        final catType = AthkarCategoryType.values.firstWhere(
          (e) => e.name == typeName,
          orElse: () => AthkarCategoryType.morning,
        );
        routeArgs = AthkarDetailArgs(
          title: action.result['category'] as String? ?? strings.hojatyAiActionAthkar,
          categoryType: catType,
        );
        break;
      case HojatyToolRegistry.toolConfigurePrayerAlerts:
        iconData = Icons.notifications_active_outlined;
        buttonText = strings.hojatyAiActionSettings;
        targetRoute = AppRoutes.notifications;
        break;
      case HojatyToolRegistry.toolUpdateAppPreferences:
        final args = action.arguments;
        if (args['fontSize'] != null) {
          iconData = Icons.text_fields_rounded;
          buttonText = strings.hojatyAiActionSettings;
          targetRoute = AppRoutes.fontSettings;
        } else if (args['enableAnaOsalyQuiet'] != null &&
            (args['themeMode'] as String? ?? '').isEmpty) {
          iconData = Icons.notifications_paused_outlined;
          buttonText = strings.hojatyAiActionSettings;
          targetRoute = AppRoutes.notifications;
        } else {
          iconData = Icons.palette_outlined;
          buttonText = strings.hojatyAiActionTheme;
          targetRoute = AppRoutes.themeSettings;
        }
        break;
      case HojatyToolRegistry.toolOpenHadithReader:
        iconData = Icons.library_books_outlined;
        buttonText = strings.hojatyAiActionLibrary;
        targetRoute = AppRoutes.books;
        break;
      case HojatyToolRegistry.toolManageQuranBookmark:
        iconData = Icons.bookmark_added_outlined;
        final pageNumber = (action.result['pageNumber'] as num?)?.toInt();
        final verseIndex = (action.result['verseIndex'] as num?)?.toInt();
        if (pageNumber != null) {
          buttonText = strings.hojatyAiActionOpen;
          targetRoute = AppRoutes.quranReader;
          routeArgs = {
            'initialPage': pageNumber,
            'highlightVerseIndex': verseIndex,
          };
        } else {
          buttonText = strings.hojatyAiActionBookmarks;
          targetRoute = AppRoutes.quranCheckpoints;
        }
        break;
      default:
        iconData = Icons.check_circle_outline_rounded;
        buttonText = strings.hojatyAiActionView;
        targetRoute = null;
    }

    final accentColor =
        isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark;

    return Container(
      margin: EdgeInsetsDirectional.only(top: 8.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightCardUnselected,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: action.isSuccess
              ? AppColors.accentGold.withValues(alpha: 0.25)
              : context.colors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: action.isSuccess ? accentColor : context.colors.error,
            size: 20.r,
          ),
          10.hor,
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (targetRoute != null) ...[
            8.hor,
            GestureDetector(
              onTap: () => context.pushNamed(targetRoute!, extra: routeArgs),
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      buttonText,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    4.hor,
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10.r,
                      color: accentColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
