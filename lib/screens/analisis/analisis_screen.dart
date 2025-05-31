import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/asignatura.dart';
import '../../providers/asignaturas_provider.dart';
import '../../config/theme.dart';

class AnalisisScreen extends StatelessWidget {
  const AnalisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis Académico'),
        centerTitle: true,
      ),
      body: Consumer<AsignaturasProvider>(
        builder: (context, provider, child) {
          final asignaturas = provider.asignaturas;
          if (asignaturas.isEmpty) {
            return const Center(
              child: Text('Agrega asignaturas para ver el análisis'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PromedioGeneralCard(asignaturas: asignaturas),
                const SizedBox(height: 16),
                _GraficoRendimiento(asignaturas: asignaturas),
                const SizedBox(height: 16),
                _EstadisticasAvanzadas(asignaturas: asignaturas),
                const SizedBox(height: 16),
                _Recomendaciones(asignaturas: asignaturas),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PromedioGeneralCard extends StatelessWidget {
  final List<Asignatura> asignaturas;

  const _PromedioGeneralCard({required this.asignaturas});

  @override
  Widget build(BuildContext context) {
    final promedioGeneral =
        asignaturas.map((a) => a.promedio).reduce((a, b) => a + b) /
            asignaturas.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Promedio General',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              promedioGeneral.toStringAsFixed(1),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.getNotaColor(promedioGeneral),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _getRendimientoMensaje(promedioGeneral),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _getRendimientoMensaje(double promedio) {
    if (promedio >= 6.0) return '¡Excelente rendimiento!';
    if (promedio >= 5.0) return 'Muy buen rendimiento';
    if (promedio >= 4.0) return 'Rendimiento satisfactorio';
    return 'Necesitas mejorar';
  }
}

class _GraficoRendimiento extends StatelessWidget {
  final List<Asignatura> asignaturas;

  const _GraficoRendimiento({required this.asignaturas});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rendimiento por Asignatura',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 7,
                  barGroups: _getBarGroups(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= asignaturas.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              asignaturas[value.toInt()].nombre.substring(0, 3),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return asignaturas.asMap().entries.map((entry) {
      final index = entry.key;
      final asignatura = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: asignatura.promedio,
            color: AppTheme.getNotaColor(asignatura.promedio),
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }
}

class _EstadisticasAvanzadas extends StatelessWidget {
  final List<Asignatura> asignaturas;

  const _EstadisticasAvanzadas({required this.asignaturas});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas Avanzadas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _EstadisticaItem(
              titulo: 'Mejor Asignatura',
              valor: _getMejorAsignatura(),
              icono: Icons.emoji_events,
              color: Colors.amber,
            ),
            const Divider(),
            _EstadisticaItem(
              titulo: 'Asignatura por Mejorar',
              valor: _getPeorAsignatura(),
              icono: Icons.warning_outlined,
              color: Colors.red,
            ),
            const Divider(),
            _EstadisticaItem(
              titulo: 'Progreso General',
              valor: '${(_getProgresoGeneral() * 100).toInt()}%',
              icono: Icons.trending_up,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  String _getMejorAsignatura() {
    if (asignaturas.isEmpty) return 'N/A';
    final mejor = asignaturas.reduce((a, b) => a.promedio > b.promedio ? a : b);
    return '${mejor.nombre} (${mejor.promedio.toStringAsFixed(1)})';
  }

  String _getPeorAsignatura() {
    if (asignaturas.isEmpty) return 'N/A';
    final peor = asignaturas.reduce((a, b) => a.promedio < b.promedio ? a : b);
    return '${peor.nombre} (${peor.promedio.toStringAsFixed(1)})';
  }

  double _getProgresoGeneral() {
    if (asignaturas.isEmpty) return 0;
    return asignaturas.map((a) => a.progreso).reduce((a, b) => a + b) /
        asignaturas.length;
  }
}

class _EstadisticaItem extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _EstadisticaItem({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icono, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  valor,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Recomendaciones extends StatelessWidget {
  final List<Asignatura> asignaturas;

  const _Recomendaciones({required this.asignaturas});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recomendaciones',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._getRecomendaciones(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _getRecomendaciones(BuildContext context) {
    final recomendaciones = <Widget>[];

    // Asignaturas en riesgo
    final asignaturasEnRiesgo =
        asignaturas.where((a) => a.promedio < 4.0).toList();
    if (asignaturasEnRiesgo.isNotEmpty) {
      recomendaciones.add(
        _RecomendacionItem(
          texto:
              'Prioriza las asignaturas: ${asignaturasEnRiesgo.map((a) => a.nombre).join(", ")}',
          subtexto: 'Estas asignaturas necesitan atención inmediata',
        ),
      );
    }

    // Asignaturas incompletas
    final asignaturasIncompletas =
        asignaturas.where((a) => a.progreso < 1.0).toList();
    if (asignaturasIncompletas.isNotEmpty) {
      recomendaciones.add(
        _RecomendacionItem(
          texto: 'Completa las evaluaciones pendientes',
          subtexto: 'Tienes asignaturas con evaluaciones por registrar',
        ),
      );
    }

    // Recomendación general basada en el promedio
    final promedioGeneral = asignaturas.isEmpty
        ? 0.0
        : asignaturas.map((a) => a.promedio).reduce((a, b) => a + b) /
            asignaturas.length;

    if (promedioGeneral < 5.0) {
      recomendaciones.add(
        _RecomendacionItem(
          texto: 'Establece un plan de estudio',
          subtexto: 'Organiza tu tiempo para mejorar tu rendimiento general',
        ),
      );
    }

    if (recomendaciones.isEmpty) {
      recomendaciones.add(
        _RecomendacionItem(
          texto: '¡Excelente trabajo!',
          subtexto: 'Mantén tu buen rendimiento',
        ),
      );
    }

    return recomendaciones;
  }
}

class _RecomendacionItem extends StatelessWidget {
  final String texto;
  final String subtexto;

  const _RecomendacionItem({
    required this.texto,
    required this.subtexto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            subtexto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
