import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/producto.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_principal.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  int _cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final productoId = ModalRoute.of(context)?.settings.arguments as String?;
    final producto = productoId == null
        ? appState.productos.first
        : appState.buscarProducto(productoId) ?? appState.productos.first;
    final disponible = producto.disponible && producto.cantidadDisponible > 0;
    final enCarrito = appState.carrito
        .where((item) => item.producto.id == producto.id)
        .fold(0, (total, item) => total + item.cantidad);

    final cantidadActual = disponible
        ? _cantidad.clamp(1, producto.cantidadDisponible).toInt()
        : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        actions: [
          IconButton(
            tooltip: 'Carrito',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.carrito),
            icon: Badge(
              isLabelVisible: appState.totalItemsCarrito > 0,
              label: Text('${appState.totalItemsCarrito}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 760 ? 56.0 : 20.0;
            return ListView(
              padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 28),
              children: [
                _ProductoHero(producto: producto, disponible: disponible),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        producto.nombre,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.verdeInstitucional,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoPill(
                      icon: Icons.category_outlined,
                      text: producto.categoria,
                    ),
                    _InfoPill(
                      icon: disponible ? Icons.check_circle_outline : Icons.cancel_outlined,
                      text: disponible ? 'Disponible' : 'Agotado',
                      color: disponible ? AppTheme.disponible : AppTheme.agotado,
                    ),
                    if (disponible)
                      _InfoPill(
                        icon: Icons.inventory_2_outlined,
                        text: '${producto.cantidadDisponible} disponibles',
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Descripción',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  producto.descripcion,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
                ),
                if (enCarrito > 0) ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.verdeInstitucional.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_cart_outlined,
                            color: AppTheme.verdeInstitucional),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '$enCarrito unidad${enCarrito == 1 ? '' : 'es'} de este producto en tu carrito.',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (disponible) ...[
                  Text(
                    'Cantidad',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  _CantidadSelector(
                    cantidad: cantidadActual,
                    minimo: 1,
                    maximo: producto.cantidadDisponible,
                    onChanged: (cantidad) => setState(() => _cantidad = cantidad),
                  ),
                  const SizedBox(height: 22),
                ],
                BotonPrincipal(
                  texto: disponible ? 'Agregar al carrito' : 'Producto agotado',
                  icon: Icons.add_shopping_cart,
                  onPressed: disponible
                      ? () {
                          appState.agregarAlCarrito(producto, cantidad: cantidadActual);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${producto.nombre} x$cantidadActual agregado al carrito.',
                              ),
                              action: SnackBarAction(
                                label: 'Ver carrito',
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.carrito,
                                ),
                              ),
                            ),
                          );
                        }
                      : null,
                ),
                if (appState.totalItemsCarrito > 0) ...[
                  const SizedBox(height: 12),
                  BotonPrincipal(
                    texto: 'Ver carrito (${appState.totalItemsCarrito})',
                    icon: Icons.shopping_cart_outlined,
                    secundario: true,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.carrito),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductoHero extends StatelessWidget {
  const _ProductoHero({required this.producto, required this.disponible});

  final Producto producto;
  final bool disponible;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.verdeInstitucional.withValues(alpha: 0.12),
            AppTheme.doradoAccion.withValues(alpha: 0.13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Icon(
          _iconoProducto(producto.icono),
          size: 96,
          color: disponible ? AppTheme.verdeInstitucional : AppTheme.agotado,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.textoPrincipal.withValues(alpha: 0.72);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: effectiveColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: effectiveColor, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _CantidadSelector extends StatelessWidget {
  const _CantidadSelector({
    required this.cantidad,
    required this.minimo,
    required this.maximo,
    required this.onChanged,
  });

  final int cantidad;
  final int minimo;
  final int maximo;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Disminuir',
            onPressed: cantidad > minimo ? () => onChanged(cantidad - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 48,
            child: Text(
              '$cantidad',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          IconButton(
            tooltip: 'Aumentar',
            onPressed: cantidad < maximo ? () => onChanged(cantidad + 1) : null,
            icon: const Icon(Icons.add),
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
