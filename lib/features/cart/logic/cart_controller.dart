
import 'package:flutter/foundation.dart';

import '../../../modelo_producto.dart';
import '../../../core/models/cart_item.dart';

class CartController extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items =>
      List.unmodifiable(_items.values);

  double get total => _items.values.fold(
    0.0,
    (suma, item) => suma + item.subtotal,
  );

  int cantidadDe(String productoId) {
    return _items[productoId]?.cantidad ?? 0;
  }

  void agregarProducto(Producto producto, int cantidad) {
    if (cantidad <= 0) {
      throw StateError('La cantidad debe ser mayor que cero');
    }

    final actual = cantidadDe(producto.id);
    actualizarCantidad(producto, actual + cantidad);
  }

  void actualizarCantidad(
    Producto producto,
    int cantidad,
  ) {
    if (cantidad <= 0) {
      eliminarProducto(producto.id);
      return;
    }

    if (cantidad > producto.stock) {
      throw StateError('No hay suficiente stock');
    }

    _items[producto.id] = CartItem(
      producto: producto,
      cantidad: cantidad,
    );

    notifyListeners();
  }

  void eliminarProducto(String productoId) {
    _items.remove(productoId);
    notifyListeners();
  }

  void vaciarCarrito() {
    _items.clear();
    notifyListeners();
  }
}
