import 'package:equatable/equatable.dart';

enum OccasionIconType {
  prophetBirthday,
  sheep,
  calendar,
  sparkle,
}

class OccasionItemModel extends Equatable {
  final String id;
  final String title;
  final String gregorianDate;
  final String hijriDate;
  final int daysRemaining;
  final String description;
  final OccasionIconType iconType;
  final DateTime? targetDateTime;
  final int hijriMonth;
  final int hijriDay;
  final int hijriYear;

  const OccasionItemModel({
    required this.id,
    required this.title,
    required this.gregorianDate,
    required this.hijriDate,
    required this.daysRemaining,
    required this.description,
    required this.iconType,
    this.targetDateTime,
    this.hijriMonth = 1,
    this.hijriDay = 1,
    this.hijriYear = 1448,
  });

  OccasionItemModel copyWith({
    String? id,
    String? title,
    String? gregorianDate,
    String? hijriDate,
    int? daysRemaining,
    String? description,
    OccasionIconType? iconType,
    DateTime? targetDateTime,
    int? hijriMonth,
    int? hijriDay,
    int? hijriYear,
  }) {
    return OccasionItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      gregorianDate: gregorianDate ?? this.gregorianDate,
      hijriDate: hijriDate ?? this.hijriDate,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      description: description ?? this.description,
      iconType: iconType ?? this.iconType,
      targetDateTime: targetDateTime ?? this.targetDateTime,
      hijriMonth: hijriMonth ?? this.hijriMonth,
      hijriDay: hijriDay ?? this.hijriDay,
      hijriYear: hijriYear ?? this.hijriYear,
    );
  }

  factory OccasionItemModel.fromJson(Map<String, dynamic> json) {
    OccasionIconType parseIcon(String? type) {
      switch (type) {
        case 'prophetBirthday':
          return OccasionIconType.prophetBirthday;
        case 'sheep':
          return OccasionIconType.sheep;
        case 'calendar':
          return OccasionIconType.calendar;
        case 'sparkle':
        default:
          return OccasionIconType.sparkle;
      }
    }

    return OccasionItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      gregorianDate: json['gregorianDate'] as String? ?? '',
      hijriDate: json['hijriDate'] as String? ?? '',
      daysRemaining: (json['daysRemaining'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      iconType: parseIcon(json['iconType'] as String?),
      targetDateTime: json['targetDateTime'] != null
          ? DateTime.tryParse(json['targetDateTime'] as String)
          : null,
      hijriMonth: (json['hijriMonth'] as num?)?.toInt() ?? 1,
      hijriDay: (json['hijriDay'] as num?)?.toInt() ?? 1,
      hijriYear: (json['hijriYear'] as num?)?.toInt() ?? 1448,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'gregorianDate': gregorianDate,
      'hijriDate': hijriDate,
      'daysRemaining': daysRemaining,
      'description': description,
      'iconType': iconType.name,
      'targetDateTime': targetDateTime?.toIso8601String(),
      'hijriMonth': hijriMonth,
      'hijriDay': hijriDay,
      'hijriYear': hijriYear,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        gregorianDate,
        hijriDate,
        daysRemaining,
        description,
        iconType,
        targetDateTime,
        hijriMonth,
        hijriDay,
        hijriYear,
      ];
}

// =========================================================================
// ARCHIVED PREVIOUS OCCASION ITEM MODEL
// =========================================================================
// class OccasionItemModel extends Equatable {
//   final String id;
//   final String title;
//   final String gregorianDate;
//   final String hijriDate;
//   final int daysRemaining;
//   final String description;
//   final OccasionIconType iconType;
//
//   const OccasionItemModel({
//     required this.id,
//     required this.title,
//     required this.gregorianDate,
//     required this.hijriDate,
//     required this.daysRemaining,
//     required this.description,
//     required this.iconType,
//   });
//
//   @override
//   List<Object?> get props => [
//         id,
//         title,
//         gregorianDate,
//         hijriDate,
//         daysRemaining,
//         description,
//         iconType,
//       ];
// }
