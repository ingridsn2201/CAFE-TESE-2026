
import 'package:flutter/material.dart';

void main() {
  runApp(const CafeTeseApp());
}

class CafeTeseApp extends StatelessWidget {
  const CafeTeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP CAFETESE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8D5A9E),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF9FC),
        useMaterial3: true,
      ),
      home: const BienvenidaPage(),
    );
  }
}

// MODELOS TEMPORALES
// Más adelante estos datos vendrán de Firebase.

class Producto {
  final String nombre;
  final double precio;
  final String categoria;
  bool disponible;

  Producto({
    required this.nombre,
    required this.precio,
    required this.categoria,
    this.disponible = true,
  });
}

class Pedido {
  final int numero;
  final List<String> productos;
  final double total;
  String estado;

  Pedido({
    required this.numero,
    required this.productos,
    required this.total,
    this.estado = 'PENDIENTE',
  });
}

class DatosApp {
  static String nombreUsuario = 'Usuario CAFETESE';
  static String correo = '';

  static List<Producto> productos = [
    Producto(nombre: 'Café americano', precio: 25, categoria: 'Bebidas'),
    Producto(nombre: 'Capuchino', precio: 38, categoria: 'Bebidas'),
    Producto(nombre: 'Agua natural', precio: 15, categoria: 'Bebidas'),
    Producto(nombre: 'Sándwich', precio: 45, categoria: 'Alimentos'),
    Producto(nombre: 'Torta', precio: 50, categoria: 'Alimentos'),
    Producto(nombre: 'Galletas', precio: 18, categoria: 'Snacks'),
  ];

  static Map<String, int> carrito = {};
  static List<Pedido> pedidos = [];
}

// COMPONENTES REUTILIZABLES

void abrir(BuildContext context, Widget pagina) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => pagina),
  );
}

Widget titulo(String texto) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      texto,
      style: const TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget boton(
  String texto,
  VoidCallback accion, {
  IconData? icono,
}) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: accion,
      icon: Icon(icono ?? Icons.arrow_forward),
      label: Text(texto),
    ),
  );
}

void aviso(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(mensaje)),
  );
}

// 1. PANTALLA DE BIENVENIDA

class BienvenidaPage extends StatelessWidget {
  const BienvenidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_cafe,
                size: 100,
                color: Color(0xFF8D5A9E),
              ),
              const SizedBox(height: 15),
              const Text(
                'APP CAFETESE',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Tu cafetería, sin largas filas'),
              const SizedBox(height: 35),
              boton(
                'Iniciar sesión',
                () => abrir(context, const LoginPage()),
                icono: Icons.login,
              ),
              const SizedBox(height: 12),
              boton(
                'Registrarse',
                () => abrir(context, const RegistroPage()),
                icono: Icons.person_add,
              ),
              TextButton(
                onPressed: () => showAboutDialog(
                  context: context,
                  applicationName: 'APP CAFETESE',
                  children: [
                    const Text(
                      'Aplicación para consultar productos y '
                      'realizar pedidos anticipados en la '
                      'cafetería del TESE.',
                    ),
                  ],
                ),
                child: const Text('Acerca de'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. REGISTRO

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final nombre = TextEditingController();
  final correo = TextEditingController();
  final password = TextEditingController();
  final confirmar = TextEditingController();

  @override
  void dispose() {
    nombre.dispose();
    correo.dispose();
    password.dispose();
    confirmar.dispose();
    super.dispose();
  }

  void registrar() {
    if (nombre.text.trim().isEmpty ||
        correo.text.trim().isEmpty ||
        password.text.isEmpty) {
      aviso(context, 'Completa todos los campos');
      return;
    }

    if (!correo.text.contains('@')) {
      aviso(context, 'Escribe un correo válido');
      return;
    }

    if (password.text != confirmar.text) {
      aviso(context, 'Las contraseñas no coinciden');
      return;
    }

    DatosApp.nombreUsuario = nombre.text.trim();
    DatosApp.correo = correo.text.trim();

    aviso(context, 'Registro de demostración completado');
    abrir(context, const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          titulo('Registro de estudiante'),
          TextField(
            controller: nombre,
            decoration: const InputDecoration(
              labelText: 'Nombre completo',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextField(
            controller: correo,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo institucional',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          TextField(
            controller: confirmar,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar contraseña',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 25),
          boton('Registrarse', registrar, icono: Icons.person_add),
          TextButton(
            onPressed: () => abrir(context, const LoginPage()),
            child: const Text('¿Ya tienes cuenta? Inicia sesión'),
          ),
        ],
      ),
    );
  }
}

// 3. INICIO DE SESIÓN

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final correo = TextEditingController();
  final password = TextEditingController();

  // SOLO PARA PROBAR LAS PANTALLAS.
  // En Firebase el rol se obtendrá de una cuenta autorizada.
  String rolDemo = 'Estudiante';

  @override
  void dispose() {
    correo.dispose();
    password.dispose();
    super.dispose();
  }

  void ingresar() {
    if (correo.text.trim().isEmpty || password.text.isEmpty) {
      aviso(context, 'Ingresa correo y contraseña');
      return;
    }

    DatosApp.correo = correo.text.trim();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => PrincipalPage(rol: rolDemo),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.local_cafe, size: 80),
          titulo('Bienvenido a CAFETESE'),
          TextField(
            controller: correo,
            decoration: const InputDecoration(
              labelText: 'Correo institucional',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Rol para probar el prototipo:'),
          DropdownButtonFormField<String>(
            initialValue: rolDemo,
            items: ['Estudiante', 'Personal', 'Administrador']
                .map(
                  (rol) => DropdownMenuItem(
                    value: rol,
                    child: Text(rol),
                  ),
                )
                .toList(),
            onChanged: (valor) {
              setState(() => rolDemo = valor!);
            },
          ),
          const SizedBox(height: 22),
          boton('Ingresar', ingresar, icono: Icons.login),
          TextButton(
            onPressed: () => aviso(
              context,
              'La recuperación de contraseña se conectará con Firebase.',
            ),
            child: const Text('¿Olvidaste tu contraseña?'),
          ),
          TextButton(
            onPressed: () => abrir(context, const RegistroPage()),
            child: const Text('¿No tienes cuenta? Regístrate'),
          ),
        ],
      ),
    );
  }
}

// 4. MENÚS SEGÚN EL ACTOR

class PrincipalPage extends StatefulWidget {
  final String rol;

  const PrincipalPage({super.key, required this.rol});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  int seleccion = 0;

  List<String> get opciones {
    if (widget.rol == 'Estudiante') {
      return ['Inicio', 'Menú', 'Carrito', 'Mis pedidos', 'Perfil'];
    }
    if (widget.rol == 'Personal') {
      return ['Inicio', 'Pedidos', 'Menú', 'Reportes', 'Perfil'];
    }
    return [
      'Inicio',
      'Usuarios',
      'Menú',
      'Pedidos',
      'Reportes',
      'Configuración',
      'Perfil',
    ];
  }

  IconData icono(String nombre) {
    switch (nombre) {
      case 'Inicio':
        return Icons.home;
      case 'Menú':
        return Icons.restaurant_menu;
      case 'Carrito':
        return Icons.shopping_cart;
      case 'Mis pedidos':
      case 'Pedidos':
        return Icons.receipt_long;
      case 'Usuarios':
        return Icons.people;
      case 'Reportes':
        return Icons.bar_chart;
      case 'Configuración':
        return Icons.settings;
      default:
        return Icons.person;
    }
  }

  Widget contenido(String opcion) {
    switch (opcion) {
      case 'Inicio':
        return pantallaInicio();
      case 'Menú':
        return pantallaMenu();
      case 'Carrito':
        return pantallaCarrito();
      case 'Mis pedidos':
      case 'Pedidos':
        return pantallaPedidos();
      case 'Usuarios':
        return pantallaUsuarios();
      case 'Reportes':
        return pantallaReportes();
      case 'Configuración':
        return pantallaConfiguracion();
      default:
        return pantallaPerfil();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAFETESE · ${widget.rol}'),
        backgroundColor: const Color(0xFFEAD7F2),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFEAD7F2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.local_cafe, size: 48),
                  const Text(
                    'APP CAFETESE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Rol: ${widget.rol}'),
                ],
              ),
            ),
            for (int i = 0; i < opciones.length; i++)
              ListTile(
                leading: Icon(icono(opciones[i])),
                title: Text(opciones[i]),
                selected: seleccion == i,
                onTap: () {
                  setState(() => seleccion = i);
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: cerrarSesion,
            ),
          ],
        ),
      ),
      body: contenido(opciones[seleccion]),
    );
  }

  // INICIO

  Widget pantallaInicio() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        titulo('¡Bienvenido a APP CAFETESE! ☕'),
        Text('Panel de ${widget.rol}'),
        const SizedBox(height: 18),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Avisos de la cafetería'),
            subtitle: const Text(
              'Consulta las novedades y horarios.',
            ),
          ),
        ),
        if (widget.rol == 'Estudiante')
          boton(
            'Explorar productos',
            () => setState(() => seleccion = 1),
            icono: Icons.restaurant_menu,
          ),
        if (widget.rol != 'Estudiante')
          Card(
            child: ListTile(
              title: const Text('Pedidos registrados'),
              trailing: Text('${DatosApp.pedidos.length}'),
            ),
          ),
      ],
    );
  }

  // MENÚ DE PRODUCTOS

  Widget pantallaMenu() {
    return StatefulBuilder(
      builder: (context, actualizar) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            titulo('Menú de la cafetería'),
            for (final producto in DatosApp.productos)
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.fastfood),
                  ),
                  title: Text(producto.nombre),
                  subtitle: Text(
                    '${producto.categoria} · '
                    '\$${producto.precio.toStringAsFixed(2)}'
                    '${producto.disponible ? "" : " · Agotado"}',
                  ),
                  trailing: widget.rol == 'Estudiante'
                      ? IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: producto.disponible
                              ? () {
                                  DatosApp.carrito.update(
                                    producto.nombre,
                                    (cantidad) => cantidad + 1,
                                    ifAbsent: () => 1,
                                  );
                                  aviso(context, 'Agregado al carrito');
                                }
                              : null,
                        )
                      : Switch(
                          value: producto.disponible,
                          onChanged: (valor) {
                            actualizar(() {
                              producto.disponible = valor;
                            });
                          },
                        ),
                ),
              ),
            if (widget.rol != 'Estudiante')
              boton(
                'Agregar producto',
                () => abrir(
                  context,
                  const AgregarProductoPage(),
                ),
                icono: Icons.add,
              ),
          ],
        );
      },
    );
  }

  // CARRITO DEL ESTUDIANTE

  Widget pantallaCarrito() {
    return StatefulBuilder(
      builder: (context, actualizar) {
        double total = 0;

        for (final producto in DatosApp.productos) {
          total += producto.precio *
              (DatosApp.carrito[producto.nombre] ?? 0);
        }

        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            titulo('Mi carrito'),
            if (DatosApp.carrito.isEmpty)
              const Text('Todavía no agregaste productos.'),
            for (final nombre in DatosApp.carrito.keys.toList())
              Card(
                child: ListTile(
                  title: Text(nombre),
                  subtitle: Text(
                    'Cantidad: ${DatosApp.carrito[nombre]}',
                  ),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          actualizar(() {
                            final cantidad =
                                DatosApp.carrito[nombre] ?? 0;
                            if (cantidad <= 1) {
                              DatosApp.carrito.remove(nombre);
                            } else {
                              DatosApp.carrito[nombre] =
                                  cantidad - 1;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          actualizar(() {
                            DatosApp.carrito[nombre] =
                                (DatosApp.carrito[nombre] ?? 0) + 1;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          actualizar(() {
                            DatosApp.carrito.remove(nombre);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 15),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Forma de pago: efectivo al recoger'),
            const SizedBox(height: 18),
            boton(
              'Confirmar pedido',
              DatosApp.carrito.isEmpty
                  ? () => aviso(context, 'Tu carrito está vacío')
                  : () {
                      DatosApp.pedidos.add(
                        Pedido(
                          numero: DatosApp.pedidos.length + 1,
                          productos: [
                            for (final item in DatosApp.carrito.entries)
                              '${item.key} x${item.value}',
                          ],
                          total: total,
                        ),
                      );
                      DatosApp.carrito.clear();
                      actualizar(() {});
                      aviso(context, 'Pedido registrado correctamente');
                      setState(() => seleccion = 3);
                    },
              icono: Icons.check_circle,
            ),
          ],
        );
      },
    );
  }

  // PEDIDOS Y SUS ESTADOS

  Widget pantallaPedidos() {
    return StatefulBuilder(
      builder: (context, actualizar) {
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            titulo('Pedidos'),
            if (DatosApp.pedidos.isEmpty)
              const Text('No hay pedidos registrados.'),
            for (final pedido in DatosApp.pedidos)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido #${pedido.numero}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(pedido.productos.join(', ')),
                      Text(
                        'Total: \$${pedido.total.toStringAsFixed(2)}',
                      ),
                      Chip(label: Text(pedido.estado)),
                      if (widget.rol != 'Estudiante')
                        Wrap(
                          spacing: 6,
                          children: [
                            for (final estado in [
                              'EN_PREPARACION',
                              'LISTO',
                              'ENTREGADO',
                            ])
                              OutlinedButton(
                                onPressed: () {
                                  actualizar(() {
                                    pedido.estado = estado;
                                  });
                                },
                                child: Text(estado),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ADMINISTRACIÓN DE USUARIOS

  Widget pantallaUsuarios() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        titulo('Administración de usuarios'),
        const Card(
          child: ListTile(
            leading: Icon(Icons.people),
            title: Text('Usuarios registrados'),
            subtitle: Text(
              'Aquí se mostrarán las cuentas guardadas '
              'en Firebase Firestore.',
            ),
          ),
        ),
        boton(
          'Asignar rol',
          () => aviso(
            context,
            'Pendiente: conectar gestión de roles con Firebase.',
          ),
          icono: Icons.admin_panel_settings,
        ),
        boton(
          'Activar o desactivar cuenta',
          () => aviso(
            context,
            'Pendiente: conectar administración de usuarios.',
          ),
          icono: Icons.manage_accounts,
        ),
      ],
    );
  }

  // REPORTES

  Widget pantallaReportes() {
    final ventas = DatosApp.pedidos.fold<double>(
      0,
      (suma, pedido) => suma + pedido.total,
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        titulo('Reportes'),
        Card(
          child: ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Pedidos registrados'),
            trailing: Text('${DatosApp.pedidos.length}'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Importe de pedidos'),
            trailing: Text('\$${ventas.toStringAsFixed(2)}'),
          ),
        ),
        const Text(
          'Estos datos son de demostración. '
          'No representan pagos cobrados ni ventas verificadas.',
        ),
      ],
    );
  }

  // CONFIGURACIÓN

  Widget pantallaConfiguracion() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        titulo('Configuración'),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Horarios de cafetería'),
          onTap: () => aviso(
            context,
            'Pendiente: configurar horarios.',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notificaciones'),
          onTap: () => aviso(
            context,
            'Pendiente: configurar notificaciones.',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Información general'),
          onTap: () => aviso(
            context,
            'Pendiente: editar información de la cafetería.',
          ),
        ),
      ],
    );
  }

  // PERFIL

  Widget pantallaPerfil() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(
          radius: 40,
          child: Icon(Icons.person, size: 42),
        ),
        titulo('Mi perfil'),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(DatosApp.nombreUsuario),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(DatosApp.correo),
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Cambiar contraseña'),
          onTap: () => aviso(
            context,
            'Pendiente: conectar con Firebase Authentication.',
          ),
        ),
        boton(
          'Cerrar sesión',
          cerrarSesion,
          icono: Icons.logout,
        ),
      ],
    );
  }

  void cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const BienvenidaPage(),
      ),
      (_) => false,
    );
  }
}

// 5. FORMULARIO PARA AGREGAR PRODUCTOS

class AgregarProductoPage extends StatefulWidget {
  const AgregarProductoPage({super.key});

  @override
  State<AgregarProductoPage> createState() =>
      _AgregarProductoPageState();
}

class _AgregarProductoPageState
    extends State<AgregarProductoPage> {
  final nombre = TextEditingController();
  final precio = TextEditingController();
  String categoria = 'Alimentos';

  @override
  void dispose() {
    nombre.dispose();
    precio.dispose();
    super.dispose();
  }

  void guardar() {
    final valor = double.tryParse(precio.text);

    if (nombre.text.trim().isEmpty ||
        valor == null ||
        valor <= 0) {
      aviso(context, 'Ingresa nombre y precio válido');
      return;
    }

    DatosApp.productos.add(
      Producto(
        nombre: nombre.text.trim(),
        precio: valor,
        categoria: categoria,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar producto')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: nombre,
            decoration: const InputDecoration(
              labelText: 'Nombre del producto',
            ),
          ),
          TextField(
            controller: precio,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Precio',
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: categoria,
            items: ['Alimentos', 'Bebidas', 'Snacks']
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onChanged: (valor) {
              setState(() => categoria = valor!);
            },
          ),
          const SizedBox(height: 20),
          boton(
            'Guardar producto',
            guardar,
            icono: Icons.save,
          ),
        ],
      ),
    );
  }
}
