import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';

class RadioPage extends StatelessWidget {
  const RadioPage({super.key});

  @override
  Widget build(BuildContext context) {
    // You can provide the BLoC locally
    return BlocProvider(
      create: (context) => injector<RadioBloc>()..add(LoadRadioEvent()),
      child: const RadioView(),
    );
  }
}

class RadioView extends StatelessWidget {
  const RadioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio')),
      body: Center(
        child: BlocBuilder<RadioBloc, RadioState>(
          builder: (context, state) {
            switch (state.status) {
              case RadioStatus.initial:
              case RadioStatus.loading:
                return const CircularProgressIndicator();
              case RadioStatus.loaded:
                return const Text('Data Loaded ✅');
              case RadioStatus.error:
                return const Text('Error: \${state.message}');
            }
          },
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<RadioBloc>().add(LoadRadioEvent()),
        child: const Icon(Icons.refresh),
       ),
    );
  }
}
