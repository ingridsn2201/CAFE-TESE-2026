class FirestorePaths {
  FirestorePaths._();

  static const String productosCollection = 'productos';
  static const String pedidosCollection = 'pedidos';

  static const String fieldIdProducto = 'idProducto';
  static const String fieldNombre = 'nombre';
  static const String fieldPrecio = 'precio';
  static const String fieldStock = 'stock';
  static const String fieldDisponible = 'disponible';

  static const String fieldUsuarioId = 'usuarioId';
  static const String fieldItems = 'items';
  static const String fieldTotal = 'total';
  static const String fieldEstado = 'estado';
  static const String fieldFechaCreacion = 'fechaCreacion';
  static const String fieldMetodoPago = 'metodoPago';

  static const String estadoRecibido = 'recibido';
  static const String estadoEnPreparacion = 'en_preparacion';
  static const String estadoListo = 'listo';
  static const String estadoEntregado = 'entregado';
  static const String estadoCancelado = 'cancelado';
}