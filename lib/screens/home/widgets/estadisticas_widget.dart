import 'package:flutter/material.dart';
import '../../../models/asignatura.dart';
import 'package:fl_chart/fl_chart.dart';

class EstadisticasWidget extends StatelessWidget {
  final List<Asignatura> asignaturas;

  const EstadisticasWidget({
    super.key,
    required this.asignaturas,
  });

  List<Asignatura> get asignaturasConNotas {
    return asignaturas.where((a) => a.notas.isNotEmpty).toList();
  }

  double get promedioGlobal {
    final asignaturasValidas = asignaturasConNotas;
    if (asignaturasValidas.isEmpty) return 0.0;
    return asignaturasValidas.map((a) => a.promedio).reduce((a, b) => a + b) /
        asignaturasValidas.length;
  }

  @override
  Widget build(BuildContext context) {
    final asignaturasValidas = asignaturasConNotas;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promedio Global',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    promedioGlobal.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Materias con Notas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    asignaturasValidas.length.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          if (asignaturasValidas.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 7,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= asignaturasValidas.length)
                            return const Text('');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              asignaturasValidas[value.toInt()]
                                  .nombre
                                  .substring(0, 3),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
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
                  barGroups: asignaturasValidas
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.promedio,
                              color: Colors.white,
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
