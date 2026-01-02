import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/routes/app_router.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/language_selector.dart';
import '../widgets/location_card.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(context.strings.settings),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.onSurface,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading || state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SettingsStatus.error) {
            return Center(
              child: Text(context.strings.errorMessage(state.message)),
            );
          }

          final user = state.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsSectionHeader(title: context.strings.appearance),
                const SizedBox(height: 10),
                ThemeSelector(
                  currentTheme: user.uiThemeMode,
                  onThemeChanged: (mode) {
                    context.read<SettingsBloc>().add(UpdateThemeEvent(mode));
                  },
                ),
                const SizedBox(height: 24),
                SettingsSectionHeader(title: context.strings.language),
                const SizedBox(height: 10),
                LanguageSelector(
                  isEnglish: user.uiIsEnglish,
                  onLanguageChanged: (isEnglish) {
                    context.read<SettingsBloc>().add(
                      UpdateLanguageEvent(isEnglish),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SettingsSectionHeader(title: context.strings.location),
                const SizedBox(height: 10),
                LocationCard(
                  cityName: user.uiCityName,
                  onRefresh: () {
                    context.read<SettingsBloc>().add(RefreshLocationEvent());
                  },
                ),
                const SizedBox(height: 24),
                _buildListTile(
                  context,
                  title: context.strings.notifications,
                  icon: Icons.notifications_outlined,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.notifications),
                ),
                _buildListTile(
                  context,
                  title: context.strings.about_app,
                  icon: Icons.info_outline,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.aboutApp),
                ),
                _buildListTile(
                  context,
                  title: context.strings.privacy_policy,
                  icon: Icons.privacy_tip_outlined,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                ),
                _buildListTile(
                  context,
                  title: context.strings.contact_us,
                  icon: Icons.contact_support_outlined,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.contactUs),
                ),
                const SizedBox(height: 32),
                // Test Notification Button (dev only or hidden?)
                // Creating a subtle version
                Center(
                  child: TextButton(
                    onPressed: () {
                      NotificationService.showTestNotification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Test notification sent!'),
                        ),
                      );
                    },
                    child: Text(
                      'Test Notification',
                      style: TextStyle(
                        color: context.colors.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: context.colors.primary),
        title: Text(title, style: context.textTheme.bodyLarge),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
