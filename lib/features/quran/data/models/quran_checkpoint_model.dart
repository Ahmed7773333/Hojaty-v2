import 'package:hive/hive.dart';

class QuranCheckpointModel {
  final String surahName;
  final int verseNumber;
  final String verseContent;
  final String verseContentEmaly;
  final int pageNumber;
  final int verseIndex;
  final DateTime createdAt;
  final String? tafseer;

  const QuranCheckpointModel({
    required this.surahName,
    required this.verseNumber,
    required this.verseContent,
    required this.verseContentEmaly,
    required this.pageNumber,
    required this.verseIndex,
    required this.createdAt,
    this.tafseer,
  });

  String get id => '${pageNumber}_$verseIndex';
}

class QuranCheckpointModelAdapter
    extends TypeAdapter<QuranCheckpointModel> {
  @override
  final int typeId = 6;

  @override
  QuranCheckpointModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranCheckpointModel(
      surahName: fields[0] as String? ?? '',
      verseNumber: fields[1] as int? ?? 1,
      verseContent: fields[2] as String? ?? '',
      verseContentEmaly: fields[3] as String? ?? '',
      pageNumber: fields[4] as int? ?? 1,
      verseIndex: fields[5] as int? ?? 0,
      createdAt: fields[6] is DateTime
          ? fields[6] as DateTime
          : (fields[6] is String
              ? DateTime.tryParse(fields[6] as String) ?? DateTime.now()
              : DateTime.now()),
      tafseer: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuranCheckpointModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.surahName)
      ..writeByte(1)
      ..write(obj.verseNumber)
      ..writeByte(2)
      ..write(obj.verseContent)
      ..writeByte(3)
      ..write(obj.verseContentEmaly)
      ..writeByte(4)
      ..write(obj.pageNumber)
      ..writeByte(5)
      ..write(obj.verseIndex)
      ..writeByte(6)
      ..write(obj.createdAt.toIso8601String())
      ..writeByte(7)
      ..write(obj.tafseer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranCheckpointModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

