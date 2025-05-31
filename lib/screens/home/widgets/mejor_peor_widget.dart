import 'package:flutter/material.dart';
import '../../../models/asignatura.dart';
import '../../../config/theme.dart';

class MejorPeorWidget extends StatelessWidget {
  final Asignatura? asignatura;
  final bool isMejor;

  const MejorPeorWidget({
    super.key,
    required this.asignatura,
    required this.isMejor,
  });

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
                  isMejor ? Icons.emoji_events : Icons.warning_outlined,
                  color: isMejor ? Colors.amber : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isMejor ? 'Mejor' : 'Por mejorar',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (asignatura != null) ...[
              Text(
                asignatura!.nombre,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.getNotaColor(asignatura!.promedio),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  asignatura!.promedio.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else
              Text(
                'Sin datos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
