import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/pedido.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_principal.dart';
import '../widgets/empty_state.dart';

class EstadoPedidoScreen extends StatelessWidget {
  const EstadoPedidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final pedido = appState.pedidoActivo;

    if (pedido == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Estado del pedido')),
        body: const EmptyState(
          icon: Icons.timeline_outlined,
          titulo: 'No hay un pedido activo',
          mensaje: 'Cuando confirmes un pedido podrás consultar aquí su avance.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado del pedido'),
        actions: [
          if (appState.usuario.esAdministrador)
            IconButton(
              tooltip: 'Panel administrativo',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.admin),
              icon: const Icon(Icons.admin_panel_settings_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 760 ? 56.0 : 20.0;
            return ListView(
              padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 28),
              children: [
                _PedidoHeader(pedido: pedido),
                const SizedBox(height: 22),
                _EstadoTimeline(pedido: pedido),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 12),
                        for (final item in pedido.items)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('${item.cantidad} × ${item.producto.nombre}'),
                                ),
                                Text(
                                  '\$${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            Text(
                              '\$${pedido.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.verdeInstitucional,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (pedido.estado == EstadoPedido.cancelado) ...[
                  const SizedBox(height: 14),
                  _EstadoNotice(
                    color: AppTheme.agotado,
                    icon: Icons.cancel_outlined,
                    text: 'Este pedido está cancelado.',
                  ),
                ],
                const SizedBox(height: 18),
                BotonPrincipal(
                  texto: 'Regresar al menú',
                  icon: Icons.restaurant_menu,
                  secundario: true,
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.menu,
                    (route) => false,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PedidoHeader extends StatelessWidget {
  const _PedidoHeader({required this.pedido});

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pedido #${pedido.id}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Creado ${_formatearFecha(pedido.fechaCreacion)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textoPrincipal.withValues(alpha: 0.62),
                    ),
              ),
            ],
          ),
        ),
        _EstadoPill(estado: pedido.estado),
      ],
    );
  }
}

class _EstadoTimeline extends StatelessWidget {
  const _EstadoTimeline({required this.pedido});

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    final estados = const [
      EstadoPedido.recibido,
      EstadoPedido.enPreparacion,
      EstadoPedido.listo,
      EstadoPedido.entregado,
    ];

    if (pedido.estado == EstadoPedido.cancelado) {
      return _EstadoNotice(
        color: AppTheme.agotado,
        icon: Icons.cancel_outlined,
        text: 'Pedido cancelado',
      );
    }

    final currentIndex = estados.indexOf(pedido.estado);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 10),
        child: Column(
          children: [
            for (var index = 0; index < estados.length; index++)
              _TimelineStep(
                estado: estados[index],
                activo: index <= currentIndex,
                actual: index == currentIndex,
                ultimo: index == estados.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.estado,
    required this.activo,
    required this.actual,
    required this.ultimo,
  });

  final EstadoPedido estado;
  final bool activo;
  final bool actual;
  final bool ultimo;

  @override
  Widget build(BuildContext context) {
    final color = activo ? AppTheme.verdeInstitucional : Colors.grey.shade300;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 36,
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: activo ? color : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  activo ? Icons.check : Icons.circle_outlined,
                  size: 18,
                  color: activo ? Colors.white : Colors.grey.shade400,
                ),
              ),
              if (!ultimo)
                Container(
                  width: 2,
                  height: 48,
                  color: color,
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    estado.etiqueta,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: actual ? FontWeight.w900 : FontWeight.w700,
                          color: activo
                              ? AppTheme.textoPrincipal
                              : AppTheme.textoPrincipal.withValues(alpha: 0.48),
                        ),
                  ),
                ),
                if (actual)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.verdeInstitucional.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Actual',
                      style: TextStyle(
                        color: AppTheme.verdeInstitucional,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EstadoPill extends StatelessWidget {
  const _EstadoPill({required this.estado});

  final EstadoPedido estado;

  @override
  Widget build(BuildContext context) {
    final color = switch (estado) {
      EstadoPedido.recibido => AppTheme.pendiente,
      EstadoPedido.enPreparacion => AppTheme.pendiente,
      EstadoPedido.listo => AppTheme.disponible,
      EstadoPedido.entregado => AppTheme.verdeInstitucional,
      EstadoPedido.cancelado => AppTheme.agotado,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        estado.etiqueta,
        style: TextStyle(color: color, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _EstadoNotice extends StatelessWidget {
  const _EstadoNotice({required this.color, required this.icon, required this.text});

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatearFecha(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  final hora = fecha.hour.toString().padLeft(2, '0');
  final minuto = fecha.minute.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year} · $hora:$minuto';
}
