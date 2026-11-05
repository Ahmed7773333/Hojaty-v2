import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../quran/domain/entities/qirat_type.dart';
import '../../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../../quran/presentation/bloc/quran_event.dart';
import '../../../../quran/presentation/bloc/quran_state.dart';
import 'quran_download_confirm_dialog.dart';
import 'quran_qirat_card_action_widget.dart';
import 'quran_qirat_card_header_widget.dart';

class QuranQiratCardWidget extends StatelessWidget {
  final QiratType qirat;

  const QuranQiratCardWidget({
    super.key,
    required this.qirat,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = qirat.themeColor;
    final state = context.watch<QuranBloc>().state;
    final lastPage = state.qiratLastPages[qirat] ?? 1;
    final isSelected = state.selectedQirat == qirat;
    final status = state.qiratStatuses[qirat] ?? QuranAssetStatus.requiresDownload;
    final progress = state.qiratProgress[qirat] ?? 0.0;
    final isDownloaded = status == QuranAssetStatus.downloaded;

    void onOpen() {
      context.read<QuranBloc>().add(SelectQiratEvent(qirat));
      context.pushNamed(AppRoutes.quranReader, extra: lastPage);
    }

    Future<void> onDownload() async {
      if (status == QuranAssetStatus.downloading) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => QuranDownloadConfirmDialog(qirat: qirat),
      );
      if (confirmed == true && context.mounted) {
        context.read<QuranBloc>().add(StartDownloadQuranAssetEvent(qirat: qirat));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Color.alphaBlend(color.withValues(alpha: isSelected ? 0.12 : 0.05), AppColors.darkCardUnselected)
            : Color.alphaBlend(color.withValues(alpha: isSelected ? 0.08 : 0.03), AppColors.lightSurface),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isSelected
              ? color
              : (isDark
                  ? color.withValues(alpha: 0.35)
                  : color.withValues(alpha: 0.22)),
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.15 : (isSelected ? 0.12 : 0.05)),
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDownloaded ? onOpen : onDownload,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: QuranQiratCardHeaderWidget(
                    qirat: qirat,
                    lastPage: lastPage,
                    isSelected: isSelected,
                  ),
                ),
                10.hor,
                QuranQiratCardActionWidget(
                  qirat: qirat,
                  assetStatus: status,
                  downloadProgress: progress,
                  onDownload: onDownload,
                  onOpen: onOpen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

