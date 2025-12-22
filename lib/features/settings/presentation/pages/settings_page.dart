import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
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
    return BlocProvider(
      create: (context) => injector<SettingsBloc>()..add(LoadSettingsEvent()),
      child: const SettingsView(),
    );
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
            return Center(child: Text('Error: ${state.message}'));
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
                LocationCard(cityName: user.uiCityName),
              ],
            ),
          );
        },
      ),
    );
  }
}
