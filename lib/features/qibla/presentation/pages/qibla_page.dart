import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/qibla/presentation/bloc/qibla_bloc.dart';
import 'package:hojaty/features/qibla/presentation/bloc/qibla_event.dart';
import 'package:hojaty/features/qibla/presentation/widgets/qibla_page_view.dart';

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
