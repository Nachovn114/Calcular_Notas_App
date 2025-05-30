// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nota.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotaAdapter extends TypeAdapter<Nota> {
  @override
  final int typeId = 1;

  @override
  Nota read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nota(
      valor: fields[0] as double,
      ponderacion: fields[1] as double,
      descripcion: fields[2] as String,
      fecha: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Nota obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.valor)
      ..writeByte(1)
      ..write(obj.ponderacion)
      ..writeByte(2)
      ..write(obj.descripcion)
      ..writeByte(3)
      ..write(obj.fecha);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
