import 'package:equatable/equatable.dart';
import 'hijri_date_model.dart';
import 'next_ramadan_model.dart';

class RamadanCheckData extends Equatable {
  final bool isRamadan;
  final HijriDateModel hijriDate;
  final NextRamadanModel nextRamadan;

  const RamadanCheckData({
    required this.isRamadan,
    required this.hijriDate,
    required this.nextRamadan,
  });

  factory RamadanCheckData.fromJson(Map<String, dynamic> json) {
    return RamadanCheckData(
      isRamadan: json['isRamadan'] as bool? ?? false,
      hijriDate: json['hijriDate'] is Map<String, dynamic>
          ? HijriDateModel.fromJson(json['hijriDate'] as Map<String, dynamic>)
          : HijriDateModel.fallback(language: 'ar'),
      nextRamadan: json['nextRamadan'] is Map<String, dynamic>
          ? NextRamadanModel.fromJson(
              json['nextRamadan'] as Map<String, dynamic>,
            )
          : NextRamadanModel.fallback(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRamadan': isRamadan,
      'hijriDate': hijriDate.toJson(),
      'nextRamadan': nextRamadan.toJson(),
    };
  }

  factory RamadanCheckData.fallback({required String language}) {
    return RamadanCheckData(
      isRamadan: false,
      hijriDate: HijriDateModel.fallback(language: language),
      nextRamadan: NextRamadanModel.fallback(),
    );
  }

  @override
  List<Object?> get props => [isRamadan, hijriDate, nextRamadan];
}

class RamadanCheckResponseModel extends Equatable {
  final String status;
  final String message;
  final RamadanCheckData data;

  const RamadanCheckResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RamadanCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return RamadanCheckResponseModel(
      status: json['status'] as String? ?? 'success',
      message: json['message'] as String? ?? '',
      data: json['data'] is Map<String, dynamic>
          ? RamadanCheckData.fromJson(json['data'] as Map<String, dynamic>)
          : RamadanCheckData.fallback(language: 'ar'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
  factory RamadanCheckResponseModel.fallback({required String language}) {
    return RamadanCheckResponseModel(
      status: 'success',
      message: '',
      data: RamadanCheckData.fallback(language: language),
    );
  }

  @override
  List<Object?> get props => [status, message, data];
}
