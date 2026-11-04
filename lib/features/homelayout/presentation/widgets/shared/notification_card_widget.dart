import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/notification_item_model.dart';
import 'notification_icon_badge_widget.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationItemModel notification;
  final VoidCallback onDelete;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4.w,
                color: notification.stripeColor,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          size: 20.r,
                        ),
                      ),
                      12.hor,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification.timeAgo,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    fontSize: 11.sp,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    notification.title,
                                    textAlign: TextAlign.end,
                                    style: context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            6.ver,
                            Text(
                              notification.body,
                              textAlign: TextAlign.end,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontSize: 12.sp,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.hor,
                      NotificationIconBadgeWidget(type: notification.iconType),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
