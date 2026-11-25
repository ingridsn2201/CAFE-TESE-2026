import 'package:flutter/material.dart';
import 'modelo_producto.dart';
import 'features/cart/logic/cart_controller.dart';
import 'features/cart/presentation/cart_screen_v2.dart';
import 'features/catalog/presentation/product_detail_screen_v2.dart';
void main() {
  runApp(const CafeTESEApp());
}

const Color cafe = Color(0xFF795548);
const Color cafeOscuro = Color(0xFF4E342E);
const Color crema = Color(0xFFFFF8EF);
const Color beige = Color(0xFFEADBC8);

class CafeTESEApp extends StatelessWidget {
  const CafeTESEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAFETESE',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: crema,
        colorScheme: ColorScheme.fromSeed(seedColor: cafe),
      ),
      home: const Bienvenida(),
    );
  }
}

// PANTALLA DE BIENVENIDA

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: beige,
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: const Icon(
                    Icons.local_cafe,
                    size: 90,
                    color: cafeOscuro,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'CAFETESE',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: cafeOscuro,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '¡Tu cafetería, a un toque!',
                  style: TextStyle(
                    fontSize: 19,
                    color: cafe,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Realiza tus pedidos fácilmente y disfruta '
                  'más de tu tiempo en el TESE.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: cafeOscuro,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 45),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cafe,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InicioSesion(),
                        ),
                      );
                    },
                    child: const Text('INICIAR SESIÓN'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cafeOscuro,
                      side: const BorderSide(color: cafe),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Registro(),
                        ),
                      );
                    },
                    child: const Text('CREAR CUENTA'),
                  ),
                ),
                const SizedBox(height: 45),
                const Text(
                  'Tecnológico de Estudios Superiores de Ecatepec',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cafe, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// INICIO DE SESIÓN

class InicioSesion extends StatelessWidget {
  const InicioSesion({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaAcceso(
      titulo: 'Iniciar sesión',
      registro: false,
    );
  }
}

// REGISTRO

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaAcceso(
      titulo: 'Crear cuenta',
      registro: true,
    );
  }
}

// FORMULARIOS DE ACCESO

class PantallaAcceso extends StatefulWidget {
  final String titulo;
  final bool registro;

  const PantallaAcceso({
    super.key,
    required this.titulo,
    required this.registro,
  });

  @override
  State<PantallaAcceso> createState() => _PantallaAccesoState();
}

class _PantallaAccesoState extends State<PantallaAcceso> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void continuar() {
    if (correoController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        (widget.registro && nombreController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos.'),
        ),
      );
      return;
    }

    if (widget.registro) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro de demostración. Próximamente Firebase.'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Catalogo(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: crema,
        foregroundColor: cafeOscuro,
        title: Text(widget.titulo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.local_cafe,
              color: cafe,
              size: 75,
            ),
            const SizedBox(height: 25),
            Text(
              widget.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: cafeOscuro,
              ),
            ),
            const SizedBox(height: 30),
            if (widget.registro) ...[
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
            ],
            TextField(
              controller: correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cafe,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              onPressed: continuar,
              child: Text(widget.registro ? 'REGISTRARME' : 'ENTRAR'),
            ),
          ],
        ),
      ),
    );
  }
}

// CATÁLOGO DE PRODUCTOS

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

  @override
  State<Catalogo> createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  final CartController carrito = CartController();

  final List<Producto> productos = [
    Producto(
      id: '1',
      nombre: 'Café frío',
      precio: 45,
      stock: 10,
      descripcion: 'Café preparado con hielo.',
    ),
    Producto(
      id: '2',
      nombre: 'Sándwich',
      precio: 50,
      stock: 8,
      descripcion: 'Sándwich de jamón y queso.',
    ),
    Producto(
      id: '3',
      nombre: 'Muffin',
      precio: 30,
      stock: 12,
      descripcion: 'Muffin de chocolate.',
    ),
    Producto(
      id: '4',
      nombre: 'Jugo natural',
      precio: 35,
      stock: 7,
      descripcion: 'Jugo de naranja natural.',
    ),
  ];

  @override
  void dispose() {
    carrito.dispose();
    super.dispose();
  }

  void abrirDetalle(Producto producto) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProductDetailScreenV2(
        producto: producto,
        carrito: carrito,
      ),
    ),
  );
}

  void abrirCarrito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreenV2(carrito: carrito),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cafe,
        foregroundColor: Colors.white,
        title: const Text('CAFETESE - Menú'),
        actions: [
          ListenableBuilder(
            listenable: carrito,
            builder: (context, child) {
              final cantidad = carrito.items.fold<int>(
                0,
                (suma, item) => suma + item.cantidad,
              );

              return IconButton(
                tooltip: 'Ver carrito',
                icon: Badge(
                  label: Text('$cantidad'),
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: abrirCarrito,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '¡Bienvenido a nuestra cafetería!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cafeOscuro,
            ),
          ),
          const SizedBox(height: 8),
          const Text('Selecciona tus productos favoritos.'),
          const SizedBox(height: 20),
          ...productos.map(
            (producto) => Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 14),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const CircleAvatar(
                  backgroundColor: beige,
                  child: Icon(Icons.local_cafe, color: cafeOscuro),
                ),
                title: Text(
                  producto.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${producto.descripcion}\n'
                  '\$${producto.precio.toStringAsFixed(2)}'
                  ' | Disponibles: ${producto.stock}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right, color: cafe),
                onTap: () => abrirDetalle(producto),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
