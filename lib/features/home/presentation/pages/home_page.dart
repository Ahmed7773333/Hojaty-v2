import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/home_injector.dart';
import '../../../../core/di/injector.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // You can provide the BLoC locally
    return BlocProvider(
      create: (context) => injector<HomeBloc>()..add(LoadHomeEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.initial:
              case HomeStatus.loading:
                return const CircularProgressIndicator();
              case HomeStatus.loaded:
                return const Text('Data  ✅');
              case HomeStatus.error:
                return Text('Error: ${state.message}');
            }
          },
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<HomeBloc>().add(LoadHomeEvent()),
        child: const Icon(Icons.refresh),
       ),
    );
  }
}
