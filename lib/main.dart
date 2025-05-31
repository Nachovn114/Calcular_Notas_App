import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme.dart';
import 'providers/asignaturas_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/asignaturas/asignaturas_screen.dart';
import 'screens/analisis/analisis_screen.dart';
import 'screens/perfil/perfil_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'widgets/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted =
      prefs.getBool('onboarding_completed') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AsignaturasProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: MyApp(showOnboarding: !onboardingCompleted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({
    super.key,
    required this.showOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Calculadora de Notas',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: showOnboarding ? const OnboardingScreen() : const MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AsignaturasScreen(),
    AnalisisScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
