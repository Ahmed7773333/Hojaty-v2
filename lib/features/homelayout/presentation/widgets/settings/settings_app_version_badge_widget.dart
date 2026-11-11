import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_version_helper.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

/// Displays the installed application version without the build number.
class SettingsAppVersionBadgeWidget extends StatefulWidget {
  const SettingsAppVersionBadgeWidget({super.key});

  @override
  State<SettingsAppVersionBadgeWidget> createState() =>
      _SettingsAppVersionBadgeWidgetState();
}

class _SettingsAppVersionBadgeWidgetState
    extends State<SettingsAppVersionBadgeWidget> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await AppVersionHelper.getAppVersion();
    if (!mounted || version.isEmpty) return;
    setState(() => _version = version);
  }

  @override
  Widget build(BuildContext context) {
    if (_version.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.accentGoldLight.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Text(
        '${context.strings.appVersionLabel} $_version',
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.accentGoldLight,
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

