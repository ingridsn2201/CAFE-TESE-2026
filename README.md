# Cafetería TESE - Maqueta funcional Flutter

Proyecto académico de la materia Fundamentos de Ingeniería de Software, grupo 5601, TESE.

La aplicación es una maqueta funcional multiplataforma para Android e iOS. Actualmente utiliza datos locales/mock y no tiene backend, base de datos ni pagos electrónicos.

## Flujo implementado

Bienvenida → Login/Registro → Menú → Detalle de producto → Carrito → Confirmación → Pedido creado → Seguimiento.

También incluye un panel administrativo simulado para gestionar productos y actualizar estados de pedidos.

## Credenciales de demostración

Usuario:
- Correo: alumno@tese.edu.mx
- Contraseña: 123456

Administrador:
- Correo: admin@tese.edu.mx
- Contraseña: admin123

## Ejecutar

```bash
flutter pub get
flutter run -d chrome
```

Para Android, inicia un emulador o conecta un dispositivo y ejecuta:

```bash
flutter devices
flutter run -d ID_DEL_DISPOSITIVO
```

## Alcance actual

- Material 3.
- Diseño responsive para Android/iOS y navegador.
- Datos mock locales.
- Menú con búsqueda y categorías.
- Disponibilidad de productos.
- Detalle y selección de cantidad.
- Carrito con modificación y eliminación.
- Confirmación de pedido.
- Número de pedido.
- Seguimiento por estados.
- Panel administrativo simulado.
- Creación y edición local de productos.
- Cambio de disponibilidad.
- Actualización de estados de pedidos.

## Pendientes para una implementación real

La integración de backend, base de datos, autenticación real y pagos electrónicos no forma parte de esta maqueta. Los métodos de pago y las políticas operativas deben validarse con el personal de cafetería antes de convertirlos en requisitos definitivos.
