import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "04_fuction_principal.dart";

class LogoScreen extends StatefulWidget {
  static const String routeName = "/logo";
  const LogoScreen({super.key});
  @override
  LogoScreenState createState() => LogoScreenState();
}

class LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    // Navega a la siguiente pantalla después de 5 minutos (300000 ms)
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, fuction_principal.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Altura del área de rectángulos en la parte inferior
        final bottomAreaHeight = maxHeight * 0.25;

        // Cálculos para los logos
        final mainLogoSize = maxWidth * 0.5;
        // Reducimos el tamaño de los logos inferiores para móviles
        final bottomLogoWidth = maxWidth * 0.35;
        // Aumentamos el espacio entre logos
        final spaceBetween = maxWidth * 0.08;
        final totalWidth = (bottomLogoWidth * 2) + spaceBetween;
        final startX = (maxWidth - totalWidth) / 2;

        return Scaffold(
          backgroundColor:
              const Color.fromARGB(255, 72, 175, 80), // Verde de fondo
          body: SafeArea(
            child: Stack(
              children: [
                // Logo principal centrado y movido hacia arriba
                Positioned(
                  top: maxHeight * 0.16,
                  left: (maxWidth - mainLogoSize) / 2,
                  child: SvgPicture.asset(
                    'lib/assets/images/USMP_LOGO.svg',
                    width: mainLogoSize,
                  ),
                ),

                // Área de rectángulos en la parte inferior
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(maxWidth, bottomAreaHeight),
                    painter: BottomRectanglesPainter(),
                  ),
                ),

                // Primer logo en el rectángulo central
                Positioned(
                  bottom: bottomAreaHeight * 0.3,
                  left: startX,
                  child: SvgPicture.asset(
                    'lib/assets/images/concytec.svg',
                    width: bottomLogoWidth,
                    height: bottomAreaHeight * 0.35,
                    fit: BoxFit.contain,
                  ),
                ),

                // Segundo logo en el rectángulo central
                Positioned(
                  bottom: bottomAreaHeight * 0.3,
                  left: startX + bottomLogoWidth + spaceBetween,
                  child: SvgPicture.asset(
                    'lib/assets/images/prociencia.svg',
                    width: bottomLogoWidth,
                    height: bottomAreaHeight * 0.35,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BottomRectanglesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Solo dibujar la franja blanca principal, sin líneas verdes divisorias
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.3, size.width, size.height * 0.4),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
