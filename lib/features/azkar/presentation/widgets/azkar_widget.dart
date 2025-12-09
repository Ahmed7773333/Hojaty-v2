import 'package:flutter/material.dart';

class FakeAzkarWidget extends StatefulWidget {
  const FakeAzkarWidget({super.key});

  @override
  State<FakeAzkarWidget> createState() => _FakeAzkarWidgetState();
}

class _FakeAzkarWidgetState extends State<FakeAzkarWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Fake Azkar Widget: counter = $counter'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
