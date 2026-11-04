// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      id: fields[0] as int?,
      phone: fields[1] as String?,
      firstName: fields[2] as String?,
      secondName: fields[3] as String?,
      name: fields[4] as String?,
      email: fields[5] as String?,
      role: fields[6] as String?,
      createdAt: fields[7] as String?,
      token: fields[8] as String?,
      language: fields[9] as String?,
      image: fields[10] as String?,
      onBoardingCompleted: fields[11] as bool?,
      isVerified: fields[12] as bool?,
      countryId: fields[13] as int?,
      cityId: fields[14] as int?,
      placeRequestsCount: fields[15] as int?,
      approvedRequestsCount: fields[16] as int?,
      rejectedRequestsCount: fields[17] as int?,
      pendingRequestsCount: fields[18] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.secondName)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.token)
      ..writeByte(9)
      ..write(obj.language)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.onBoardingCompleted)
      ..writeByte(12)
      ..write(obj.isVerified)
      ..writeByte(13)
      ..write(obj.countryId)
      ..writeByte(14)
      ..write(obj.cityId)
      ..writeByte(15)
      ..write(obj.placeRequestsCount)
      ..writeByte(16)
      ..write(obj.approvedRequestsCount)
      ..writeByte(17)
      ..write(obj.rejectedRequestsCount)
      ..writeByte(18)
      ..write(obj.pendingRequestsCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
