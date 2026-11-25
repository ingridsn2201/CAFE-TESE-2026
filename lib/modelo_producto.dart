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

  // Convierte el objeto a mapa (útil para pruebas o Firestore)
  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'disponible': disponible,
    };
  }

  // Crea un Producto a partir de un mapa (por ejemplo, un documento de Firestore)
  factory Producto.fromMap(Map<String, dynamic> map, {String? docId}) {
    final precioRaw = map['precio'];
    final stockRaw = map['stock'];

    return Producto(
      idProducto: (map['idProducto'] ?? docId ?? '').toString(),
      nombre: (map['nombre'] ?? '').toString(),
      precio: precioRaw is num ? precioRaw.toDouble() : 0.0,
      stock: stockRaw is int ? stockRaw : int.tryParse(stockRaw?.toString() ?? '') ?? 0,
      disponible: map['disponible'] is bool ? map['disponible'] as bool : false,
    );
  }

  // Devuelve una copia modificando solo los campos indicados
  Producto copyWith({
    String? idProducto,
    String? nombre,
    double? precio,
    int? stock,
    bool? disponible,
  }) {
    return Producto(
      idProducto: idProducto ?? this.idProducto,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      disponible: disponible ?? this.disponible,
    );
  }
}