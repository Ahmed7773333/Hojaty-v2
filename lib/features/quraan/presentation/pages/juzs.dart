import 'package:flutter/material.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../widgets/hezb_card.dart';

class Guzs extends StatefulWidget {
  const Guzs({super.key});

  @override
  State<Guzs> createState() => _GuzsState();
}

class _GuzsState extends State<Guzs> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 30,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (context, index) =>
              HizbCard(index: index, animation: _animation),
        ),
      ),
    );
  }
}
