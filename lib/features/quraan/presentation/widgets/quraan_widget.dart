import 'package:flutter/material.dart';

class FakeQuraanWidget extends StatefulWidget {
  const FakeQuraanWidget({super.key});

  @override
  State<FakeQuraanWidget> createState() => _FakeQuraanWidgetState();
}

class _FakeQuraanWidgetState extends State<FakeQuraanWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Fake Quraan Widget: counter = $counter'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
