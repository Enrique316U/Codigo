import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/screens/actividades/juego_actividad_screen.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/models/etapa_models.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/models/seccion_models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../services/progreso_service.dart';

class MapaEtapaScreen extends StatefulWidget {
  final int etapaIndex;
  final VoidCallback? onBackPressed;

  const MapaEtapaScreen(
      {Key? key, required this.etapaIndex, this.onBackPressed})
      : super(key: key);

  @override
  State<MapaEtapaScreen> createState() => _MapaEtapaScreenState();
}

class _MapaEtapaScreenState extends State<MapaEtapaScreen> {
  @override
  void initState() {
    super.initState();
    // Verificar y forzar desbloqueo si es necesario
    _verificarDesbloqueoAutomatico();
  }

  Future<void> _verificarDesbloqueoAutomatico() async {
    // Solo para Etapa 6 (índice 5)
    if (widget.etapaIndex == 5) {
      final progresoService = ProgresoService();

      print('🔍 VERIFICACIÓN AUTO-DESBLOQUEO ETAPA 6:');

      // Verificar si las 3 actividades de la sección 0 están completadas
      bool act0 = await progresoService.esActividadCompletada(5, 0, 0);
      bool act1 = await progresoService.esActividadCompletada(5, 0, 1);
      bool act2 = await progresoService.esActividadCompletada(5, 0, 2);

      print('  📋 Sección 1: Act0=$act0, Act1=$act1, Act2=$act2');

      if (act0 && act1 && act2) {
        // Verificar si la sección 1 ya está desbloqueada
        bool seccion1Desbloqueada =
            await progresoService.esNodoDesbloqueado(5, 1);

        print('  🔐 Sección 2 desbloqueada: $seccion1Desbloqueada');

        if (!seccion1Desbloqueada) {
          print(
              '🔓 AUTO-DESBLOQUEO: Todas las actividades de Sección 1 completadas, desbloqueando Sección 2...');
          await progresoService.forzarDesbloqueoNodo(5, 1);
          setState(() {});
        } else {
          print('✅ Sección 2 ya estaba desbloqueada');

          // Verificar disponibilidad de primera actividad de Sección 2
          bool act0Seccion2Disponible = await _esActividadDisponible(1, 0);
          print(
              '  🎯 Primera actividad de Sección 2 disponible: $act0Seccion2Disponible');
        }
      } else {
        print('  ⏳ Aún faltan actividades por completar en Sección 1');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final etapa = etapasData[widget.etapaIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF1F8E9),
              Color(0xFFE8F5E8),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header personalizado con mejor contraste
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 15,
                bottom: 25,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    etapa.color,
                    etapa.color.withOpacity(0.8),
                    etapa.color.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: etapa.color.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (widget.onBackPressed != null)
                    GestureDetector(
                      onTap: widget.onBackPressed,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  if (widget.onBackPressed != null) const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.explore,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                'Mapa - ${etapa.nombre}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 6,
                                      color: Colors.black38,
                                    ),
                                    Shadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 1,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Explora las actividades de aprendizaje',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Contenido del body original
            Expanded(
              child: Column(
                children: [
                  _buildTopStats(etapa),
                  Expanded(
                    child: _buildSectionsList(context, etapa),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStats(EtapaData etapa) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      color: etapa.color.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Racha
          _buildStatItem(
            icon: Icons.local_fire_department,
            color: Colors.orange,
            value: '5',
            label: 'Racha',
          ),

          // Secciones completadas
          _buildStatItem(
            icon: Icons.task_alt,
            color: etapa.color,
            value: '${etapa.seccionesCompletadas}/${etapa.totalSecciones}',
            label: 'Completadas',
          ),

          // Vidas
          _buildStatItem(
            icon: Icons.favorite,
            color: Colors.red,
            value: '3',
            label: 'Vidas',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionsList(BuildContext context, EtapaData etapa) {
    // Crear las secciones para esta etapa
    final List<SectionData> secciones = _getSectionsForEtapa(etapa);

    return SingleChildScrollView(
      padding: EdgeInsets.zero, // ELIMINADO: padding superior
      child: Column(
        children: List.generate(
          secciones.length,
          (index) =>
              _buildSectionItem(context, secciones[index], etapa.color, index),
        ),
      ),
    );
  }

  Widget _buildSectionItem(BuildContext context, SectionData seccion,
      Color etapaColor, int sectionIndex) {
    return Column(
      children: [
        // Encabezado de la sección
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: seccion.color.withOpacity(0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                seccion.titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 6,
                      color: Colors.black54,
                    ),
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 2,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  _mostrarDescripcionSeccion(context, seccion);
                },
              ),
            ],
          ),
        ),
        // Contenedor de las actividades con fondo dinámico
        Container(
          padding: EdgeInsets.zero, // ELIMINADO: padding vertical
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                seccion.color.withOpacity(0.15),
                seccion.color.withOpacity(0.05),
                _getComplementaryColor(seccion.color).withOpacity(0.08),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Fondo SVG con colores dinámicos según la sección
              Positioned.fill(
                child: _buildCustomColoredSvg(seccion.color, sectionIndex),
              ),
              // Contenido de los botones encima del fondo
              _buildActividadesButtons(
                  context, seccion, etapaColor, sectionIndex),
            ],
          ),
        ),
        // ELIMINADO: const SizedBox(height: 15), - Sin separación entre secciones
      ],
    );
  }

  Widget _buildActividadesButtons(BuildContext context, SectionData seccion,
      Color etapaColor, int sectionIndex) {
    final screenWidth = MediaQuery.of(context).size.width;

    print(
        '🎯 Construyendo ${seccion.actividades.length} actividades para sección $sectionIndex');
    for (int i = 0; i < seccion.actividades.length; i++) {
      print('   📍 Actividad $i: ${seccion.actividades[i]}');
    }

    // Calcular tamaño de nodo responsivo para el posicionamiento
    final baseSize = (screenWidth * 0.15).clamp(60.0, 120.0);

    // Usar el tamaño más grande para el posicionamiento (nubes son más grandes)
    final maxNodeSize = baseSize * 1.2; // Usar tamaño de nubes como referencia
    final nodeRadius = maxNodeSize / 2;

    // Crear posiciones serpenteantes para las actividades
    final containerHeight = MediaQuery.of(context).size.height * 0.7;
    final List<Offset> positions = _createSerpentePositions(
        screenWidth, seccion.actividades.length, containerHeight);

    return Container(
      height: MediaQuery.of(context).size.height *
          0.7, // 70% de altura para actividades
      child: Stack(
        children: [
          // Dibujar líneas serpenteantes discontinuas
          CustomPaint(
            painter: ActividadPathPainter(positions, seccion.color),
            size: Size(screenWidth, MediaQuery.of(context).size.height * 0.7),
          ),
          // Botones sobre las líneas
          ...List.generate(
            seccion.actividades.length,
            (index) => Positioned(
              left: positions[index].dx -
                  nodeRadius, // Centrar usando radio responsivo
              top: positions[index].dy,
              child: _buildSingleActividadButton(
                  context, seccion, etapaColor, index, sectionIndex),
            ),
          ),
        ],
      ),
    );
  }

  List<Offset> _createSerpentePositions(
      double screenWidth, int count, double containerHeight) {
    final List<Offset> positions = [];

    if (count == 0) return positions;

    print('🗺️ Creando $count posiciones en serpiente');

    // Distribuir verticalmente según el número de elementos (en porcentajes)
    // Usar menos espacio vertical para evitar que se salgan del fondo
    final double verticalSpacing =
        count > 1 ? 0.6 / (count - 1) : 0; // 60% del contenedor distribuido

    for (int i = 0; i < count; i++) {
      double x = screenWidth * 0.25; // Valor por defecto ajustado
      final double y = containerHeight * 0.25 +
          (i *
              verticalSpacing *
              containerHeight); // Empezar en 25% de la altura (más abajo)

      // Crear patrón serpenteante con márgenes ajustados para que no se salgan del fondo
      switch (i % 4) {
        case 0:
          x = screenWidth * 0.25; // Izquierda (más centrado)
          break;
        case 1:
          x = screenWidth * 0.50; // Centro
          break;
        case 2:
          x = screenWidth * 0.75; // Derecha (más centrado)
          break;
        case 3:
          x = screenWidth * 0.50; // Centro
          break;
      }

      positions.add(Offset(x, y));
      print(
          '   📍 Posición $i: (x: ${x.toStringAsFixed(1)}, y: ${y.toStringAsFixed(1)})');
    }

    return positions;
  }

  Widget _buildSingleActividadButton(BuildContext context, SectionData seccion,
      Color etapaColor, int index, int sectionIndex) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Tamaño base adaptativo según el tamaño de pantalla
    final baseSize =
        (screenWidth * 0.15).clamp(60.0, 120.0); // Entre 60 y 120 pixels

    // Tamaño diferenciado según el tipo de sección
    final double nodeSize;
    if (sectionIndex % 2 == 0) {
      // Sección par - lápidas (tamaño base × 0.8)
      nodeSize = baseSize * 0.8;
    } else {
      // Sección impar - nubes (tamaño base × 0.8 × 1.5 = tamaño base × 1.2)
      nodeSize = baseSize * 1.2;
    }

    // Hacer una sola consulta unificada para evitar inconsistencias
    return FutureBuilder<Map<String, dynamic>>(
      future: _getActividadStatus(sectionIndex, index),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: nodeSize,
            height: nodeSize,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(seccion.color),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        bool isCompleted = data['isCompleted'] ?? false;
        bool isAvailable = data['isAvailable'] ?? false;

        // Determinar qué imagen usar según la sección (par/impar) y estado
        String imagePath;
        if (sectionIndex % 2 == 0) {
          // Sección par (0, 2, 4...) - usar lápidas
          if (isCompleted) {
            imagePath = 'lib/assets/images/mapa_progress/lapida_completado.svg';
          } else {
            // Rotar entre las 4 variantes de lápidas según el índice de actividad
            int variantNumber = (index % 4) + 1; // 1, 2, 3, 4
            imagePath =
                'lib/assets/images/mapa_progress/lapida_0$variantNumber.svg';
          }
        } else {
          // Sección impar (1, 3, 5...) - usar nubes
          if (isCompleted) {
            imagePath = 'lib/assets/images/mapa_progress/nube_completado.svg';
          } else {
            // Rotar entre las 4 variantes de nubes según el índice de actividad
            int variantNumber = (index % 4) + 1; // 1, 2, 3, 4
            imagePath =
                'lib/assets/images/mapa_progress/nube_0$variantNumber.svg';
          }
        }

        return GestureDetector(
          onTap: () async {
            // Debug: mostrar información sobre la actividad tocada
            print('🔍 ACTIVIDAD TOCADA:');
            print('  - Etapa: ${widget.etapaIndex}');
            print('  - Sección: $sectionIndex');
            print('  - Actividad: $index');
            print('  - Título: ${seccion.actividades[index]}');
            print('  - isCompleted: $isCompleted');
            print('  - isAvailable: $isAvailable');

            // Debug adicional para actividades no disponibles
            if (!isAvailable && index > 0) {
              print('  🔍 DEBUGGING DISPONIBILIDAD:');
              final progresoService = ProgresoService();
              bool anteriorCompletada =
                  await progresoService.esActividadCompletada(
                      widget.etapaIndex, sectionIndex, index - 1);
              print(
                  '    - Actividad anterior ($index-1) completada: $anteriorCompletada');
              if (sectionIndex > 0) {
                bool nodoDesbloqueado = await progresoService
                    .esNodoDesbloqueado(widget.etapaIndex, sectionIndex);
                print(
                    '    - Nodo $sectionIndex desbloqueado: $nodoDesbloqueado');
              }
            }

            if (isAvailable) {
              print('  ✅ Navegando a la actividad...');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JuegoActividadScreen(
                    etapaIndex: widget.etapaIndex,
                    seccionTitulo: seccion.titulo,
                    actividadTitulo: seccion.actividades[index],
                    actividadIndex: index,
                    color: seccion.color,
                  ),
                ),
              ).then((result) {
                // Refrescar la UI cuando regreses de la actividad
                if (mounted) {
                  print('🔄 Refrescando UI después de completar actividad');
                  setState(() {
                    // Forzar rebuild para actualizar el estado de las actividades
                  });
                }
              });
            } else {
              print('  ❌ Actividad no disponible');

              // Mensaje personalizado según la situación
              String mensaje;
              if (index == 0 && sectionIndex > 0) {
                // Primera actividad de un nodo bloqueado
                mensaje =
                    'Completa todas las actividades de la sección anterior para desbloquear este nodo';
              } else if (index > 0) {
                // Actividad que requiere completar la anterior
                mensaje =
                    'Completa la actividad anterior primero (${seccion.actividades[index - 1]})';
              } else {
                mensaje = 'Esta actividad no está disponible aún';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    mensaje,
                    style: TextStyle(color: etapaColor),
                  ),
                  backgroundColor: Colors.white,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: Stack(
            children: [
              // SVG de la actividad
              Container(
                width: nodeSize,
                height: nodeSize,
                child: FutureBuilder<String>(
                  future: _loadSvgString(imagePath, nodeSize),
                  builder: (context, svgSnapshot) {
                    if (svgSnapshot.hasData) {
                      return SvgPicture.string(
                        svgSnapshot.data!,
                        width: nodeSize,
                        height: nodeSize,
                        fit: BoxFit.contain,
                      );
                    } else {
                      // Fallback mientras carga la imagen
                      return Container(
                        width: nodeSize,
                        height: nodeSize,
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.white : Colors.grey[300],
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (isCompleted)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                          border: Border.all(
                            color: seccion.color.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: nodeSize *
                                  0.25, // Tamaño de fuente responsivo
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? seccion.color
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              // Badge con número de actividad
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: nodeSize * 0.3,
                  height: nodeSize * 0.3,
                  decoration: BoxDecoration(
                    color: isAvailable ? seccion.color : Colors.grey[400],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: nodeSize * 0.15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  void _mostrarDescripcionSeccion(BuildContext context, SectionData seccion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          seccion.titulo,
          style: TextStyle(
            color: seccion.color,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        content: Text(seccion.descripcion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: seccion.color),
            child: const Text(
              'CERRAR',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Determinar si una actividad está disponible según las reglas de progreso
  Future<bool> _esActividadDisponible(
      int sectionIndex, int actividadIndex) async {
    final progresoService = ProgresoService();

    print(
        '🔍 Evaluando disponibilidad - Etapa: ${widget.etapaIndex}, Sección: $sectionIndex, Actividad: $actividadIndex');

    // Verificar si esta actividad ya está completada
    bool yaCompletada = await progresoService.esActividadCompletada(
        widget.etapaIndex, sectionIndex, actividadIndex);

    if (yaCompletada) {
      print('  ✅ Actividad ya completada - SE PUEDE REPETIR');
      return true; // Las actividades completadas se pueden repetir
    }

    // Para el primer nodo (sección 0), las actividades están disponibles secuencialmente
    if (sectionIndex == 0) {
      // La primera actividad siempre está disponible si no está completada
      if (actividadIndex == 0) {
        print('  ✅ Primera actividad del primer nodo - DISPONIBLE');
        return true;
      }

      // Las siguientes actividades están disponibles si la anterior está completada
      bool anteriorCompletada = await progresoService.esActividadCompletada(
          widget.etapaIndex, sectionIndex, actividadIndex - 1);
      print(
          '  📋 Actividad anterior (Etapa:${widget.etapaIndex}, Sección:$sectionIndex, Actividad:${actividadIndex - 1}) completada: $anteriorCompletada');
      if (anteriorCompletada) {
        print('  ✅ Actividad anterior completada - DISPONIBLE');
        return true;
      } else {
        print('  ❌ Actividad anterior no completada - NO DISPONIBLE');
        return false;
      }
    }

    // Para los siguientes nodos, primero verificar si el nodo está desbloqueado
    bool nodoDesbloqueado = await progresoService.esNodoDesbloqueado(
        widget.etapaIndex, sectionIndex);
    print('  🔐 Nodo $sectionIndex desbloqueado: $nodoDesbloqueado');

    if (!nodoDesbloqueado) {
      print('  ❌ Nodo no desbloqueado - NO DISPONIBLE');
      return false;
    }

    // Si el nodo está desbloqueado, aplicar las mismas reglas secuenciales
    if (actividadIndex == 0) {
      print('  ✅ Primera actividad de nodo desbloqueado - DISPONIBLE');
      return true;
    }

    // Para actividades que NO son la primera del nodo, verificar secuencia
    print('  🔍 Verificando secuencia dentro del nodo desbloqueado...');
    bool anteriorCompletada = await progresoService.esActividadCompletada(
        widget.etapaIndex, sectionIndex, actividadIndex - 1);
    print(
        '  📋 Actividad anterior (Etapa:${widget.etapaIndex}, Sección:$sectionIndex, Actividad:${actividadIndex - 1}) completada: $anteriorCompletada');

    if (anteriorCompletada) {
      print('  ✅ Actividad anterior completada - DISPONIBLE');
      return true;
    } else {
      print('  ❌ Actividad anterior no completada - NO DISPONIBLE');
      return false;
    }
  }

  List<SectionData> _getSectionsForEtapa(EtapaData etapa) {
    // Verificar que solo tenemos hasta la etapa 6
    if (widget.etapaIndex > 5) {
      // widget.etapaIndex es 0-based, entonces 5 = etapa 6
      return []; // No mostrar secciones para etapas superiores a 6
    }

    // En base a la etapa, crear SOLO 2 secciones específicas
    switch (widget.etapaIndex) {
      case 0: // Etapa 1: Desarrollo Sostenible - Jardín de la Vida
        return [
          SectionData(
            titulo: 'Seres Vivos y Plantas',
            color: Colors.green[600]!,
            descripcion:
                '¿Qué son los seres vivos? La planta y sus partes. Cuidado de las plantas. Conociendo a los animales.',
            actividades: [
              '¿Qué son los seres vivos?',
              'La planta y sus partes',
              'Cuidado de las plantas',
              'Conociendo a los animales',
            ],
            completadas: 0,
          ),
          SectionData(
            titulo: 'Animales, Agua y Suelo',
            color: Colors.blue[600]!,
            descripcion:
                'Cuidado de los animales. El agua y sus estados. El aire y su contaminación. El suelo y sus tipos.',
            actividades: [
              'Cuidado de los animales',
              'El agua y sus estados',
              'El aire y su contaminación',
              'El suelo y sus tipos',
            ],
            completadas: 0,
          ),
        ];

      case 1: // Etapa 2: Ecosistemas - Bosque del Cuidado Ambiental
        return [
          SectionData(
            titulo: 'Seres Vivos y Materiales',
            color: Colors.orange[600]!,
            descripcion:
                'Las plantas y sus funciones. Los animales y sus características. Clasificación de materiales. Fenómenos del clima.',
            actividades: [
              'Las Plantas y sus Funciones',
              'Los Animales y sus Características',
              'Clasificación de Materiales',
              'Fenómenos del Clima',
            ],
            completadas: 0,
          ),
          SectionData(
            titulo: 'Cuidado Ambiental y Física',
            color: Colors.cyan[600]!,
            descripcion: 'Cuidado del ambiente. Fuerzas simples. El sonido.',
            actividades: [
              'Cuidado del Ambiente',
              'Fuerzas Simples',
              'El Sonido',
            ],
            completadas: 0,
          ),
        ];

      case 2: // Etapa 3: Energías Renovables - Ecosistema Acuático
        return [
          SectionData(
            titulo: 'Plantas y Ecosistemas',
            color: Colors.teal[600]!,
            descripcion:
                'Importancia de las plantas. Insectos y arácnidos en el ecosistema. ¿Qué es un ecosistema? Proyecto: Animales en extinción.',
            actividades: [
              'Importancia de las plantas',
              'Insectos y arácnidos en el ecosistema',
              '¿Qué es un ecosistema?',
              'Proyecto: Animales en extinción',
            ],
            completadas: 0,
          ),
          SectionData(
            titulo: 'Agua, Aire y Suelo',
            color: Colors.indigo[600]!,
            descripcion:
                'El agua y sus propiedades. El ciclo del agua. El aire y sus propiedades. Contaminación del aire. El suelo y su conservación.',
            actividades: [
              'El agua y sus propiedades',
              'El ciclo del agua',
              'El aire y sus propiedades',
              'Contaminación del aire',
              'El suelo y su conservación',
            ],
            completadas: 0,
          ),
        ];

      case 3: // Etapa 4: Economía Circular - Región Andina
        return [
          SectionData(
            titulo: 'Ecosistemas y Alimentación',
            color: Colors.purple[600]!,
            descripcion:
                'Clasificación de ecosistemas. Cadenas y redes alimenticias. Ciclos biogeoquímicos. Cambio climático.',
            actividades: [
              'Ecosistemas y su clasificación',
              'Cadenas y redes alimenticias',
              'Ciclos biogeoquímicos',
              'Cambio climático',
            ],
            completadas: 0,
          ),
          SectionData(
            titulo: 'Función del Suelo',
            color: Colors.brown[600]!,
            descripcion:
                'Conservación del suelo y ecosistemas locales del Perú.',
            actividades: [
              'Conservación del suelo',
              'Ecosistemas locales',
            ],
            completadas: 0,
          ),
        ];

      case 4: // Etapa 5: Agua y Recursos Hídricos - Desiertos y Humedales
        return [
          SectionData(
            titulo: 'Plantas y Factores del Ecosistema',
            color: Colors.amber[700]!,
            descripcion:
                'Importancia de las plantas. Factores del ecosistema. Hábitat y nicho ecológico. Relaciones interespecíficas.',
            actividades: [
              'Importancia de las plantas',
              'Factores del ecosistema',
              'Hábitat y nicho ecológico',
              'Relaciones interespecíficas',
            ],
            completadas: 0,
          ),
          SectionData(
            titulo: 'Importancia del Agua, Aire y Suelo',
            color: Colors.lime[700]!,
            descripcion:
                'Importancia del agua. Importancia del aire. Importancia del suelo.',
            actividades: [
              'Importancia del agua',
              'Importancia del aire',
              'Importancia del suelo',
            ],
            completadas: 0,
          ),
        ];

      case 5: // Etapa 6: Alimentación Sostenible - Ecosistema Global
        return [
          SectionData(
            titulo: 'Biología y Biodiversidad',
            color: Colors.deepPurple[600]!,
            descripcion:
                'Introducción a la biología. Los seres vivos y la biodiversidad. Niveles de organización de los seres vivos.',
            actividades: [
              'Introducción a la biología',
              'Los seres vivos y la biodiversidad',
              'Niveles de organización de los seres vivos',
            ],
            completadas: 0,
          ),
          SectionData(
            titulo: 'Ecosistemas y Población',
            color: Colors.pink[600]!,
            descripcion:
                'Ecosistemas. Factores bióticos y abióticos. Población, comunidad, ecosistema y biosfera.',
            actividades: [
              'Ecosistemas',
              'Factores bióticos y abióticos',
              'Población, comunidad, ecosistema y biosfera',
            ],
            completadas: 0,
          ),
        ];

      default:
        // Para etapas superiores a 6, no mostrar nada
        return [];
    }
  }

  // Método para generar colores complementarios que coordinen visualmente
  Color _getComplementaryColor(Color color) {
    // Obtener valores HSV para manipular el color
    final hsvColor = HSVColor.fromColor(color);

    // Crear un color complementario ajustando el matiz
    final complementaryHue = (hsvColor.hue + 120) % 360;

    // Mantener saturación y valor similares pero ligeramente diferentes
    final complementaryColor = HSVColor.fromAHSV(
      hsvColor.alpha,
      complementaryHue,
      (hsvColor.saturation * 0.7).clamp(0.0, 1.0), // Asegurar que no exceda 1.0
      (hsvColor.value * 1.1).clamp(0.0, 1.0), // Asegurar que no exceda 1.0
    );

    return complementaryColor.toColor();
  }

  // Método para crear SVG con colores personalizados según la sección
  Widget _buildCustomColoredSvg(Color sectionColor, int sectionIndex) {
    return Builder(
      builder: (context) => FutureBuilder<String>(
        future: _getCustomColoredSvgString(context, sectionColor, sectionIndex),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SvgPicture.string(
              snapshot.data!,
              fit: BoxFit.cover,
            );
          } else {
            // Fallback mientras carga
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    sectionColor.withOpacity(0.15),
                    sectionColor.withOpacity(0.05),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Método para cargar SVG desde assets
  Future<String> _loadSvgString(String assetPath, double size) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      print('❌ Error cargando SVG desde $assetPath: $e');
      // Retornar SVG básico responsivo en caso de error
      final center = size / 2;
      final radius = center * 0.8;
      final fontSize = size * 0.25;
      final strokeWidth = size * 0.03;

      return '''<svg width="$size" height="$size" viewBox="0 0 $size $size" fill="none">
        <circle cx="$center" cy="$center" r="$radius" fill="#e0e0e0" stroke="#9e9e9e" stroke-width="$strokeWidth"/>
        <text x="$center" y="${center + fontSize * 0.3}" text-anchor="middle" fill="#666" font-size="$fontSize" font-weight="bold">?</text>
      </svg>''';
    }
  }

  // Método para generar SVG string con colores personalizados
  Future<String> _getCustomColoredSvgString(
      BuildContext context, Color sectionColor, int sectionIndex) async {
    try {
      // Verificar que solo tenemos hasta la etapa 6
      if (widget.etapaIndex > 5) {
        // widget.etapaIndex es 0-based, entonces 5 = etapa 6
        return '''<svg width="408" height="408" viewBox="0 0 408 408" fill="none">
          <rect width="408" height="408" fill="${_colorToHex(sectionColor.withOpacity(0.1))}" />
          <text x="204" y="204" text-anchor="middle" fill="${_colorToHex(sectionColor)}" font-size="16">Etapa no disponible</text>
        </svg>''';
      }

      // Calcular el número de imagen según la etapa y sección
      // Etapa 1: imágenes 01-02, Etapa 2: imágenes 03-04, etc.
      final imageNumber = (widget.etapaIndex * 2) + sectionIndex + 1;
      final svgPath =
          'lib/assets/images/mapa_progress/mapa_progress_${imageNumber.toString().padLeft(2, '0')}.svg';

      print(
          '🗺️ Cargando imagen de fondo: $svgPath para etapa ${widget.etapaIndex + 1}, sección ${sectionIndex + 1}');

      final svgString =
          await DefaultAssetBundle.of(context).loadString(svgPath);

      // Las nuevas imágenes ya vienen con sus colores apropiados,
      // así que las devolvemos tal como están
      return svgString;
    } catch (e) {
      print(
          '❌ Error cargando imagen de fondo para etapa ${widget.etapaIndex + 1}, sección ${sectionIndex + 1}: $e');

      // En caso de error, retornar SVG básico con información de la etapa
      final imageNumber = (widget.etapaIndex * 2) + sectionIndex + 1;
      return '''<svg width="408" height="408" viewBox="0 0 408 408" fill="none">
        <rect width="408" height="408" fill="${_colorToHex(sectionColor.withOpacity(0.1))}" />
        <circle cx="204" cy="154" r="80" fill="${_colorToHex(sectionColor.withOpacity(0.3))}" />
        <text x="204" y="160" text-anchor="middle" fill="${_colorToHex(sectionColor)}" font-size="24" font-weight="bold">Etapa ${widget.etapaIndex + 1}</text>
        <text x="204" y="190" text-anchor="middle" fill="${_colorToHex(sectionColor)}" font-size="16">Sección ${sectionIndex + 1}</text>
        <text x="204" y="260" text-anchor="middle" fill="${_colorToHex(sectionColor)}" font-size="14">Imagen ${imageNumber.toString().padLeft(2, '0')} no disponible</text>
      </svg>''';
    }
  }

  // Método para convertir Color a string hexadecimal
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  // Método para obtener el estado de completitud y disponibilidad de una actividad
  Future<Map<String, dynamic>> _getActividadStatus(
      int sectionIndex, int actividadIndex) async {
    final progresoService = ProgresoService();

    // Obtener el estado de completitud de la actividad
    bool isCompleted = await progresoService.esActividadCompletada(
        widget.etapaIndex, sectionIndex, actividadIndex);

    // Obtener el estado de disponibilidad de la actividad
    bool isAvailable =
        await _esActividadDisponible(sectionIndex, actividadIndex);

    return {
      'isCompleted': isCompleted,
      'isAvailable': isAvailable,
    };
  }
}

// Painter para dibujar las líneas serpenteantes discontinuas en actividades
class ActividadPathPainter extends CustomPainter {
  final List<Offset> positions;
  final Color color;

  ActividadPathPainter(this.positions, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Pintura principal para el cuerpo de la culebra (líneas discontinuas)
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 12.0 // TRIPLICADO: era 4.0, ahora 12.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Pintura para la línea interior más clara (escamas de culebra)
    final innerPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 6.0 // TRIPLICADO: era 2.0, ahora 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (positions.isNotEmpty) {
      // Empezar desde el primer punto
      path.moveTo(positions[0].dx, positions[0].dy + 30);

      // Crear curvas serpenteantes como una culebra real
      for (int i = 1; i < positions.length; i++) {
        final current = Offset(positions[i].dx, positions[i].dy + 30);
        final previous = Offset(positions[i - 1].dx, positions[i - 1].dy + 30);

        // Calcular la distancia entre puntos
        final deltaX = current.dx - previous.dx;
        final deltaY = current.dy - previous.dy;

        // Crear curvas serpenteantes como una culebra real
        double verticalInfluence =
            0.6; // Mayor influencia vertical para ondulaciones

        // Punto de control 1: Curva inicial más suave
        final controlPoint1 = Offset(
          previous.dx + deltaX * 0.3,
          previous.dy + deltaY * verticalInfluence,
        );

        // Punto de control 2: Curva final que completa la ondulación
        final controlPoint2 = Offset(
          current.dx - deltaX * 0.3,
          current.dy - deltaY * (1 - verticalInfluence),
        );

        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          current.dx,
          current.dy,
        );
      }
    }

    // Dibujar líneas discontinuas para efecto serpenteante
    _drawDashedPath(canvas, path, paint,
        dashLength: 15.0,
        gapLength: 20.0); // AUMENTADO gap: era 10.0, ahora 20.0

    // Dibujar la línea interior discontinua para efecto de escamas
    _drawDashedPath(canvas, path, innerPaint,
        dashLength: 12.0,
        gapLength: 16.0); // AUMENTADO gap: era 8.0, ahora 16.0
  }

  // Método para dibujar líneas discontinuas
  void _drawDashedPath(Canvas canvas, Path path, Paint paint,
      {required double dashLength, required double gapLength}) {
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0.0;
      bool drawDash = true;

      while (distance < metric.length) {
        final currentLength = drawDash ? dashLength : gapLength;
        final end = distance + currentLength;

        if (drawDash) {
          final segment = metric.extractPath(
              distance, end > metric.length ? metric.length : end);
          canvas.drawPath(segment, paint);
        }

        distance = end;
        drawDash = !drawDash;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
