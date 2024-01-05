// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountCategoryAdapter extends TypeAdapter<AccountCategory> {
  @override
  final int typeId = 2;

  @override
  AccountCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountCategory(
      id: fields[0] as int,
      categoryName: fields[2] as String,
      type: fields[3] as int,
    )
      ..iconid = fields[1] as int?
      ..isDeleted = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, AccountCategory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.iconid)
      ..writeByte(2)
      ..write(obj.categoryName)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
