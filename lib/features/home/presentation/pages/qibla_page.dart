import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../widgets/qibla_compass_widget.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.strings.qibla)),
      body: const QiblaCompassWidget(),
    );
  }
}
