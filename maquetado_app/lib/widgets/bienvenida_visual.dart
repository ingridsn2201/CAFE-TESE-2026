import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BienvenidaVisual extends StatelessWidget {
  const BienvenidaVisual({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 18,
              top: 18,
              child: _CircleAccent(
                size: 74,
                color: AppTheme.doradoAccion.withValues(alpha: 0.22),
              ),
            ),
            Positioned(
              left: 18,
              bottom: 16,
              child: _CircleAccent(
                size: 54,
                color: Colors.white.withValues(alpha: 0.16),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _FeatureCard(
                        icon: Icons.restaurant_menu,
                        label: 'Menú',
                        color: Colors.white,
                        iconColor: AppTheme.verdeInstitucional,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Transform.translate(
                        offset: const Offset(0, -14),
                        child: _FeatureCard(
                          icon: Icons.local_cafe,
                          label: 'Café',
                          color: AppTheme.doradoAccion,
                          iconColor: Colors.white,
                          labelColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _FeatureCard(
                        icon: Icons.schedule,
                        label: 'Pedido',
                        color: Colors.white,
                        iconColor: AppTheme.verdeInstitucional,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.labelColor = AppTheme.textoPrincipal,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 34, color: iconColor),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAccent extends StatelessWidget {
  const _CircleAccent({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
