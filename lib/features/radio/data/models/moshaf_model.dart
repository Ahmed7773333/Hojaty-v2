import 'package:equatable/equatable.dart';

class MoshafModel extends Equatable {
  final int? id;
  final String? name;
  final String? server;
  final int? surahTotal;
  final int? moshafType;
  final String? surahList;

  const MoshafModel({
    this.id,
    this.name,
    this.server,
    this.surahTotal,
    this.moshafType,
    this.surahList,
  });

  factory MoshafModel.fromJson(Map<String, dynamic> json) {
    return MoshafModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      server: json['server'] as String?,
      surahTotal: json['surah_total'] as int?,
      moshafType: json['moshaf_type'] as int?,
      surahList: json['surah_list'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'server': server,
      'surah_total': surahTotal,
      'moshaf_type': moshafType,
      'surah_list': surahList,
    };
  }

  MoshafModel copyWith({
    int? id,
    String? name,
    String? server,
    int? surahTotal,
    int? moshafType,
    String? surahList,
  }) {
    return MoshafModel(
      id: id ?? this.id,
      name: name ?? this.name,
      server: server ?? this.server,
      surahTotal: surahTotal ?? this.surahTotal,
      moshafType: moshafType ?? this.moshafType,
      surahList: surahList ?? this.surahList,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        server,
        surahTotal,
        moshafType,
        surahList,
      ];
}

