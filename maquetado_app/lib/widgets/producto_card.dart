import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';

class ProductoCard extends StatelessWidget {
  const ProductoCard({
    required this.producto,
    required this.onSeleccionar,
    required this.onAgregar,
    super.key,
  });

  final Producto producto;
  final VoidCallback onSeleccionar;
  final VoidCallback? onAgregar;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final disponible = producto.disponible && producto.cantidadDisponible > 0;
    final foregroundColor =
        disponible ? AppTheme.textoPrincipal : AppTheme.textoPrincipal.withValues(alpha: 0.55);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onSeleccionar,
        child: Opacity(
          opacity: disponible ? 1 : 0.72,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductoVisual(producto: producto, disponible: disponible),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              producto.nombre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium?.copyWith(
                                color: foregroundColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${producto.precio.toStringAsFixed(2)}',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppTheme.verdeInstitucional,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        producto.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: foregroundColor.withValues(alpha: 0.78),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _StatusPill(disponible: disponible),
                          _CategoryPill(categoria: producto.categoria),
                          if (disponible)
                            Text(
                              '${producto.cantidadDisponible} disp.',
                              style: textTheme.labelMedium?.copyWith(
                                color: AppTheme.textoPrincipal.withValues(alpha: 0.64),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: disponible ? onAgregar : null,
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: Text(disponible ? 'Agregar' : 'Agotado'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(118, 40),
                            backgroundColor: AppTheme.doradoAccion,
                            foregroundColor: AppTheme.textoPrincipal,
                            disabledBackgroundColor: Colors.grey.shade200,
                            disabledForegroundColor:
                                AppTheme.textoPrincipal.withValues(alpha: 0.46),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductoVisual extends StatelessWidget {
  const _ProductoVisual({
    required this.producto,
    required this.disponible,
  });

  final Producto producto;
  final bool disponible;

  @override
  Widget build(BuildContext context) {
    final background = disponible
        ? AppTheme.verdeInstitucional.withValues(alpha: 0.11)
        : AppTheme.agotado.withValues(alpha: 0.08);

    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _iconoProducto(producto.icono),
        color: disponible ? AppTheme.verdeInstitucional : AppTheme.agotado,
        size: 38,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.disponible});

  final bool disponible;

  @override
  Widget build(BuildContext context) {
    final color = disponible ? AppTheme.disponible : AppTheme.agotado;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        disponible ? 'Disponible' : 'Agotado',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.categoria});

  final String categoria;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        categoria,
        style: TextStyle(
          color: AppTheme.textoPrincipal.withValues(alpha: 0.70),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
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
