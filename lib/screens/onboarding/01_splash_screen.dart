import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '02_logo_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LogoScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Calculamos tamaños responsivos
        final logoSize = maxWidth * 0.14; // 56px en una pantalla de 400px

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              /// SVG de fondo
              Positioned.fill(
                child: SvgPicture.asset(
                  "lib/assets/images/inicio.svg",
                  fit: BoxFit.cover,
                ),
              ),

              /// Texto separado en la parte superior
              Positioned(
                top: maxHeight * 0.1, // 80px en una pantalla de 800px
                left: maxWidth * 0.05, // 20px en una pantalla de 400px
                right: maxWidth * 0.05,
                child: Center(
                  child: RichText(
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
                            color: Colors.green,
                          ),
                        ),
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
}
