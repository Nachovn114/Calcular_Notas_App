import 'package:json_annotation/json_annotation.dart';
import 'nota.dart';

part 'asignatura.g.dart';

@JsonSerializable()
class Asignatura {
  final String id;
  final String nombre;
  final List<Nota> notas;
  final double notaDeseada;

  Asignatura({
    required this.id,
    required this.nombre,
    List<Nota>? notas,
    this.notaDeseada = 4.0,
  }) : notas = notas ?? [];

  double get promedio {
    if (notas.isEmpty) return 0.0;
    double sumaNotas = 0.0;
    double sumaPesos = 0.0;

    for (var nota in notas) {
      sumaNotas += nota.valor * (nota.peso / 100);
      sumaPesos += nota.peso / 100;
    }

    return sumaPesos > 0 ? sumaNotas / sumaPesos : 0.0;
  }

  double get progreso {
    if (notas.isEmpty) return 0.0;
    double sumaPesos = 0.0;

    for (var nota in notas) {
      sumaPesos += nota.peso;
    }

    return sumaPesos / 100;
  }

  factory Asignatura.fromJson(Map<String, dynamic> json) =>
      _$AsignaturaFromJson(json);
  Map<String, dynamic> toJson() => _$AsignaturaToJson(this);
}
