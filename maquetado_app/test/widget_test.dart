import 'package:cafe_tese/app/cafe_tese_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> abrirLogin(WidgetTester tester) async {
    await tester.pumpWidget(const CafeTeseApp());
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
  }

  Future<void> iniciarSesion(
    WidgetTester tester, {
    bool admin = false,
  }) async {
    await abrirLogin(tester);
    if (admin) {
      await tester.tap(find.text('Administrador'));
      await tester.pumpAndSettle();
    }
    await tester.enterText(
      find.byKey(const ValueKey('login-correo')),
      admin ? 'admin@tese.edu.mx' : 'alumno@tese.edu.mx',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-contrasena')),
      admin ? 'admin123' : '123456',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();
  }

  testWidgets('bienvenida muestra identidad y acciones principales', (tester) async {
    await tester.pumpWidget(const CafeTeseApp());
    expect(find.text('Cafetería TESE'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });

  group('Login y registro', () {
    testWidgets('login valida correo vacío', (tester) async {
      await abrirLogin(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
      await tester.pump();
      expect(find.text('Ingresa tu correo institucional.'), findsOneWidget);
    });

    testWidgets('login correcto lleva al menú', (tester) async {
      await iniciarSesion(tester);
      expect(find.text('Hola, Alumno'), findsOneWidget);
    });

    testWidgets('login de administrador lleva al panel', (tester) async {
      await iniciarSesion(tester, admin: true);
      expect(find.text('Panel administrativo'), findsWidgets);
      expect(find.text('Productos'), findsOneWidget);
    });

    testWidgets('registro valida contraseñas distintas', (tester) async {
      await tester.pumpWidget(const CafeTeseApp());
      await tester.tap(find.text('Crear cuenta'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('registro-nombre')),
        'Nuevo Alumno',
      );
      await tester.enterText(
        find.byKey(const ValueKey('registro-correo')),
        'nuevo@tese.edu.mx',
      );
      await tester.enterText(
        find.byKey(const ValueKey('registro-contrasena')),
        '123456',
      );
      await tester.enterText(
        find.byKey(const ValueKey('registro-confirmar')),
        '654321',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Crear cuenta'));
      await tester.pump();
      expect(find.text('Las contraseñas no coinciden.'), findsOneWidget);
    });
  });

  group('Menú', () {
    testWidgets('muestra productos y categorías', (tester) async {
      await iniciarSesion(tester);
      expect(find.text('Torta de huevo'), findsOneWidget);
      expect(find.text('Chilaquiles verdes'), findsOneWidget);
      expect(find.text('Todos'), findsOneWidget);
      expect(find.text('Bebidas'), findsWidgets);
    });

    testWidgets('categoría Bebidas filtra productos', (tester) async {
      await iniciarSesion(tester);
      await tester.tap(find.text('Bebidas').first);
      await tester.pumpAndSettle();
      expect(find.text('Agua de jamaica'), findsOneWidget);
      expect(find.text('Café americano'), findsOneWidget);
      expect(find.text('Torta de huevo'), findsNothing);
    });

    testWidgets('búsqueda filtra por nombre', (tester) async {
      await iniciarSesion(tester);
      await tester.enterText(
        find.byKey(const ValueKey('menu-busqueda')),
        'café',
      );
      await tester.pumpAndSettle();
      expect(find.text('Café americano'), findsOneWidget);
      expect(find.text('Torta de huevo'), findsNothing);
    });

    testWidgets('producto agotado no puede agregarse', (tester) async {
      await iniciarSesion(tester);
      await tester.enterText(
        find.byKey(const ValueKey('menu-busqueda')),
        'sandwich',
      );
      await tester.pumpAndSettle();
      final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Agotado'),
      );
      expect(boton.onPressed, isNull);
    });
  });

  group('Producto y carrito', () {
    testWidgets('detalle permite cambiar cantidad y agregar', (tester) async {
      await iniciarSesion(tester);
      await tester.tap(find.text('Torta de huevo'));
      await tester.pumpAndSettle();
      expect(find.text('Detalle del producto'), findsOneWidget);
      expect(find.text('Cantidad'), findsOneWidget);
      await tester.tap(find.byTooltip('Aumentar'));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Agregar al carrito'));
      await tester.pump();
      expect(find.textContaining('agregado al carrito'), findsOneWidget);
    });

    testWidgets('carrito permite modificar cantidad y eliminar', (tester) async {
      await iniciarSesion(tester);
      await tester.tap(find.text('Torta de huevo'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Agregar al carrito'));
      await tester.pump();
      await tester.tap(find.textContaining('Ver carrito').first);
      await tester.pumpAndSettle();
      expect(find.text('Mi carrito'), findsOneWidget);
      expect(find.text('Torta de huevo'), findsOneWidget);
      await tester.tap(find.byTooltip('Aumentar cantidad'));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
      await tester.tap(find.byTooltip('Eliminar producto'));
      await tester.pump();
      expect(find.text('Tu carrito está vacío'), findsOneWidget);
    });

    testWidgets('carrito vacío no permite continuar', (tester) async {
      await iniciarSesion(tester);
      await tester.tap(find.byTooltip('Carrito'));
      await tester.pumpAndSettle();
      expect(find.text('Tu carrito está vacío'), findsOneWidget);
    });
  });

  group('Pedido y seguimiento', () {
    testWidgets('puede confirmar pedido y ver número', (tester) async {
      await iniciarSesion(tester);
      await tester.tap(find.text('Torta de huevo'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Agregar al carrito'));
      await tester.pump();
      await tester.tap(find.textContaining('Ver carrito').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Continuar a confirmación'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Confirmar pedido'));
      await tester.pumpAndSettle();
      expect(find.text('¡Pedido realizado!'), findsOneWidget);
      expect(find.textContaining('#TESE-'), findsOneWidget);
    });
  });
}
