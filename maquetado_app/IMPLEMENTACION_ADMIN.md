# Implementación del módulo administrativo - Cafetería TESE

## Funciones incluidas en el prototipo

- Selector de modo de inicio de sesión: Cliente o Administrador.
- Validación del rol después de verificar las credenciales.
- El modo Cliente permite acceder a usuarios que no tengan rol de administrador, incluido el personal de cafetería.
- Panel administrativo con indicadores de productos, disponibilidad y pedidos.
- Gestión de productos: alta, edición, búsqueda y filtro por categoría.
- Control de disponibilidad mediante interruptor.
- Gestión de pedidos: búsqueda por identificador, filtro por estado y actualización de estado con confirmación.
- Estados disponibles: Recibido, En preparación, Listo, Entregado y Cancelado.
- Aviso visible que aclara que se trata de datos de demostración.

## Cuentas de demostración local

Estas cuentas funcionan únicamente con los datos mock del proyecto:

- Cliente alumno: `alumno@tese.edu.mx` / `123456`
- Cliente personal de cafetería: `cafeteria@tese.edu.mx` / `cafe123`
- Administrador: `admin@tese.edu.mx` / `admin123`

En el selector de acceso, elige Cliente para las dos primeras cuentas y Administrador para la tercera.

## Limitaciones actuales

La aplicación todavía usa `AppState` y datos de demostración en memoria. Los cambios en productos, disponibilidad y estados de pedidos no persisten al cerrar o reiniciar la aplicación. Firebase Authentication y Cloud Firestore aún no están conectados.

El selector de modo ayuda a orientar la navegación, pero no sustituye la seguridad real. Antes de publicar, los roles deben validarse con Firebase y protegerse mediante reglas de seguridad de Firestore y mecanismos confiables de asignación de roles. No debe permitirse que un usuario se otorgue el rol de administrador desde el cliente.
