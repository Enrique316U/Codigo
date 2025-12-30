import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedCombinedPainter extends CustomPainter {
  final Color targetColor;
  final double progress;

  AnimatedCombinedPainter(this.targetColor, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Calcula el color actual basado en el progreso
    final currentColor = Color.lerp(
      const Color.fromARGB(0, 255, 255, 255),
      targetColor,
      progress,
    )!;

    final fillPaint = Paint()
      ..color = currentColor
      ..style = PaintingStyle.fill;

    // Círculo 1 (llenado)
    canvas.drawCircle(
      Offset(size.width * 0.9, -size.height * 0.0),
      size.width * 0.4,
      fillPaint,
    );

    // Círculo 2 (borde)

    // ¡Eliminamos los cuadrados de la parte de abajo!
  }

  @override
  bool shouldRepaint(covariant AnimatedCombinedPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.targetColor != targetColor;
  }
}

class AnimatedBackground extends StatefulWidget {
  final Color targetColor;

  const AnimatedBackground({super.key, required this.targetColor});

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    // Inicializar el Ticker
    _ticker = createTicker((elapsed) {
      setState(() {
        _progress = (elapsed.inMilliseconds / 1000).clamp(0.0, 1.0);
        if (_progress == 1.0) {
          _ticker.stop();
        }
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final aspectRatio = screenWidth / screenHeight; // Relación de aspecto

    // Ajuste dinámico según la relación de aspecto
    double svgHeight = screenHeight * (aspectRatio > 0.65 ? 0.35 : 0.48);
    double svgWidth = screenWidth * 1; // Mantén el ancho al 100%

    return Stack(
      children: [
        CustomPaint(
          size: Size(screenWidth, screenHeight),
          painter: AnimatedCombinedPainter(widget.targetColor, _progress),
        ),
        Positioned(
          bottom: 0,
          left: (screenWidth - svgWidth) / 2,
          child: SvgPicture.asset(
            'lib/assets/images/onboarding/misti.svg',
            width: svgWidth,
            height: svgHeight,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
