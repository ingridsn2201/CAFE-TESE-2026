import 'package:flutter/material.dart';

import '../../../modelo_producto.dart';
import '../../cart/logic/cart_controller.dart';
import '../../cart/presentation/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Producto producto;
  final CartController carrito;

  const ProductDetailScreen({
    super.key,
    required this.producto,
    required this.carrito,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final disponible = producto.stock > 0;
    final subtotal = producto.precio * cantidad;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(
                    carrito: widget.carrito,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.fastfood,
                size: 110,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              producto.nombre,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              producto.descripcion,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            Text(
              'Precio: \$${producto.precio.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              disponible
                  ? 'Disponibles: ${producto.stock}'
                  : 'Producto agotado',
              style: TextStyle(
                color: disponible
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Selecciona la cantidad:',
              style: TextStyle(fontSize: 18),
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                  onPressed: cantidad > 1
                      ? () {
                          setState(() {
                            cantidad--;
                          });
                        }
                      : null,
                ),

                Text(
                  '$cantidad',
                  style: const TextStyle(fontSize: 22),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                  onPressed:
                      disponible && cantidad < producto.stock
                      ? () {
                          setState(() {
                            cantidad++;
                          });
                        }
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              'Subtotal: \$${subtotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
                onPressed: disponible
                    ? () {
                        try {
                          widget.carrito.agregarProducto(
                            producto,
                            cantidad,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Producto agregado al carrito',
                              ),
                            ),
                          );
                        } on StateError catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(e.message),
                            ),
                          );
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
