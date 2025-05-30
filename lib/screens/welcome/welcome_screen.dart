import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../config/theme.dart';
import '../subjects/subjects_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school,
                  size: 80,
                  color: Colors.white,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .shimmer(
                      duration: const Duration(seconds: 2),
                      color: Colors.white.withOpacity(0.5),
                    ),
                const SizedBox(height: 24),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('¡Bienvenido!'),
                    ],
                    isRepeatingAnimation: false,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Calcula fácilmente las notas que necesitas para aprobar tus ramos',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 500))
                    .slideY(
                      begin: 0.3,
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubjectsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calculate),
                  label: const Text('Comenzar a Calcular'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryLight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 1000))
                    .slideY(
                      begin: 0.3,
                      curve: Curves.easeOut,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
