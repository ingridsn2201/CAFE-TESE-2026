import 'package:flutter/material.dart';

class CategoriaChip extends StatelessWidget {
  const CategoriaChip({
    required this.texto,
    required this.seleccionada,
    required this.onSelected,
    super.key,
  });

  final String texto;
  final bool seleccionada;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(texto),
      selected: seleccionada,
      onSelected: onSelected,
    );
  }
}
