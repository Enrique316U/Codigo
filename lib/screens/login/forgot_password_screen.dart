import "package:flutter/material.dart";
import "../../widgets/animated_combined_painter.dart";
import "../../services/auth_service.dart";
import "package:google_fonts/google_fonts.dart";

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = "/forgot-password";
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

  Future<void> _handlePasswordReset() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await _authService.sendPasswordResetEmail(emailController.text.trim());
      setState(() {
        _isSuccess = true;
        _message =
            'Se ha enviado un correo de recuperación a ${emailController.text.trim()}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _message = _authService.getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
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
                  const SizedBox(height: 40),
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
                            // Icono
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF025810).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 60,
                                color: Color(0xFF025810),
                              ),
                            ),
                            const SizedBox(height: 24),

                            Text(
                              "¿Olvidaste tu contraseña?",
                              style: GoogleFonts.nunito(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF025810),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            Text(
                              "No te preocupes, ingresa tu correo electrónico y te enviaremos un enlace para recuperar tu contraseña",
                              style: GoogleFonts.nunito(
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Campo de email
                            if (!_isSuccess) ...[
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
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Por favor ingresa un email válido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Mostrar mensaje si existe
                            if (_message != null) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: _isSuccess
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _isSuccess
                                        ? Colors.green.shade300
                                        : Colors.red.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _isSuccess
                                          ? Icons.check_circle_outline
                                          : Icons.error_outline,
                                      color: _isSuccess
                                          ? Colors.green.shade600
                                          : Colors.red.shade600,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _message!,
                                        style: TextStyle(
                                          color: _isSuccess
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Botón principal
                            if (!_isSuccess) ...[
                              ElevatedButton(
                                onPressed:
                                    _isLoading ? null : _handlePasswordReset,
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
                                        'Enviar Enlace',
                                        style: GoogleFonts.nunito(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ] else ...[
                              // Botón para volver al login
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 76, 175, 79),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 65),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  'Volver al Login',
                                  style: GoogleFonts.nunito(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),

                            // Enlace para volver
                            if (!_isSuccess) ...[
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                child: Text(
                                  "Volver al inicio de sesión",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.0,
                                    color: const Color(0xFF025810),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
