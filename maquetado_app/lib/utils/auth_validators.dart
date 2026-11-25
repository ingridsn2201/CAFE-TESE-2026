String? validarCorreoInstitucional(String? value) {
  final correo = value?.trim() ?? '';
  if (correo.isEmpty) {
    return 'Ingresa tu correo institucional.';
  }
  final expresion = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!expresion.hasMatch(correo)) {
    return 'Ingresa un correo válido.';
  }
  return null;
}

String? validarContrasenaLogin(String? value) {
  if ((value ?? '').isEmpty) {
    return 'Ingresa tu contraseña.';
  }
  return null;
}

String? validarNombre(String? value) {
  if ((value ?? '').trim().isEmpty) {
    return 'Ingresa tu nombre completo.';
  }
  return null;
}

String? validarContrasenaRegistro(String? value) {
  final contrasena = value ?? '';
  if (contrasena.isEmpty) {
    return 'Ingresa una contraseña.';
  }
  if (contrasena.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres.';
  }
  return null;
}
