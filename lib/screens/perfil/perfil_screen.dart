import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../providers/theme_provider.dart';
import '../onboarding/onboarding_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  Future<void> _resetOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', false);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: AppTheme.pagePadding,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Estudiante',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Universidad',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notificaciones'),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // Implementar lógica de notificaciones
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Tema oscuro'),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.backup_outlined),
                      title: const Text('Respaldo automático'),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // Implementar lógica de respaldo
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Ayuda y soporte'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Implementar navegación a ayuda
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Acerca de'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Implementar navegación a información
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.tonal(
                onPressed: () {
                  // Implementar cierre de sesión
                },
                child: const Text('Cerrar sesión'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _resetOnboarding(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Reiniciar Tutorial'),
              ),
            ],
          );
        },
      ),
    );
  }
}
