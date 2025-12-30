import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding/04_fuction_principal.dart';
import "../onboarding/06_resumen.dart"; // Importa la pantalla de funciones principales
import "../../widgets/animated_combined_painter.dart";

class PermisosConfiguration extends StatefulWidget {
  @override
  _PermisosConfigurationState createState() => _PermisosConfigurationState();
}

class _PermisosConfigurationState extends State<PermisosConfiguration> {
  bool _notificationsEnabled = false;
  bool _locationEnabled = false;
  bool _cameraEnabled = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        // Calculamos tamaños responsivos
        final titleSize = maxWidth * 0.06;
        final subtitleSize = maxWidth * 0.045;
        final buttonTextSize = maxWidth * 0.045;
        final iconSize = maxWidth * 0.06;

        return Scaffold(
          body: Stack(
            children: [
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
              AnimatedBackground(
                  targetColor: const Color.fromARGB(255, 189, 223, 208)),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxWidth * 0.05,
                      vertical: maxHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Botón de retroceso
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.green.shade800,
                              size: iconSize * 1.2,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        SizedBox(height: maxHeight * 0.02),

                        // Título
                        Text(
                          "Configuración de permisos",
                          style: GoogleFonts.nunito(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 2, 88, 16),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: maxHeight * 0.02),

                        // Subtítulo
                        Text(
                          "Para ofrecerte la mejor experiencia, necesitamos algunos permisos:",
                          style: GoogleFonts.nunito(
                            fontSize: subtitleSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: maxHeight * 0.04),

                        // Contenedor de permisos
                        Container(
                          padding: EdgeInsets.all(maxWidth * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildPermissionItem(
                                context: context,
                                title: "Notificaciones",
                                description:
                                    "Recibe alertas sobre el estado de tus plantas",
                                icon: Icons.notifications_none,
                                value: _notificationsEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _notificationsEnabled = value;
                                  });
                                },
                                iconSize: iconSize,
                                titleSize: subtitleSize,
                                descriptionSize: subtitleSize * 0.8,
                              ),
                              Divider(height: maxHeight * 0.03),
                              _buildPermissionItem(
                                context: context,
                                title: "Ubicación",
                                description:
                                    "Para recomendaciones basadas en tu clima local",
                                icon: Icons.location_on_outlined,
                                value: _locationEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _locationEnabled = value;
                                  });
                                },
                                iconSize: iconSize,
                                titleSize: subtitleSize,
                                descriptionSize: subtitleSize * 0.8,
                              ),
                              Divider(height: maxHeight * 0.03),
                              _buildPermissionItem(
                                context: context,
                                title: "Cámara",
                                description:
                                    "Para escanear y hacer seguimiento a tus plantas",
                                icon: Icons.camera_alt_outlined,
                                value: _cameraEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _cameraEnabled = value;
                                  });
                                },
                                iconSize: iconSize,
                                titleSize: subtitleSize,
                                descriptionSize: subtitleSize * 0.8,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: maxHeight * 0.06),

                        // Botón de continuar
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ResumenScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 76, 175, 79),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: maxHeight * 0.015),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Iniciar",
                            style: GoogleFonts.nunito(
                              fontSize: buttonTextSize,
                              fontWeight: FontWeight.w900,
                            ),
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

  Widget _buildPermissionItem({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required double iconSize,
    required double titleSize,
    required double descriptionSize,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize * 1.2,
          color: Colors.green.shade700,
        ),
        SizedBox(width: iconSize),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.nunito(
                  fontSize: descriptionSize,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ),
      ],
    );
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
