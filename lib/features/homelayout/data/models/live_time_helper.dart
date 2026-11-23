enum LiveTimeFormat {
  verbose,
  short,
  timerWithDays,
}

class TimerDb {
  final DateTime sinceWhen;
  final DateTime? end;
  final LiveTimeFormat formatEnum;
  final Duration? tickInterval;

  const TimerDb({
    required this.sinceWhen,
    this.end,
    this.formatEnum = LiveTimeFormat.verbose,
    this.tickInterval,
  });

  static String formatDuration(
    Duration duration,
    LiveTimeFormat format, {
    String lang = 'ar',
  }) {
    final isArabic = lang == 'ar';

    if (format == LiveTimeFormat.short) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final hours = twoDigits(duration.inHours.remainder(24));
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return '$hours:$minutes:$seconds';
    }

    if (format == LiveTimeFormat.timerWithDays) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final days = duration.inDays;
      final hours = twoDigits(duration.inHours.remainder(24));
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      if (days > 0) {
        return '$days ${isArabic ? 'يوم' : 'd'} $hours:$minutes:$seconds';
      }
      return '$hours:$minutes:$seconds';
    }

    // Verbose
    if (duration.inSeconds < 1) {
      return isArabic ? '0 ثواني' : '0 seconds';
    }

    final parts = <String>[];
    if (duration.inDays > 0) {
      parts.add('${duration.inDays} ${isArabic ? 'يوم' : 'd'}');
    }
    if (duration.inHours.remainder(24) > 0 || parts.isNotEmpty) {
      parts.add('${duration.inHours.remainder(24)} ${isArabic ? 'ساعة' : 'h'}');
    }
    if (duration.inMinutes.remainder(60) > 0 || parts.isNotEmpty) {
      parts.add('${duration.inMinutes.remainder(60)} ${isArabic ? 'دقيقة' : 'm'}');
    }
    if (duration.inSeconds.remainder(60) > 0 && parts.length < 2) {
      parts.add('${duration.inSeconds.remainder(60)} ${isArabic ? 'ثانية' : 's'}');
    }

    return parts.take(3).join(', ');
  }
}
