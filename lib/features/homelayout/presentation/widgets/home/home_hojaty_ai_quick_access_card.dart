import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/play_asset_delivery_service.dart';
import '../../../../../core/utils/screen_util_like.dart';

class HomeHojatyAiQuickAccessCard extends StatefulWidget {
  const HomeHojatyAiQuickAccessCard({super.key});

  @override
  State<HomeHojatyAiQuickAccessCard> createState() => _HomeHojatyAiQuickAccessCardState();
}

class _HomeHojatyAiQuickAccessCardState extends State<HomeHojatyAiQuickAccessCard> {
  bool _isDownloaded = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    if (kDebugMode) {
      if (mounted) setState(() => _isDownloaded = true);
      return;
    }

    try {
      final packPath = await PlayAssetDeliveryService.getAssetPackPath('hojaty_rag');
      if (packPath != null && packPath.isNotEmpty && File('$packPath/hojaty_rag.db').existsSync()) {
        if (mounted) setState(() => _isDownloaded = true);
        return;
      }
      final direct = File('android/hojaty_rag/src/main/assets/hojaty_rag.db');
      if (direct.existsSync()) {
        if (mounted) setState(() => _isDownloaded = true);
        return;
      }
      final info = await PlayAssetDeliveryService.getAssetPackStatus('hojaty_rag');
      if (mounted) {
        setState(() => _isDownloaded = info.isDownloaded);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: () async {
        await context.pushNamed(AppRoutes.hojatyAi);
        _checkStatus();
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(
                alpha: isDark ? 0.2 : 0.04,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: isDark
                    ? AppColors.accentGoldLight
                    : AppColors.accentGoldDark,
                size: 22.r,
              ),
            ),
            12.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.hojatyAiQuickAccessTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  4.ver,
                  Text(
                    context.strings.hojatyAiQuickAccessSubtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!_isDownloaded) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_download_rounded,
                      size: 13.r,
                      color: isDark
                          ? AppColors.accentGoldLight
                          : AppColors.accentGoldDark,
                    ),
                    4.hor,
                    Text(
                      '~127MB',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.accentGoldDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              8.hor,
            ],
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.r,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}

