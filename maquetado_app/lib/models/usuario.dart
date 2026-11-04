enum RolUsuario {
  alumno,
  docente,
  administrativo,
  cafeteria,
  administrador,
}

class Usuario {
  const Usuario({
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.contrasenaMock,
  });

  final String nombre;
  final String correo;
  final RolUsuario rol;
  final String contrasenaMock;

  bool get esAdministrador => rol == RolUsuario.administrador;

  Usuario copyWith({
    String? nombre,
    String? correo,
    RolUsuario? rol,
    String? contrasenaMock,
  }) {
    return Usuario(
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      rol: rol ?? this.rol,
      contrasenaMock: contrasenaMock ?? this.contrasenaMock,
    );
  }
}
