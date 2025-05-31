// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asignatura.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asignatura _$AsignaturaFromJson(Map<String, dynamic> json) => Asignatura(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      notas: (json['notas'] as List<dynamic>?)
          ?.map((e) => Nota.fromJson(e as Map<String, dynamic>))
          .toList(),
      notaDeseada: (json['notaDeseada'] as num?)?.toDouble() ?? 4.0,
    );

Map<String, dynamic> _$AsignaturaToJson(Asignatura instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'notas': instance.notas,
      'notaDeseada': instance.notaDeseada,
    };
