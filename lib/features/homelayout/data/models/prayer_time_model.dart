import 'package:equatable/equatable.dart';

enum PrayerType {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha,
}

class PrayerTimeModel extends Equatable {
  final PrayerType type;
  final String time;
  final DateTime? dateTime;
  final bool isNotificationEnabled;
  final bool isCurrent;
  final bool isNext;
  final String startWindow;
  final String endWindow;

  const PrayerTimeModel({
    required this.type,
    required this.time,
    this.dateTime,
    this.isNotificationEnabled = true,
    this.isCurrent = false,
    this.isNext = false,
    required this.startWindow,
    required this.endWindow,
  });

  PrayerTimeModel copyWith({
    PrayerType? type,
    String? time,
    DateTime? dateTime,
    bool? isNotificationEnabled,
    bool? isCurrent,
    bool? isNext,
    String? startWindow,
    String? endWindow,
  }) {
    return PrayerTimeModel(
      type: type ?? this.type,
      time: time ?? this.time,
      dateTime: dateTime ?? this.dateTime,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      isCurrent: isCurrent ?? this.isCurrent,
      isNext: isNext ?? this.isNext,
      startWindow: startWindow ?? this.startWindow,
      endWindow: endWindow ?? this.endWindow,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'time': time,
      'dateTime': dateTime?.toIso8601String(),
      'isNotificationEnabled': isNotificationEnabled,
      'isCurrent': isCurrent,
      'isNext': isNext,
      'startWindow': startWindow,
      'endWindow': endWindow,
    };
  }

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      type: PrayerType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PrayerType.fajr,
      ),
      time: json['time'] as String? ?? '',
      dateTime: json['dateTime'] != null
          ? DateTime.tryParse(json['dateTime'] as String)
          : null,
      isNotificationEnabled: json['isNotificationEnabled'] as bool? ?? true,
      isCurrent: json['isCurrent'] as bool? ?? false,
      isNext: json['isNext'] as bool? ?? false,
      startWindow: json['startWindow'] as String? ?? '',
      endWindow: json['endWindow'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        type,
        time,
        dateTime,
        isNotificationEnabled,
        isCurrent,
        isNext,
        startWindow,
        endWindow,
      ];
}

// =========================================================================
// ARCHIVED ORIGINAL PRAYER TIME MODEL
// =========================================================================
// class PrayerTimeModel extends Equatable {
//   final PrayerType type;
//   final String time;
//   final bool isNotificationEnabled;
//   final bool isCurrent;
//   final bool isNext;
//   final String startWindow;
//   final String endWindow;
//
//   const PrayerTimeModel({
//     required this.type,
//     required this.time,
//     this.isNotificationEnabled = true,
//     this.isCurrent = false,
//     this.isNext = false,
//     required this.startWindow,
//     required this.endWindow,
//   });
//   ...
// }
