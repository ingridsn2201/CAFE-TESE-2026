import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/app_user.dart';

class AuthRepository {
  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _db;

  AuthRepository({
    fb_auth.FirebaseAuth? auth,
    FirebaseFirestore? db,
  })  : _auth = auth ?? fb_auth.FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance;

  Stream<fb_auth.User?> get authStateChanges => _auth.authStateChanges();

  Future<AppUser?> get currentUserModel async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _db.collection('usuarios').doc(user.uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<fb_auth.UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<fb_auth.UserCredential> signUp({
    required String email,
    required String password,
    required String nombre,
  }) async {
    final creds = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (creds.user != null) {
      final newUser = AppUser(
        uid: creds.user!.uid,
        nombre: nombre,
        correo: email,
        rol: 'alumno',
        fechaRegistro: DateTime.now(),
      );
      await _db
          .collection('usuarios')
          .doc(creds.user!.uid)
          .set(newUser.toFirestore());
    }

    return creds;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}