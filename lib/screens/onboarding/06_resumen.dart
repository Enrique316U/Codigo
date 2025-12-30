import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login/login_screen.dart';
import '../login/register_screen.dart';
import "../../widgets/animated_combined_painter.dart";
// Si planeas usar AnimatedCombinedPainter, impórtalo aquí
// import '../../widgets/animated_combined_painter.dart';

class ResumenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        // Calculamos tamaños responsivos
        final titleSize = maxWidth * 0.06;
        final logoSize = maxWidth * 0.12;
        final descriptionSize = maxWidth * 0.045;
        final buttonTextSize = maxWidth * 0.045;
        final footerTextSize = maxWidth * 0.035;

        // Tamaño de la imagen ajustado para diferentes pantallas
        final imageSize = maxWidth * 0.55;

        return Scaffold(
          body: Stack(
            children: [
              /// 1. FONDO CON GRADIENTE
              Container(
                width: maxWidth,
                height: maxHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 209, 242, 230),
                      Colors.green.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              //Capa 1.5 Figuras animadas
              AnimatedBackground(
                  targetColor: const Color.fromARGB(255, 189, 223, 208)),

              /// 2. CONTENIDO PRINCIPAL
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxWidth * 0.05,
                      vertical: maxHeight * 0.02,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: maxHeight * 0.02),

                        // Imagen del personaje
                        Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 233, 241, 217),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'lib/assets/images/onboarding/pet.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: maxHeight * 0.03),

                        // Título "Resumen"
                        Text(
                          "Resumen",
                          style: GoogleFonts.nunito(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 2, 88, 16),
                          ),
                        ),

                        SizedBox(height: maxHeight * 0.02),

                        // Logo "Green Cloud"
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Green ",
                                style: GoogleFonts.nunito(
                                  fontSize: logoSize,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: "Cloud",
                                style: GoogleFonts.nunito(
                                  fontSize: logoSize,
                                  fontWeight: FontWeight.w900,
                                  color: const Color.fromARGB(255, 76, 175, 79),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: maxHeight * 0.02),

                        // Texto descriptivo
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                          child: Text(
                            "Tu configuración está lista para comenzar a cuidar tus plantas por favor apoyanos con una donación.",
                            style: GoogleFonts.nunito(
                              fontSize: descriptionSize,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 51, 51, 51),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: maxHeight * 0.04),

                        // Botón Ingresar
                        _buildButton(
                          text: "Ingresar",
                          color: const Color.fromARGB(255, 76, 175, 79),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          ),
                          height: maxHeight * 0.065,
                          fontSize: buttonTextSize,
                        ),

                        SizedBox(height: maxHeight * 0.02),

                        // Botón Registrarse
                        _buildButton(
                          text: "Registrarse",
                          color: const Color.fromARGB(255, 176, 196, 164),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          ),
                          height: maxHeight * 0.065,
                          fontSize: buttonTextSize,
                        ),

                        SizedBox(height: maxHeight * 0.04),

                        // Footer con términos y privacidad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFooterText(
                              "Privacy Policy",
                              footerTextSize,
                              Colors.grey.shade700,
                            ),
                            _buildFooterText(
                              " - ",
                              footerTextSize,
                              Colors.grey.shade700,
                            ),
                            _buildFooterText(
                              "Terms of Service",
                              footerTextSize,
                              Colors.grey.shade700,
                            ),
                          ],
                        ),

                        SizedBox(height: maxHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    required double height,
    required double fontSize,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.nunito(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText(String text, double fontSize, Color color) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

// Placeholder for the Dashboard screen
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Green Cloud",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 76, 175, 79),
      ),
      body: Center(
        child: Text(
          "Tablero Principal",
          style: GoogleFonts.nunito(
            fontSize: 18,
            color: const Color.fromARGB(255, 76, 175, 79),
          ),
        ),
      ),
    );
  }
}
