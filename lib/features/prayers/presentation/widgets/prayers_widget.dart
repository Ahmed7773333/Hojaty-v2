import 'package:flutter/material.dart';

class FakePrayersWidget extends StatefulWidget {
  const FakePrayersWidget({super.key});

  @override
  State<FakePrayersWidget> createState() => _FakePrayersWidgetState();
}

class _FakePrayersWidgetState extends State<FakePrayersWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Fake Prayers Widget: counter = $counter'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
