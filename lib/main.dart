import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/theme.dart';
import 'models/asignatura.dart';
import 'models/nota.dart';
import 'screens/welcome/welcome_screen.dart';
import 'providers/asignaturas_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar adaptadores
  Hive.registerAdapter(AsignaturaAdapter());
  Hive.registerAdapter(NotaAdapter());

  // Abrir las cajas
  await Hive.openBox<Asignatura>('asignaturas');

  // Configurar orientación
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AsignaturasProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Calculadora de Notas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const WelcomeScreen(),
      ),
    );
  }
}
