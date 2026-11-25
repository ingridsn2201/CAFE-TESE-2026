class ProductValidator {
  ProductValidator._();

  /// Valida que el nombre del producto no esté vacío
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre del producto es obligatorio.';
    }
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres.';
    }
    return null;
  }

  /// Valida que el precio sea un número válido y no negativo
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El precio es obligatorio.';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Ingresa un precio numérico válido.';
    }
    if (parsed < 0) {
      return 'El precio no puede ser negativo.';
    }
    return null;
  }

  /// Valida que el stock sea un número entero no negativo
  static String? validateStock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La cantidad disponible es obligatoria.';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Ingresa un número entero válido.';
    }
    if (parsed < 0) {
      return 'La cantidad disponible no puede ser negativa.';
    }
    return null;
  }

  /// Garantiza coherencia: si no hay existencias (stock <= 0), disponible debe ser false
  static bool resolveAvailability({
    required bool requestedAvailability,
    required int stock,
  }) {
    if (stock <= 0) {
      return false;
    }
    return requestedAvailability;
  }
}