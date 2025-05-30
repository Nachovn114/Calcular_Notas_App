import 'package:hive/hive.dart';

part 'nota.g.dart';

@HiveType(typeId: 1)
class Nota extends HiveObject {
  static const double NOTA_MINIMA = 1.0;
  static const double NOTA_MAXIMA = 7.0;
  static const double PONDERACION_MINIMA = 0.0;
  static const double PONDERACION_MAXIMA = 100.0;

  @HiveField(0)
  final double valor;

  @HiveField(1)
  final double ponderacion;

  @HiveField(2)
  final String descripcion;

  @HiveField(3)
  final DateTime fecha;

  Nota({
    required this.valor,
    required this.ponderacion,
    required this.descripcion,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now() {
    if (!esNotaValida(valor)) {
      throw Exception(
          'La nota debe estar entre ${NOTA_MINIMA.toStringAsFixed(1)} y ${NOTA_MAXIMA.toStringAsFixed(1)}');
    }
    if (!esPonderacionValida(ponderacion)) {
      throw Exception(
          'La ponderación debe estar entre ${PONDERACION_MINIMA.toStringAsFixed(1)}% y ${PONDERACION_MAXIMA.toStringAsFixed(1)}%');
    }
  }

  static bool esNotaValida(double nota) {
    return nota >= NOTA_MINIMA && nota <= NOTA_MAXIMA;
  }

  static bool esPonderacionValida(double ponderacion) {
    return ponderacion >= PONDERACION_MINIMA &&
        ponderacion <= PONDERACION_MAXIMA;
  }

  Map<String, dynamic> toJson() => {
        'valor': valor,
        'ponderacion': ponderacion,
        'descripcion': descripcion,
        'fecha': fecha.toIso8601String(),
      };

  factory Nota.fromJson(Map<String, dynamic> json) => Nota(
        valor: json['valor'] as double,
        ponderacion: json['ponderacion'] as double,
        descripcion: json['descripcion'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
      );
}
