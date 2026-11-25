import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../state/app_state.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_header.dart';
import '../widgets/boton_principal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _ocultarContrasena = true;
  String _modoAcceso = 'cliente';
  String? _errorCredenciales;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    FocusScope.of(context).unfocus();
    setState(() => _errorCredenciales = null);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final appState = AppStateScope.of(context);
    final accesoPermitido = appState.iniciarSesion(
      correo: _correoController.text,
      contrasena: _contrasenaController.text,
    );

    if (!accesoPermitido) {
      setState(() {
        _errorCredenciales =
            'Credenciales incorrectas. Revisa tu correo y contraseña.';
      });
      return;
    }

    final esAdmin = appState.usuario.esAdministrador;
    final modoCorrecto = _modoAcceso == 'administrador' ? esAdmin : !esAdmin;
    if (!modoCorrecto) {
      appState.cerrarSesion();
      setState(() {
        _errorCredenciales = _modoAcceso == 'administrador'
            ? 'Esta cuenta no tiene permisos de administrador.'
            : 'Esta cuenta corresponde a administración. Selecciona el modo administrador.';
      });
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      esAdmin ? AppRoutes.admin : AppRoutes.menu,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

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
                      titulo: 'Iniciar sesión',
                      descripcion:
                          'Accede con tu cuenta institucional para preparar tu pedido anticipado.',
                    ),
                    const SizedBox(height: 22),
                    Text(
                      '¿Cómo deseas ingresar?',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(
                          value: 'cliente',
                          icon: Icon(Icons.person_outline),
                          label: Text('Cliente'),
                        ),
                        ButtonSegment<String>(
                          value: 'administrador',
                          icon: Icon(Icons.admin_panel_settings_outlined),
                          label: Text('Administrador'),
                        ),
                      ],
                      selected: {_modoAcceso},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _modoAcceso = selection.first;
                          _errorCredenciales = null;
                        });
                      },
                      showSelectedIcon: false,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _modoAcceso == 'cliente'
                          ? 'Alumnado y personal de cafetería pueden ingresar para realizar pedidos.'
                          : 'Acceso exclusivo para cuentas con permisos administrativos.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('login-correo'),
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Correo institucional',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: validarCorreoInstitucional,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('login-contrasena'),
                      controller: _contrasenaController,
                      obscureText: _ocultarContrasena,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
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
                      validator: validarContrasenaLogin,
                      onFieldSubmitted: (_) => _iniciarSesion(),
                    ),
                    if (_errorCredenciales != null) ...[
                      const SizedBox(height: 12),
                      _ErrorMessage(texto: _errorCredenciales!),
                    ],
                    const SizedBox(height: 24),
                    BotonPrincipal(
                      texto: 'Iniciar sesión',
                      icon: Icons.login,
                      onPressed: _iniciarSesion,
                    ),
                    const SizedBox(height: 12),
                    if (_modoAcceso == 'cliente')
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.registro),
                        child: const Text('¿No tienes una cuenta? Crear cuenta de cliente'),
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

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.26),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
