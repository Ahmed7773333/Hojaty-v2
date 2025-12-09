import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/prayers_bloc.dart';
import '../bloc/prayers_event.dart';
import '../bloc/prayers_state.dart';

class PrayersPage extends StatelessWidget {
  const PrayersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // You can provide the BLoC locally
    return BlocProvider(
      create: (context) => injector<PrayersBloc>()..add(LoadPrayersEvent()),
      child: const PrayersView(),
    );
  }
}

class PrayersView extends StatelessWidget {
  const PrayersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayers')),
      body: Center(
        child: BlocBuilder<PrayersBloc, PrayersState>(
          builder: (context, state) {
            switch (state.status) {
              case PrayersStatus.initial:
              case PrayersStatus.loading:
                return const CircularProgressIndicator();
              case PrayersStatus.loaded:
                return const Text('Data Loaded ✅');
              case PrayersStatus.error:
                return Text('Error: ${state.message}');
            }
          },
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PrayersBloc>().add(LoadPrayersEvent()),
        child: const Icon(Icons.refresh),
       ),
    );
  }
}
