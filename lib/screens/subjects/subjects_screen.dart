import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/asignatura.dart';
import '../../providers/asignaturas_provider.dart';
import '../calculator/calculator_screen.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Asignaturas'),
        flexibleSpace: Container(
          decoration: AppTheme.gradientBackground,
        ),
      ),
      body: Consumer<AsignaturasProvider>(
        builder: (context, provider, child) {
          final asignaturas = provider.asignaturas;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: asignaturas.length,
            itemBuilder: (context, index) {
              final asignatura = asignaturas[index];
              return _SubjectCard(asignatura: asignatura);
            },
          );
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Asignatura asignatura;

  const _SubjectCard({
    required this.asignatura,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.read<AsignaturasProvider>().seleccionarAsignatura(asignatura);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CalculatorScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
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
                        'Promedio: ${asignatura.promedioActual.toStringAsFixed(1)}',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.percent,
                    label:
                        'Ponderación: ${asignatura.ponderacionAcumulada.toStringAsFixed(1)}%',
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
