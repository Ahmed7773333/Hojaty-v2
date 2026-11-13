import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/qibla_bloc.dart';
import '../bloc/qibla_event.dart';
import '../widgets/qibla_page_view.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QiblaBloc>(
      create: (_) => injector<QiblaBloc>()..add(const StartCompassEvent()),
      child: const QiblaPageView(),
    );
  }
}
