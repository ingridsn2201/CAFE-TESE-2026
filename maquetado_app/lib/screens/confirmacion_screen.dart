import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_principal.dart';

class ConfirmacionScreen extends StatelessWidget {
  const ConfirmacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final carrito = appState.carrito;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar pedido')),
      body: carrito.isEmpty
          ? const Center(child: Text('No hay productos para confirmar.'))
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal = constraints.maxWidth >= 760 ? 56.0 : 20.0;
                  return ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 130),
                    children: [
                      Text(
                        'Revisa tu pedido',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Confirma que los productos y cantidades sean correctos antes de generar el pedido.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textoPrincipal.withValues(alpha: 0.68),
                              height: 1.4,
                            ),
                      ),
                      const SizedBox(height: 18),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              for (final item in carrito)
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.verdeInstitucional.withValues(alpha: 0.10),
                                    foregroundColor: AppTheme.verdeInstitucional,
                                    child: const Icon(Icons.fastfood_outlined),
                                  ),
                                  title: Text(
                                    item.producto.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  subtitle: Text(
                                    '${item.cantidad} × \$${item.producto.precio.toStringAsFixed(2)}',
                                  ),
                                  trailing: Text(
                                    '\$${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              _TotalRow(
                                label: 'Productos',
                                value: '${appState.totalItemsCarrito}',
                              ),
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 12),
                              _TotalRow(
                                label: 'Total',
                                value: '\$${appState.totalCarrito.toStringAsFixed(2)}',
                                destacado: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.pendiente.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: AppTheme.pendiente),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'El pago se realizará en efectivo al momento de recoger el pedido en la cafetería.',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
      bottomNavigationBar: carrito.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: BotonPrincipal(
                texto: 'Confirmar pedido',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  try {
                    appState.confirmarPedido();
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.pedidoRealizado,
                    );
                  } on StateError catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message)),
                    );
                  }
                },
              ),
            ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value, this.destacado = false});

  final String label;
  final String value;
  final bool destacado;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: destacado ? FontWeight.w900 : FontWeight.w600,
                ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: destacado ? AppTheme.verdeInstitucional : AppTheme.textoPrincipal,
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }
}
