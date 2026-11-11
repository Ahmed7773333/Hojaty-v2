import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/chat_session_model.dart';

class HojatyAiHistoryItemWidget extends StatelessWidget {
  final ChatSessionModel session;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HojatyAiHistoryItemWidget({
    super.key,
    required this.session,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dateText = DateFormat('yyyy/MM/dd • hh:mm a').format(session.updatedAt);

    return Material(
      color: isSelected
          ? (isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected)
          : (isDark ? AppColors.darkCardUnselected : AppColors.lightSurface),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
                  : (isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentGold.withValues(alpha: 0.2)
                      : (isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18.r,
                  color: isSelected
                      ? (isDark ? AppColors.accentGoldLight : AppColors.primaryDark)
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
              12.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 14.sp,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    4.ver,
                    Row(
                      children: [
                        Text(
                          context.strings.hojatyAiMessagesCount(session.messages.length),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.accentGoldLight
                                : AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
                          ),
                        ),
                        8.hor,
                        Expanded(
                          child: Text(
                            dateText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: context.strings.hojatyAiDeleteChat,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20.r,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
