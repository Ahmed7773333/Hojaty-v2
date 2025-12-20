import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // You can provide the BLoC locally
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
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            switch (state.status) {
              case SettingsStatus.initial:
              case SettingsStatus.loading:
                return const CircularProgressIndicator();
              case SettingsStatus.loaded:
                return const Text('Data Loaded ✅');
              case SettingsStatus.error:
                return Text('Error: ${state.message}');
            }
          },
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SettingsBloc>().add(LoadSettingsEvent()),
        child: const Icon(Icons.refresh),
       ),
    );
  }
}
