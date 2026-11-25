import '../models/usuario.dart';

const Usuario usuarioMock = Usuario(
  nombre: 'Alumno TESE',
  correo: 'alumno@tese.edu.mx',
  rol: RolUsuario.alumno,
  contrasenaMock: '123456',
);

const Usuario administradorMock = Usuario(
  nombre: 'Administrador Cafeteria',
  correo: 'admin@tese.edu.mx',
  rol: RolUsuario.administrador,
  contrasenaMock: 'admin123',
);

const Usuario personalCafeteriaMock = Usuario(
  nombre: 'Personal de Cafetería',
  correo: 'cafeteria@tese.edu.mx',
  rol: RolUsuario.cafeteria,
  contrasenaMock: 'cafe123',
);

const List<Usuario> usuariosMock = [
  usuarioMock,
  administradorMock,
  personalCafeteriaMock,
];
