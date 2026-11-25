import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    required this.titulo,
    required this.descripcion,
    super.key,
  });

  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.verdeInstitucional,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_cafe,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'Cafetería TESE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textoPrincipal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          titulo,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppTheme.textoPrincipal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          descripcion,
          style: textTheme.bodyMedium?.copyWith(
            color: AppTheme.textoPrincipal.withValues(alpha: 0.72),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
