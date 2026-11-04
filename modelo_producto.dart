class Producto {
  String id;
  String nombre;
  double precio;
  int stock;

  // Constructor
  Producto(this.id, this.nombre, this.precio, this.stock);

  // Método para aplicar descuento
  void aplicarDescuento(double porcentaje) {
    precio = precio - (precio * (porcentaje / 100));
  }
}