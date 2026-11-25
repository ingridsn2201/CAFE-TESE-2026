import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../logic/cart_controller.dart';

class CartScreenV2 extends StatefulWidget {
  final CartController carrito;
  const CartScreenV2({super.key, required this.carrito});

  @override
  State<CartScreenV2> createState() => _CartScreenV2State();
}

class _CartScreenV2State extends State<CartScreenV2> {
  static const chocolate = Color(0xFF64341F);
  static const caramelo = Color(0xFFE17B32);
  static const crema = Color(0xFFFFF3E6);
  final AudioPlayer _audio = AudioPlayer();
  bool sonido = true;
  CartController get carrito => widget.carrito;

  // Genera un sonido WAV breve sin archivos de audio adicionales.
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
    if (!sonido) return;
    try {
      
      if (!mounted || !sonido) return;
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

  void aviso(String mensaje, Color color, IconData icono) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(children: [Icon(icono, color: Colors.white),
          const SizedBox(width: 12), Expanded(child: Text(mensaje))]),
      ));
  }

  void cambiarCantidad(String id, int cantidad) {
    final item = carrito.items.firstWhere((e) => e.producto.id == id);
    final aumenta = cantidad > item.cantidad;
    try {
      carrito.actualizarCantidad(item.producto, cantidad);
      reproducir(aumenta ? 880 : 440);
      aviso(aumenta ? '¡Producto agregado!' : 'Producto quitado',
          aumenta ? Colors.green.shade800 : chocolate,
          aumenta ? Icons.check_circle : Icons.remove_circle_outline);
    } on StateError catch (e) {
      aviso(e.message.toString(), Colors.red.shade800, Icons.warning_amber);
    }
  }

  Widget animado(String valor, TextStyle estilo) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 220),
    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
    child: Text(valor, key: ValueKey(valor), style: estilo),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: crema,
      appBar: AppBar(
        title: const Text('Mi carrito · V2'),
        foregroundColor: Colors.white,
        backgroundColor: chocolate,
        leading: IconButton(icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop()),
        actions: [IconButton(
          tooltip: sonido ? 'Silenciar sonidos' : 'Activar sonidos',
          icon: Icon(sonido ? Icons.volume_up : Icons.volume_off),
          onPressed: () { setState(() => sonido = !sonido); if (!sonido) _audio.stop(); },
        )],
      ),
      body: ListenableBuilder(listenable: carrito, builder: (context, child) {
        final cantidad = carrito.items.fold<int>(0, (suma, item) => suma + item.cantidad);
        return Column(children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [chocolate, caramelo]),
              borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('CAFETESE', style: TextStyle(color: Colors.white70, letterSpacing: 2)),
                Text('Tu selección', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
              ])),
              const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              const SizedBox(width: 8),
              animado('$cantidad', const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            ]),
          ),
          if (carrito.items.isEmpty)
            Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.shopping_cart_outlined, size: 90, color: caramelo),
              const SizedBox(height: 16),
              const Text('Tu carrito está vacío', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: chocolate)),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Volver al catálogo')),
            ])))
          else ...[
            Expanded(child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: carrito.items.length,
              itemBuilder: (context, index) {
                final item = carrito.items[index];
                final producto = item.producto;
                return Card(
                  key: ValueKey(producto.id), color: Colors.white, elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                    Row(children: [
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: crema, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.fastfood, color: caramelo, size: 30)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(producto.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: chocolate)),
                        Text('\$${producto.precio.toStringAsFixed(2)}', style: const TextStyle(color: chocolate)),
                      ])),
                      IconButton(tooltip: 'Eliminar producto', icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () {
                        carrito.eliminarProducto(producto.id);
                        reproducir(260);
                        aviso('Producto eliminado', Colors.red.shade800, Icons.delete_outline);
                      }),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      IconButton.filledTonal(tooltip: 'Disminuir cantidad', onPressed: () => cambiarCantidad(producto.id, item.cantidad - 1), icon: const Icon(Icons.remove)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: animado('${item.cantidad}', const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      IconButton.filled(style: IconButton.styleFrom(backgroundColor: caramelo, foregroundColor: Colors.white), tooltip: 'Aumentar cantidad', onPressed: item.cantidad < producto.stock ? () => cambiarCantidad(producto.id, item.cantidad + 1) : null, icon: const Icon(Icons.add)),
                      const Spacer(),
                      Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: animado('\$${item.subtotal.toStringAsFixed(2)}', const TextStyle(fontSize: 20, color: chocolate, fontWeight: FontWeight.bold)))),
                    ]),
                  ])),
                );
              },
            )),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: chocolate, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
              child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Total a pagar', style: TextStyle(color: Colors.white70)),
                animado('\$${carrito.total.toStringAsFixed(2)}', const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5BF52), foregroundColor: chocolate, padding: const EdgeInsets.all(16)),
                  icon: const Icon(Icons.check_circle_outline), label: const Text('Confirmar pedido'),
                  onPressed: () { reproducir(1100); aviso('El registro del pedido se integrará próximamente con Firebase.', chocolate, Icons.info_outline); },
                )),
              ])),
            ),
          ],
        ]);
      }),
    );
  }
}
