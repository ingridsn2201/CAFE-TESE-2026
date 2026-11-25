import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../data/mock_productos.dart';
import '../models/producto.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/categoria_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/producto_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const String _categoriaTodos = 'Todos';

  final TextEditingController _busquedaController = TextEditingController();
  String _categoriaSeleccionada = _categoriaTodos;
  String _busqueda = '';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final productosFiltrados = _filtrarProductos(appState.productos);
    final todosAgotados =
        productosFiltrados.isNotEmpty && productosFiltrados.every(_estaAgotado);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafetería TESE'),
        actions: [
          if (appState.pedidoActivo != null)
            IconButton(
              tooltip: 'Mi pedido',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.estadoPedido),
              icon: const Icon(Icons.timeline_outlined),
            ),
          IconButton(
            tooltip: 'Carrito',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.carrito),
            icon: Badge(
              label: Text('${appState.totalItemsCarrito}'),
              isLabelVisible: appState.totalItemsCarrito > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Cuenta',
            onSelected: (value) {
              if (value == 'admin') {
                Navigator.pushNamed(context, AppRoutes.admin);
              } else if (value == 'logout') {
                appState.cerrarSesion();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.bienvenida,
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                value: 'user',
                child: Text(appState.usuario.nombre),
              ),
              if (appState.usuario.esAdministrador)
                const PopupMenuItem<String>(
                  value: 'admin',
                  child: Text('Panel administrativo'),
                ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: _MenuHeader(nombre: appState.usuario.nombre),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: _SearchField(
                      controller: _busquedaController,
                      onChanged: (value) {
                        setState(() {
                          _busqueda = value;
                        });
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: _CategoriasBar(
                      categorias: const [_categoriaTodos, ...categoriasMock],
                      seleccionada: _categoriaSeleccionada,
                      onSelected: (categoria) {
                        setState(() {
                          _categoriaSeleccionada = categoria;
                        });
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: _MenuSummary(
                      total: productosFiltrados.length,
                      categoria: _categoriaSeleccionada,
                    ),
                  ),
                ),
                if (todosAgotados)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: _AgotadosNotice(),
                    ),
                  ),
                if (productosFiltrados.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.search_off,
                      titulo: _busqueda.trim().isEmpty
                          ? 'No hay productos en esta categoría'
                          : 'No encontramos productos',
                      mensaje: _busqueda.trim().isEmpty
                          ? 'Esta categoría aún no tiene productos disponibles.'
                          : 'Intenta con otro alimento, bebida o categoría.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: _ProductosList(
                      productos: productosFiltrados,
                      maxWidth: constraints.maxWidth,
                      onSeleccionar: (producto) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.producto,
                          arguments: producto.id,
                        );
                      },
                      onAgregar: (producto) {
                        appState.agregarAlCarrito(producto);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${producto.nombre} agregado.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Producto> _filtrarProductos(List<Producto> productos) {
    final categoria = _categoriaSeleccionada;
    final busquedaNormalizada = _normalizar(_busqueda);

    return productos.where((producto) {
      final coincideCategoria =
          categoria == _categoriaTodos || producto.categoria == categoria;
      final coincideBusqueda = busquedaNormalizada.isEmpty ||
          _normalizar(
            '${producto.nombre} ${producto.descripcion} ${producto.categoria}',
          ).contains(busquedaNormalizada);

      return coincideCategoria && coincideBusqueda;
    }).toList();
  }

  bool _estaAgotado(Producto producto) {
    return !producto.disponible || producto.cantidadDisponible <= 0;
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primerNombre = nombre.trim().split(RegExp(r'\s+')).first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, $primerNombre',
          style: textTheme.headlineSmall?.copyWith(
            color: AppTheme.textoPrincipal,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '¿Qué se te antoja hoy?',
          style: textTheme.titleLarge?.copyWith(
            color: AppTheme.textoPrincipal,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Consulta el menú, revisa disponibilidad y prepara tu pedido.',
          style: textTheme.bodyMedium?.copyWith(
            color: AppTheme.textoPrincipal.withValues(alpha: 0.68),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const ValueKey('menu-busqueda'),
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar alimentos...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Limpiar búsqueda',
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(Icons.close),
              ),
      ),
      onChanged: onChanged,
    );
  }
}

class _CategoriasBar extends StatelessWidget {
  const _CategoriasBar({
    required this.categorias,
    required this.seleccionada,
    required this.onSelected,
  });

  final List<String> categorias;
  final String seleccionada;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        key: const ValueKey('menu-categorias'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categorias.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          return CategoriaChip(
            texto: categoria,
            seleccionada: categoria == seleccionada,
            onSelected: (_) => onSelected(categoria),
          );
        },
      ),
    );
  }
}

class _MenuSummary extends StatelessWidget {
  const _MenuSummary({
    required this.total,
    required this.categoria,
  });

  final int total;
  final String categoria;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            categoria == 'Todos' ? 'Menú disponible' : categoria,
            style: textTheme.titleMedium?.copyWith(
              color: AppTheme.textoPrincipal,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          '$total productos',
          style: textTheme.labelLarge?.copyWith(
            color: AppTheme.textoPrincipal.withValues(alpha: 0.62),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AgotadosNotice extends StatelessWidget {
  const _AgotadosNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.pendiente.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppTheme.pendiente),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Todos los productos mostrados están agotados por ahora.',
              style: TextStyle(
                color: AppTheme.textoPrincipal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductosList extends StatelessWidget {
  const _ProductosList({
    required this.productos,
    required this.maxWidth,
    required this.onSeleccionar,
    required this.onAgregar,
  });

  final List<Producto> productos;
  final double maxWidth;
  final ValueChanged<Producto> onSeleccionar;
  final ValueChanged<Producto> onAgregar;

  @override
  Widget build(BuildContext context) {
    if (maxWidth >= 720) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 430,
          mainAxisExtent: 212,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final producto = productos[index];
            return ProductoCard(
              producto: producto,
              onSeleccionar: () => onSeleccionar(producto),
              onAgregar: _puedeAgregarse(producto) ? () => onAgregar(producto) : null,
            );
          },
          childCount: productos.length,
        ),
      );
    }

    return SliverList.separated(
      itemBuilder: (context, index) {
        final producto = productos[index];
        return ProductoCard(
          producto: producto,
          onSeleccionar: () => onSeleccionar(producto),
          onAgregar: _puedeAgregarse(producto) ? () => onAgregar(producto) : null,
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemCount: productos.length,
    );
  }

  bool _puedeAgregarse(Producto producto) {
    return producto.disponible && producto.cantidadDisponible > 0;
  }
}

String _normalizar(String value) {
  return value
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n');
}
