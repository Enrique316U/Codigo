import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/store_model.dart';

/// Widget para mostrar el fondo de pantalla seleccionado
/// Puede cambiar entre SVG (calidad) y JPG (rendimiento) según necesidades
class BackgroundWidget extends StatelessWidget {
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool useSvg; // true = SVG (calidad), false = JPG (rendimiento)

  const BackgroundWidget({
    Key? key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.useSvg = true, // Por defecto usar SVG para calidad
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreModel>(
      builder: (context, storeModel, child) {
        // Obtener la ruta del fondo según el tipo solicitado
        final backgroundPath = useSvg
            ? storeModel.getSelectedBackgroundSvgPath()
            : storeModel.getSelectedBackgroundJpgPath();

        if (useSvg) {
          // Usar SVG para máxima calidad en pantalla principal
          return SvgPicture.asset(
            backgroundPath,
            fit: fit,
            width: width,
            height: height,
            placeholderBuilder: (context) => _buildFallbackWidget(),
          );
        } else {
          // Usar JPG para mejor rendimiento en tienda
          return Image.asset(
            backgroundPath,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) =>
                _buildFallbackWidget(),
          );
        }
      },
    );
  }

  Widget _buildFallbackWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF1F8E9),
            const Color(0xFFE8F5E8),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.landscape,
              size: 64,
              color: Colors.green.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Fondo no disponible',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget específico para la pantalla principal (máxima calidad)
class MainScreenBackground extends StatelessWidget {
  const MainScreenBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BackgroundWidget(
      useSvg: true, // Usar SVG para máxima calidad en pantalla principal
      fit: BoxFit.cover,
    );
  }
}

/// Widget específico para vistas previas (mejor rendimiento)
class PreviewBackground extends StatelessWidget {
  final double? width;
  final double? height;

  const PreviewBackground({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      useSvg: false, // Usar JPG para mejor rendimiento en previews
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}
