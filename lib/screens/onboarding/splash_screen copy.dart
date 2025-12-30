import "package:flutter/material.dart";
import "02_logo_screen.dart";
import "package:rive/rive.dart" as rive;

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 100.0; //grosor de la linea

    //dibujar linea
    final startPoint = Offset(size.width * -0.1,
        size.height - 220); // Comienza más hacia el centro izquierdo
    final endPoint = Offset(
        size.width + 40,
        size.height *
            0.2); // Termina más hacia el centro derecho // Termina más hacia el centro

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  static const String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late rive.RiveAnimationController _controllerLogo;
  late rive.RiveAnimationController _controllerPet;
  late rive.RiveAnimationController _controllerCloud;

  @override
  void dispose() {
    //desechar el controlador
    _controllerCloud.dispose();
    _controllerPet.dispose();
    _controllerLogo.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controllerCloud = rive.SimpleAnimation("letra");
    _controllerPet = rive.SimpleAnimation("pet_pestañas");
    _controllerLogo = rive.SimpleAnimation("usmp_logo_animate");
    //DURACION
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LogoScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: Stack(
        children: [
          //fondo de pantalla
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: DiagonalLinePainter(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo superior
                SizedBox(
                  width: 100,
                  height: 100,
                  child: rive.RiveAnimation.asset(
                    "lib/assets/animations/usmp.riv",
                    fit: BoxFit.cover,
                    controllers: [_controllerLogo],
                    onInit: (_) => setState(() {}),
                  ),
                ),
                SizedBox(height: 70), // espacio entre logo y texto

                SizedBox(
                  width: 300,
                  height: 300,
                  child: rive.RiveAnimation.asset(
                    "lib/assets/animations/pet_machin.riv",
                    fit: BoxFit.cover,
                    controllers: [_controllerPet],
                    onInit: (_) => setState(() {}),
                  ),
                ),
                SizedBox(height: 70),
                //rive animacion
                SizedBox(
                    width: 300,
                    height: 100,
                    child: rive.RiveAnimation.asset(
                      "lib/assets/animations/palabras.riv",
                      fit: BoxFit.cover,
                      controllers: [_controllerCloud],
                      onInit: (_) => setState(() {}),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
