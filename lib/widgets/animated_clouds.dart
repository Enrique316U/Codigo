import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedCloud extends StatefulWidget {
  final String cloudAsset;
  final double speed;
  final double startPosition;
  final double size;
  final double initialPosition;

  const AnimatedCloud({
    Key? key,
    required this.cloudAsset,
    required this.speed,
    required this.startPosition,
    required this.size,
    required this.initialPosition,
  }) : super(key: key);

  @override
  State<AnimatedCloud> createState() => _AnimatedCloudState();
}

class _AnimatedCloudState extends State<AnimatedCloud>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _position = 0.0;
  double _lastUpdate = 0.0;

  @override
  void initState() {
    super.initState();
    // Establecer la posición inicial
    _position = widget.initialPosition;

    // Crear un controlador que se actualice constantemente
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    // Escuchar los cambios del controlador
    _controller.addListener(_updatePosition);
  }

  void _updatePosition() {
    if (!mounted) return;

    // Calcular el tiempo transcurrido desde la última actualización
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    if (_lastUpdate == 0) {
      _lastUpdate = now;
      return;
    }

    final elapsed = now - _lastUpdate;
    _lastUpdate = now;

    // Calcular cuánto se debe mover la nube en este intervalo
    final distance = widget.speed * elapsed * 0.03;

    setState(() {
      // Mover la nube hacia la izquierda
      _position -= distance;

      // Si la nube ha salido completamente por la izquierda, reubicarla a la derecha
      final screenWidth = MediaQuery.of(context).size.width;
      final cloudWidth = widget.size;
      final cloudWidthRatio = cloudWidth / screenWidth;

      if (_position < -0.5 - cloudWidthRatio) {
        _position = 1.0;
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePosition);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * _position,
      top: widget.startPosition,
      child: SvgPicture.asset(
        widget.cloudAsset,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}

class AnimatedClouds extends StatelessWidget {
  const AnimatedClouds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Nubes con velocidades lentas
        AnimatedCloud(
          cloudAsset: 'lib/assets/animations/nube_01.svg',
          speed: 0.5,
          startPosition: size.height * 0.1,
          size: size.width * 0.1,
          initialPosition: 1.0,
        ),
        AnimatedCloud(
          cloudAsset: 'lib/assets/animations/nube_02.svg',
          speed: 0.7,
          startPosition: size.height * 0.2,
          size: size.width * 0.05,
          initialPosition: 0.29,
        ),
        AnimatedCloud(
          cloudAsset: 'lib/assets/animations/nube_03.svg',
          speed: 1.0,
          startPosition: size.height * 0.05,
          size: size.width * 0.05,
          initialPosition: 0.75,
        ),
        AnimatedCloud(
          cloudAsset: 'lib/assets/animations/nube_04.svg',
          speed: 0.8,
          startPosition: size.height * 0.1,
          size: size.width * 0.13,
          initialPosition: -0.2,
        ),

        // Avioneta con velocidad rápida
        AnimatedCloud(
          cloudAsset: 'lib/assets/animations/avioneta.svg',
          speed: 2.5, // Velocidad más rápida que las nubes
          startPosition: size.height * 0.15, // Altura intermedia
          size: size.width * 0.05, // Tamaño pequeño para la avioneta
          initialPosition: 1.2, // Empieza desde fuera de la pantalla
        ),
      ],
    );
  }
}
