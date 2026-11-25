import 'dart:math' as math;
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../modelo_producto.dart';
import '../../cart/logic/cart_controller.dart';
import '../../cart/presentation/cart_screen_v2.dart';

class ProductDetailScreenV2 extends StatefulWidget {
  final Producto producto;
  final CartController carrito;

  const ProductDetailScreenV2({
    super.key,
    required this.producto,
    required this.carrito,
  });

  @override
  State<ProductDetailScreenV2> createState() =>
      _ProductDetailScreenV2State();
}

class _ProductDetailScreenV2State
    extends State<ProductDetailScreenV2> {
  int cantidad = 1;
  final AudioPlayer _audio = AudioPlayer();
  Uint8List tono(double frecuencia) {
    const tasa = 22050;
    const muestras = 3307;
    final b = ByteData(44 + muestras * 2);
    void texto(int pos, String s) {
      for (var i = 0; i < s.length; i++) {
        b.setUint8(pos + i, s.codeUnitAt(i));
      }
    }
    texto(0, 'RIFF');
    b.setUint32(4, b.lengthInBytes - 8, Endian.little);
    texto(8, 'WAVE');
    texto(12, 'fmt ');
    b.setUint32(16, 16, Endian.little);
    b.setUint16(20, 1, Endian.little);
    b.setUint16(22, 1, Endian.little);
    b.setUint32(24, tasa, Endian.little);
    b.setUint32(28, tasa * 2, Endian.little);
    b.setUint16(32, 2, Endian.little);
    b.setUint16(34, 16, Endian.little);
    texto(36, 'data');
    b.setUint32(40, muestras * 2, Endian.little);
    for (var i = 0; i < muestras; i++) {
      final envolvente = math.min(1.0, i / 150) * (1 - i / muestras);
      b.setInt16(44 + i * 2,
          (6500 * envolvente * math.sin(2 * math.pi * frecuencia * i / tasa)).round(),
          Endian.little);
    }
    return b.buffer.asUint8List();
  }

  Future<void> reproducir(double frecuencia) async {
    
    try {
      
      if (!mounted) return;
      await _audio.play(BytesSource(tono(frecuencia), mimeType: 'audio/wav'));
    } catch (e) {
      debugPrint('Audio del carrito: $e');
    }
  }


  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final disponible = producto.stock > 0;
    final subtotal = producto.precio * cantidad;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        backgroundColor: const Color(0xFFE17B32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: ListenableBuilder(
              listenable: widget.carrito,
              builder: (context, child) {
                final total = widget.carrito.items.fold<int>(0, (s, i) => s + i.cantidad);
                return Badge(backgroundColor: Colors.red, isLabelVisible: total > 0,
                  label: Text('$total'), child: const Icon(Icons.shopping_cart));
              },
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreenV2(
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
                          reproducir(440);
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
                          reproducir(880);
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
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C481B), foregroundColor: Colors.white, padding: const EdgeInsets.all(18)),
                onPressed: disponible
                    ? () {
                        try {
                          widget.carrito.agregarProducto(
                            producto,
                            cantidad,
                          );
                          reproducir(1040);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                '¡Producto agregado al carrito!',
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