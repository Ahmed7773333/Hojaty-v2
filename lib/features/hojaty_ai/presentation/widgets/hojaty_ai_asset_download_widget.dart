import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../bloc/hojaty_ai_cubit.dart';
import '../bloc/hojaty_ai_state.dart';

class HojatyAiAssetDownloadWidget extends StatelessWidget {
  const HojatyAiAssetDownloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: BlocBuilder<HojatyAiCubit, HojatyAiState>(
              builder: (context, state) {
                if (state.assetStatus == HojatyAiAssetStatus.checking) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                      ),
                      24.ver,
                      Text(
                        context.strings.downloading,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  );
                }

                final isDownloading = state.assetStatus == HojatyAiAssetStatus.downloading;
                final isFailed = state.assetStatus == HojatyAiAssetStatus.failed;

                final int downloadedMb = (state.bytesDownloaded / (1024 * 1024)).round();
                final int totalMb = state.totalBytes > 0
                    ? (state.totalBytes / (1024 * 1024)).round()
                    : 237;
                final int percent = (state.downloadProgress * 100).round().clamp(0, 100);

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84.w,
                        height: 84.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.darkCardSelected
                              : AppColors.lightCardSelected,
                        ),
                        child: Icon(
                          isDownloading
                              ? Icons.cloud_download_rounded
                              : (isFailed ? Icons.error_outline_rounded : Icons.auto_awesome_rounded),
                          size: 42.sp,
                          color: isFailed
                              ? Colors.redAccent
                              : (isDark ? AppColors.accentGold : AppColors.primaryDark),
                        ),
                      ),
                      20.ver,
                      Text(
                        context.strings.hojatyAiDownloadTitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      12.ver,
                      Text(
                        context.strings.hojatyAiDownloadDesc,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                      14.ver,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCardUnselected
                              : AppColors.lightCardUnselected,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          context.strings.hojatyAiDownloadSize,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      28.ver,
                      if (isDownloading) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: LinearProgressIndicator(
                            value: state.downloadProgress > 0 ? state.downloadProgress : null,
                            minHeight: 10.h,
                            backgroundColor: isDark
                                ? AppColors.darkCardUnselected
                                : AppColors.lightBorderUnselected,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDark ? AppColors.accentGold : AppColors.primaryDark,
                            ),
                          ),
                        ),
                        16.ver,
                        Text(
                          context.strings.hojatyAiDownloadProgress(downloadedMb, totalMb, percent),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                        20.ver,
                        OutlinedButton(
                          onPressed: () {
                            context.read<HojatyAiCubit>().cancelDownload();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? AppColors.accentGold : AppColors.primaryDark,
                            side: BorderSide(
                              color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(context.strings.hojatyAiCancelDownload),
                        ),
                      ] else ...[
                        if (isFailed) ...[
                          Text(
                            context.strings.hojatyAiDownloadError,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.redAccent,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          16.ver,
                        ],
                        CustomElevatedButton(
                          text: isFailed
                              ? context.strings.hojatyAiRetryDownload
                              : context.strings.hojatyAiStartDownload,
                          backgroundColor: isDark ? AppColors.accentGold : AppColors.primaryDark,
                          foregroundColor: isDark ? AppColors.primaryDarkBackground : AppColors.white,
                          onPressed: () {
                            context.read<HojatyAiCubit>().startDownload();
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
