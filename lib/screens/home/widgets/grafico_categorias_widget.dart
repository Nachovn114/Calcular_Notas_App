import 'package:flutter/material.dart';
import '../../../models/asignatura.dart';
import '../../../config/theme.dart';

class GraficoCategorias extends StatelessWidget {
  final List<Asignatura> asignaturas;

  const GraficoCategorias({
    super.key,
    required this.asignaturas,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular cantidad de asignaturas por categoría
    int excelente = 0;
    int bueno = 0;
    int regular = 0;
    int deficiente = 0;

    for (var asignatura in asignaturas) {
      if (asignatura.promedio >= 6.0) {
        excelente++;
      } else if (asignatura.promedio >= 5.0) {
        bueno++;
      } else if (asignatura.promedio >= 4.0) {
        regular++;
      } else {
        deficiente++;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desempeño por Categoría',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _CategoriaBar(
              label: 'Excelente',
              cantidad: excelente,
              total: asignaturas.length,
              color: AppTheme.successLight,
            ),
            const SizedBox(height: 12),
            _CategoriaBar(
              label: 'Bueno',
              cantidad: bueno,
              total: asignaturas.length,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _CategoriaBar(
              label: 'Regular',
              cantidad: regular,
              total: asignaturas.length,
              color: AppTheme.warningLight,
            ),
            const SizedBox(height: 12),
            _CategoriaBar(
              label: 'Deficiente',
              cantidad: deficiente,
              total: asignaturas.length,
              color: AppTheme.dangerLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriaBar extends StatelessWidget {
  final String label;
  final int cantidad;
  final int total;
  final Color color;

  const _CategoriaBar({
    required this.label,
    required this.cantidad,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final porcentaje = total > 0 ? cantidad / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '$cantidad',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: porcentaje,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
