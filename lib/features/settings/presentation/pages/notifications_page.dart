import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_section_header.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(context.strings.notifications),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading || state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SettingsSectionHeader(title: context.strings.notifications),
              const SizedBox(height: 10),
              // Show Notifications Toggle
              SwitchListTile(
                value: user.uiShowNotifications,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                    UpdateNotificationSettingsEvent(showNotifications: value),
                  );
                },
                title: Text(
                  context.strings.show_notifications,
                  style: context.textTheme.titleMedium,
                ),
                secondary: Icon(
                  Icons.notifications_active_rounded,
                  color: context.colors.primary,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              // Sound Toggle
              SwitchListTile(
                value: user.uiIsSoundEnabled,
                onChanged: user.uiShowNotifications
                    ? (value) {
                        context.read<SettingsBloc>().add(
                          UpdateNotificationSettingsEvent(
                            isSoundEnabled: value,
                          ),
                        );
                      }
                    : null,
                title: Text(
                  context.strings.sound,
                  style: context.textTheme.titleMedium,
                ),
                secondary: Icon(
                  Icons.volume_up_rounded,
                  color: user.uiShowNotifications
                      ? context.colors.primary
                      : context.colors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              // Vibrate Toggle
              SwitchListTile(
                value: user.uiIsVibrateEnabled,
                onChanged: user.uiShowNotifications
                    ? (value) {
                        context.read<SettingsBloc>().add(
                          UpdateNotificationSettingsEvent(
                            isVibrateEnabled: value,
                          ),
                        );
                      }
                    : null,
                title: Text(
                  context.strings.vibrate,
                  style: context.textTheme.titleMedium,
                ),
                secondary: Icon(
                  Icons.vibration_rounded,
                  color: user.uiShowNotifications
                      ? context.colors.primary
                      : context.colors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
