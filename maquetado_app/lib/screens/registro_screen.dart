import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../state/app_state.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_header.dart';
import '../widgets/boton_principal.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();
  bool _ocultarContrasena = true;
  bool _ocultarConfirmacion = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _crearCuenta() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final appState = AppStateScope.of(context);
    appState.registrarUsuario(
      nombre: _nombreController.text,
      correo: _correoController.text,
      contrasena: _contrasenaController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuenta creada correctamente.'),
      ),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.menu);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final appState = AppStateScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width < 380 ? 18 : 24,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      titulo: 'Crear cuenta',
                      descripcion:
                          'Registra una cuenta local de demostración para continuar con el flujo de pedidos.',
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      key: const ValueKey('registro-nombre'),
                      controller: _nombreController,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: validarNombre,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('registro-correo'),
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Correo institucional',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: (value) {
                        final errorFormato = validarCorreoInstitucional(value);
                        if (errorFormato != null) {
                          return errorFormato;
                        }
                        if (appState.existeCorreo(value ?? '')) {
                          return 'Este correo ya está registrado.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('registro-contrasena'),
                      controller: _contrasenaController,
                      obscureText: _ocultarContrasena,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _ocultarContrasena
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          onPressed: () {
                            setState(() {
                              _ocultarContrasena = !_ocultarContrasena;
                            });
                          },
                          icon: Icon(
                            _ocultarContrasena
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: validarContrasenaRegistro,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('registro-confirmar'),
                      controller: _confirmarController,
                      obscureText: _ocultarConfirmacion,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: 'Confirmar contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _ocultarConfirmacion
                              ? 'Mostrar confirmación'
                              : 'Ocultar confirmación',
                          onPressed: () {
                            setState(() {
                              _ocultarConfirmacion = !_ocultarConfirmacion;
                            });
                          },
                          icon: Icon(
                            _ocultarConfirmacion
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return 'Confirma tu contraseña.';
                        }
                        if (value != _contrasenaController.text) {
                          return 'Las contraseñas no coinciden.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _crearCuenta(),
                    ),
                    const SizedBox(height: 24),
                    BotonPrincipal(
                      texto: 'Crear cuenta',
                      icon: Icons.person_add_alt_1,
                      onPressed: _crearCuenta,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, AppRoutes.login),
                      child: const Text('¿Ya tienes una cuenta? Iniciar sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
