import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../theme/app_theme.dart';
import '../widgets/bienvenida_visual.dart';
import '../widgets/boton_principal.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    final compactHeight = size.height < 700;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width < 380 ? 18 : 24,
                vertical: compactHeight ? 18 : 28,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (compactHeight ? 36 : 56),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                'TESE',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textoPrincipal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: compactHeight ? 22 : 30),
                        const BienvenidaVisual(),
                        SizedBox(height: compactHeight ? 24 : 32),
                        Text(
                          'Cafetería TESE',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textoPrincipal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ordena con anticipación y disfruta tu comida sin filas.',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppTheme.textoPrincipal.withValues(alpha: 0.78),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Consulta alimentos, revisa disponibilidad y prepara tu pedido antes de llegar a la cafetería.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textoPrincipal.withValues(alpha: 0.68),
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: compactHeight ? 24 : 32),
                        BotonPrincipal(
                          texto: 'Iniciar sesión',
                          icon: Icons.login,
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.login),
                        ),
                        const SizedBox(height: 12),
                        BotonPrincipal(
                          texto: 'Crear cuenta',
                          icon: Icons.person_add_alt_1,
                          secundario: true,
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.registro),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
