import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../domain/entities/qirat_type.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import 'quran_qirat_tile_widget.dart';

class QuranQiratBottomSheetWidget extends StatelessWidget {
  const QuranQiratBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                16.ver,
                Text(
                  context.strings.select_qirat,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                  ),
                ),
                16.ver,
                Column(
                  children: QiratType.values.map((qirat) {
                    final isSelected = state.selectedQirat == qirat;
                    final status = state.qiratStatuses[qirat] ??
                        (qirat == state.selectedQirat ? state.assetStatus : QuranAssetStatus.requiresDownload);
                    final progress = state.qiratProgress[qirat] ??
                        (qirat == state.selectedQirat ? state.downloadProgress : 0.0);

                    return QuranQiratTileWidget(
                      qirat: qirat,
                      isSelected: isSelected,
                      assetStatus: status,
                      downloadProgress: progress,
                      onTap: () {
                        context.read<QuranBloc>().add(SelectQiratEvent(qirat));
                        Navigator.of(context).pop();
                      },
                      onDownload: () {
                        context.read<QuranBloc>().add(StartDownloadQuranAssetEvent(qirat: qirat));
                      },
                    );
                  }).toList(),
                ),
                12.ver,
              ],
            ),
          );
        },
      ),
    );
  }
}
