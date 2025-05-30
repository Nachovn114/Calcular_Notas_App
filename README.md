# Calculadora de Notas

Una aplicación móvil desarrollada en Flutter para calcular promedios y notas necesarias para aprobar asignaturas universitarias.

## Características

- 🎓 Gestión de múltiples asignaturas
- 📊 Cálculo de promedios ponderados
- 🎯 Calculadora de nota necesaria para aprobar
- 💾 Persistencia de datos
- 🎨 Interfaz moderna y atractiva
- ✨ Animaciones fluidas
- 📱 Diseño responsivo

## Asignaturas Predefinidas

La aplicación viene con las siguientes asignaturas precargadas:

- DESARROLLO ORIENTADO A OBJETOS
- DOCTRINA SOCIAL DE LA IGLESIA
- INGENIERÍA DE SOFTWARE
- BASE DE DATOS APLICADA II
- INGLÉS ELEMENTAL II

## Funcionalidades

### Pantalla de Bienvenida
- Animaciones atractivas
- Transición suave a la selección de asignaturas

### Selección de Asignaturas
- Lista de asignaturas disponibles
- Información del promedio actual y ponderación por asignatura
- Navegación intuitiva

### Calculadora de Notas
- Visualización del estado actual de la asignatura
- Calculadora de nota necesaria para el examen
- Validación de datos ingresados
- Mensajes informativos y recomendaciones

## Requisitos Técnicos

- Flutter SDK: >=3.2.3 <4.0.0
- Dart SDK: >=3.2.3 <4.0.0

## Dependencias Principales

- provider: ^6.1.1 (Gestión de estado)
- hive: ^2.2.3 (Base de datos local)
- flutter_animate: ^4.5.0 (Animaciones)
- animated_text_kit: ^4.2.2 (Textos animados)

## Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/tu-usuario/calcular_notas_app.git
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Genera los adaptadores de Hive:
```bash
dart run build_runner build
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
  ├── config/
  │   └── theme.dart
  ├── models/
  │   ├── asignatura.dart
  │   └── nota.dart
  ├── providers/
  │   └── asignaturas_provider.dart
  ├── screens/
  │   ├── welcome/
  │   │   └── welcome_screen.dart
  │   ├── subjects/
  │   │   └── subjects_screen.dart
  │   └── calculator/
  │       └── calculator_screen.dart
  └── main.dart
```

## Contribución

Si deseas contribuir al proyecto:

1. Haz un fork del repositorio
2. Crea una rama para tu característica (`git checkout -b feature/AmazingFeature`)
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles. 