// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistItemAdapter extends TypeAdapter<PlaylistItem> {
  @override
  final int typeId = 10;

  @override
  PlaylistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistItem(
      surahId: fields[0] as int,
      surahNameAr: fields[1] as String,
      surahNameEn: fields[2] as String,
      reciterName: fields[3] as String,
      reciterLetter: fields[4] as String,
      serverUrl: fields[5] as String,
      reciterId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.surahId)
      ..writeByte(1)
      ..write(obj.surahNameAr)
      ..writeByte(2)
      ..write(obj.surahNameEn)
      ..writeByte(3)
      ..write(obj.reciterName)
      ..writeByte(4)
      ..write(obj.reciterLetter)
      ..writeByte(5)
      ..write(obj.serverUrl)
      ..writeByte(6)
      ..write(obj.reciterId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
