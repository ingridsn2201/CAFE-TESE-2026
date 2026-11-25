import 'package:flutter/material.dart';

import '../data/mock_pedidos.dart';
import '../data/mock_productos.dart';
import '../data/mock_usuario.dart';
import '../models/carrito_item.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../models/usuario.dart';

class AppState extends ChangeNotifier {
  AppState({
    required List<Producto> productos,
    required List<Pedido> pedidos,
    required List<Usuario> usuarios,
  })  : _productos = productos,
        _pedidos = pedidos,
        _usuarios = usuarios;

  factory AppState.demo() {
    return AppState(
      productos: List<Producto>.from(productosMock),
      pedidos: List<Pedido>.from(pedidosMock),
      usuarios: List<Usuario>.from(usuariosMock),
    );
  }

  final List<CarritoItem> _carrito = [];
  List<Producto> _productos;
  List<Pedido> _pedidos;
  List<Usuario> _usuarios;
  Usuario? _usuarioActual;
  Pedido? _pedidoActivo;

  List<Producto> get productos => List.unmodifiable(_productos);
  List<CarritoItem> get carrito => List.unmodifiable(_carrito);
  List<Pedido> get pedidos => List.unmodifiable(_pedidos);
  List<Usuario> get usuarios => List.unmodifiable(_usuarios);
  Usuario? get usuarioActual => _usuarioActual;
  Usuario get usuario => _usuarioActual ?? usuarioMock;
  Pedido? get pedidoActivo => _pedidoActivo;

  double get totalCarrito =>
      _carrito.fold(0, (total, item) => total + item.subtotal);

  int get totalItemsCarrito =>
      _carrito.fold(0, (total, item) => total + item.cantidad);

  Producto? buscarProducto(String id) {
    for (final producto in _productos) {
      if (producto.id == id) return producto;
    }
    return null;
  }

  bool existeCorreo(String correo) {
    final normalizado = correo.trim().toLowerCase();
    return _usuarios.any(
      (usuario) => usuario.correo.toLowerCase() == normalizado,
    );
  }

  bool iniciarSesion({
    required String correo,
    required String contrasena,
  }) {
    final normalizado = correo.trim().toLowerCase();
    for (final usuario in _usuarios) {
      if (usuario.correo.toLowerCase() == normalizado &&
          usuario.contrasenaMock == contrasena) {
        _usuarioActual = usuario;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Usuario registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
  }) {
    final usuario = Usuario(
      nombre: nombre.trim(),
      correo: correo.trim().toLowerCase(),
      rol: RolUsuario.alumno,
      contrasenaMock: contrasena,
    );
    _usuarios = [..._usuarios, usuario];
    _usuarioActual = usuario;
    notifyListeners();
    return usuario;
  }

  void cerrarSesion() {
    _usuarioActual = null;
    _carrito.clear();
    _pedidoActivo = null;
    notifyListeners();
  }

  void agregarAlCarrito(Producto producto, {int cantidad = 1}) {
    if (!producto.disponible || producto.cantidadDisponible <= 0) return;

    final index = _carrito.indexWhere((item) => item.producto.id == producto.id);
    final cantidadSegura = cantidad.clamp(1, producto.cantidadDisponible).toInt();

    if (index == -1) {
      _carrito.add(CarritoItem(producto: producto, cantidad: cantidadSegura));
    } else {
      final item = _carrito[index];
      final nuevaCantidad = (item.cantidad + cantidadSegura)
          .clamp(1, producto.cantidadDisponible)
          .toInt();
      _carrito[index] = item.copyWith(cantidad: nuevaCantidad);
    }
    notifyListeners();
  }

  void actualizarCantidad(String productoId, int cantidad) {
    final index = _carrito.indexWhere((item) => item.producto.id == productoId);
    if (index == -1) return;

    if (cantidad <= 0) {
      _carrito.removeAt(index);
    } else {
      final item = _carrito[index];
      final segura = cantidad.clamp(1, item.producto.cantidadDisponible).toInt();
      _carrito[index] = item.copyWith(cantidad: segura);
    }
    notifyListeners();
  }

  void eliminarDelCarrito(String productoId) {
    _carrito.removeWhere((item) => item.producto.id == productoId);
    notifyListeners();
  }

  Pedido confirmarPedido() {
    if (_carrito.isEmpty) {
      throw StateError('No se puede confirmar un carrito vacío.');
    }

    for (final item in _carrito) {
      final productoActual = buscarProducto(item.producto.id);
      if (productoActual == null ||
          !productoActual.disponible ||
          productoActual.cantidadDisponible < item.cantidad) {
        throw StateError(
          'El producto ${item.producto.nombre} ya no tiene disponibilidad suficiente.',
        );
      }
    }

    final numero = (_pedidos.length + 1).toString().padLeft(3, '0');
    final pedido = Pedido(
      id: 'TESE-$numero',
      items: List<CarritoItem>.from(_carrito),
      total: totalCarrito,
      estado: EstadoPedido.recibido,
      fechaCreacion: DateTime.now(),
    );

    _pedidos = [..._pedidos, pedido];
    _productos = [
      for (final producto in _productos)
        _descontarProductoConfirmado(producto),
    ];
    _pedidoActivo = pedido;
    _carrito.clear();
    notifyListeners();
    return pedido;
  }

  Producto _descontarProductoConfirmado(Producto producto) {
    final solicitado = _carrito
        .where((item) => item.producto.id == producto.id)
        .fold<int>(0, (total, item) => total + item.cantidad);
    if (solicitado == 0) return producto;

    final nuevaCantidad = (producto.cantidadDisponible - solicitado)
        .clamp(0, producto.cantidadDisponible)
        .toInt();
    return producto.copyWith(
      cantidadDisponible: nuevaCantidad,
      disponible: producto.disponible && nuevaCantidad > 0,
    );
  }

  void seleccionarPedidoActivo(String pedidoId) {
    for (final pedido in _pedidos) {
      if (pedido.id == pedidoId) {
        _pedidoActivo = pedido;
        notifyListeners();
        return;
      }
    }
  }

  void actualizarEstadoPedido(String pedidoId, EstadoPedido estado) {
    _pedidos = [
      for (final pedido in _pedidos)
        pedido.id == pedidoId ? pedido.copyWith(estado: estado) : pedido,
    ];

    if (_pedidoActivo?.id == pedidoId) {
      _pedidoActivo = _pedidoActivo!.copyWith(estado: estado);
    }
    notifyListeners();
  }

  void guardarProducto(Producto producto) {
    final index = _productos.indexWhere((item) => item.id == producto.id);
    if (index == -1) {
      _productos = [..._productos, producto];
    } else {
      _productos = [
        for (final item in _productos)
          item.id == producto.id ? producto : item,
      ];
    }
    notifyListeners();
  }

  void alternarDisponibilidad(String productoId) {
    _productos = [
      for (final producto in _productos)
        if (producto.id == productoId)
          producto.copyWith(disponible: !producto.disponible)
        else
          producto,
    ];
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    required AppState super.notifier,
    required super.child,
    super.key,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope no está disponible en el árbol.');
    return scope!.notifier!;
  }
}
