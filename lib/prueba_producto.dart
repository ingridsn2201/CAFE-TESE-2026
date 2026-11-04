
import 'modelo_producto.dart';

void main() {
  // Crear un producto
  Producto producto = Producto(
    id: '1',
    nombre: 'Café frío',
    precio: 100.0,
    stock: 10,
    descripcion: 'Café preparado con hielo',
  );

  print('========== PRODUCTO ORIGINAL ==========');
  print('ID: ${producto.id}');
  print('Nombre: ${producto.nombre}');
  print('Precio: \$${producto.precio.toStringAsFixed(2)}');
  print('Stock: ${producto.stock}');
  print('Descripción: ${producto.descripcion}');

  // Aplicar descuento del 20%
  print('\n========== APLICANDO DESCUENTO ==========');
  print('Descuento aplicado: 20%');

  producto.aplicarDescuento(20);

  print('\n========== RESULTADO FINAL ==========');
  print('Precio original: \$100.00');
  print('Nuevo precio: \$${producto.precio.toStringAsFixed(2)}');

  // Probar reducción de inventario
  producto.reducirStock(2);

  print('\n========== INVENTARIO ==========');
  print('Cantidad retirada: 2');
  print('Stock restante: ${producto.stock}');
}
