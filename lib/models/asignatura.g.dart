// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asignatura.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AsignaturaAdapter extends TypeAdapter<Asignatura> {
  @override
  final int typeId = 0;

  @override
  Asignatura read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Asignatura(
      nombre: fields[0] as String,
      notas: (fields[1] as List?)?.cast<Nota>(),
    )
      ..promedioActual = fields[2] as double
      ..ponderacionAcumulada = fields[3] as double;
  }

  @override
  void write(BinaryWriter writer, Asignatura obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.notas)
      ..writeByte(2)
      ..write(obj.promedioActual)
      ..writeByte(3)
      ..write(obj.ponderacionAcumulada);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsignaturaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
