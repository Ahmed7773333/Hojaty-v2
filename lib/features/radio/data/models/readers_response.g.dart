// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readers_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadersResponseModelAdapter extends TypeAdapter<ReadersResponseModel> {
  @override
  final int typeId = 1;

  @override
  ReadersResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadersResponseModel(
      reciters: (fields[0] as List?)?.cast<Reciters>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReadersResponseModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.reciters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadersResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecitersAdapter extends TypeAdapter<Reciters> {
  @override
  final int typeId = 2;

  @override
  Reciters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reciters(
      id: fields[0] as int?,
      name: fields[1] as String?,
      letter: fields[2] as String?,
      moshaf: (fields[3] as List?)?.cast<Moshaf>(),
    );
  }

  @override
  void write(BinaryWriter writer, Reciters obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.letter)
      ..writeByte(3)
      ..write(obj.moshaf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecitersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoshafAdapter extends TypeAdapter<Moshaf> {
  @override
  final int typeId = 3;

  @override
  Moshaf read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Moshaf(
      id: fields[0] as int?,
      name: fields[1] as String?,
      server: fields[2] as String?,
      surahTotal: fields[3] as int?,
      moshafType: fields[4] as int?,
      surahList: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Moshaf obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.server)
      ..writeByte(3)
      ..write(obj.surahTotal)
      ..writeByte(4)
      ..write(obj.moshafType)
      ..writeByte(5)
      ..write(obj.surahList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoshafAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
