import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/asignaturas_provider.dart';
import '../../models/nota.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _notaController = TextEditingController();
  final _ponderacionController = TextEditingController();

  @override
  void dispose() {
    _notaController.dispose();
    _ponderacionController.dispose();
    super.dispose();
  }

  void _agregarNota() {
    if (_notaController.text.isEmpty || _ponderacionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor ingresa la nota y ponderación')),
      );
      return;
    }

    final nota = double.parse(_notaController.text);
    final ponderacion = double.parse(_ponderacionController.text);

    try {
      final nuevaNota = Nota(
        valor: nota,
        ponderacion: ponderacion,
        descripcion: 'Evaluación',
      );

      context.read<AsignaturasProvider>().agregarNota(nuevaNota);
      _notaController.clear();
      _ponderacionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String _obtenerMensajeMotivacional(double nota) {
    if (nota <= 4.0) return '¡Es posible aprobar! 💪';
    if (nota <= 5.0) return '¡Esfuérzate un poco más! 📚';
    if (nota <= 6.0) return '¡Necesitas dedicarle tiempo! 🎯';
    return '¡Con dedicación lo lograrás! ⭐';
  }

  @override
  Widget build(BuildContext context) {
    final asignatura =
        context.watch<AsignaturasProvider>().asignaturaSeleccionada!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double? notaNecesaria;
    String mensaje = '';

    try {
      notaNecesaria = asignatura.calcularNotaNecesaria();
      mensaje = _obtenerMensajeMotivacional(notaNecesaria);
    } catch (e) {
      mensaje = e.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(asignatura.nombre),
            Text(
              'Promedio: ${asignatura.promedioActual.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppTheme.borderRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _notaController,
                        decoration: const InputDecoration(
                          labelText: 'Nota',
                          prefixIcon: Icon(Icons.grade),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,1}')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _ponderacionController,
                        decoration: const InputDecoration(
                          labelText: 'Ponderación %',
                          prefixIcon: Icon(Icons.percent),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,1}')),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _agregarNota,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Nota'),
                ),
              ],
            ),
          ),
          if (asignatura.notas.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.list_alt, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Notas Ingresadas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount:
                    asignatura.notas.length + (notaNecesaria != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < asignatura.notas.length) {
                    final nota = asignatura.notas[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? AppTheme.getNotaColorDark(nota.valor)
                              : AppTheme.getNotaColor(nota.valor),
                          child: Text(
                            nota.valor.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          'Evaluación ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          'Ponderación: ${nota.ponderacion}%',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _notaController.text = nota.valor.toString();
                                _ponderacionController.text =
                                    nota.ponderacion.toString();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Editar Nota'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _notaController,
                                          decoration: const InputDecoration(
                                            labelText: 'Nota',
                                            prefixIcon: Icon(Icons.grade),
                                          ),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d{0,1}')),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _ponderacionController,
                                          decoration: const InputDecoration(
                                            labelText: 'Ponderación %',
                                            prefixIcon: Icon(Icons.percent),
                                          ),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d{0,1}')),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      FilledButton.icon(
                                        onPressed: () {
                                          if (_notaController.text.isEmpty ||
                                              _ponderacionController
                                                  .text.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Por favor ingresa la nota y ponderación')),
                                            );
                                            return;
                                          }

                                          final nuevaNota = double.parse(
                                              _notaController.text);
                                          final nuevaPonderacion = double.parse(
                                              _ponderacionController.text);

                                          try {
                                            context
                                                .read<AsignaturasProvider>()
                                                .eliminarNota(nota);
                                            final notaEditada = Nota(
                                              valor: nuevaNota,
                                              ponderacion: nuevaPonderacion,
                                              descripcion: nota.descripcion,
                                            );
                                            context
                                                .read<AsignaturasProvider>()
                                                .agregarNota(notaEditada);
                                            Navigator.pop(context);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(e.toString())),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.save),
                                        label: const Text('Guardar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Eliminar Nota'),
                                    content: const Text(
                                        '¿Estás seguro de que deseas eliminar esta nota?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      FilledButton.icon(
                                        onPressed: () {
                                          context
                                              .read<AsignaturasProvider>()
                                              .eliminarNota(nota);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.delete),
                                        label: const Text('Eliminar'),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              'Nota Necesaria ET',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? AppTheme.getNotaColorDark(notaNecesaria!)
                                    : AppTheme.getNotaColor(notaNecesaria!),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDark
                                            ? AppTheme.getNotaColorDark(
                                                notaNecesaria)
                                            : AppTheme.getNotaColor(
                                                notaNecesaria))
                                        .withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                notaNecesaria.toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              mensaje,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ] else if (mensaje.isNotEmpty) ...[
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mensaje,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
