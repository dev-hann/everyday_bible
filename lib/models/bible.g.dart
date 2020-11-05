// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BibleAdapter extends TypeAdapter<Bible> {
  @override
  final int typeId = 0;

  @override
  Bible read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bible(
      title: fields[3] as String,
      audio: fields[2] as String,
      gospel: (fields[1] as Map)?.cast<int, String>(),
      subTitle: fields[4] as String,
      dateTime: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Bible obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.gospel)
      ..writeByte(2)
      ..write(obj.audio)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.subTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
