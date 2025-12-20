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

    final double? lat = fields[0] as double?;
    final double? lng = fields[1] as double?;

    return User(
      lastKnownLocation: (lat != null && lng != null)
          ? Coordinates(lat, lng)
          : null,
      cityName: fields[2] as String?,
      themeMode: ThemeMode.values[(fields[3] as int?) ?? 0],
      isEnglish: fields[4] as bool?,
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
