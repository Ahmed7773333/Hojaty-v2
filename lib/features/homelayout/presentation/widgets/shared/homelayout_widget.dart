import 'package:flutter/material.dart';

class FakeHomelayoutWidget extends StatefulWidget {
  const FakeHomelayoutWidget({super.key});

  @override
  State<FakeHomelayoutWidget> createState() => _FakeHomelayoutWidgetState();
}

class _FakeHomelayoutWidgetState extends State<FakeHomelayoutWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Fake Homelayout Widget: counter = \$counter'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
