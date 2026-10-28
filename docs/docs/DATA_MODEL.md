# Modelo Conceptual de Datos (Cloud Firestore)

La base de datos utiliza Cloud Firestore (NoSQL) estructurada en colecciones y documentos.

## Colecciones Principales

### 1. `usuarios`
- `uid` (string): Identificador único de Firebase Auth.
- `nombre` (string): Nombre completo del usuario.
- `correo` (string): Correo institucional.
- `rol` (string): "Alumno" o "Administrador".
- `fechaRegistro` (timestamp): Fecha de creación de la cuenta.
- `activo` (boolean): Estado de la cuenta.

### 2. `productos`
- `productId` (string): ID único del producto.
- `nombre` (string): Nombre del producto o platillo.
- `descripcion` (string): Detalles e ingredientes.
- `precio` (number): Precio unitario ($).
- `categoriaId` (string): Categoría a la que pertenece.
- `disponible` (boolean): Disponibilidad para pedidos.
- `cantidadDisponible` (number): Stock en inventario.
- `imagenUrl` (string): Enlace a la imagen en Firebase Storage.

### 3. `categorias`
- `categoriaId` (string): ID de la categoría (Desayunos, Bebidas, etc.).
- `nombre` (string): Nombre de la categoría.
- `orden` (number): Prioridad de visualización.

### 4. `pedidos`
- `pedidoId` (string): Código de orden (ej. #TESE-001).
- `userId` (string): ID del alumno que realiza el pedido.
- `fechaCreacion` (timestamp): Hora exacta de la orden.
- `estado` (string): "recibido", "en_preparacion", "listo", "entregado", "cancelado".
- `total` (number): Importe total a pagar.
- `metodoPago` (string): "efectivo".

#### Subcolección `pedidos/{pedidoId}/productosPedido`
- `productId` (string): Referencia al producto original.
- `nombre` (string): Copia del nombre al momento de la compra.
- `precio` (number): Precio congelado en el momento del pedido.
- `cantidad` (number): Unidades solicitadas.
- `subtotal` (number): precio * cantidad.
