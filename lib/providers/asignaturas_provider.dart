import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/asignatura.dart';
import '../models/nota.dart';

class AsignaturasProvider with ChangeNotifier {
  late Box<Asignatura> _box;
  Asignatura? _asignaturaSeleccionada;

  AsignaturasProvider() {
    _initBox();
  }

  void _initBox() {
    _box = Hive.box<Asignatura>('asignaturas');
    if (_box.isEmpty) {
      // Cargar asignaturas predefinidas
      for (var asignatura in Asignatura.asignaturasPredefinidas()) {
        _box.add(asignatura);
      }
    }
  }

  List<Asignatura> get asignaturas => _box.values.toList();

  Asignatura? get asignaturaSeleccionada => _asignaturaSeleccionada;

  void seleccionarAsignatura(Asignatura asignatura) {
    _asignaturaSeleccionada = asignatura;
    notifyListeners();
  }

  void agregarNota(Nota nota) {
    if (_asignaturaSeleccionada != null) {
      _asignaturaSeleccionada!.agregarNota(nota);
      _asignaturaSeleccionada!.save();
      notifyListeners();
    }
  }

  void eliminarNota(Nota nota) {
    if (_asignaturaSeleccionada != null) {
      _asignaturaSeleccionada!.eliminarNota(nota);
      _asignaturaSeleccionada!.save();
      notifyListeners();
    }
  }

  double calcularNotaNecesaria() {
    if (_asignaturaSeleccionada == null) {
      throw Exception('No hay asignatura seleccionada');
    }

    return _asignaturaSeleccionada!.calcularNotaNecesaria();
  }

  void limpiarSeleccion() {
    _asignaturaSeleccionada = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _box.close();
    super.dispose();
  }
}
