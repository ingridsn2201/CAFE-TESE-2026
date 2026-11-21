
import '../../modelo_producto.dart';

class CartItem {
  final Producto producto;
  final int cantidad;

  CartItem({
    required this.producto,
    required this.cantidad,
  });

  double get subtotal => producto.precio * cantidad;
}
