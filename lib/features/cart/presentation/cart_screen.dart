
import 'package:flutter/material.dart';

import '../logic/cart_controller.dart';

class CartScreen extends StatelessWidget {
  final CartController carrito;

  const CartScreen({
    super.key,
    required this.carrito,
  });

  static const Color cafe = Color(0xFF795548);
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color crema = Color(0xFFFFF8F0);
  static const Color beige = Color(0xFFFFEDE5);

  void cambiarCantidad(
    BuildContext context,
    String productoId,
    int nuevaCantidad,
  ) {
    final item = carrito.items.firstWhere(
      (elemento) => elemento.producto.id == productoId,
    );

    try {
      carrito.actualizarCantidad(
        item.producto,
        nuevaCantidad,
      );
    } on StateError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: cafeOscuro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: crema,
      appBar: AppBar(
  title: const Text('Mi carrito'),
  backgroundColor: cafe,
  foregroundColor: Colors.white,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.of(context).pop();
    },
  ),
),

      body: ListenableBuilder(
        listenable: carrito,
        builder: (context, child) {
          if (carrito.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 90,
                    color: cafe,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: cafeOscuro,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Agrega productos desde el catálogo.',
                    style: TextStyle(color: cafe),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: carrito.items.length,
                  itemBuilder: (context, index) {
                    final item = carrito.items[index];
                    final producto = item.producto;

                    return Card(
                      color: beige,
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.fastfood,
                                  color: cafe,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    producto.nombre,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: cafeOscuro,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Eliminar producto',
                                  onPressed: () {
                                    carrito.eliminarProducto(
                                      producto.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Precio: \$${producto.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: cafeOscuro,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Cantidad:',
                                  style: TextStyle(
                                    color: cafeOscuro,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: cafe,
                                  ),
                                  tooltip: 'Disminuir cantidad',
                                  onPressed: () {
                                    cambiarCantidad(
                                      context,
                                      producto.id,
                                      item.cantidad - 1,
                                    );
                                  },
                                ),
                                Text(
                                  '${item.cantidad}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: cafe,
                                  ),
                                  tooltip: 'Aumentar cantidad',
                                  onPressed:
                                      item.cantidad < producto.stock
                                          ? () {
                                              cambiarCantidad(
                                                context,
                                                producto.id,
                                                item.cantidad + 1,
                                              );
                                            }
                                          : null,
                                ),
                                const Spacer(),
                                Text(
                                  '\$${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: cafeOscuro,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total: \$${carrito.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: cafeOscuro,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cafe,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                        icon: const Icon(
                          Icons.check_circle_outline,
                        ),
                        label: const Text(
                          'Confirmar pedido',
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'El registro del pedido '
                                'se integrará próximamente '
                                'con Firebase.',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
