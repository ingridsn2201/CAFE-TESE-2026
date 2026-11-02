class Producto {
  // Atributos tipados
  String idProducto;
  String nombre;
  double precio;
  int stock;
  bool disponible;

  // Constructor
  Producto({
    required this.idProducto,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.disponible,
  });

  // Método para aplicar un descuento al precio
  void aplicarDescuento(double porcentaje) {
    if (porcentaje > 0 && porcentaje <= 100) {
      double descuento = precio * (porcentaje / 100);
      precio -= descuento;
    }
  }

  // Método opcional para convertir el objeto a un formato legible (útil para pruebas o Firestore)
  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'disponible': disponible,
    };
  }
}