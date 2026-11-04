
class Producto {
  // Atributos del producto
  String id;
  String nombre;
  double precio;
  int stock;

  // Constructor
  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
  });

  // Metodo para aplicar descuento
  double aplicarDescuento(double porcentaje) {
    if (porcentaje < 0 || porcentaje > 100) {
      throw ArgumentError(
        'El descuento debe estar entre 0 y 100',
      );
    }

    double descuento = precio * (porcentaje / 100);

    precio = precio - descuento;

    return precio;
  }

  // Metodo para obtener los detalles del producto
  String obtenerDetalles() {
    return 'ID: $id, Nombre: $nombre, '
        'Precio: \$${precio.toStringAsFixed(2)}, '
        'Stock: $stock';
  }
}
