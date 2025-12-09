import 'package:flutter/material.dart';

class FakeHomeWidget extends StatefulWidget {
  const FakeHomeWidget({super.key});

  @override
  State<FakeHomeWidget> createState() => _FakeHomeWidgetState();
}

class _FakeHomeWidgetState extends State<FakeHomeWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Fake Home Widget: counter = $counter'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
