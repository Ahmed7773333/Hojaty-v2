import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final Color? color;
  final Color? backgroundColor;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? context.colors.primary,
      backgroundColor: backgroundColor ?? Colors.white,
      strokeWidth: 2.5,
      child: child,
    );
  }
}
