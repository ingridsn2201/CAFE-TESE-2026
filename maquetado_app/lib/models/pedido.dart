import 'carrito_item.dart';

enum EstadoPedido {
  recibido,
  enPreparacion,
  listo,
  entregado,
  cancelado,
}

extension EstadoPedidoTexto on EstadoPedido {
  String get etiqueta {
    switch (this) {
      case EstadoPedido.recibido:
        return 'Recibido';
      case EstadoPedido.enPreparacion:
        return 'En preparación';
      case EstadoPedido.listo:
        return 'Listo';
      case EstadoPedido.entregado:
        return 'Entregado';
      case EstadoPedido.cancelado:
        return 'Cancelado';
    }
  }
}

class Pedido {
  const Pedido({
    required this.id,
    required this.items,
    required this.total,
    required this.estado,
    required this.fechaCreacion,
  });

  final String id;
  final List<CarritoItem> items;
  final double total;
  final EstadoPedido estado;
  final DateTime fechaCreacion;

  Pedido copyWith({
    String? id,
    List<CarritoItem>? items,
    double? total,
    EstadoPedido? estado,
    DateTime? fechaCreacion,
  }) {
    return Pedido(
      id: id ?? this.id,
      items: items ?? this.items,
      total: total ?? this.total,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
