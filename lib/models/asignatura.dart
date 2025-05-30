import 'package:hive/hive.dart';
import 'nota.dart';

part 'asignatura.g.dart';

@HiveType(typeId: 0)
class Asignatura extends HiveObject {
  static const double PONDERACION_MAXIMA_NOTAS = 60.0;
  static const double PONDERACION_EXAMEN = 40.0;
  static const double NOTA_MINIMA_APROBACION = 4.0;
  static const double NOTA_MAXIMA = 7.0;

  @HiveField(0)
  final String nombre;

  @HiveField(1)
  final List<Nota> notas;

  @HiveField(2)
  double promedioActual;

  @HiveField(3)
  double ponderacionAcumulada;

  Asignatura({
    required this.nombre,
    List<Nota>? notas,
  })  : notas = notas ?? [],
        promedioActual = 0.0,
        ponderacionAcumulada = 0.0 {
    _calcularPromedio();
  }

  void agregarNota(Nota nota) {
    // Validar que la suma de ponderaciones internas no supere el 100%
    double nuevaPonderacionInterna = 0.0;
    for (var n in notas) {
      nuevaPonderacionInterna += n.ponderacion;
    }
    nuevaPonderacionInterna += nota.ponderacion;

    if (nuevaPonderacionInterna > 100.0) {
      throw Exception(
          'La suma de ponderaciones internas no puede superar el 100%');
    }

    notas.add(nota);
    _calcularPromedio();
  }

  void eliminarNota(Nota nota) {
    notas.remove(nota);
    _calcularPromedio();
  }

  void _calcularPromedio() {
    if (notas.isEmpty) {
      promedioActual = 0.0;
      ponderacionAcumulada = 0.0;
      return;
    }

    double sumaPonderada = 0.0;
    ponderacionAcumulada = 0.0;

    // Calcular la suma ponderada y la ponderación total
    for (var nota in notas) {
      sumaPonderada += nota.valor * (nota.ponderacion / 100);
      ponderacionAcumulada += nota.ponderacion;
    }

    // Si la ponderación acumulada es 0, evitar división por cero
    if (ponderacionAcumulada == 0.0) {
      promedioActual = 0.0;
      return;
    }

    // El promedio actual es la suma ponderada (ya normalizada a 100%)
    promedioActual = sumaPonderada;
  }

  double calcularNotaNecesaria() {
    // Validar que las ponderaciones sumen exactamente 100%
    if (ponderacionAcumulada < 100.0) {
      throw Exception(
          'Las ponderaciones deben sumar exactamente 100%. Actual: ${ponderacionAcumulada.toStringAsFixed(1)}%');
    }
    if (ponderacionAcumulada > 100.0) {
      throw Exception(
          'Las ponderaciones no pueden superar el 100%. Actual: ${ponderacionAcumulada.toStringAsFixed(1)}%');
    }

    // Si no hay notas, necesita un 4.0 en el examen
    if (notas.isEmpty) {
      return NOTA_MINIMA_APROBACION;
    }

    // El aporte de las notas parciales al promedio final (60% del total)
    final aporteParciales = promedioActual * (PONDERACION_MAXIMA_NOTAS / 100);

    // Calcular nota necesaria en el examen
    final notaNecesaria =
        (NOTA_MINIMA_APROBACION - aporteParciales) / (PONDERACION_EXAMEN / 100);

    // Validar que la nota necesaria sea posible
    if (notaNecesaria > NOTA_MAXIMA) {
      throw Exception(
          'No es posible aprobar. Necesitarías un ${notaNecesaria.toStringAsFixed(1)} en el examen');
    }

    if (notaNecesaria < 1.0) {
      return 1.0; // La nota mínima posible es 1.0
    }

    // Redondear a un decimal
    return double.parse(notaNecesaria.toStringAsFixed(1));
  }

  String obtenerDetalleCalculo() {
    if (notas.isEmpty) {
      return 'No hay notas ingresadas';
    }

    final buffer = StringBuffer();
    buffer.writeln('Detalle del cálculo:');
    buffer.writeln('\nNotas Parciales (representan el 60% de la nota final):');

    // Mostrar cada nota con su ponderación interna
    for (var nota in notas) {
      buffer.writeln(
          '- ${nota.descripcion}: ${nota.valor.toStringAsFixed(1)} (${nota.ponderacion.toStringAsFixed(1)}% del total de parciales)');
    }

    // Mostrar el cálculo del promedio ponderado de parciales
    buffer.writeln('\nCálculo del promedio ponderado de parciales:');
    double sumaPonderada = 0.0;
    for (var nota in notas) {
      final aporte = nota.valor * (nota.ponderacion / 100);
      buffer.writeln(
          '${nota.valor.toStringAsFixed(1)} × ${(nota.ponderacion / 100).toStringAsFixed(2)} = ${aporte.toStringAsFixed(2)}');
      sumaPonderada += aporte;
    }

    // Mostrar el promedio de parciales y su aporte al promedio final
    buffer.writeln(
        '\nPromedio de parciales: ${promedioActual.toStringAsFixed(2)}');
    final aporteParciales = promedioActual * (PONDERACION_MAXIMA_NOTAS / 100);
    buffer.writeln(
        'Aporte al promedio final (60%): ${aporteParciales.toStringAsFixed(2)}');

    try {
      final notaNecesaria = calcularNotaNecesaria();
      buffer.writeln('\nPara aprobar con 4.0:');
      buffer.writeln(
          'Nota necesaria en examen: ${notaNecesaria.toStringAsFixed(1)}');

      // Mostrar la fórmula completa
      buffer.writeln('\nFórmula completa:');
      buffer.writeln(
          '4.0 = (${promedioActual.toStringAsFixed(2)} × 0.6) + (${notaNecesaria.toStringAsFixed(1)} × 0.4)');
      buffer.writeln(
          '4.0 = ${aporteParciales.toStringAsFixed(2)} + ${(notaNecesaria * 0.4).toStringAsFixed(2)}');

      // Mostrar nota final si se obtiene exactamente la nota necesaria
      final notaFinal = aporteParciales + (notaNecesaria * 0.4);
      buffer.writeln('     = ${notaFinal.toStringAsFixed(2)}');
    } catch (e) {
      buffer.writeln('\n${e.toString()}');
    }

    return buffer.toString();
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'notas': notas.map((nota) => nota.toJson()).toList(),
        'promedioActual': promedioActual,
        'ponderacionAcumulada': ponderacionAcumulada,
      };

  factory Asignatura.fromJson(Map<String, dynamic> json) => Asignatura(
        nombre: json['nombre'] as String,
        notas:
            (json['notas'] as List).map((nota) => Nota.fromJson(nota)).toList(),
      );

  static List<Asignatura> asignaturasPredefinidas() => [
        Asignatura(nombre: 'DESARROLLO ORIENTADO A OBJETOS'),
        Asignatura(nombre: 'DOCTRINA SOCIAL DE LA IGLESIA'),
        Asignatura(nombre: 'INGENIERÍA DE SOFTWARE'),
        Asignatura(nombre: 'BASE DE DATOS APLICADA II'),
        Asignatura(nombre: 'INGLÉS ELEMENTAL II'),
      ];
}
