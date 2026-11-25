import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_principal.dart';

class PedidoRealizadoScreen extends StatelessWidget {
  const PedidoRealizadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pedido = AppStateScope.of(context).pedidoActivo;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: AppTheme.disponible.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 58,
                      color: AppTheme.disponible,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '¡Pedido realizado!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu pedido fue registrado correctamente en esta maqueta.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textoPrincipal.withValues(alpha: 0.68),
                        ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Número de pedido',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '#${pedido?.id ?? 'TESE-000'}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.verdeInstitucional,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          if (pedido != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              '${pedido.items.length} concepto${pedido.items.length == 1 ? '' : 's'} · \$${pedido.total.toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.verdeInstitucional.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.verdeInstitucional),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Consulta el estado del pedido para seguir su avance.',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  BotonPrincipal(
                    texto: 'Consultar estado',
                    icon: Icons.timeline,
                    onPressed: pedido == null
                        ? null
                        : () => Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.estadoPedido,
                            ),
                  ),
                  const SizedBox(height: 12),
                  BotonPrincipal(
                    texto: 'Regresar al menú',
                    icon: Icons.restaurant_menu,
                    secundario: true,
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.menu,
                      (route) => false,
                    ),
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
