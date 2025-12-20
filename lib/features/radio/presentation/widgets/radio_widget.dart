import 'package:flutter/material.dart';

class FakeRadioWidget extends StatefulWidget {
  const FakeRadioWidget({super.key});

  @override
  State<FakeRadioWidget> createState() => _FakeRadioWidgetState();
}

class _FakeRadioWidgetState extends State<FakeRadioWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Fake Radio Widget: counter = \$counter'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
