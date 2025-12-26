import 'package:hive_flutter/hive_flutter.dart';

class PageData {
  final bool? hasBesmALLAH;
  final int? numberOfBesmALLAH;
  final List<String>? versesContent;
  final List<int>? versesNumbers;
  final List<String>? surahsNames;
  final bool? hasHead;
  final bool? hasQurater;
  final bool? isFateha;
  final String? quarterName;
  final String? juzName;
  final int? numberOfHeads;
  final int? pageNumber;
  final int? juzNumber;
  final int? rubNumber;
  final int? rubAya;
  final List<int>? surahsNumber;
  final List<String>? versesContentEmaly;
  final List<String>? tafseer;
  final List<int>? lineEnds;
  final List<int>? lineStarts;

  PageData({
    this.hasBesmALLAH,
    this.numberOfBesmALLAH,
    this.versesContent,
    this.versesNumbers,
    this.surahsNames,
    this.hasHead,
    this.hasQurater,
    this.isFateha,
    this.quarterName,
    this.juzName,
    this.numberOfHeads,
    this.pageNumber,
    this.juzNumber,
    this.rubNumber,
    this.rubAya,
    this.surahsNumber,
    this.versesContentEmaly,
    this.tafseer,
    this.lineEnds,
    this.lineStarts,
  });

  factory PageData.fromJson(Map<dynamic, dynamic> json) {
    return PageData(
      hasBesmALLAH: json['hasBesmALLAH'] as bool?,
      numberOfBesmALLAH: json['numberOfBesmALLAH'] as int?,
      versesContent: (json['versesContent'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      versesNumbers: (json['versesNumbers'] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
      surahsNames: (json['surahsNames'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      hasHead: json['hasHead'] as bool?,
      hasQurater: json['hasQurater'] as bool?,
      isFateha: json['isFateha'] as bool?,
      quarterName: json['quarterName'] as String?,
      juzName: json['juzName'] as String?,
      numberOfHeads: json['numberOfHeads'] as int?,
      pageNumber: json['pageNumber'] as int?,
      juzNumber: json['juzNumber'] as int?,
      rubNumber: json['rubNumber'] as int?,
      rubAya: json['rubAya'] as int?,
      surahsNumber: (json['surahsNumber'] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
      versesContentEmaly: (json['versesContentEmaly'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      tafseer: (json['tafseer'] as List?)?.map((e) => e.toString()).toList(),
      lineEnds: (json['lineEnds'] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
      lineStarts: (json['lineStarts'] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
    );
  }
}

class PageDataAdapter extends TypeAdapter<PageData> {
  @override
  final int typeId = 1;

  @override
  PageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageData(
      hasBesmALLAH: fields[0] as bool?,
      numberOfBesmALLAH: fields[1] as int?,
      versesContent: (fields[2] as List?)?.cast<String>(),
      versesNumbers: (fields[3] as List?)?.cast<int>(),
      surahsNames: (fields[4] as List?)?.cast<String>(),
      hasHead: fields[5] as bool?,
      hasQurater: fields[6] as bool?,
      isFateha: fields[7] as bool?,
      quarterName: fields[8] as String?,
      juzName: fields[9] as String?,
      numberOfHeads: fields[10] as int?,
      pageNumber: fields[11] as int?,
      juzNumber: fields[12] as int?,
      rubNumber: fields[13] as int?,
      rubAya: fields[14] as int?,
      surahsNumber: (fields[15] as List?)?.cast<int>(),
      versesContentEmaly: (fields[16] as List?)?.cast<String>(),
      tafseer: (fields[17] as List?)?.cast<String>(),
      lineEnds: (fields[18] as List?)?.cast<int>(),
      lineStarts: (fields[19] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, PageData obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.hasBesmALLAH)
      ..writeByte(1)
      ..write(obj.numberOfBesmALLAH)
      ..writeByte(2)
      ..write(obj.versesContent)
      ..writeByte(3)
      ..write(obj.versesNumbers)
      ..writeByte(4)
      ..write(obj.surahsNames)
      ..writeByte(5)
      ..write(obj.hasHead)
      ..writeByte(6)
      ..write(obj.hasQurater)
      ..writeByte(7)
      ..write(obj.isFateha)
      ..writeByte(8)
      ..write(obj.quarterName)
      ..writeByte(9)
      ..write(obj.juzName)
      ..writeByte(10)
      ..write(obj.numberOfHeads)
      ..writeByte(11)
      ..write(obj.pageNumber)
      ..writeByte(12)
      ..write(obj.juzNumber)
      ..writeByte(13)
      ..write(obj.rubNumber)
      ..writeByte(14)
      ..write(obj.rubAya)
      ..writeByte(15)
      ..write(obj.surahsNumber)
      ..writeByte(16)
      ..write(obj.versesContentEmaly)
      ..writeByte(17)
      ..write(obj.tafseer)
      ..writeByte(18)
      ..write(obj.lineEnds)
      ..writeByte(19)
      ..write(obj.lineStarts);
  }
}
