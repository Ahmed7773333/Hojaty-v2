import 'package:hive_flutter/hive_flutter.dart';
part 'readers_response.g.dart';

@HiveType(typeId: 1)
class ReadersResponseModel {
  @HiveField(0)
  List<Reciters>? reciters;

  ReadersResponseModel({this.reciters});

  ReadersResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['reciters'] != null) {
      reciters = <Reciters>[];
      json['reciters'].forEach((v) {
        reciters!.add(Reciters.fromJson(v));
      });
    }
  }
}

@HiveType(typeId: 2)
class Reciters {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? letter;
  @HiveField(3)
  List<Moshaf>? moshaf;

  Reciters({this.id, this.name, this.letter, this.moshaf});

  Reciters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    letter = json['letter'];
    if (json['moshaf'] != null) {
      moshaf = <Moshaf>[];
      json['moshaf'].forEach((v) {
        moshaf!.add(Moshaf.fromJson(v));
      });
    }
  }
}

@HiveType(typeId: 3)
class Moshaf {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? server;
  @HiveField(3)
  int? surahTotal;
  @HiveField(4)
  int? moshafType;
  @HiveField(5)
  String? surahList;

  Moshaf({
    this.id,
    this.name,
    this.server,
    this.surahTotal,
    this.moshafType,
    this.surahList,
  });

  Moshaf.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    server = json['server'];
    surahTotal = json['surah_total'];
    moshafType = json['moshaf_type'];
    surahList = json['surah_list'];
  }
}
