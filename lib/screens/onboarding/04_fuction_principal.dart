import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "../onboarding/05_permisos_configuracion.dart"; // Importado para navegación,
import "../onboarding/06_resumen.dart"; // Importado para navegación
import "../../widgets/animated_combined_painter.dart";

class fuction_principal extends StatefulWidget {
  static const String routeName = "/welcome";
  const fuction_principal({super.key});

  @override
  State<fuction_principal> createState() => _fuction_principalState();
}

class _fuction_principalState extends State<fuction_principal> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculamos dimensiones responsivas basadas en el tamaño de la pantalla
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        // Ajustamos tamaños de fuente y espaciado según el ancho de la pantalla
        final titleSize = maxWidth * 0.06;
        final buttonTextSize = maxWidth * 0.045;
        final descriptionSize = maxWidth * 0.04;
        final imageSize = maxWidth * 0.55; // Reducimos el tamaño de la imagen

        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: maxWidth,
                height: maxHeight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 209, 242, 230),
                      Color.fromARGB(255, 209, 242, 230),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              AnimatedBackground(
                  targetColor: const Color.fromARGB(255, 189, 223, 208)),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: maxHeight * 0.02),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            _buildWelcomePage(
                                context, imageSize, titleSize, descriptionSize),
                            _buildFeaturesPage(
                                context, imageSize, titleSize, descriptionSize),
                          ],
                        ),
                      ),
                      // Indicadores de página
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPageIndicator(0),
                          SizedBox(width: maxWidth * 0.02),
                          _buildPageIndicator(1),
                        ],
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      // Botones de navegación
                      Padding(
                        padding: EdgeInsets.only(bottom: maxHeight * 0.03),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildButton(
                                "Saltar",
                                const Color.fromARGB(255, 176, 196, 164),
                                buttonTextSize,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ResumenScreen()),
                                ),
                              ),
                            ),
                            SizedBox(width: maxWidth * 0.04),
                            Expanded(
                              child: _buildButton(
                                "Siguiente",
                                const Color.fromARGB(255, 76, 175, 79),
                                buttonTextSize,
                                () {
                                  if (_currentPage == 0) {
                                    _pageController.animateToPage(
                                      1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PermisosConfiguration(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator(int pageNumber) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == pageNumber ? Colors.green : Colors.white,
      ),
    );
  }

  Widget _buildButton(
      String text, Color color, double fontSize, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }

  Widget _buildWelcomePage(BuildContext context, double imageSize,
      double titleSize, double descriptionSize) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Padding(
              padding: EdgeInsets.all(imageSize * 0.05),
              child: ClipOval(
                child: Image.asset(
                  "lib/assets/images/onboarding/viejo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Bienvenido",
            style: GoogleFonts.nunito(
              fontSize: titleSize,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 2, 88, 16),
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Green ",
                  style: GoogleFonts.nunito(
                    fontSize: titleSize * 2,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "Cloud",
                  style: GoogleFonts.nunito(
                    fontSize: titleSize * 2,
                    fontWeight: FontWeight.w900,
                    color: const Color.fromARGB(255, 76, 175, 79),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Esta aplicación fue creada para estar siempre conectados con nuestras plantas.",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: descriptionSize,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesPage(BuildContext context, double imageSize,
      double titleSize, double descriptionSize) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Padding(
              padding: EdgeInsets.all(imageSize * 0.05),
              child: ClipOval(
                child: Image.asset(
                  "lib/assets/images/onboarding/niña.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Conoce lo que puedes hacer con Green Cloud",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: titleSize,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 2, 88, 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem(
                    context, "Monitorea tu planta", descriptionSize),
                const SizedBox(height: 15),
                _buildFeatureItem(
                    context, "Desbloquea recompensas", descriptionSize),
                const SizedBox(height: 15),
                _buildFeatureItem(context, "Aprende jugando", descriptionSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 8, right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade800,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Aquí asumimos cómo se ve la clase FunctionPrincipalScreen
// Reemplaza esto con la definición real de tu FunctionPrincipalScreen
class FunctionPrincipalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Funciones Principales"),
      ),
      body: Center(
        child: Text("Pantalla de Funciones Principales"),
      ),
    );
  }
}
