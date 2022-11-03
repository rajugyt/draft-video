// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draftvideo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraftVideoModelAdapter extends TypeAdapter<DraftVideoModel> {
  @override
  final int typeId = 0;

  @override
  DraftVideoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraftVideoModel(
      description: fields[0] as String?,
      videoFilePath: fields[1] as String?,
      videoThumbnail: fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, DraftVideoModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.videoFilePath)
      ..writeByte(2)
      ..write(obj.videoThumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftVideoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
