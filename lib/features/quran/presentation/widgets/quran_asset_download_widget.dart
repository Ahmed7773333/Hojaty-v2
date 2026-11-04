import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';

class QuranAssetDownloadWidget extends StatelessWidget {
  const QuranAssetDownloadWidget({super.key});

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
            child: BlocBuilder<QuranBloc, QuranState>(
              builder: (context, state) {
                if (state.assetStatus == QuranAssetStatus.checking) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                      ),
                      24.ver,
                      Text(
                        context.strings.downloadingQuran,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  );
                }

                final isDownloading = state.assetStatus == QuranAssetStatus.downloading;
                final isFailed = state.assetStatus == QuranAssetStatus.failed;

                final int downloadedMb = (state.bytesDownloaded / (1024 * 1024)).round();
                final int totalMb = state.totalBytes > 0
                    ? (state.totalBytes / (1024 * 1024)).round()
                    : 140;
                final int percent = (state.downloadProgress * 100).round();

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
                              : (isFailed ? Icons.error_outline_rounded : Icons.auto_stories_rounded),
                          size: 42.sp,
                          color: isFailed
                              ? Colors.redAccent
                              : (isDark ? AppColors.accentGold : AppColors.primaryDark),
                        ),
                      ),
                      20.ver,
                      Text(
                        context.strings.downloadQuranPages,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      12.ver,
                      Text(
                        context.strings.downloadQuranPagesDesc,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 14.sp,
                          height: 1.5,
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
                          context.strings.downloadProgress(downloadedMb, totalMb, percent),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                        20.ver,
                        OutlinedButton(
                          onPressed: () {
                            context.read<QuranBloc>().add(const CancelDownloadQuranAssetEvent());
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
                          child: Text(context.strings.cancel),
                        ),
                      ] else ...[
                        if (isFailed) ...[
                          Text(
                            context.strings.downloadQuranError,
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
                              ? context.strings.retryDownload
                              : context.strings.startDownload,
                          backgroundColor: isDark ? AppColors.accentGold : AppColors.primaryDark,
                          foregroundColor: isDark ? AppColors.primaryDarkBackground : AppColors.white,
                          onPressed: () {
                            context.read<QuranBloc>().add(const StartDownloadQuranAssetEvent());
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
