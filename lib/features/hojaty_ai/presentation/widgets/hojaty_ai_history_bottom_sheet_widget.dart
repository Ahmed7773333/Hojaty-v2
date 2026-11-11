import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/hojaty_ai_cubit.dart';
import '../bloc/hojaty_ai_state.dart';
import 'hojaty_ai_history_item_widget.dart';

class HojatyAiHistoryBottomSheetWidget extends StatelessWidget {
  const HojatyAiHistoryBottomSheetWidget({super.key});

  static void show(BuildContext context) {
    final cubit = context.read<HojatyAiCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const HojatyAiHistoryBottomSheetWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: Column(
            children: [
              12.ver,
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                      size: 22.r,
                    ),
                    10.hor,
                    Expanded(
                      child: Text(
                        context.strings.hojatyAiHistoryTitle,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 17.sp,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    BlocBuilder<HojatyAiCubit, HojatyAiState>(
                      buildWhen: (prev, curr) =>
                          prev.historySessions.isEmpty !=
                          curr.historySessions.isEmpty,
                      builder: (context, state) {
                        if (state.historySessions.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return TextButton(
                          onPressed: () {
                            _confirmClearAll(context);
                          },
                          child: Text(
                            context.strings.hojatyAiClearAllHistory,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<HojatyAiCubit>().startNewChat();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.add_comment_outlined,
                      size: 18.r,
                      color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    ),
                    label: Text(
                      context.strings.hojatyAiNewChat,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.accentGold
                            : AppColors.primaryDark,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                ),
              ),
              12.ver,
              Divider(
                height: 1,
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
              ),
              Expanded(
                child: BlocBuilder<HojatyAiCubit, HojatyAiState>(
                  buildWhen: (prev, curr) =>
                      prev.historySessions != curr.historySessions ||
                      prev.currentSessionId != curr.currentSessionId,
                  builder: (context, state) {
                    if (state.historySessions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_toggle_off_rounded,
                              size: 52.r,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            14.ver,
                            Text(
                              context.strings.hojatyAiHistoryEmpty,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.historySessions.length,
                      separatorBuilder: (_, __) => 10.ver,
                      itemBuilder: (context, index) {
                        final session = state.historySessions[index];
                        final isSelected = session.id == state.currentSessionId;
                        return HojatyAiHistoryItemWidget(
                          session: session,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<HojatyAiCubit>().selectSession(session.id);
                            Navigator.of(context).pop();
                          },
                          onDelete: () {
                            context.read<HojatyAiCubit>().deleteSession(session.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmClearAll(BuildContext context) {
    final cubit = context.read<HojatyAiCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.strings.hojatyAiClearAllHistory),
          content: Text(context.strings.hojatyAiClearAllConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.strings.cancel),
            ),
            TextButton(
              onPressed: () {
                cubit.clearAllHistory();
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                context.strings.hojatyAiClearAllHistory,
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
