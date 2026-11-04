class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.icono,
    required this.disponible,
    required this.cantidadDisponible,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final String icono;
  final bool disponible;
  final int cantidadDisponible;

  Producto copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    double? precio,
    String? categoria,
    String? icono,
    bool? disponible,
    int? cantidadDisponible,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      categoria: categoria ?? this.categoria,
      icono: icono ?? this.icono,
      disponible: disponible ?? this.disponible,
      cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
    );
  }
}
