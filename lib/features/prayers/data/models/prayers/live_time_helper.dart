
import '../../../../../core/utils/extensions/strings_extensions.dart';

enum LiveTimeFormat {
  verbose, // e.g., 2 hours, 30 minutes, 15 seconds
  short, // e.g., 02:30:15
}

class TimerDb {
  final DateTime sinceWhen;
  final DateTime? end;
  final LiveTimeFormat formatEnum;
  final Duration? tickInterval;

  TimerDb({
    required this.sinceWhen,
    this.end,
    this.formatEnum = LiveTimeFormat.verbose,
    this.tickInterval,
  });

  static String formatDuration(Duration duration, LiveTimeFormat format) {
    if (format == LiveTimeFormat.short) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      String hours = twoDigits(duration.inHours);
      return "$hours:$twoDigitMinutes:$twoDigitSeconds";
    }

    // Default to verbose format (Used for the NextPrayerCard)
    if (duration.inSeconds < 1) {
      return '0 ثواني';
    }

    final parts = <String>[];
    if (duration.inDays > 0) {
      parts.add('${duration.inDays} يوم');
    }
    if (duration.inHours.remainder(24) > 0 || parts.isNotEmpty) {
      parts.add('${duration.inHours.remainder(24)} ساعة');
    }
    if (duration.inMinutes.remainder(60) > 0 || parts.isNotEmpty) {
      parts.add('${duration.inMinutes.remainder(60)} دقيقة');
    }
    if (duration.inSeconds.remainder(60) > 0 || parts.isNotEmpty) {
      parts.add('${duration.inSeconds.remainder(60)} ثانية');
    }

    // Return the parts for readability
    return parts.take(3).join(', ').toArabicDigits();
  }
}
