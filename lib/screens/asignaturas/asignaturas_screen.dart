import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/asignatura.dart';
import '../../providers/asignaturas_provider.dart';
import '../../config/theme.dart';
import '../asignatura/agregar_asignatura_screen.dart';
import '../asignatura/detalle_asignatura_screen.dart';

class AsignaturasScreen extends StatelessWidget {
  const AsignaturasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignaturas'),
        centerTitle: true,
      ),
      body: Consumer<AsignaturasProvider>(
        builder: (context, asignaturasProvider, child) {
          final asignaturas = asignaturasProvider.asignaturas;

          if (asignaturas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay asignaturas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega tu primera asignatura',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AgregarAsignaturaScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Asignatura'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: AppTheme.pagePadding,
            itemCount: asignaturas.length,
            itemBuilder: (context, index) {
              final asignatura = asignaturas[index];
              return _AsignaturaCard(asignatura: asignatura);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AgregarAsignaturaScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AsignaturaCard extends StatelessWidget {
  final Asignatura asignatura;

  const _AsignaturaCard({
    required this.asignatura,
  });

  String _calcularNotaNecesaria(
      double promedioActual, double progreso, double notaDeseada) {
    // Si no tiene el 100% de las evaluaciones regulares, no mostramos nada
    if (progreso < 1.0) return '';

    // El promedio actual representa el 60% de la nota final
    // El examen transversal representa el 40% restante
    // Queremos alcanzar al menos un 4.0 final

    // Nota final = (promedio_actual * 0.6) + (nota_examen * 0.4)
    // 4.0 = (promedio_actual * 0.6) + (nota_examen * 0.4)
    // nota_examen = (4.0 - (promedio_actual * 0.6)) / 0.4

    double notaNecesariaExamen = (4.0 - (promedioActual * 0.6)) / 0.4;

    // Verificar si es posible aprobar
    if (notaNecesariaExamen > 7.0) {
      return 'Imposible aprobar';
    } else if (notaNecesariaExamen < 1.0) {
      return 'Ya aprobado';
    }

    return notaNecesariaExamen.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleAsignaturaScreen(
              asignaturaId: asignatura.id,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      asignatura.nombre,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.getNotaColor(asignatura.promedio),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      asignatura.promedio.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${asignatura.notas.length} evaluaciones',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  if (asignatura.progreso >= 1.0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calculate_outlined,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Nota Ex. Trans: ${_calcularNotaNecesaria(asignatura.promedio, asignatura.progreso, asignatura.notaDeseada)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: asignatura.progreso,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(asignatura.progreso * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
