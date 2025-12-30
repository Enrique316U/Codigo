import 'package:flutter/material.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/screens/etapas/mapa_etapa_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/models/etapa_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EtapaDetalleScreen extends StatefulWidget {
  final int etapa;
  final VoidCallback? onBackPressed;
  final Function(int)? onIngresarPressed;
  final Function(int)? onEtapaChanged; // Nuevo callback para notificar cambios

  const EtapaDetalleScreen(
      {Key? key,
      required this.etapa,
      this.onBackPressed,
      this.onIngresarPressed,
      this.onEtapaChanged}) // Agregar el nuevo parámetro
      : super(key: key);

  @override
  State<EtapaDetalleScreen> createState() => _EtapaDetalleScreenState();
}

class _EtapaDetalleScreenState extends State<EtapaDetalleScreen> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.etapa - 1;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Guardar la etapa actual en SharedPreferences
  Future<void> _saveCurrentEtapa(int etapa) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ultima_etapa_visitada', etapa);
      print('💾 Etapa $etapa guardada desde EtapaDetalleScreen');
    } catch (e) {
      print('❌ Error guardando etapa desde EtapaDetalleScreen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Solo mostrar las primeras 6 etapas
    const maxEtapas = 6;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: maxEtapas, // Limitado a 6 etapas
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });

                // Notificar el cambio de etapa al padre (BottomNavBar)
                final nuevaEtapa = index + 1;
                print('📖 Cambiando a etapa: $nuevaEtapa');

                // Guardar automáticamente la nueva etapa
                _saveCurrentEtapa(nuevaEtapa);

                // Notificar al padre si tiene el callback
                if (widget.onEtapaChanged != null) {
                  widget.onEtapaChanged!(nuevaEtapa);
                }
              },
              itemBuilder: (context, index) {
                return _buildEtapaPage(context, etapasData[index], index + 1);
              },
            ),
          ),
          _buildPageIndicator(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEtapaPage(
      BuildContext context, EtapaData etapa, int numeroEtapa) {
    // Obtener el tamaño de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Definir el porcentaje que quieres para la imagen (puedes modificar estos valores)
    final imageContainerSize = screenWidth * 0.8; // 50% del ancho de pantalla
    final imageSize = imageContainerSize * 0.9; // 75% del contenedor

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: etapa.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: etapa.color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: etapa.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de la etapa
            Container(
              width: imageContainerSize,
              height: imageContainerSize,
              decoration: BoxDecoration(
                color: etapa.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  etapa.imagen,
                  width: imageSize,
                  height: imageSize,
                  placeholderBuilder: (context) => Icon(
                    Icons.eco,
                    size: imageSize * 0.6, // 60% del tamaño de la imagen
                    color: etapa.color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Título de la etapa
            Text(
              etapa.nombre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: etapa.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Información de secciones
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: etapa.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Secciones: ${etapa.seccionesCompletadas}/${etapa.totalSecciones}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: etapa.color,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Barra de progreso
            Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: etapa.seccionesCompletadas / etapa.totalSecciones,
                child: Container(
                  decoration: BoxDecoration(
                    color: etapa.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Botones con estilo rectangular
            Column(
              children: [
                // Botón Objetivos
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _mostrarObjetivos(context, etapa);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade50,
                      foregroundColor: Colors.grey.shade700,
                      elevation: 1,
                      side: BorderSide(color: Colors.grey.shade200, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'OBJETIVOS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Botón Ingresar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.onIngresarPressed != null) {
                        widget.onIngresarPressed!(_currentPage);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MapaEtapaScreen(etapaIndex: _currentPage),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: etapa.color,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'INGRESAR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    const maxEtapas = 6; // Solo mostrar indicadores para las primeras 6 etapas

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(maxEtapas, (index) {
          return Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _currentPage
                  ? etapasData[_currentPage].color
                  : Colors.grey.shade300,
            ),
          );
        }),
      ),
    );
  }

  void _mostrarObjetivos(BuildContext context, EtapaData etapa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Objetivos',
          style: TextStyle(color: etapa.color, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(etapa.descripcion),
              const SizedBox(height: 20),
              ...etapa.objetivos.map((objetivo) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: etapa.color, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(objetivo)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: etapa.color),
            child: const Text('CERRAR'),
          ),
        ],
      ),
    );
  }
}
