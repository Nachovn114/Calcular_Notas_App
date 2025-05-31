import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asignatura.dart';
import '../models/nota.dart';

class AsignaturasProvider with ChangeNotifier {
  List<Asignatura> _asignaturas = [];
  final SharedPreferences _prefs;
  static const String _key = 'asignaturas';
  Asignatura? _asignaturaSeleccionada;

  AsignaturasProvider(this._prefs) {
    _cargarAsignaturas();
  }

  List<Asignatura> get asignaturas => List.unmodifiable(_asignaturas);
  Asignatura? get asignaturaSeleccionada => _asignaturaSeleccionada;

  Asignatura? getAsignatura(String id) {
    try {
      return _asignaturas.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  void _cargarAsignaturas() {
    final String? asignaturasString = _prefs.getString(_key);
    if (asignaturasString != null) {
      final List<dynamic> decoded = jsonDecode(asignaturasString);
      _asignaturas = decoded.map((item) => Asignatura.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _guardarAsignaturas() async {
    final String encoded =
        jsonEncode(_asignaturas.map((a) => a.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }

  void agregarAsignatura(Asignatura asignatura) {
    _asignaturas.add(asignatura);
    _guardarAsignaturas();
    notifyListeners();
  }

  void agregarNota(String asignaturaId, Nota nota) {
    final index = _asignaturas.indexWhere((a) => a.id == asignaturaId);
    if (index != -1) {
      final asignatura = _asignaturas[index];
      final nuevasNotas = List<Nota>.from(asignatura.notas)..add(nota);
      _asignaturas[index] = Asignatura(
        id: asignatura.id,
        nombre: asignatura.nombre,
        notas: nuevasNotas,
        notaDeseada: asignatura.notaDeseada,
      );
      _guardarAsignaturas();
      notifyListeners();
    }
  }

  void eliminarNota(String asignaturaId, String notaId) {
    final index = _asignaturas.indexWhere((a) => a.id == asignaturaId);
    if (index != -1) {
      final asignatura = _asignaturas[index];
      final nuevasNotas =
          asignatura.notas.where((n) => n.id != notaId).toList();
      _asignaturas[index] = Asignatura(
        id: asignatura.id,
        nombre: asignatura.nombre,
        notas: nuevasNotas,
        notaDeseada: asignatura.notaDeseada,
      );
      _guardarAsignaturas();
      notifyListeners();
    }
  }

  void actualizarAsignatura(Asignatura asignatura) {
    final index = _asignaturas.indexWhere((a) => a.id == asignatura.id);
    if (index != -1) {
      _asignaturas[index] = asignatura;
      _guardarAsignaturas();
      notifyListeners();
    }
  }

  void eliminarAsignatura(String id) {
    _asignaturas.removeWhere((a) => a.id == id);
    _guardarAsignaturas();
    notifyListeners();
  }

  void seleccionarAsignatura(Asignatura? asignatura) {
    _asignaturaSeleccionada = asignatura;
    notifyListeners();
  }

  double get promedioGeneral {
    if (_asignaturas.isEmpty) return 0.0;
    final promedios = _asignaturas.map((a) => a.promedio).toList();
    return promedios.reduce((a, b) => a + b) / promedios.length;
  }

  double get progresoGeneral {
    if (_asignaturas.isEmpty) return 0.0;
    final progresos = _asignaturas.map((a) => a.progreso).toList();
    return progresos.reduce((a, b) => a + b) / progresos.length;
  }

  @override
  void dispose() {
    _guardarAsignaturas();
    super.dispose();
  }
}
