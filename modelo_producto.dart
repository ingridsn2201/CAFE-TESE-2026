class Producto {
  String id;
  String nombre;
  double precio;
  int stock;

  // Constructor
  Producto(this.id, this.nombre, this.precio, this.stock);

  // Metodo para reducir el stock
  void reducirStock() {
    if (stock > 0) {
      stock--;
    }
  }

  // Metodo para obtener los detalles del producto
  String obtenerDetalles() {
    return "ID: $id, Nombre: $nombre, Precio: $precio, Stock: $stock";
  }

  // Metodo para aplicar un descuento al precio
  void aplicarDescuento(double porcentaje) {
    precio = precio - (precio * porcentaje / 100);
  }
}
