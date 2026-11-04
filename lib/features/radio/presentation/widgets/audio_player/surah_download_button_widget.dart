import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/services/radio_download_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SurahDownloadButtonWidget extends StatefulWidget {
  final String audioUrl;
  final String reciterName;
  final int surahNumber;
  final ValueChanged<String>? onDownloadSuccess;
  final VoidCallback? onDownloadDeleted;

  const SurahDownloadButtonWidget({
    super.key,
    required this.audioUrl,
    required this.reciterName,
    required this.surahNumber,
    this.onDownloadSuccess,
    this.onDownloadDeleted,
  });

  @override
  State<SurahDownloadButtonWidget> createState() =>
      _SurahDownloadButtonWidgetState();
}

class _SurahDownloadButtonWidgetState extends State<SurahDownloadButtonWidget> {
  late final RadioDownloadService _downloadService;
  bool _isChecking = true;
  bool _isDownloaded = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _downloadService = injector<RadioDownloadService>();
    _checkStatus();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    final downloaded = await _downloadService.isDownloaded(
      widget.reciterName,
      widget.surahNumber,
    );
    if (!mounted) return;
    setState(() {
      _isDownloaded = downloaded;
      _isChecking = false;
    });
  }

  Future<void> _startDownload() async {
    _cancelToken = CancelToken();
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final savedPath = await _downloadService.downloadSurah(
        url: widget.audioUrl,
        reciterName: widget.reciterName,
        surahId: widget.surahNumber,
        cancelToken: _cancelToken,
        onProgress: (progress) {
          if (mounted) {
            setState(() => _downloadProgress = progress);
          }
        },
      );

      if (!mounted) return;
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });

      widget.onDownloadSuccess?.call(savedPath);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.strings.downloadSuccess)));
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      if (!CancelToken.isCancel(e)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.downloadFailed)));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.strings.downloadFailed)));
    }
  }

  void _cancelDownload() {
    _cancelToken?.cancel();
    setState(() => _isDownloading = false);
  }

  Future<void> _deleteDownload() async {
    final deleted = await _downloadService.deleteDownloadedSurah(
      widget.reciterName,
      widget.surahNumber,
    );
    if (!mounted) return;
    if (deleted) {
      setState(() => _isDownloaded = false);
      widget.onDownloadDeleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const SizedBox.shrink();
    }

    final isDark = context.isDark;

    if (_isDownloaded) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCardSelected
              : AppColors.lightCardSelected,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? AppColors.accentGold : AppColors.primaryDark,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: isDark ? AppColors.accentGold : AppColors.primaryDark,
              size: 20.sp,
            ),
            8.hor,
            Text(
              context.strings.offlineAvailable,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            12.hor,
            InkWell(
              onTap: _deleteDownload,
              borderRadius: BorderRadius.circular(12.r),
              child: Icon(
                Icons.delete_outline_rounded,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
                size: 18.sp,
              ),
            ),
          ],
        ),
      );
    }

    if (_isDownloading) {
      final percentage = (_downloadProgress * 100).clamp(0, 100).toInt();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
          ),
        ),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _downloadProgress > 0 ? _downloadProgress : null,
              color: AppColors.accentGold,
              backgroundColor: isDark
                  ? AppColors.darkCardUnselected
                  : AppColors.lightCardSelected,
              borderRadius: BorderRadius.circular(8.r),
            ),
            8.ver,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$percentage% - ${context.strings.downloading}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                InkWell(
                  onTap: _cancelDownload,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: _startDownload,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? AppColors.accentGold : AppColors.primaryDark,
        side: BorderSide(
          color: isDark ? AppColors.accentGold : AppColors.primaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
      icon: Icon(Icons.download_rounded, size: 18.sp),
      label: Text(
        context.strings.download,
        style: context.textTheme.labelLarge?.copyWith(
          color: isDark ? AppColors.accentGold : AppColors.primaryDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
