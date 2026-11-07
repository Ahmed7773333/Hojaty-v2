import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayers_helper.dart';

class HomePrayerProgressWidget extends StatefulWidget {
  final DateTime previousTime;
  final DateTime nextTime;

  const HomePrayerProgressWidget({
    super.key,
    required this.previousTime,
    required this.nextTime,
  });

  @override
  State<HomePrayerProgressWidget> createState() =>
      _HomePrayerProgressWidgetState();
}

class _HomePrayerProgressWidgetState extends State<HomePrayerProgressWidget> {
  Timer? _timer;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _recalculateProgress();
  }

  void _recalculateProgress() {
    _progress = PrayersHelper.calculatePrayerProgress(
      now: DateTime.now(),
      previousTime: widget.previousTime,
      nextTime: widget.nextTime,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isTickerActive = TickerMode.of(context);
    if (!isTickerActive) {
      _timer?.cancel();
      _timer = null;
    } else if (_timer == null) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (!mounted || !TickerMode.of(context)) return;

    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!mounted) return;
      setState(() {
        _recalculateProgress();
      });
    });
  }

  @override
  void didUpdateWidget(covariant HomePrayerProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.previousTime != widget.previousTime ||
        oldWidget.nextTime != widget.nextTime) {
      _recalculateProgress();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: SizedBox(
          height: 4.h,
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.primaryDarkSurface,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.accentGold,
            ),
          ),
        ),
      ),
    );
  }
}

