import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/quraan_bloc.dart';
import '../bloc/quraan_event.dart';
import '../bloc/quraan_state.dart';

class QuraanPage extends StatelessWidget {
  const QuraanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // You can provide the BLoC locally
    return BlocProvider(
      create: (context) => injector<QuraanBloc>()..add(LoadQuraanEvent()),
      child: const QuraanView(),
    );
  }
}

class QuraanView extends StatelessWidget {
  const QuraanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quraan')),
      body: Center(
        child: BlocBuilder<QuraanBloc, QuraanState>(
          builder: (context, state) {
            switch (state.status) {
              case QuraanStatus.initial:
              case QuraanStatus.loading:
                return const CircularProgressIndicator();
              case QuraanStatus.loaded:
                return const Text('Data Loaded ✅');
              case QuraanStatus.error:
                return Text('Error: ${state.message}');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<QuraanBloc>().add(LoadQuraanEvent()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
