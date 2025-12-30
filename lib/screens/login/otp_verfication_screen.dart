import 'package:flutter/material.dart';
import "package:green_cloud/widgets/animated_combined_painter.dart";
import "package:green_cloud/screens/login/password_changed_screen.dart";

class OtpVerificationScreen extends StatelessWidget {
  static const String routeName = "/otp-verification";
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(
              targetColor: const Color.fromARGB(255, 151, 226, 193)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                Text(
                  "Verificación OTP",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Text(
                  "Ingrese el código de verificación que acabamos de enviar a su dirección de correo electrónico.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _buildOtpField()),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Lógica de verificación aquí
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PasswordChangedScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 65),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 193, 39, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Verificar",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const Spacer(),
                const Text(
                  "¿Recordaste la contraseña? Inicia sesión",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpField() {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
