import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/asignatura.dart';
import '../../providers/asignaturas_provider.dart';
import '../../config/theme.dart';
import 'agregar_nota_screen.dart';
import 'agregar_asignatura_screen.dart';

class DetalleAsignaturaScreen extends StatelessWidget {
  final String asignaturaId;

  const DetalleAsignaturaScreen({
    super.key,
    required this.asignaturaId,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AsignaturasProvider, Asignatura?>(
      selector: (_, provider) => provider.getAsignatura(asignaturaId),
      builder: (context, asignatura, child) {
        if (asignatura == null) {
          return const Scaffold(
            body: Center(
              child: Text('Asignatura no encontrada'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(asignatura.nombre),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgregarAsignaturaScreen(
                        asignatura: asignatura,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar asignatura'),
                      content: const Text(
                          '¿Estás seguro de eliminar esta asignatura?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () {
                            context
                                .read<AsignaturasProvider>()
                                .eliminarAsignatura(asignatura.id);
                            Navigator.pop(context); // Cierra el diálogo
                            Navigator.pop(
                                context); // Vuelve a la pantalla anterior
                          },
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: AppTheme.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Promedio actual',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  asignatura.promedio.toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppTheme.getNotaColor(
                                            asignatura.promedio),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Progreso',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '${(asignatura.progreso * 100).toStringAsFixed(0)}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: asignatura.progreso,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Evaluaciones',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (asignatura.notas.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text('No hay evaluaciones registradas'),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: asignatura.notas.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final nota = asignatura.notas[index];
                            return ListTile(
                              title: Text(nota.nombre),
                              subtitle: Text(
                                  'Ponderación: ${nota.peso.toStringAsFixed(0)}%'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.getNotaColor(nota.valor),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      nota.valor.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AgregarNotaScreen(
                                            asignatura: asignatura,
                                            nota: nota,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      context
                                          .read<AsignaturasProvider>()
                                          .eliminarNota(
                                            asignatura.id,
                                            nota.id,
                                          );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AgregarNotaScreen(asignatura: asignatura),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
