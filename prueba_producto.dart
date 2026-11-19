import 'modelo_producto.dart';

void main() {
  Producto producto = Producto("P01", "Hamburguesa", 50.0, 10);

  print("DATOS DEL PRODUCTO");
  print(producto.obtenerDetalles());

  producto.aplicarDescuento(20);

  print("PRECIO CON DESCUENTO");
  print(producto.precio);

  producto.reducirStock();

  print("STOCK ACTUALIZADO");
  print(producto.stock);
}
