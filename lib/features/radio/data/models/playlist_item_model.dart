import 'package:equatable/equatable.dart';

class PlaylistItemModel extends Equatable {
  final int surahId;
  final String surahNameAr;
  final String surahNameEn;
  final String reciterName;
  final String reciterLetter;
  final String serverUrl;
  final String? reciterId;

  const PlaylistItemModel({
    required this.surahId,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.reciterName,
    required this.reciterLetter,
    required this.serverUrl,
    this.reciterId,
  });

  factory PlaylistItemModel.fromJson(Map<String, dynamic> json) {
    return PlaylistItemModel(
      surahId: json['surahId'] as int? ?? 0,
      surahNameAr: json['surahNameAr'] as String? ?? '',
      surahNameEn: json['surahNameEn'] as String? ?? '',
      reciterName: json['reciterName'] as String? ?? '',
      reciterLetter: json['reciterLetter'] as String? ?? '',
      serverUrl: json['serverUrl'] as String? ?? '',
      reciterId: json['reciterId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahId': surahId,
      'surahNameAr': surahNameAr,
      'surahNameEn': surahNameEn,
      'reciterName': reciterName,
      'reciterLetter': reciterLetter,
      'serverUrl': serverUrl,
      'reciterId': reciterId,
    };
  }

  PlaylistItemModel copyWith({
    int? surahId,
    String? surahNameAr,
    String? surahNameEn,
    String? reciterName,
    String? reciterLetter,
    String? serverUrl,
    String? reciterId,
  }) {
    return PlaylistItemModel(
      surahId: surahId ?? this.surahId,
      surahNameAr: surahNameAr ?? this.surahNameAr,
      surahNameEn: surahNameEn ?? this.surahNameEn,
      reciterName: reciterName ?? this.reciterName,
      reciterLetter: reciterLetter ?? this.reciterLetter,
      serverUrl: serverUrl ?? this.serverUrl,
      reciterId: reciterId ?? this.reciterId,
    );
  }

  @override
  List<Object?> get props => [
        surahId,
        surahNameAr,
        surahNameEn,
        reciterName,
        reciterLetter,
        serverUrl,
        reciterId,
      ];
}

