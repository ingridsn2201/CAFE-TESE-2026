import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_principal.dart';
import '../widgets/empty_state.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final carrito = appState.carrito;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi carrito'),
        actions: [
          if (carrito.isNotEmpty)
            IconButton(
              tooltip: 'Vaciar carrito',
              onPressed: () => _confirmarVaciar(context, appState),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: carrito.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 100),
                EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  titulo: 'Tu carrito está vacío',
                  mensaje:
                      'Agrega productos del menú para preparar tu pedido.',
                ),
              ],
            )
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal = constraints.maxWidth >= 760 ? 56.0 : 20.0;
                  return ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 150),
                    children: [
                      _CarritoHeader(
                        totalItems: appState.totalItemsCarrito,
                      ),
                      const SizedBox(height: 18),
                      for (final item in carrito) ...[
                        _CarritoItemCard(
                          nombre: item.producto.nombre,
                          descripcion: item.producto.descripcion,
                          precio: item.producto.precio,
                          subtotal: item.subtotal,
                          cantidad: item.cantidad,
                          maximo: item.producto.cantidadDisponible,
                          icono: item.producto.icono,
                          onIncrementar: () => appState.actualizarCantidad(
                            item.producto.id,
                            item.cantidad + 1,
                          ),
                          onDisminuir: () => appState.actualizarCantidad(
                            item.producto.id,
                            item.cantidad - 1,
                          ),
                          onEliminar: () => appState.eliminarDelCarrito(item.producto.id),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 4),
                      _ResumenCarrito(
                        totalItems: appState.totalItemsCarrito,
                        total: appState.totalCarrito,
                      ),
                      const SizedBox(height: 14),
                      _InfoPagoPendiente(),
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
                texto: 'Continuar a confirmación',
                icon: Icons.receipt_long_outlined,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.confirmacion),
              ),
            ),
    );
  }

  Future<void> _confirmarVaciar(BuildContext context, AppState appState) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text(
          'Se eliminarán todos los productos seleccionados de esta sesión.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vaciar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      for (final item in List.of(appState.carrito)) {
        appState.eliminarDelCarrito(item.producto.id);
      }
    }
  }
}

class _CarritoHeader extends StatelessWidget {
  const _CarritoHeader({required this.totalItems});

  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Revisa tu selección',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.verdeInstitucional.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$totalItems ${totalItems == 1 ? 'producto' : 'productos'}',
            style: const TextStyle(
              color: AppTheme.verdeInstitucional,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _CarritoItemCard extends StatelessWidget {
  const _CarritoItemCard({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.subtotal,
    required this.cantidad,
    required this.maximo,
    required this.icono,
    required this.onIncrementar,
    required this.onDisminuir,
    required this.onEliminar,
  });

  final String nombre;
  final String descripcion;
  final double precio;
  final double subtotal;
  final int cantidad;
  final int maximo;
  final String icono;
  final VoidCallback onIncrementar;
  final VoidCallback onDisminuir;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.verdeInstitucional.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _iconoProducto(icono),
                color: AppTheme.verdeInstitucional,
                size: 34,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textoPrincipal.withValues(alpha: 0.62),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      Text(
                        '\$${precio.toStringAsFixed(2)} c/u',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppTheme.verdeInstitucional,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _CantidadButton(
                        icon: Icons.remove,
                        onPressed: cantidad > 1 ? onDisminuir : null,
                        tooltip: 'Disminuir cantidad',
                      ),
                      SizedBox(
                        width: 42,
                        child: Text(
                          '$cantidad',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      _CantidadButton(
                        icon: Icons.add,
                        onPressed: cantidad < maximo ? onIncrementar : null,
                        tooltip: 'Aumentar cantidad',
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Eliminar producto',
                        onPressed: onEliminar,
                        icon: const Icon(Icons.delete_outline),
                        color: AppTheme.agotado,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CantidadButton extends StatelessWidget {
  const _CantidadButton({required this.icon, required this.onPressed, required this.tooltip});

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton.filledTonal(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
      ),
    );
  }
}

class _ResumenCarrito extends StatelessWidget {
  const _ResumenCarrito({required this.totalItems, required this.total});

  final int totalItems;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text('Productos')),
                Text('$totalItems'),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.verdeInstitucional,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPagoPendiente extends StatelessWidget {
  const _InfoPagoPendiente();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'El pago se realizará en efectivo al recoger el pedido.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconoProducto(String icono) {
  switch (icono) {
    case 'breakfast_dining':
      return Icons.breakfast_dining;
    case 'restaurant':
      return Icons.restaurant;
    case 'local_drink':
      return Icons.local_drink;
    case 'local_cafe':
      return Icons.local_cafe;
    case 'lunch_dining':
      return Icons.lunch_dining;
    case 'dinner_dining':
      return Icons.dinner_dining;
    case 'cake':
      return Icons.cake;
    default:
      return Icons.fastfood;
  }
}
