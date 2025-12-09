// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_db.dart';

// ***************************************************************************
// TypeAdapterGenerator
// ***************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final field_0 = fields[0];
    final field_1 = fields[1];
    final field_2 = fields[2];
    final field_3 = fields[3];
    final field_4 = fields[4];

    return User(
      lastKnownLocation:
          Coordinates(([field_0] as double?) ?? 0, ([field_1] as double?) ?? 0),
      cityName: [field_2] as String?,
      themeMode: ThemeMode.values[(field_3 as int?) ?? 0],
      isEnglish: field_4 as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.lastKnownLocation?.latitude)
      ..writeByte(1)
      ..write(obj.lastKnownLocation?.longitude)
      ..writeByte(2)
      ..write(obj.cityName)
      ..writeByte(3)
      ..write(obj.themeMode?.index)
      ..writeByte(4)
      ..write(obj.isEnglish);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
