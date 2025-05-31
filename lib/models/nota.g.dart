// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nota _$NotaFromJson(Map<String, dynamic> json) => Nota(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      valor: (json['valor'] as num).toDouble(),
      peso: (json['peso'] as num).toDouble(),
      fecha: json['fecha'] == null
          ? null
          : DateTime.parse(json['fecha'] as String),
    );

Map<String, dynamic> _$NotaToJson(Nota instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'valor': instance.valor,
      'peso': instance.peso,
      'fecha': instance.fecha.toIso8601String(),
    };
