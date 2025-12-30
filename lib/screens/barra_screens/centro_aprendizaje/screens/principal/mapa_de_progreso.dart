import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/store_model.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/screens/etapas/etapa_detalle_screen.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/screens/actividades/juegos_seccion_screen.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/models/seccion_models.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapaDeProgreso extends StatelessWidget {
  final Function(int)? onEtapaSelected;

  const MapaDeProgreso({Key? key, this.onEtapaSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header mejorado con mejor contraste
            SliverAppBar(
              expandedHeight: 160,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[800]!,
                        Colors.green[700]!,
                        Colors.green[600]!,
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
                        color: Colors.green.withOpacity(0.4),
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
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
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
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.25),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.3),
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
                                        const Flexible(
                                          child: Text(
                                            'Mapa de Progreso',
                                            style: TextStyle(
                                              fontSize: 28,
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
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.school,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Tu viaje de aprendizaje ambiental',
                                            style: TextStyle(
                                              fontSize: 15,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Estadísticas mejoradas
            SliverToBoxAdapter(
              child: _buildTopStats(),
            ),

            // Botón de etapa mejorado
            SliverToBoxAdapter(
              child: _buildStageButton(context),
            ),

            // Lista de secciones
            SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: _buildSectionsList(context),
            ),

            // Espacio extra al final
            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStats() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          // Racha de días consecutivos
          Expanded(
            child: _buildStatCard(
              icon: Icons.local_fire_department,
              color: Colors.orange,
              value: '5',
              label: 'Racha de días',
              gradient: [Colors.orange[400]!, Colors.orange[600]!],
            ),
          ),
          const SizedBox(width: 12),

          // Monedas
          Expanded(
            child: Consumer<StoreModel>(
              builder: (context, storeModel, child) {
                return _buildStatCard(
                  icon: Icons.monetization_on,
                  color: Colors.amber,
                  value: '${storeModel.coins}',
                  label: 'Monedas',
                  gradient: [Colors.amber[400]!, Colors.amber[600]!],
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Corazones/Vidas
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite,
              color: Colors.red,
              value: '3',
              label: 'Vidas',
              gradient: [Colors.red[400]!, Colors.red[600]!],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStageButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          if (onEtapaSelected != null) {
            onEtapaSelected!(1);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EtapaDetalleScreen(etapa: 1),
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[500]!, Colors.green[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ETAPA 1',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '¡Comienza tu aventura!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Nivel Principiante',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionsList(BuildContext context) {
    // Definir las 10 secciones con sus datos
    final List<SectionInfo> secciones = [
      SectionInfo(
        color: Colors.red[400]!,
        title: 'Sección 1',
        description:
            'Introducción al desarrollo sostenible y conciencia ambiental.',
        activities: [
          'Actividad 1: Introducción',
          'Actividad 2: Conceptos básicos',
          'Actividad 3: Reciclaje básico',
          'Actividad 4: Quiz inicial',
          'Actividad 5: Reto práctico',
          'Actividad 6: Mini-juego',
          'Actividad 7: Evaluación',
        ],
      ),
      SectionInfo(
        color: Colors.orange[400]!,
        title: 'Sección 2',
        description:
            'Residuos y economía circular: reutilización de materiales.',
        activities: [
          'Actividad 1: Tipos de residuos',
          'Actividad 2: Separación correcta',
          'Actividad 3: Economía circular',
          'Actividad 4: Quiz de reconocimiento',
          'Actividad 5: Creación con reciclados',
          'Actividad 6: Mini-juego de clasificación',
          'Actividad 7: Evaluación final',
        ],
      ),
      SectionInfo(
        color: Colors.yellow[700]!,
        title: 'Sección 3',
        description: 'Consumo responsable y huella ecológica personal.',
        activities: [
          'Actividad 1: ¿Qué compramos?',
          'Actividad 2: Huella de carbono',
          'Actividad 3: Consumo local',
          'Actividad 4: Quiz de hábitos',
          'Actividad 5: Reto de reducción',
          'Actividad 6: Mini-juego de compras',
          'Actividad 7: Evaluación y compromisos',
        ],
      ),
      SectionInfo(
        color: Colors.green[500]!,
        title: 'Sección 4',
        description: 'Agua y recursos hídricos: conservación y uso eficiente.',
        activities: [
          'Actividad 1: El ciclo del agua',
          'Actividad 2: Uso doméstico',
          'Actividad 3: Contaminación',
          'Actividad 4: Quiz sobre agua',
          'Actividad 5: Detección de fugas',
          'Actividad 6: Mini-juego de ahorro',
          'Actividad 7: Evaluación práctica',
        ],
      ),
      SectionInfo(
        color: Colors.blue[400]!,
        title: 'Sección 5',
        description: 'Energías renovables y eficiencia energética en el hogar.',
        activities: [
          'Actividad 1: Tipos de energía',
          'Actividad 2: Renovables vs. Fósiles',
          'Actividad 3: Ahorro energético',
          'Actividad 4: Quiz energético',
          'Actividad 5: Auditoría casera',
          'Actividad 6: Mini-juego de fuentes',
          'Actividad 7: Evaluación de impacto',
        ],
      ),
      SectionInfo(
        color: Colors.indigo[400]!,
        title: 'Sección 6',
        description: 'Biodiversidad y ecosistemas: protección y conservación.',
        activities: [
          'Actividad 1: Ecosistemas locales',
          'Actividad 2: Especies en peligro',
          'Actividad 3: Cadenas alimentarias',
          'Actividad 4: Quiz de especies',
          'Actividad 5: Observación natural',
          'Actividad 6: Mini-juego de hábitats',
          'Actividad 7: Evaluación ecosistémica',
        ],
      ),
      SectionInfo(
        color: Colors.purple[400]!,
        title: 'Sección 7',
        description: 'Alimentación sostenible y huertos urbanos.',
        activities: [
          'Actividad 1: Impacto alimentario',
          'Actividad 2: Alimentos de temporada',
          'Actividad 3: Crear un huerto',
          'Actividad 4: Quiz de cultivos',
          'Actividad 5: Recetas sostenibles',
          'Actividad 6: Mini-juego de granjero',
          'Actividad 7: Evaluación de cosecha',
        ],
      ),
      SectionInfo(
        color: Colors.pink[400]!,
        title: 'Sección 8',
        description: 'Movilidad sostenible y reducción de la contaminación.',
        activities: [
          'Actividad 1: Transporte y CO2',
          'Actividad 2: Opciones urbanas',
          'Actividad 3: Planificación de rutas',
          'Actividad 4: Quiz de movilidad',
          'Actividad 5: Reto sin motor',
          'Actividad 6: Mini-juego de tráfico',
          'Actividad 7: Evaluación de impacto',
        ],
      ),
      SectionInfo(
        color: Colors.brown[400]!,
        title: 'Sección 9',
        description: 'Activismo ambiental y participación comunitaria.',
        activities: [
          'Actividad 1: Comunicación verde',
          'Actividad 2: Iniciativas locales',
          'Actividad 3: Diseño de campaña',
          'Actividad 4: Quiz de activismo',
          'Actividad 5: Proyecto grupal',
          'Actividad 6: Mini-juego de influencia',
          'Actividad 7: Evaluación de impacto',
        ],
      ),
      SectionInfo(
        color: Colors.blueGrey[400]!,
        title: 'Sección 10',
        description: 'Cambio climático: causas, efectos y soluciones globales.',
        activities: [
          'Actividad 1: Ciencia climática',
          'Actividad 2: Efectos globales',
          'Actividad 3: Acuerdos internacionales',
          'Actividad 4: Quiz climático',
          'Actividad 5: Plan personal',
          'Actividad 6: Mini-juego de simulación',
          'Actividad 7: Evaluación final',
        ],
      ),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final seccion = secciones[index];
          return _buildSectionItem(context, seccion, index + 1);
        },
        childCount: secciones.length,
      ),
    );
  }

  Widget _buildSectionItem(
      BuildContext context, SectionInfo seccion, int numeroSeccion) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: seccion.color.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(
          children: [
            // Header de la sección mejorado
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    seccion.color,
                    seccion.color.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      _getSectionIcon(numeroSeccion),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sección $numeroSeccion',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
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
                        const SizedBox(height: 6),
                        Text(
                          '7 actividades disponibles',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 4,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showSectionDescription(context, seccion),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido de actividades
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    seccion.color.withOpacity(0.1),
                    Colors.white,
                    _getComplementaryColor(seccion.color).withOpacity(0.05),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Fondo SVG con colores dinámicos según la sección
                  Positioned.fill(
                    child: _buildCustomColoredSvg(seccion.color),
                  ),
                  // Contenido de los botones encima del fondo
                  _buildActivityButtons(context, seccion),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon(int sectionNumber) {
    switch (sectionNumber) {
      case 1:
        return Icons.eco;
      case 2:
        return Icons.recycling;
      case 3:
        return Icons.shopping_cart;
      case 4:
        return Icons.water_drop;
      case 5:
        return Icons.energy_savings_leaf;
      case 6:
        return Icons.forest;
      case 7:
        return Icons.restaurant;
      case 8:
        return Icons.directions_bike;
      case 9:
        return Icons.campaign;
      case 10:
        return Icons.public;
      default:
        return Icons.circle;
    }
  }

  Widget _buildActivityButtons(BuildContext context, SectionInfo seccion) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight = MediaQuery.of(context).size.height * 0.75;

    // Definir posiciones para crear un patrón serpenteante como una culebra (en porcentajes)
    final List<Offset> positions = [
      Offset(
          screenWidth * 0.15,
          containerHeight *
              0.15), // Botón 1: Extremo izquierdo (cabeza de la culebra)
      Offset(screenWidth * 0.45,
          containerHeight * 0.25), // Botón 2: Primera curva hacia la derecha
      Offset(
          screenWidth * 0.80,
          containerHeight *
              0.35), // Botón 3: Extremo derecho (primera ondulación)
      Offset(screenWidth * 0.60,
          containerHeight * 0.45), // Botón 4: Regreso hacia el centro
      Offset(
          screenWidth * 0.20,
          containerHeight *
              0.55), // Botón 5: Segunda ondulación hacia la izquierda
      Offset(screenWidth * 0.50,
          containerHeight * 0.65), // Botón 6: Nueva curva hacia el centro
      Offset(
          screenWidth * 0.85,
          containerHeight *
              0.75), // Botón 7: Tercera ondulación hacia la derecha (cola)
    ];

    return Container(
      height: MediaQuery.of(context).size.height *
          0.7, // 70% de la altura de pantalla
      child: Stack(
        children: [
          // Dibujar líneas de conexión del camino
          CustomPaint(
            painter: PathPainter(positions, seccion.color),
            size: Size(screenWidth, MediaQuery.of(context).size.height * 0.7),
          ),
          // Botones sobre las líneas
          ...List.generate(
            7,
            (index) => Positioned(
              left: positions[index].dx -
                  45, // Centrar botón (45 = radio del botón)
              top: positions[index].dy,
              child: _buildSingleActivityButton(context, seccion, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleActivityButton(
      BuildContext context, SectionInfo seccion, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JuegosSeccionScreen(
              seccionTitle: seccion.title,
              actividadIndex: index,
              actividadNombre: seccion.activities[index],
            ),
          ),
        );
      },
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: seccion.color.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              spreadRadius: -2,
              blurRadius: 8,
              offset: const Offset(-2, -2),
            ),
          ],
          border: Border.all(
            color: seccion.color.withOpacity(0.4),
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                'lib/assets/images/etapas/boton_imagen_${(index + 1).toString().padLeft(2, '0')}.svg',
                width: 75,
                height: 75,
                placeholderBuilder: (context) => Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        seccion.color.withOpacity(0.2),
                        seccion.color.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForButton(index),
                    size: 40,
                    color: seccion.color,
                  ),
                ),
              ),
            ),
            // Número de actividad
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [seccion.color, seccion.color.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: seccion.color.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Iconos temporales mientras se agregan las imágenes SVG
  IconData _getIconForButton(int index) {
    switch (index) {
      case 0:
        return Icons.eco;
      case 1:
        return Icons.water_drop;
      case 2:
        return Icons.energy_savings_leaf;
      case 3:
        return Icons.recycling;
      case 4:
        return Icons.solar_power;
      case 5:
        return Icons.forest;
      case 6:
        return Icons.public;
      default:
        return Icons.circle;
    }
  }

  void _showSectionDescription(BuildContext context, SectionInfo seccion) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 10,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                seccion.color.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header del diálogo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [seccion.color, seccion.color.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        seccion.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
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
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido del diálogo
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: seccion.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: seccion.color.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          seccion.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Actividades incluidas:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: seccion.color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...seccion.activities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final actividad = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: seccion.color.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: seccion.color.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: seccion.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  actividad,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              // Footer del diálogo
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            seccion.color,
                            seccion.color.withOpacity(0.8)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: seccion.color.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Entendido',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  Widget _buildCustomColoredSvg(Color sectionColor) {
    return Builder(
      builder: (context) => FutureBuilder<String>(
        future: _getCustomColoredSvgString(context, sectionColor),
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

  // Método para generar SVG string con colores personalizados
  Future<String> _getCustomColoredSvgString(
      BuildContext context, Color sectionColor) async {
    try {
      // Leer el SVG original
      final svgString = await DefaultAssetBundle.of(context)
          .loadString('lib/assets/images/etapas/fondo_01.svg');

      // Generar colores personalizados basados en el color de la sección
      final hsv = HSVColor.fromColor(sectionColor);

      // Edificios (color más intenso - rojo original #AA2A2E)
      final edificiosColor = HSVColor.fromAHSV(
              1.0,
              hsv.hue,
              (hsv.saturation * 0.9).clamp(0.0, 1.0),
              (hsv.value * 0.7).clamp(0.0, 1.0))
          .toColor();

      // Montaña (color intermedio - naranja original #EE7B7A)
      final montanaColor = HSVColor.fromAHSV(
              1.0,
              hsv.hue,
              (hsv.saturation * 0.6).clamp(0.0, 1.0),
              (hsv.value * 0.8).clamp(0.0, 1.0))
          .toColor();

      // Cielo (color más claro - rosa claro original #FBDBDD)
      final cieloColor = HSVColor.fromAHSV(
              1.0,
              hsv.hue,
              (hsv.saturation * 0.3).clamp(0.0, 1.0),
              (hsv.value * 0.95).clamp(0.0, 1.0))
          .toColor();

      // Reemplazar colores en el SVG
      String customSvg = svgString
          .replaceAll('#AA2A2E', _colorToHex(edificiosColor)) // Edificios
          .replaceAll('#EE7B7A', _colorToHex(montanaColor)) // Montaña
          .replaceAll('#ED7A7A', _colorToHex(montanaColor)) // Montaña variación
          .replaceAll('#EE7C7B', _colorToHex(montanaColor)) // Montaña variación
          .replaceAll('#ED7B7A', _colorToHex(montanaColor)) // Montaña variación
          .replaceAll('#EE7B7B', _colorToHex(montanaColor)) // Montaña variación
          .replaceAll('#EE7D7C', _colorToHex(montanaColor)) // Montaña variación
          .replaceAll('#ED7D7C', _colorToHex(montanaColor)) // Montaña variación
          .replaceAll('#EE7F7E', _colorToHex(montanaColor)) // Montaña variación
          .replaceAll('#FBDBDD', _colorToHex(cieloColor)); // Cielo

      return customSvg;
    } catch (e) {
      // En caso de error, retornar SVG básico
      return '''<svg width="408" height="408" viewBox="0 0 408 408" fill="none">
        <rect width="408" height="408" fill="${_colorToHex(sectionColor.withOpacity(0.1))}" />
      </svg>''';
    }
  }

  // Método para convertir Color a string hexadecimal
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}

// Painter para dibujar las líneas de conexión del camino
class PathPainter extends CustomPainter {
  final List<Offset> positions;
  final Color color;

  PathPainter(this.positions, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Pintura principal para el cuerpo de la culebra (líneas discontinuas)
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Pintura para la línea interior más clara (escamas de culebra)
    final innerPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (positions.isNotEmpty) {
      // Empezar desde el primer punto
      path.moveTo(positions[0].dx, positions[0].dy + 45);

      // Crear curvas muy pronunciadas para una "S" más orgánica
      for (int i = 1; i < positions.length; i++) {
        final current = Offset(positions[i].dx, positions[i].dy + 45);
        final previous = Offset(positions[i - 1].dx, positions[i - 1].dy + 45);

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
    _drawDashedPath(canvas, path, paint, dashLength: 15.0, gapLength: 8.0);

    // Dibujar la línea interior discontinua para efecto de escamas
    _drawDashedPath(canvas, path, innerPaint, dashLength: 12.0, gapLength: 6.0);
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
