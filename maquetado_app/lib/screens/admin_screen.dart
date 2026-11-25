import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _tab = 0;
  String _busquedaProducto = '';
  String _categoriaProducto = 'Todas';
  String _filtroPedido = 'Todos';
  String _busquedaPedido = '';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    if (!appState.usuario.esAdministrador) {
      return Scaffold(
        appBar: AppBar(title: const Text('Panel administrativo')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const EmptyState(
                  icon: Icons.lock_outline,
                  titulo: 'Acceso restringido',
                  mensaje: 'Esta sección está disponible únicamente para cuentas administradoras.',
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text('Volver al inicio de sesión'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final disponibles = appState.productos.where((p) => p.disponible && p.cantidadDisponible > 0).length;
    final agotados = appState.productos.length - disponibles;
    final activos = appState.pedidos.where((p) =>
        p.estado != EstadoPedido.entregado && p.estado != EstadoPedido.cancelado).length;
    final pendientes = appState.pedidos.where((p) => p.estado == EstadoPedido.recibido).length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.verdeInstitucional,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.local_cafe, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            const Flexible(child: Text('Cafetería TESE')),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Center(
              child: Text(
                'Administrador',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Opciones de cuenta',
            onSelected: (value) {
              if (value == 'cliente') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.menu,
                  (route) => false,
                );
              } else if (value == 'salir') {
                appState.cerrarSesion();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'cliente',
                child: Text('Abrir vista de cliente'),
              ),
              PopupMenuItem(value: 'salir', child: Text('Cerrar sesión')),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(86),
          child: _AdminNavBar(
            selectedIndex: _tab,
            onSelected: (index) => setState(() => _tab = index),
          ),
        ),
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _buildDashboard(
            context,
            appState,
            totalProductos: appState.productos.length,
            disponibles: disponibles,
            agotados: agotados,
            totalPedidos: appState.pedidos.length,
            activos: activos,
            pendientes: pendientes,
            onGoProductos: () => setState(() => _tab = 1),
            onGoPedidos: () => setState(() => _tab = 2),
          ),
          _buildProductos(context, appState),
          _buildPedidos(context, appState),
        ],
      ),
    );
  }

  Widget _pageBody(
    BuildContext context,
    List<Widget> children, {
    required String storageKey,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 1180 ? 1120.0 : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: ListView(
              key: PageStorageKey(storageKey),
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 500 ? 16 : 28,
                vertical: 24,
              ),
              children: children,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    AppState state, {
    required int totalProductos,
    required int disponibles,
    required int agotados,
    required int totalPedidos,
    required int activos,
    required int pendientes,
    required VoidCallback onGoProductos,
    required VoidCallback onGoPedidos,
  }) {
    final recientes = state.pedidos.reversed.take(5).toList();
    return _pageBody(context, [
      Text('Panel administrativo', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 5),
      Text('Resumen de productos, disponibilidad y pedidos de la cafetería.', style: TextStyle(color: AppTheme.textoPrincipal.withValues(alpha: .68))),
      const SizedBox(height: 20),
      LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth > 780 ? 4 : (constraints.maxWidth > 480 ? 2 : 1);
        final cards = [
          _StatCard(titulo: 'Productos', valor: '$totalProductos', detalle: 'En el catálogo', icono: Icons.restaurant_menu, color: AppTheme.verdeInstitucional),
          _StatCard(titulo: 'Disponibles', valor: '$disponibles', detalle: '$agotados agotados/no disponibles', icono: Icons.check_circle_outline, color: AppTheme.disponible),
          _StatCard(titulo: 'Pedidos activos', valor: '$activos', detalle: '$pendientes por revisar', icono: Icons.shopping_bag_outlined, color: AppTheme.doradoAccion),
          _StatCard(titulo: 'Pedidos totales', valor: '$totalPedidos', detalle: 'Registrados en esta sesión', icono: Icons.receipt_long_outlined, color: const Color(0xFF4777A8)),
        ];
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 3.3 : (columns == 2 ? 1.8 : 1.45),
          children: cards,
        );
      }),
      const SizedBox(height: 28),
      _SectionHeading(
        title: 'Accesos rápidos',
        subtitle: 'Administra la información principal de la cafetería.',
      ),
      const SizedBox(height: 12),
      LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth > 650;
        final actions = [
          _QuickAction(icon: Icons.add_box_outlined, title: 'Agregar producto', subtitle: 'Registrar un nuevo artículo', onTap: () async { await _mostrarEditorProducto(context, state); }),
          _QuickAction(icon: Icons.inventory_outlined, title: 'Gestionar productos', subtitle: 'Editar precios y disponibilidad', onTap: onGoProductos),
          _QuickAction(icon: Icons.receipt_long_outlined, title: 'Gestionar pedidos', subtitle: 'Revisar y actualizar estados', onTap: onGoPedidos),
        ];
        if (!wide) return Column(children: [for (final action in actions) Padding(padding: const EdgeInsets.only(bottom: 10), child: action)]);
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [for (var i = 0; i < actions.length; i++) Expanded(child: Padding(padding: EdgeInsets.only(right: i == actions.length - 1 ? 0 : 12), child: actions[i]))]);
      }),
      const SizedBox(height: 28),
      _SectionHeading(title: 'Pedidos recientes', subtitle: 'Últimas órdenes registradas.'),
      const SizedBox(height: 12),
      if (recientes.isEmpty)
        const EmptyState(icon: Icons.receipt_long_outlined, titulo: 'Aún no hay pedidos', mensaje: 'Cuando un cliente confirme una orden, aparecerá en esta sección.')
      else
        Card(child: Column(children: [for (var i = 0; i < recientes.length; i++) ...[
          _RecentOrderRow(pedido: recientes[i]),
          if (i < recientes.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
        ]])) ,
      const SizedBox(height: 20),
      const _DemoNotice(),
    ], storageKey: 'admin-dashboard');
  }

  Widget _buildProductos(BuildContext context, AppState state) {
    final categorias = ['Todas', ...{for (final p in state.productos) p.categoria}];
    final filtrados = state.productos.where((producto) {
      final texto = '${producto.nombre} ${producto.descripcion}'.toLowerCase();
      final coincideTexto = texto.contains(_busquedaProducto.toLowerCase());
      final coincideCategoria = _categoriaProducto == 'Todas' || producto.categoria == _categoriaProducto;
      return coincideTexto && coincideCategoria;
    }).toList();

    return _pageBody(context, [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Gestión de productos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text('Crea, edita y controla la disponibilidad del catálogo.', style: TextStyle(color: AppTheme.textoPrincipal.withValues(alpha: .68))),
        ])),
        const SizedBox(width: 12),
        FilledButton.icon(onPressed: () => _mostrarEditorProducto(context, state), icon: const Icon(Icons.add), label: const Text('Agregar')),
      ]),
      const SizedBox(height: 18),
      TextField(
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Buscar producto', hintText: 'Nombre o descripción'),
        onChanged: (value) => setState(() => _busquedaProducto = value),
      ),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(
        value: categorias.contains(_categoriaProducto) ? _categoriaProducto : 'Todas',
        decoration: const InputDecoration(labelText: 'Filtrar por categoría'),
        items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (value) => setState(() => _categoriaProducto = value ?? 'Todas'),
      ),
      const SizedBox(height: 16),
      Row(children: [const Icon(Icons.info_outline, size: 18, color: AppTheme.verdeInstitucional), const SizedBox(width: 8), Expanded(child: Text('${filtrados.length} producto(s). Desactiva un producto si no está disponible para la venta.', style: Theme.of(context).textTheme.bodySmall))]),
      const SizedBox(height: 10),
      if (filtrados.isEmpty)
        const EmptyState(icon: Icons.search_off, titulo: 'Sin resultados', mensaje: 'Prueba con otro nombre o categoría.')
      else
        for (final producto in filtrados) ...[
          _AdminProductTile(
            producto: producto,
            onEdit: () => _mostrarEditorProducto(context, state, producto: producto),
            onToggle: () {
              if (!producto.disponible && producto.cantidadDisponible <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registra existencias en Editar producto antes de habilitarlo.'),
                  ),
                );
                return;
              }
              state.alternarDisponibilidad(producto.id);
            },
          ),
          const SizedBox(height: 10),
        ],
      const SizedBox(height: 16),
      const _DemoNotice(),
    ], storageKey: 'admin-products');
  }

  Widget _buildPedidos(BuildContext context, AppState state) {
    final pedidos = state.pedidos.reversed.where((pedido) {
      final query = _busquedaPedido.toLowerCase();
      final coincideTexto = pedido.id.toLowerCase().contains(query);
      final coincideEstado = _filtroPedido == 'Todos' || pedido.estado.etiqueta == _filtroPedido;
      return coincideTexto && coincideEstado;
    }).toList();

    return _pageBody(context, [
      Text('Gestión de pedidos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 5),
      Text('Consulta las órdenes y actualiza su avance hasta la entrega.', style: TextStyle(color: AppTheme.textoPrincipal.withValues(alpha: .68))),
      const SizedBox(height: 18),
      TextField(
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Buscar pedido', hintText: 'Ej. TESE-001'),
        onChanged: (value) => setState(() => _busquedaPedido = value),
      ),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(
        value: _filtroPedido,
        decoration: const InputDecoration(labelText: 'Filtrar por estado'),
        items: ['Todos', ...EstadoPedido.values.map((e) => e.etiqueta)].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (value) => setState(() => _filtroPedido = value ?? 'Todos'),
      ),
      const SizedBox(height: 16),
      if (pedidos.isEmpty) ...[
        const EmptyState(icon: Icons.receipt_long_outlined, titulo: 'No hay pedidos para mostrar', mensaje: 'Cuando existan pedidos, aparecerán aquí para su seguimiento.'),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _tab = 0),
            icon: const Icon(Icons.dashboard_outlined),
            label: const Text('Volver al inicio del panel'),
          ),
        ),
      ]
      else
        for (final pedido in pedidos) ...[
          _AdminOrderTile(
            pedido: pedido,
            onChanged: (estado) => _confirmarCambioEstado(context, state, pedido, estado),
          ),
          const SizedBox(height: 12),
        ],
      const SizedBox(height: 16),
      const _DemoNotice(),
    ], storageKey: 'admin-orders');
  }

  Future<void> _confirmarCambioEstado(BuildContext context, AppState state, Pedido pedido, EstadoPedido estado) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Actualizar pedido'),
        content: Text('¿Cambiar el pedido ${pedido.id} a "${estado.etiqueta}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Confirmar')),
        ],
      ),
    );
    if (confirmado == true) {
      state.actualizarEstadoPedido(pedido.id, estado);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pedido ${pedido.id}: ${estado.etiqueta.toLowerCase()}.')));
    }
  }

  Future<void> _mostrarEditorProducto(BuildContext context, AppState state, {Producto? producto}) async {
    final formKey = GlobalKey<FormState>();
    final nombre = TextEditingController(text: producto?.nombre ?? '');
    final descripcion = TextEditingController(text: producto?.descripcion ?? '');
    final precio = TextEditingController(text: producto == null ? '' : producto.precio.toStringAsFixed(2));
    final cantidad = TextEditingController(text: producto == null ? '5' : '${producto.cantidadDisponible}');
    var categoria = producto?.categoria ?? 'Desayunos';
    var icono = producto?.icono ?? 'restaurant';
    var disponible = producto?.disponible ?? true;

    final guardado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: Text(producto == null ? 'Agregar producto' : 'Editar producto'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(controller: nombre, decoration: const InputDecoration(labelText: 'Nombre del producto'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre.' : null),
                const SizedBox(height: 12),
                TextFormField(controller: descripcion, maxLines: 2, decoration: const InputDecoration(labelText: 'Descripción'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa una descripción.' : null),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextFormField(controller: precio, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Precio (MXN)'), validator: (v) { final n = double.tryParse((v ?? '').trim().replaceAll(',', '.')); return n == null || n <= 0 ? 'Precio inválido.' : null; })),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: cantidad, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Existencias'), validator: (v) { final n = int.tryParse((v ?? '').trim()); return n == null || n < 0 ? 'Cantidad inválida.' : null; })),
                ]),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(value: categoria, decoration: const InputDecoration(labelText: 'Categoría'), items: const ['Desayunos', 'Comidas', 'Snacks', 'Bebidas', 'Postres'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) { if (v != null) setDialogState(() => categoria = v); }),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(value: icono, decoration: const InputDecoration(labelText: 'Icono del producto'), items: const {'restaurant':'Restaurante','breakfast_dining':'Desayuno','local_drink':'Bebida','local_cafe':'Café','lunch_dining':'Comida','dinner_dining':'Platillo','cake':'Postre'}.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (v) { if (v != null) setDialogState(() => icono = v); }),
                const SizedBox(height: 4),
                SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, value: disponible, title: const Text('Producto disponible'), subtitle: const Text('Desactívalo si está agotado o no se vende.'), onChanged: (v) => setDialogState(() => disponible = v), activeColor: AppTheme.verdeInstitucional),
              ]),
            )),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
            FilledButton.icon(onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final cantidadValida = int.parse(cantidad.text.trim());
              final activo = disponible && cantidadValida > 0;
              final nuevo = Producto(
                id: producto?.id ?? 'p${DateTime.now().millisecondsSinceEpoch}',
                nombre: nombre.text.trim(),
                descripcion: descripcion.text.trim(),
                precio: double.parse(precio.text.trim().replaceAll(',', '.')),
                categoria: categoria,
                icono: icono,
                disponible: activo,
                cantidadDisponible: activo ? cantidadValida : 0,
              );
              state.guardarProducto(nuevo);
              Navigator.pop(dialogContext, true);
            }, icon: const Icon(Icons.save_outlined), label: const Text('Guardar producto')),
          ],
        );
      }),
    );

    nombre.dispose();
    descripcion.dispose();
    precio.dispose();
    cantidad.dispose();
    if (guardado == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(producto == null ? 'Producto agregado al catálogo.' : 'Producto actualizado.')));
    }
  }
}

class _AdminNavBar extends StatelessWidget {
  const _AdminNavBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Container(
        height: 86,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 66),
          child: Row(
            children: [
              _AdminNavItem(
                index: 0,
                selectedIndex: selectedIndex,
                icon: Icons.dashboard_outlined,
                label: 'Inicio',
                onSelected: onSelected,
              ),
              _AdminNavItem(
                index: 1,
                selectedIndex: selectedIndex,
                icon: Icons.inventory_2_outlined,
                label: 'Productos',
                onSelected: onSelected,
              ),
              _AdminNavItem(
                index: 2,
                selectedIndex: selectedIndex,
                icon: Icons.receipt_long_outlined,
                label: 'Pedidos',
                onSelected: onSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminNavItem extends StatelessWidget {
  const _AdminNavItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.label,
    required this.onSelected,
  });

  final int index;
  final int selectedIndex;
  final IconData icon;
  final String label;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = index == selectedIndex;
    final color = selected ? AppTheme.verdeInstitucional : AppTheme.textoPrincipal.withValues(alpha: .72);

    return InkWell(
      onTap: () => onSelected(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 104,
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 9),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 3,
              width: selected ? 76 : 0,
              decoration: BoxDecoration(
                color: AppTheme.verdeInstitucional,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.titulo, required this.valor, required this.detalle, required this.icono, required this.color});
  final String titulo;
  final String valor;
  final String detalle;
  final IconData icono;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)), child: Icon(icono, color: color)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(titulo, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 3), Text(valor, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), Text(detalle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textoPrincipal.withValues(alpha: .62))) ])),
    ])),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: AppTheme.textoPrincipal.withValues(alpha: .65)))]);
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(child: InkWell(borderRadius: BorderRadius.circular(8), onTap: onTap, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: AppTheme.verdeInstitucional.withValues(alpha: .10), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppTheme.verdeInstitucional)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])), const Icon(Icons.chevron_right)]))));
}

class _AdminProductTile extends StatelessWidget {
  const _AdminProductTile({required this.producto, required this.onEdit, required this.onToggle});
  final Producto producto;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) {
    final activo = producto.disponible && producto.cantidadDisponible > 0;
    return Card(child: Padding(padding: const EdgeInsets.all(14), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTheme.verdeInstitucional.withValues(alpha: .09), borderRadius: BorderRadius.circular(10)), child: Icon(_iconFor(producto.icono), color: AppTheme.verdeInstitucional)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(producto.categoria, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 5), Text('\$${producto.precio.toStringAsFixed(2)} · Existencias: ${producto.cantidadDisponible}', style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6), _StatusPill(text: activo ? 'Disponible' : 'Agotado / desactivado', color: activo ? AppTheme.disponible : AppTheme.agotado)])),
      Column(children: [IconButton(tooltip: 'Editar producto', onPressed: onEdit, icon: const Icon(Icons.edit_outlined)), Switch.adaptive(value: activo, onChanged: (_) => onToggle(), activeColor: AppTheme.verdeInstitucional)]),
    ])));
  }
}

class _AdminOrderTile extends StatelessWidget {
  const _AdminOrderTile({required this.pedido, required this.onChanged});
  final Pedido pedido;
  final ValueChanged<EstadoPedido> onChanged;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Pedido #${pedido.id}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), const SizedBox(height: 4), Text(_formatDate(pedido.fechaCreacion), style: Theme.of(context).textTheme.bodySmall)])), Text('\$${pedido.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.verdeInstitucional, fontWeight: FontWeight.w900))]),
    const SizedBox(height: 10),
    Text('${pedido.items.fold<int>(0, (sum, item) => sum + item.cantidad)} artículo(s) · ${pedido.items.map((i) => i.producto.nombre).join(', ')}', maxLines: 3, overflow: TextOverflow.ellipsis),
    const SizedBox(height: 14),
    DropdownButtonFormField<EstadoPedido>(value: pedido.estado, decoration: const InputDecoration(labelText: 'Estado del pedido', prefixIcon: Icon(Icons.sync_alt)), items: EstadoPedido.values.map((e) => DropdownMenuItem(value: e, child: Text(e.etiqueta))).toList(), onChanged: (estado) { if (estado != null && estado != pedido.estado) onChanged(estado); }),
  ])));
}

class _RecentOrderRow extends StatelessWidget {
  const _RecentOrderRow({required this.pedido});
  final Pedido pedido;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13), child: Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: AppTheme.verdeInstitucional.withValues(alpha: .09), borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.receipt_long_outlined, color: AppTheme.verdeInstitucional)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('#${pedido.id}', style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text('${pedido.items.length} concepto(s) · ${_formatDate(pedido.fechaCreacion)}', style: Theme.of(context).textTheme.bodySmall)])), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('\$${pedido.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), _StatusPill(text: pedido.estado.etiqueta, color: _statusColor(pedido.estado))]) ]));
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(20)), child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)));
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: AppTheme.pendiente.withValues(alpha: .10), borderRadius: BorderRadius.circular(10)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: AppTheme.pendiente), SizedBox(width: 9), Expanded(child: Text('Modo de demostración: los cambios se conservan en memoria durante esta ejecución. La conexión con Firebase se integrará en una etapa posterior.', style: TextStyle(fontWeight: FontWeight.w600)))]));
}

IconData _iconFor(String name) {
  switch (name) {
    case 'breakfast_dining': return Icons.breakfast_dining;
    case 'local_drink': return Icons.local_drink;
    case 'local_cafe': return Icons.local_cafe;
    case 'lunch_dining': return Icons.lunch_dining;
    case 'dinner_dining': return Icons.dinner_dining;
    case 'cake': return Icons.cake;
    default: return Icons.restaurant;
  }
}

Color _statusColor(EstadoPedido estado) {
  switch (estado) {
    case EstadoPedido.recibido: return AppTheme.pendiente;
    case EstadoPedido.enPreparacion: return const Color(0xFF2878B5);
    case EstadoPedido.listo: return AppTheme.disponible;
    case EstadoPedido.entregado: return const Color(0xFF66716B);
    case EstadoPedido.cancelado: return AppTheme.agotado;
  }
}

String _formatDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final h = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '$d/$m/${date.year} · $h:$min';
}
