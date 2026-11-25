import 'package:flutter/material.dart';

import '../screens/admin_screen.dart';
import '../screens/bienvenida_screen.dart';
import '../screens/carrito_screen.dart';
import '../screens/confirmacion_screen.dart';
import '../screens/estado_pedido_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/pedido_realizado_screen.dart';
import '../screens/producto_screen.dart';
import '../screens/registro_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const bienvenida = '/';
  static const login = '/login';
  static const registro = '/registro';
  static const menu = '/menu';
  static const producto = '/producto';
  static const carrito = '/carrito';
  static const confirmacion = '/confirmacion';
  static const pedidoRealizado = '/pedido-realizado';
  static const estadoPedido = '/estado-pedido';
  static const admin = '/admin';

  static Map<String, WidgetBuilder> buildRoutes() {
    return {
      bienvenida: (_) => const BienvenidaScreen(),
      login: (_) => const LoginScreen(),
      registro: (_) => const RegistroScreen(),
      menu: (_) => const MenuScreen(),
      producto: (_) => const ProductoScreen(),
      carrito: (_) => const CarritoScreen(),
      confirmacion: (_) => const ConfirmacionScreen(),
      pedidoRealizado: (_) => const PedidoRealizadoScreen(),
      estadoPedido: (_) => const EstadoPedidoScreen(),
      admin: (_) => const AdminScreen(),
    };
  }
}
