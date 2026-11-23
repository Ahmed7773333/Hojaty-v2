import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_cubit.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_history_bottom_sheet_widget.dart';

class HojatyAiHeaderWidget extends StatelessWidget {
  const HojatyAiHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryDarkSurface
            : AppColors.primaryDarkHeader,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.primaryDarkBorder,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: 20.r,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            8.hor,
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentGold, width: 1.2),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: AppColors.accentGoldLight,
                size: 20.r,
              ),
            ),
            12.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.strings.hojatyAiTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.history_rounded,
                color: AppColors.white,
                size: 22.r,
              ),
              tooltip: context.strings.hojatyAiHistoryTitle,
              onPressed: () {
                HojatyAiHistoryBottomSheetWidget.show(context);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add_comment_outlined,
                color: AppColors.accentGoldLight,
                size: 21.r,
              ),
              tooltip: context.strings.hojatyAiNewChat,
              onPressed: () {
                context.read<HojatyAiCubit>().startNewChat();
              },
            ),
          ],
        ),
      ),
    );
  }
}
