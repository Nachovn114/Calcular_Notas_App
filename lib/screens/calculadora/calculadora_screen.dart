import 'package:flutter/material.dart';
import '../../config/theme.dart';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final _formKey = GlobalKey<FormState>();
  double _promedioActual = 0.0;
  double _pesoRestante = 0.0;
  double _notaDeseada = 4.0;
  double _notaNecesaria = 0.0;

  void _calcularNotaNecesaria() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Fórmula: (NotaDeseada - (PromedioActual * (1 - PesoRestante))) / PesoRestante
        _notaNecesaria =
            (_notaDeseada - (_promedioActual * (1 - _pesoRestante / 100))) /
                (_pesoRestante / 100);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Notas'),
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
                      Text(
                        'Calcula tu nota necesaria',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Promedio actual',
                          suffixText: '/ 7.0',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu promedio actual';
                          }
                          final numero = double.tryParse(value);
                          if (numero == null || numero < 0 || numero > 7) {
                            return 'Ingresa un número válido entre 0 y 7';
                          }
                          _promedioActual = numero;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Peso restante',
                          suffixText: '%',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el peso restante';
                          }
                          final numero = double.tryParse(value);
                          if (numero == null || numero <= 0 || numero > 100) {
                            return 'Ingresa un número válido entre 1 y 100';
                          }
                          _pesoRestante = numero;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nota deseada',
                          suffixText: '/ 7.0',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: '4.0',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la nota deseada';
                          }
                          final numero = double.tryParse(value);
                          if (numero == null || numero < 1 || numero > 7) {
                            return 'Ingresa un número válido entre 1 y 7';
                          }
                          _notaDeseada = numero;
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _calcularNotaNecesaria,
                          child: const Text('Calcular'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_notaNecesaria > 0) ...[
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Necesitas sacar',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _notaNecesaria.toStringAsFixed(1),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          _notaNecesaria > 7.0
                              ? '😢 No es posible alcanzar la nota deseada'
                              : _notaNecesaria > 6.0
                                  ? '😅 ¡Necesitarás esforzarte mucho!'
                                  : '😊 ¡Es alcanzable!',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
