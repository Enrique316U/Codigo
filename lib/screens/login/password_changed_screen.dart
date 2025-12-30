import "package:flutter/material.dart";
import "package:green_cloud/screens/onboarding/04_fuction_principal.dart";
import "package:green_cloud/widgets/animated_combined_painter.dart";

class PasswordChangedScreen extends StatelessWidget {
  static const String routeName = "/password_changed";
  const PasswordChangedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(
            targetColor: Color.fromARGB(255, 151, 226, 193),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 220),
                Text(
                  "¡Contraseña Cambiada!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 30),
                Text(
                  "Tu contraseña ha sido cambiada con éxito",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                const Icon(Icons.check_circle,
                    color: Color.fromARGB(255, 151, 226, 193), size: 200),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const fuction_principal()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 65),
                    backgroundColor: const Color.fromARGB(255, 193, 39, 44),
                    shadowColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: Text("Volver al Inicio",
                      style: Theme.of(context).textTheme.titleSmall),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
