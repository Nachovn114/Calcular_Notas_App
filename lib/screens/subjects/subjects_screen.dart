import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/asignatura.dart';
import '../../providers/asignaturas_provider.dart';
import '../analisis/analisis_screen.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AsignaturasProvider>(
      builder: (context, provider, child) {
        final asignaturas = provider.asignaturas;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: asignaturas.length,
          itemBuilder: (context, index) {
            final asignatura = asignaturas[index];
            return _SubjectCard(
              asignatura: asignatura,
              onTap: () {
                provider.seleccionarAsignatura(asignatura);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalisisScreen(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Asignatura asignatura;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.asignatura,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asignatura.nombre,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.grade,
                    label:
                        'Promedio: ${asignatura.promedio.toStringAsFixed(1)}',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.percent,
                    label:
                        'Progreso: ${(asignatura.progreso * 100).toStringAsFixed(1)}%',
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
