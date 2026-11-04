import 'modelo_producto.dart';

void main() {
  // Crear un producto
  Producto cafe = Producto(
    id: 'P001',
    nombre: 'Cafe',
    precio: 30.00,
    stock: 50,
  );

  // Mostrar informacion original
  print('PRODUCTO ORIGINAL');
  print(cafe.obtenerDetalles());

  // Aplicar descuento del 10%
  cafe.aplicarDescuento(10);

  // Mostrar informacion actualizada
  print('\nPRODUCTO CON DESCUENTO');
  print(cafe.obtenerDetalles());
}


