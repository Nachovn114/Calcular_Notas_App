import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/asignatura.dart';
import '../../providers/asignaturas_provider.dart';
import '../../config/theme.dart';
import 'package:uuid/uuid.dart';

class AgregarAsignaturaScreen extends StatefulWidget {
  final Asignatura? asignatura;

  const AgregarAsignaturaScreen({
    super.key,
    this.asignatura,
  });

  @override
  State<AgregarAsignaturaScreen> createState() =>
      _AgregarAsignaturaScreenState();
}

class _AgregarAsignaturaScreenState extends State<AgregarAsignaturaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _notaDeseadaController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.asignatura != null;
    _nombreController = TextEditingController(
      text: widget.asignatura?.nombre ?? '',
    );
    _notaDeseadaController = TextEditingController(
      text: widget.asignatura?.notaDeseada.toString() ?? '4.0',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _notaDeseadaController.dispose();
    super.dispose();
  }

  void _guardarAsignatura() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AsignaturasProvider>();

      final asignatura = Asignatura(
        id: widget.asignatura?.id ?? const Uuid().v4(),
        nombre: _nombreController.text,
        notaDeseada: double.parse(_notaDeseadaController.text),
        notas: widget.asignatura?.notas ?? [],
      );

      if (_isEditing) {
        provider.actualizarAsignatura(asignatura);
      } else {
        provider.agregarAsignatura(asignatura);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Asignatura' : 'Nueva Asignatura'),
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
                          labelText: 'Nombre de la asignatura',
                          hintText: 'Ej: Matemáticas',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el nombre de la asignatura';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notaDeseadaController,
                        decoration: const InputDecoration(
                          labelText: 'Nota mínima deseada',
                          suffixText: '/ 7.0',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la nota deseada';
                          }
                          final numero = double.tryParse(value);
                          if (numero == null || numero < 1 || numero > 7) {
                            return 'Ingresa un número válido entre 1 y 7';
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
                onPressed: _guardarAsignatura,
                child: Text(_isEditing ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
