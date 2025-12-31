import 'package:flutter/material.dart';
import '../widgets/qibla_compass_widget.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qibla")),
      body: const QiblaCompassWidget(),
    );
  }
}
