# Arquitectura del Sistema - APP CAFETESE

El sistema APP CAFETESE adopta una arquitectura por capas, diseñada para garantizar la separación de responsabilidades, la escalabilidad y el fácil mantenimiento del código.

## Capas del Sistema

1. **Capa de Presentación (Flutter):**
   - **Módulo de Alumno:** Vista del catálogo, detalle de producto, carrito de compras, confirmación y seguimiento del pedido.
   - **Módulo Administrativo:** Panel de control, gestión del catálogo, control de existencias y cambio de estados de pedidos.

2. **Capa de Lógica de Negocio (Dart):**
   - Validaciones del carrito y reglas de negocio.
   - Cálculo dinámico de subtotales y totales.
   - Control de estados del flujo del pedido.

3. **Capa de Acceso a Datos (Repositorios):**
   - Abstracción para la consulta y persistencia de información.
   - Desacopla las vistas directas de la base de datos Firestore.

4. **Capa de Servicios en la Nube (Firebase):**
   - **Firebase Authentication:** Gestión de credenciales y tokens de sesión.
   - **Cloud Firestore:** Base de datos NoSQL para almacenamiento en tiempo real.
