import 'package:json_annotation/json_annotation.dart';

part 'nota.g.dart';

@JsonSerializable()
class Nota {
  final String id;
  final String nombre;
  final double valor;
  final double peso;
  final DateTime fecha;

  Nota({
    required this.id,
    required this.nombre,
    required this.valor,
    required this.peso,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();

  factory Nota.fromJson(Map<String, dynamic> json) => _$NotaFromJson(json);
  Map<String, dynamic> toJson() => _$NotaToJson(this);
}
