import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/custom_app_bar.dart';
import 'widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: AnimatedGradientBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Calculadora de Notas',
                onThemeToggle: themeProvider.toggleTheme,
                isDark: isDark,
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView(
                    padding: AppTheme.pagePadding,
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      // TODO: Implementar lista de asignaturas con AnimatedList
                      EmptyState(
                        message: 'No hay asignaturas registradas',
                        subMessage:
                            'Toca el botón + para agregar una asignatura',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Implementar agregar asignatura
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
