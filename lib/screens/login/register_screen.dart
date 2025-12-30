import "package:flutter/material.dart";
import "package:green_cloud/services/auth_service.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "../../widgets/animated_combined_painter.dart";
import "package:green_cloud/screens/login/login_screen.dart";
import "package:google_fonts/google_fonts.dart";
import "../../widgets/BottomNavBar.dart";

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/register";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Instancia de AuthService
  final AuthService _authService = AuthService();

  // Estados de la UI
  bool _isLoading = false;
  String? _errorMessage;

  // Método para manejar el registro
  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userCredential != null && mounted) {
        // Actualizar el nombre del usuario
        await userCredential.user
            ?.updateDisplayName(nameController.text.trim());

        // Navegar a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = _authService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  // Método para manejar registro con Google
  Future<void> _handleGoogleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = _authService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 242, 230),
      body: Stack(
        children: [
          AnimatedBackground(
              targetColor: const Color.fromARGB(255, 189, 223, 208)),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Botón de regresar
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios),
                        color: const Color(0xFF025810),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 189, 223, 208),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Crear Cuenta",
                              style: GoogleFonts.nunito(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF025810),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Únete a Green Cloud y cuida tus plantas",
                              style: GoogleFonts.nunito(
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Campo de nombre
                            TextFormField(
                              controller: nameController,
                              style: GoogleFonts.nunito(),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.nunito(
                                  color: const Color(0xFF025810),
                                  fontSize: 16.0,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 232, 249, 243),
                                labelText: 'Nombre completo',
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF025810)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu nombre';
                                }
                                if (value.length < 2) {
                                  return 'El nombre debe tener al menos 2 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Campo de email
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.nunito(),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.nunito(
                                  color: const Color(0xFF025810),
                                  fontSize: 16.0,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 232, 249, 243),
                                labelText: 'Correo Electrónico',
                                prefixIcon: const Icon(Icons.email,
                                    color: Color(0xFF025810)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Por favor ingresa un email válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Campo de contraseña
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              style: GoogleFonts.nunito(),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.nunito(
                                  color: const Color(0xFF025810),
                                  fontSize: 16.0,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 232, 249, 243),
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock,
                                    color: Color(0xFF025810)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Campo de confirmar contraseña
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              style: GoogleFonts.nunito(),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.nunito(
                                  color: const Color(0xFF025810),
                                  fontSize: 16.0,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 232, 249, 243),
                                labelText: 'Confirmar Contraseña',
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Color(0xFF025810)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor confirma tu contraseña';
                                }
                                if (value != passwordController.text) {
                                  return 'Las contraseñas no coinciden';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Mostrar mensaje de error si existe
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.red.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red.shade600, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Botón de registro
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 76, 175, 79),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 65),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Crear Cuenta',
                                      style: GoogleFonts.nunito(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 24),

                            // Separador
                            Text(
                              "O regístrate con",
                              style: GoogleFonts.nunito(
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Botón de Google
                            ElevatedButton.icon(
                              onPressed:
                                  _isLoading ? null : _handleGoogleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              icon: const FaIcon(FontAwesomeIcons.google,
                                  color: Colors.red, size: 18),
                              label: Text(
                                "Continuar con Google",
                                style: GoogleFonts.nunito(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Enlace para login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "¿Ya tienes cuenta? ",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                          );
                                        },
                                  child: Text(
                                    "Iniciar Sesión",
                                    style: GoogleFonts.nunito(
                                      fontSize: 16.0,
                                      color: const Color(0xFF025810),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
