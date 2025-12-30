import "package:flutter/material.dart";
import "package:green_cloud/widgets/BottomNavBar.dart";
import "forgot_password_screen.dart";
import "../../services/auth_service.dart";
import "package:flutter/services.dart";
import "package:flutter/cupertino.dart";
import "package:rive/rive.dart" as rive;
import "package:google_fonts/google_fonts.dart";
import "../../widgets/animated_combined_painter.dart";
import "package:firebase_auth/firebase_auth.dart";

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de texto
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Instancia de AuthService
  final AuthService _authService = AuthService();

  // Estados de la UI
  bool _isLoading = false;
  String? _errorMessage;

  //ANIMACION
  var animationLink = "lib/assets/animations/animated_login_screen.riv";

  rive.SMIInput<bool>? isChecking;
  rive.SMIInput<bool>? isHandsUp;
  rive.SMIInput<bool>? trigSuccess;
  rive.SMIInput<bool>? trigFail;
  rive.SMIInput<double>? numLook;
  late rive.StateMachineController? stateMachineController;

  // Método para manejar el inicio de sesión con USERNAME (con auto-registro)
  Future<void> _handleUsernameLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      isChecking?.change(false);
      isHandsUp?.change(false);
      trigSuccess?.change(false);
      trigFail?.change(true);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    isChecking?.change(true);
    isHandsUp?.change(false);

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    try {
      UserCredential? userCredential;

      // 1. Verificar si el usuario existe antes de intentar nada
      final bool userExists = await _authService.checkUsernameExists(username);

      if (userExists) {
        // 2. Si existe, intentar iniciar sesión
        try {
          userCredential = await _authService.signInWithUsername(
            username: username,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            throw FirebaseAuthException(
              code: 'wrong-password',
              message: 'El usuario ya existe. Escribe bien la contraseña.',
            );
          }
          rethrow;
        }
      } else {
        // 3. Si NO existe, registrar automáticamente
        print('👤 Usuario nuevo detectado. Creando cuenta...');
        userCredential = await _authService.registerWithUsername(
          username: username,
          password: password,
          displayName: username,
        );
      }

      // 5. Si login o registro fue exitoso
      if (userCredential != null) {
        isChecking?.change(false);
        trigSuccess?.change(true);

        // Pequeño delay para mostrar la animación de éxito
        await Future.delayed(const Duration(milliseconds: 500));

        // Navegar a la pantalla principal
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBar()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = _authService.getErrorMessage(e);
        _isLoading = false;
      });

      isChecking?.change(false);
      isHandsUp?.change(false);
      trigSuccess?.change(false);
      trigFail?.change(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 242, 230),
      body: Stack(
        children: [
          AnimatedBackground(targetColor: Color.fromARGB(255, 189, 223, 208)),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    height: 310,
                    child: rive.RiveAnimation.asset(animationLink,
                        fit: BoxFit.fill,
                        stateMachines: ["Login Machine"], onInit: (artBoard) {
                      stateMachineController =
                          rive.StateMachineController.fromArtboard(
                        artBoard,
                        "Login Machine",
                      );
                      if (stateMachineController == null) return;
                      artBoard.addController(stateMachineController!);
                      isChecking =
                          stateMachineController?.findInput("isChecking");
                      isHandsUp =
                          stateMachineController?.findInput("isHandsUp");
                      trigSuccess =
                          stateMachineController?.findInput("trigSuccess");
                      trigFail = stateMachineController?.findInput("trigFail");
                      numLook = stateMachineController?.findInput("numLook");
                    }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 189, 223, 208),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    // Eliminada altura fija para evitar overflow
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Iniciar Sesión",
                              style: GoogleFonts.nunito(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF025810),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              onChanged: (value) {
                                if (isHandsUp != null) {
                                  isHandsUp!.change(false);
                                }
                                if (isChecking == null) return;
                                isChecking!.change(true);
                                if (numLook != null) {
                                  numLook!.change(value.length.toDouble());
                                }
                              },
                              controller: usernameController,
                              style: GoogleFonts.nunito(),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.nunito(
                                  color: const Color(0xFF025810),
                                  fontSize: 16.0,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 232, 249, 243),
                                labelText: 'Nombre de Usuario',
                                hintText: 'ejemplo: usuario123',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu nombre de usuario';
                                }
                                // Validación de username (3-20 caracteres, alfanumérico y guión bajo)
                                if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$')
                                    .hasMatch(value)) {
                                  return 'Usuario debe tener 3-20 caracteres (letras, números, _)';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32.0),
                            TextFormField(
                              onChanged: (value) {
                                if (isChecking != null) {
                                  isChecking!.change(false);
                                }
                                if (isHandsUp == null) return;
                                isHandsUp!.change(true);
                              },
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF025810)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
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
                            const SizedBox(height: 0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen()),
                                  );
                                },
                                child: Text(
                                  "¿Olvidaste tu contraseña?",
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xFF025810),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
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
                            ElevatedButton(
                              onPressed:
                                  _isLoading ? null : _handleUsernameLogin,
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
                                      'Iniciar Sesión',
                                      style: GoogleFonts.nunito(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 24),
                            // Enlace para registro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "¿No tienes cuenta? ",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          Navigator.pushNamed(
                                              context, '/register');
                                        },
                                  child: Text(
                                    "Regístrate",
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
