
class Producto {
  String id;
  String nombre;
  double precio;
  int stock;
  String descripcion;

  // Constructor de la clase Producto
  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.descripcion,
  });

  // Método para aplicar un descuento
  void aplicarDescuento(double porcentaje) {
    if (porcentaje >= 0 && porcentaje <= 100) {
      double descuento = precio * porcentaje / 100;
      precio = precio - descuento;
    }
  }

  // Método para reducir el inventario
  void reducirStock(int cantidad) {
    if (cantidad > 0 && cantidad <= stock) {
      stock = stock - cantidad;
    }
  }
}
