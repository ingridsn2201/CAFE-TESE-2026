import 'package:flutter/material.dart';

import '../modelo_producto.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final List<Producto> listaProductos = [
    Producto(
      idProducto: '1',
      nombre: 'Café Americano',
      precio: 35.0,
      stock: 20,
      disponible: true,
    ),
    Producto(
      idProducto: '2',
      nombre: 'Capuchino',
      precio: 50.0,
      stock: 15,
      disponible: true,
    ),
    Producto(
      idProducto: '3',
      nombre: 'Panini de Pollo',
      precio: 65.0,
      stock: 8,
      disponible: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú - CAFÉ TESE'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: listaProductos.length,
        itemBuilder: (context, index) {
          final producto = listaProductos[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.coffee, color: Colors.brown),
              title: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Precio: \$${producto.precio} | Stock: ${producto.stock}'),
              trailing: IconButton(
                icon: const Icon(Icons.local_offer, color: Colors.green),
                onPressed: () {
                  producto.aplicarDescuento(10);
                  print('Nuevo precio con descuento para ${producto.nombre}: \$${producto.precio}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}