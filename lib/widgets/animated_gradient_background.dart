import 'package:flutter/material.dart';
import '../config/theme.dart';

class AnimatedGradientBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isDark
          ? AppTheme.darkGradientBackground
          : AppTheme.gradientBackground,
      child: child,
    );
  }
}
