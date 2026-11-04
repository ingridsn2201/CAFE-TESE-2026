import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../widgets/boton_principal.dart';

class BasePlaceholderScreen extends StatelessWidget {
  const BasePlaceholderScreen({
    required this.titulo,
    required this.descripcion,
    this.mostrarAppBar = true,
    this.acciones = const [],
    super.key,
  });

  final String titulo;
  final String descripcion;
  final bool mostrarAppBar;
  final List<Widget> acciones;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: mostrarAppBar ? AppBar(title: Text(titulo)) : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.coffee,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    descripcion,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ...acciones,
                  if (acciones.isNotEmpty) const SizedBox(height: 12),
                  BotonPrincipal(
                    texto: 'Ir al menu',
                    icon: Icons.restaurant_menu,
                    secundario: true,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.menu,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
