import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/asignatura.dart';
import '../../providers/asignaturas_provider.dart';
import '../../config/theme.dart';
import '../asignatura/agregar_asignatura_screen.dart';
import '../asignatura/detalle_asignatura_screen.dart';
import 'widgets/asignatura_card.dart';
import 'widgets/estadisticas_widget.dart';
import 'widgets/resumen_widget.dart';
import 'widgets/mejor_peor_widget.dart';
import 'widgets/grafico_categorias_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Consumer<AsignaturasProvider>(
        builder: (context, provider, child) {
          final asignaturas = provider.asignaturas;
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

          final asignaturasConNotas =
              asignaturas.where((a) => a.notas.isNotEmpty).toList();
          final mejorAsignatura = asignaturasConNotas.isEmpty
              ? null
              : asignaturasConNotas
                  .reduce((a, b) => a.promedio > b.promedio ? a : b);
          final peorAsignatura = asignaturasConNotas.isEmpty
              ? null
              : asignaturasConNotas
                  .reduce((a, b) => a.promedio < b.promedio ? a : b);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResumenWidget(asignaturas: asignaturasConNotas),
                const SizedBox(height: 16),
                Padding(
                  padding: AppTheme.pagePadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: MejorPeorWidget(
                          asignatura: mejorAsignatura,
                          isMejor: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MejorPeorWidget(
                          asignatura: peorAsignatura,
                          isMejor: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: AppTheme.pagePadding,
                  child: GraficoCategorias(asignaturas: asignaturasConNotas),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
