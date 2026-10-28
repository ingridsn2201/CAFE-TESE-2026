# Seguridad y Control de Acceso

La estrategia de seguridad de APP CAFETESE se fundamenta en la verificación estricta en el servidor mediante Firebase Authentication y las Reglas de Seguridad de Firestore.

## Mecanismos de Seguridad

1. **Autenticación:**
   - Registro e inicio de sesión con correo institucional.
   - Identificación única por UID gestionada por Firebase.

2. **Control de Acceso Basado en Roles (RBAC):**
   - **Alumnos:** Permisos de lectura sobre el catálogo y escritura/lectura sobre sus propios pedidos.
   - **Administradores:** Permisos totales para crear, editar o eliminar productos, así como actualizar el estado de cualquier pedido.

3. **Integridad y Reglas de Negocio:**
   - Validación doble de stock y precios al momento de confirmar una orden.
   - Restricción de modificaciones en el historial de pedidos una vez confirmados.
