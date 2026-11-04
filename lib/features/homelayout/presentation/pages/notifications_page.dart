import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/homelayout_bloc.dart';
import '../bloc/homelayout_event.dart';
import '../bloc/homelayout_state.dart';
import '../widgets/shared/notification_card_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          Container(
            color: AppColors.primaryDarkBackground,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<HomelayoutBloc>().add(
                        const MarkAllNotificationsReadEvent(),
                      );
                    },
                    child: Text(
                      context.strings.markAllAsRead,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGoldLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Text(
                    context.strings.notificationsTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),

                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.white,
                      size: 18.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HomelayoutBloc, HomelayoutState>(
              builder: (context, state) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      context.strings.notificationsTitle,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return NotificationCardWidget(
                      notification: notification,
                      onDelete: () {
                        context.read<HomelayoutBloc>().add(
                          DeleteNotificationEvent(notification.id),
                        );
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
  }
}
