import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/asignatura.dart';
import '../../models/nota.dart';
import '../../providers/asignaturas_provider.dart';
import '../../config/theme.dart';
import 'package:uuid/uuid.dart';

class AgregarNotaScreen extends StatefulWidget {
  final Asignatura asignatura;
  final Nota? nota;

  const AgregarNotaScreen({
    super.key,
    required this.asignatura,
    this.nota,
  });

  @override
  State<AgregarNotaScreen> createState() => _AgregarNotaScreenState();
}

class _AgregarNotaScreenState extends State<AgregarNotaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _valorController;
  late TextEditingController _pesoController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.nota != null;
    _nombreController = TextEditingController(
      text: widget.nota?.nombre ?? '',
    );
    _valorController = TextEditingController(
      text: widget.nota?.valor.toString() ?? '',
    );
    _pesoController = TextEditingController(
      text: widget.nota?.peso.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _valorController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  void _guardarNota() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AsignaturasProvider>();

      final nota = Nota(
        id: widget.nota?.id ?? const Uuid().v4(),
        nombre: _nombreController.text,
        valor: double.parse(_valorController.text),
        peso: double.parse(_pesoController.text),
        fecha: widget.nota?.fecha ?? DateTime.now(),
      );

      provider.agregarNota(widget.asignatura.id, nota);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pesoRestante = 100 -
        widget.asignatura.notas
            .where((nota) => widget.nota == null || nota.id != widget.nota!.id)
            .fold(0.0, (sum, nota) => sum + nota.peso);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Nota' : 'Nueva Nota'),
      ),
      body: SingleChildScrollView(
        padding: AppTheme.pagePadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la evaluación',
                          hintText: 'Ej: Prueba 1',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el nombre de la evaluación';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _valorController,
                        decoration: const InputDecoration(
                          labelText: 'Nota obtenida',
                          suffixText: '/ 7.0',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la nota';
                          }
                          final numero = double.tryParse(value);
                          if (numero == null || numero < 1 || numero > 7) {
                            return 'Ingresa un número válido entre 1 y 7';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pesoController,
                        decoration: InputDecoration(
                          labelText: 'Ponderación',
                          suffixText: '%',
                          helperText: 'Peso disponible: $pesoRestante%',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la ponderación';
                          }
                          final numero = double.tryParse(value);
                          if (numero == null || numero <= 0 || numero > 100) {
                            return 'Ingresa un número válido entre 1 y 100';
                          }
                          if (numero > pesoRestante && !_isEditing) {
                            return 'La ponderación excede el peso disponible ($pesoRestante%)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _guardarNota,
                child: Text(_isEditing ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
