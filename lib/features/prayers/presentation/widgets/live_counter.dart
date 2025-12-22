import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/prayers/live_time_helper.dart';

/// LiveTimeSince shows elapsed since start or a countdown to end when start is missing.
class LiveTimerDisplay extends StatefulWidget {
  final TimerDb? timer;
  final DateTime? start;
  final DateTime? end;
  final LiveTimeFormat? format;
  final Duration? tickInterval;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;

  const LiveTimerDisplay({
    super.key,
    this.timer,
    this.start,
    this.end,
    this.format,
    this.tickInterval,
    this.style,
    this.prefix,
    this.suffix,
  }) : assert(
         timer != null || start != null || end != null,
         'Either timer, start or end must be provided',
       );

  @override
  State<LiveTimerDisplay> createState() => _LiveTimerDisplayState();
}

class _LiveTimerDisplayState extends State<LiveTimerDisplay> {
  Timer? _timer;
  late DateTime _now;

  DateTime? get _start {
    if (widget.start != null) return widget.start;
    if (widget.timer != null) return widget.timer!.sinceWhen;
    return null;
  }

  DateTime? get _end {
    if (widget.end != null) return widget.end;
    if (widget.timer != null) return widget.timer!.end;
    return null;
  }

  LiveTimeFormat get _format {
    if (widget.format != null) return widget.format!;
    if (widget.timer != null) return widget.timer!.formatEnum;
    return LiveTimeFormat.verbose;
  }

  Duration get _tickInterval {
    if (widget.tickInterval != null) return widget.tickInterval!;
    if (widget.timer?.tickInterval != null) return widget.timer!.tickInterval!;
    return const Duration(seconds: 1);
  }

  bool get _isStaticElapsed => (_start != null) && (_end != null);
  // bool get _isCountingElapsed => (_start != null) && (_end == null);
  bool get _isCountdown => (_start == null) && (_end != null);

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _setupTimerIfNeeded();
  }

  void _setupTimerIfNeeded() {
    _timer?.cancel();

    if (_isStaticElapsed) {
      _now = DateTime.now();
      return;
    }

    _timer = Timer.periodic(_tickInterval, (_) {
      if (!mounted) return;

      final oldNow = _now;
      _now = DateTime.now();

      if (_isCountdown) {
        final remaining = _end!.difference(_now);
        // If remaining time went from positive to negative, force a refresh on the parent
        if (remaining.isNegative && !oldNow.isAfter(_end!)) {
          _timer?.cancel();
          // In the NextPrayerCard, hitting '0' means we should call the parent's onDone/reload.
          // Since we don't have access to the parent's callback here, the parent must watch for this state.
        }
      }

      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant LiveTimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool shouldRecreateTimer =
        oldWidget.timer != widget.timer ||
        oldWidget.start != widget.start ||
        oldWidget.end != widget.end ||
        oldWidget.format != widget.format ||
        oldWidget.tickInterval != widget.tickInterval;

    if (shouldRecreateTimer) {
      _setupTimerIfNeeded();
      if (mounted) setState(() => _now = DateTime.now());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If we have a start -> show elapsed
    if (_start != null) {
      final end = _end ?? _now;
      final elapsed = end.difference(_start!);
      final text = TimerDb.formatDuration(elapsed, _format);
      final display = '${widget.prefix ?? ''}$text${widget.suffix ?? ''}';
      return Text(display, style: widget.style, maxLines: 3);
    }

    // If no start but we have an end -> countdown mode
    if (_end != null) {
      final remaining = _end!.difference(_now);

      if (remaining.inSeconds <= 0) {
        // If countdown finished
        return Text('حان الآن', style: widget.style, maxLines: 1);
      }

      final remainingNonNeg = remaining;
      final text = TimerDb.formatDuration(remainingNonNeg, _format);
      final display = '${widget.prefix ?? ''}$text${widget.suffix ?? ''}';
      return Text(display, style: widget.style, maxLines: 3);
    }

    // fallback: nothing to show
    return Text('-', style: widget.style);
  }
}
