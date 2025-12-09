import 'package:flutter/material.dart';

class FakeSettingsWidget extends StatefulWidget {
  const FakeSettingsWidget({super.key});

  @override
  State<FakeSettingsWidget> createState() => _FakeSettingsWidgetState();
}

class _FakeSettingsWidgetState extends State<FakeSettingsWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Fake Settings Widget: counter = $counter'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
