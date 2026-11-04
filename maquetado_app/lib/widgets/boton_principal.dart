import 'package:flutter/material.dart';

class BotonPrincipal extends StatelessWidget {
  const BotonPrincipal({
    required this.texto,
    required this.onPressed,
    this.icon,
    this.secundario = false,
    super.key,
  });

  final String texto;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool secundario;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(texto)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Flexible(child: Text(texto)),
            ],
          );

    if (secundario) {
      return OutlinedButton(
        onPressed: onPressed,
        child: child,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
