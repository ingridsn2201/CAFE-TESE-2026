import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String nombre;
  final String correo;
  final String rol; // 'alumno' o 'admin'
  final DateTime fechaRegistro;

  const AppUser({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.fechaRegistro,
  });

  factory AppUser.fromFirestore(
    DocumentSnapshot> doc,
  ) {
    final data = doc.data()!;
    return AppUser(
      uid: doc.id,
      nombre: data['nombre'] as String? ?? '',
      correo: data['correo'] as String? ?? '',
      rol: data['rol'] as String? ?? 'alumno',
      fechaRegistro: (data['fechaRegistro'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'nombre': nombre,
    'correo': correo,
    'rol': rol,
    'fechaRegistro': Timestamp.fromDate(fechaRegistro),
  };
}