import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/azkar_bloc.dart';
import '../bloc/azkar_event.dart';
import '../bloc/azkar_state.dart';

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    // You can provide the BLoC locally
    return BlocProvider(
      create: (context) => injector<AzkarBloc>()..add(LoadAzkarEvent()),
      child: const AzkarView(),
    );
  }
}

class AzkarView extends StatelessWidget {
  const AzkarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Azkar')),
      body: Center(
        child: BlocBuilder<AzkarBloc, AzkarState>(
          builder: (context, state) {
            switch (state.status) {
              case AzkarStatus.initial:
              case AzkarStatus.loading:
                return const CircularProgressIndicator();
              case AzkarStatus.loaded:
                return const Text('Data Loaded ✅');
              case AzkarStatus.error:
                return Text('Error: ${state.message}');
            }
          },
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AzkarBloc>().add(LoadAzkarEvent()),
        child: const Icon(Icons.refresh),
       ),
    );
  }
}
