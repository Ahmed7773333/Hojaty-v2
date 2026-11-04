import 'package:flutter/material.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/local/user_hive_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/app_content_model.dart';
import '../../domain/usecases/get_privacy_policy_use_case.dart';
import '../../domain/usecases/get_terms_and_conditions_use_case.dart';
import '../widgets/settings/app_content_card_widget.dart';
import '../widgets/settings/app_content_error_widget.dart';
import '../widgets/settings/app_content_loading_widget.dart';
import '../widgets/settings/settings_page_header_widget.dart';

enum AppContentType {
  privacyPolicy,
  termsAndConditions,
  custom,
}

class AppInfoContentPage extends StatefulWidget {
  final AppContentType contentType;
  final String title;
  final String content;

  const AppInfoContentPage({
    super.key,
    this.contentType = AppContentType.custom,
    required this.title,
    required this.content,
  });

  @override
  State<AppInfoContentPage> createState() => _AppInfoContentPageState();
}

class _AppInfoContentPageState extends State<AppInfoContentPage> {
  bool _isLoading = false;
  bool _hasError = false;
  late String _displayTitle;
  late String _displayContent;
  String? _version;
  String? _updatedAt;

  @override
  void initState() {
    super.initState();
    _displayTitle = widget.title;
    _displayContent = widget.content;

    if (widget.contentType != AppContentType.custom) {
      _fetchRemoteContent();
    }
  }

  Future<void> _fetchRemoteContent() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final lang = UserHiveHelper.getUser()?.language ?? 'ar';

    try {
      AppContentModel model;
      if (widget.contentType == AppContentType.privacyPolicy) {
        model = await injector<GetPrivacyPolicyUseCase>()(language: lang);
      } else {
        model = await injector<GetTermsAndConditionsUseCase>()(language: lang);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (model.title.isNotEmpty) _displayTitle = model.title;
          if (model.content.isNotEmpty) _displayContent = model.content;
          _version = model.version;
          _updatedAt = model.updatedAt;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          SettingsPageHeaderWidget(title: _displayTitle),
          Expanded(
            child: _isLoading
                ? const AppContentLoadingWidget()
                : _hasError && _displayContent.isEmpty
                    ? AppContentErrorWidget(onRetry: _fetchRemoteContent)
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          children: [
                            AppContentCardWidget(
                              content: _displayContent,
                              version: _version,
                              updatedAt: _updatedAt,
                            ),
                            if (_hasError) ...[
                              16.ver,
                              AppContentErrorWidget(
                                onRetry: _fetchRemoteContent,
                              ),
                            ],
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// ARCHIVED ORIGINAL APP INFO CONTENT PAGE
// =========================================================================
// class AppInfoContentPage extends StatelessWidget {
//   final String title;
//   final String content;
//
//   const AppInfoContentPage({
//     super.key,
//     required this.title,
//     required this.content,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
//     return Scaffold(
//       backgroundColor: isDark
//           ? AppColors.darkBackground
//           : AppColors.lightBackground,
//       body: Column(
//         children: [
//           SettingsPageHeaderWidget(title: title),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
//                 decoration: BoxDecoration(
//                   color: isDark
//                       ? AppColors.darkCardUnselected
//                       : AppColors.lightSurface,
//                   borderRadius: BorderRadius.circular(18.r),
//                   border: Border.all(
//                     color: isDark
//                         ? AppColors.darkBorderUnselected
//                         : AppColors.lightBorderUnselected,
//                     width: 1.0,
//                   ),
//                 ),
//                 child: Text(
//                   content,
//                   style: context.textTheme.bodyMedium?.copyWith(
//                     height: 1.8,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
