
class Producto {
  String id;
  String nombre;
  double precio;
  int stock;

  Producto(this.id, this.nombre, this.precio, this.stock);

  void aplicarDescuento(double porcentaje) {
    if (porcentaje >= 0 && porcentaje <= 100) {
      double descuento = precio * (porcentaje / 100);
      precio = precio - descuento;
    }
  }
}
