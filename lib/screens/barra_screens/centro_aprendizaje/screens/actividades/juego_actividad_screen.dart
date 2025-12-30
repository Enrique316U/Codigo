import 'package:flutter/material.dart';
// Etapa 1 imports
import 'Etapa_1/seccion_1/Nodo_1/minijuego_nodo.dart';
import 'Etapa_1/seccion_1/Nodo_2/minijuego_nodo.dart';
import 'Etapa_1/seccion_1/Nodo_3/minijuego_nodo.dart';
import 'Etapa_1/seccion_1/Nodo_4/minijuego_nodo.dart';
import 'Etapa_1/seccion_2/Nodo_5/minijuego_nodo.dart';
import 'Etapa_1/seccion_2/Nodo_6/minijuego_nodo.dart';
import 'Etapa_1/seccion_2/Nodo_7/minijuego_nodo.dart';
import 'Etapa_1/seccion_2/Nodo_8/minijuego_nodo.dart';
// Etapa 2 imports
import 'Etapa_2/seccion_1/Nodo_1/minijuego_nodo.dart' as Etapa2Nodo1;
import 'Etapa_2/seccion_1/Nodo_2/minijuego_nodo.dart' as Etapa2Nodo2;
import 'Etapa_2/seccion_1/Nodo_3/minijuego_nodo.dart' as Etapa2Nodo3;
import 'Etapa_2/seccion_1/Nodo_4/minijuego_nodo.dart' as Etapa2Nodo4;
import 'Etapa_2/seccion_2/Nodo_5/minijuego_nodo.dart' as Etapa2Nodo5;
import 'Etapa_2/seccion_2/Nodo_6/minijuego_nodo.dart' as Etapa2Nodo6;
import 'Etapa_2/seccion_2/Nodo_7/minijuego_nodo.dart' as Etapa2Nodo7;
// Etapa 3 imports
import 'Etapa_3/seccion_1/Nodo_1/minijuego_nodo.dart' as Etapa3Nodo1;
import 'Etapa_3/seccion_1/Nodo_2/minijuego_nodo.dart' as Etapa3Nodo2;
import 'Etapa_3/seccion_1/Nodo_3/minijuego_nodo.dart' as Etapa3Nodo3;
import 'Etapa_3/seccion_1/Nodo_4/minijuego_nodo.dart' as Etapa3Nodo4;
import 'Etapa_3/seccion_2/Nodo_5/minijuego_nodo.dart' as Etapa3Nodo5;
import 'Etapa_3/seccion_2/Nodo_6/minijuego_nodo.dart' as Etapa3Nodo6;
import 'Etapa_3/seccion_2/Nodo_7/minijuego_nodo.dart' as Etapa3Nodo7;
import 'Etapa_3/seccion_2/Nodo_8/minijuego_nodo.dart' as Etapa3Nodo8;
import 'Etapa_3/seccion_2/Nodo_9/minijuego_nodo.dart' as Etapa3Nodo9;
// Etapa 4 imports
import 'Etapa_4/seccion_1/Nodo_1/minijuego_nodo.dart' as Etapa4Nodo1;
import 'Etapa_4/seccion_1/Nodo_2/minijuego_nodo.dart' as Etapa4Nodo2;
import 'Etapa_4/seccion_1/Nodo_3/minijuego_nodo.dart' as Etapa4Nodo3;
import 'Etapa_4/seccion_1/Nodo_4/minijuego_nodo.dart' as Etapa4Nodo4;
import 'Etapa_4/seccion_2/Nodo_5/minijuego_nodo.dart' as Etapa4Nodo5;
import 'Etapa_4/seccion_2/Nodo_6/minijuego_nodo.dart' as Etapa4Nodo6;
// Etapa 5 imports
import 'Etapa_5/seccion_1/Nodo_1/minijuego_nodo.dart' as Etapa5Nodo1;
import 'Etapa_5/seccion_1/Nodo_2/minijuego_nodo.dart' as Etapa5Nodo2;
import 'Etapa_5/seccion_1/Nodo_3/minijuego_nodo.dart' as Etapa5Nodo3;
import 'Etapa_5/seccion_1/Nodo_4/minijuego_nodo.dart' as Etapa5Nodo4;
import 'Etapa_5/seccion_2/Nodo_5/minijuego_nodo.dart' as Etapa5Nodo5;
import 'Etapa_5/seccion_2/Nodo_6/minijuego_nodo.dart' as Etapa5Nodo6;
import 'Etapa_5/seccion_2/Nodo_7/minijuego_nodo.dart' as Etapa5Nodo7;
// Etapa 6 imports
import 'Etapa_6/seccion_1/Nodo_1/minijuego_nodo.dart' as Etapa6Nodo1;
import 'Etapa_6/seccion_1/Nodo_2/minijuego_nodo.dart' as Etapa6Nodo2;
import 'Etapa_6/seccion_1/Nodo_3/minijuego_nodo.dart' as Etapa6Nodo3;
import 'Etapa_6/seccion_2/Nodo_4/minijuego_nodo.dart' as Etapa6Nodo4;
import 'Etapa_6/seccion_2/Nodo_5/minijuego_nodo.dart' as Etapa6Nodo5;
import 'Etapa_6/seccion_2/Nodo_6/minijuego_nodo.dart' as Etapa6Nodo6;

class JuegoActividadScreen extends StatefulWidget {
  final int etapaIndex;
  final String seccionTitulo;
  final String actividadTitulo;
  final int actividadIndex;
  final Color color;

  const JuegoActividadScreen({
    Key? key,
    required this.etapaIndex,
    required this.seccionTitulo,
    required this.actividadTitulo,
    required this.actividadIndex,
    required this.color,
  }) : super(key: key);

  @override
  State<JuegoActividadScreen> createState() => _JuegoActividadScreenState();
}

class _JuegoActividadScreenState extends State<JuegoActividadScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  bool _actividadCompletada = false;

  @override
  void initState() {
    super.initState();
    print('🎮 DEBUG JuegoActividadScreen:');
    print('  - etapaIndex: ${widget.etapaIndex}');
    print('  - seccionTitulo: "${widget.seccionTitulo}"');
    print('  - actividadTitulo: "${widget.actividadTitulo}"');
    print('  - actividadIndex: ${widget.actividadIndex}');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.actividadTitulo),
        backgroundColor: widget.color,
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                  // Marcar como completada si llega a la última página
                  if (page == _getPaginasActividad().length - 1) {
                    _actividadCompletada = true;
                  }
                });
              },
              children: _getPaginasActividad(),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final totalPages = _getPaginasActividad().length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.seccionTitulo} - ${widget.actividadTitulo}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
              Text(
                '${_currentPage + 1}/$totalPages',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: ((_currentPage + 1) / totalPages),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == _getPaginasActividad().length - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: widget.color,
                side: BorderSide(color: widget.color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 8),
                  Text('Anterior'),
                ],
              ),
            )
          else
            const SizedBox(width: 120), // Espacio cuando no hay botón anterior

          ElevatedButton(
            onPressed: () {
              if (isLastPage) {
                // Volver a la pantalla anterior al completar
                Navigator.pop(context);
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Text(isLastPage ? 'Completar' : 'Siguiente'),
                const SizedBox(width: 8),
                Icon(isLastPage ? Icons.check : Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Generar páginas de contenido basadas en la actividad actual
  List<Widget> _getPaginasActividad() {
    print('🔍 _getPaginasActividad() verificando condiciones:');
    print('  - widget.etapaIndex: ${widget.etapaIndex}');
    print('  - widget.seccionTitulo: "${widget.seccionTitulo}"');

    // Verificar si es Etapa 1 para mostrar minijuegos específicos
    if (widget.etapaIndex == 0 &&
        widget.seccionTitulo == 'Seres Vivos y Plantas') {
      print('  ✅ Etapa 1 - Seres Vivos y Plantas');
      return _getPaginasEtapa1Nodo1();
    }

    if (widget.etapaIndex == 0 &&
        widget.seccionTitulo == 'Animales, Agua y Suelo') {
      print('  ✅ Etapa 1 - Animales, Agua y Suelo');
      return _getPaginasEtapa1Nodo2();
    }

    // Etapa 2: Bosque del Cuidado Ambiental
    if (widget.etapaIndex == 1 &&
        widget.seccionTitulo == 'Seres Vivos y Materiales') {
      print('  ✅ Etapa 2 - Seres Vivos y Materiales');
      return _getPaginasEtapa2Seccion1();
    }

    if (widget.etapaIndex == 1 &&
        widget.seccionTitulo == 'Cuidado Ambiental y Física') {
      print('  ✅ Etapa 2 - Cuidado Ambiental y Física');
      return _getPaginasEtapa2Seccion2();
    }

    // Etapa 3: Ecosistema Acuático
    if (widget.etapaIndex == 2 &&
        widget.seccionTitulo == 'Plantas y Ecosistemas') {
      print('  ✅ Etapa 3 - Plantas y Ecosistemas');
      return _getPaginasEtapa3Seccion1();
    }

    if (widget.etapaIndex == 2 &&
        widget.seccionTitulo == 'Agua, Aire y Suelo') {
      print('  ✅ Etapa 3 - Agua, Aire y Suelo');
      return _getPaginasEtapa3Seccion2();
    }

    // Etapa 4: Región Andina - Sección 1
    if (widget.etapaIndex == 3 &&
        widget.seccionTitulo == 'Ecosistemas y Alimentación') {
      return _getPaginasEtapa4Seccion1();
    }

    // Verificar si es Etapa 4 Sección 2 para mostrar contenido específico de suelo
    if (widget.etapaIndex == 3 && widget.seccionTitulo == 'Función del Suelo') {
      return _getPaginasEtapa4Seccion2();
    }

    // Etapa 5: Desiertos y Humedales
    if (widget.etapaIndex == 4 &&
        widget.seccionTitulo == 'Plantas y Factores del Ecosistema') {
      return _getPaginasEtapa5Seccion1();
    }

    if (widget.etapaIndex == 4 &&
        widget.seccionTitulo == 'Importancia del Agua, Aire y Suelo') {
      return _getPaginasEtapa5Seccion2();
    }

    // Etapa 6: Ecosistema Global
    if (widget.etapaIndex == 5 &&
        widget.seccionTitulo == 'Biología y Biodiversidad') {
      return _getPaginasEtapa6Seccion1();
    }

    if (widget.etapaIndex == 5 &&
        widget.seccionTitulo == 'Ecosistemas y Población') {
      return _getPaginasEtapa6Seccion2();
    }

    print('  ⚠️ NINGUNA CONDICIÓN COINCIDIÓ - Mostrando contenido por defecto');
    // Simulamos diferentes tipos de actividades según el índice
    switch (widget.actividadIndex) {
      case 0: // Introducción
        return [
          _buildContenidoTexto(
            'Introducción',
            'Bienvenido a esta actividad de aprendizaje. Aquí aprenderás conceptos importantes sobre sostenibilidad ambiental y cómo aplicarlos en tu vida diaria.',
            Icons.lightbulb_outline,
          ),
          _buildContenidoImagen(
            'Objetivos de Aprendizaje',
            'En esta actividad, aprenderás:\n\n• Conceptos básicos de sostenibilidad\n• Impacto de nuestras acciones en el medio ambiente\n• Prácticas sostenibles para la vida diaria',
            'lib/assets/images/learning.png',
          ),
          _buildContenidoTexto(
            '¡Vamos a comenzar!',
            'Desliza para continuar con la lección y no olvides completar todas las actividades para ganar puntos y desbloquear nuevos contenidos.',
            Icons.play_arrow,
          ),
        ];

      case 1: // Conceptos
        return [
          _buildContenidoTexto(
            'Conceptos Fundamentales',
            'La sostenibilidad se basa en tres pilares principales: ambiental, económico y social. Estos tres aspectos deben estar en equilibrio para lograr un desarrollo verdaderamente sostenible.',
            Icons.science,
          ),
          _buildContenidoImagen(
            'Pilares de la Sostenibilidad',
            '1. Ambiental: Preservación de ecosistemas y recursos naturales\n2. Económico: Desarrollo económico equitativo\n3. Social: Bienestar humano y equidad social',
            'lib/assets/images/sustainability.png',
          ),
          _buildQuiz(
            '¿Cuáles son los tres pilares de la sostenibilidad?',
            [
              'Ambiental, Político, Social',
              'Ambiental, Económico, Social',
              'Ecológico, Financiero, Cultural',
              'Natural, Artificial, Humano'
            ],
            1,
          ),
        ];

      case 2: // Actividad práctica
        return [
          _buildContenidoTexto(
            'Actividad Práctica',
            'Ahora aplicaremos lo aprendido con un ejercicio práctico. Esto te ayudará a comprender mejor los conceptos y a desarrollar habilidades para aplicarlos en situaciones reales.',
            Icons.build,
          ),
          _buildInteractivo(
            'Clasificación de Residuos',
            'Arrastra cada residuo a su contenedor correspondiente:',
          ),
          _buildContenidoTexto(
            '¡Buen trabajo!',
            'Has completado con éxito la actividad práctica. Recuerda aplicar estos conocimientos en tu vida diaria para contribuir a un planeta más sostenible.',
            Icons.check_circle,
          ),
        ];

      default: // Para otras actividades
        return [
          _buildContenidoTexto(
            'Actividad en Desarrollo',
            'Esta actividad está en desarrollo. Pronto tendrás acceso a nuevo contenido educativo sobre sostenibilidad ambiental.',
            Icons.construction,
          ),
          _buildContenidoTexto(
            'Mantente atento',
            'Estamos trabajando para ofrecerte la mejor experiencia de aprendizaje. Mientras tanto, puedes explorar otras secciones disponibles.',
            Icons.hourglass_empty,
          ),
        ];
    }
  }

  // Páginas específicas para Etapa 1 Nodo 1: Seres Vivos y Plantas
  List<Widget> _getPaginasEtapa1Nodo1() {
    switch (widget.actividadIndex) {
      case 0: // ¿Qué son los seres vivos?
        return [
          _buildContenidoTexto(
            '¿Qué son los seres vivos?',
            'Los seres vivos son todos los organismos que tienen vida. ¿Pero qué significa tener vida?\n\nLos seres vivos:\n• Nacen y crecen\n• Se alimentan\n• Respiran\n• Se reproducen\n• Se mueven (aunque sea muy poco)\n• Responden a su ambiente',
            Icons.favorite,
          ),
          _buildContenidoTexto(
            'Ejemplos de seres vivos',
            '🐕 Animales: perros, gatos, pájaros, peces\n🌱 Plantas: árboles, flores, pasto\n🦋 Insectos: mariposas, abejas, hormigas\n🧍 Personas: tú y yo somos seres vivos\n\n¿Puedes pensar en más ejemplos?',
            Icons.pets,
          ),
          _buildMinijuegoButton(
            '¡Juega y Aprende!',
            'Ahora vamos a jugar para aprender mejor. Tendrás que clasificar qué cosas son seres vivos y cuáles no.',
            'Clasificar Seres Vivos',
          ),
        ];

      case 1: // La planta y sus partes
        return [
          _buildContenidoTexto(
            'La planta y sus partes',
            'Las plantas tienen diferentes partes, y cada una tiene una función importante:\n\n🌳 Raíz: absorbe agua y nutrientes\n🌿 Tallo: sostiene la planta\n🍃 Hojas: hacen la comida de la planta\n🌸 Flor: ayuda a hacer nuevas plantas\n🍎 Fruto: protege las semillas',
            Icons.local_florist,
          ),
          _buildContenidoTexto(
            '¿Cómo funcionan?',
            'Cada parte de la planta es como un órgano en nuestro cuerpo:\n\n• Las raíces son como nuestra boca: toman el alimento\n• El tallo es como nuestros huesos: da soporte\n• Las hojas son como nuestro estómago: procesan la comida\n• Las flores son especiales para hacer bebés planta',
            Icons.eco,
          ),
          _buildMinijuegoButton(
            '¡Conecta las partes!',
            'Vamos a aprender conectando cada parte de la planta con su función.',
            'Partes de la Planta',
          ),
        ];

      case 2: // Cuidado de las plantas
        return [
          _buildContenidoTexto(
            'Cuidado de las plantas',
            'Las plantas necesitan cuidados especiales para vivir felices:\n\n💧 Agua: pero no demasiada\n☀️ Luz del sol: para hacer su comida\n🌬️ Aire fresco: para respirar\n🌱 Tierra buena: para sus raíces\n❤️ Mucho amor: ¡las plantas sienten nuestro cariño!',
            Icons.water_drop,
          ),
          _buildContenidoTexto(
            'Consejos de cuidado',
            '✅ Riega por la mañana o tarde\n✅ No enchares la tierra\n✅ Ponlas cerca de ventanas\n✅ Habla con tus plantas\n✅ Revisa si están sanas\n\n❌ No las pongas al sol fuerte del mediodía\n❌ No les pongas mucha agua',
            Icons.tips_and_updates,
          ),
          _buildMinijuegoButton(
            '¡Quiz de Cuidado!',
            'Demuestra lo que has aprendido sobre cómo cuidar las plantas.',
            'Cuidado de Plantas',
          ),
        ];

      case 3: // Conociendo a los animales
        return [
          _buildContenidoTexto(
            'Conociendo a los animales',
            'Los animales son seres vivos muy especiales:\n\n🐕 Algunos son nuestras mascotas\n🦅 Otros viven libres en la naturaleza\n🐠 Algunos viven en el agua\n🦋 Otros pueden volar\n🐛 Y algunos son muy pequeñitos',
            Icons.pets,
          ),
          _buildContenidoTexto(
            'Tipos de animales',
            'Podemos agrupar a los animales de diferentes formas:\n\n🏠 Domésticos: perros, gatos, hamsters\n🌳 Salvajes: leones, jirafas, monos\n🌊 Acuáticos: peces, delfines, pulpos\n🦅 Voladores: pájaros, murciélagos, insectos\n🐌 Terrestres: hormigas, caracoles, ratones',
            Icons.nature,
          ),
          _buildMinijuegoButton(
            '¡Juego de Memoria!',
            'Encuentra las parejas de animales en este divertido juego de memoria.',
            'Memoria de Animales',
          ),
        ];

      default:
        return [
          _buildContenidoTexto(
            'Actividad en desarrollo',
            'Esta actividad estará disponible pronto. ¡Sigue explorando las otras actividades!',
            Icons.construction,
          ),
        ];
    }
  }

  // Páginas específicas para Etapa 1 Nodo 2: Animales, Agua y Suelo
  List<Widget> _getPaginasEtapa1Nodo2() {
    switch (widget.actividadIndex) {
      case 0: // Cuidado de los animales
        return [
          _buildContenidoTexto(
            'Cuidado de los animales',
            'Los animales son seres vivos que necesitan nuestro cuidado y amor. Cada animal tiene necesidades especiales:\n\n🐕 Los perros necesitan agua fresca, comida nutritiva y ejercicio\n🐱 Los gatos requieren limpieza, cariño y un lugar seguro\n🐰 Los conejos comen verduras frescas y necesitan espacio\n🐦 Los pájaros requieren semillas, agua y libertad para volar',
            Icons.pets,
          ),
          _buildContenidoTexto(
            'Responsabilidades con las mascotas',
            'Si tienes una mascota, eres responsable de:\n\n💧 Darle agua limpia todos los días\n🍎 Alimentarla con comida apropiada\n🏥 Llevarla al veterinario cuando esté enferma\n❤️ Darle mucho amor y atención\n🧼 Mantener limpio su espacio\n🎾 Jugar y hacer ejercicio con ella',
            Icons.favorite,
          ),
          _buildMinijuegoButton(
            '¡Cuida a los Animales!',
            'Ayuda a diferentes animales resolviendo situaciones de cuidado. Aprende qué hacer en cada caso.',
            'Cuidado de Animales',
          ),
        ];

      case 1: // El agua y sus estados
        return [
          _buildContenidoTexto(
            'El agua y sus estados',
            'El agua es muy especial porque puede cambiar de forma:\n\n❄️ SÓLIDO: Como hielo, nieve o granizo (cuando hace mucho frío)\n💧 LÍQUIDO: Como en ríos, lluvia o cuando la bebes (temperatura normal)\n☁️ GASEOSO: Como vapor o nubes (cuando se calienta mucho)',
            Icons.water_drop,
          ),
          _buildContenidoTexto(
            '¿Cómo cambia el agua?',
            'El agua cambia según la temperatura:\n\n🔥 Si se calienta mucho → se convierte en vapor (gas)\n🧊 Si se enfría mucho → se convierte en hielo (sólido)\n🌡️ A temperatura normal → es líquida\n\n¡Es la misma agua, solo cambia de forma!',
            Icons.thermostat,
          ),
          _buildMinijuegoButton(
            '¡Clasifica el Agua!',
            'Ayuda a clasificar diferentes formas del agua según su estado: sólido, líquido o gaseoso.',
            'Estados del Agua',
          ),
        ];

      case 2: // El aire y su contaminación
        return [
          _buildContenidoTexto(
            'El aire y su contaminación',
            'El aire es invisible pero muy importante para vivir. Todos los seres vivos necesitamos aire limpio para respirar:\n\n🌬️ El aire limpio no tiene olor ni color\n🏭 La contaminación hace que el aire se vuelva sucio\n🚗 Los carros y fábricas pueden contaminar el aire\n🌳 Las plantas ayudan a limpiar el aire',
            Icons.air,
          ),
          _buildContenidoTexto(
            '¿Cómo cuidar el aire?',
            'Podemos ayudar a mantener el aire limpio:\n\n🌱 Plantando más árboles y plantas\n🚴 Usando bicicleta en lugar de carro\n♻️ No quemando basura\n🚶 Caminando distancias cortas\n🌍 Cuidando la naturaleza\n\n¡Todos podemos ayudar!',
            Icons.eco,
          ),
          _buildMinijuegoButton(
            '¡Protege el Aire!',
            'Responde preguntas sobre la contaminación del aire y aprende cómo protegerlo.',
            'Contaminación del Aire',
          ),
        ];

      case 3: // El suelo y sus tipos
        return [
          _buildContenidoTexto(
            'El suelo y sus tipos',
            'El suelo es la tierra donde crecen las plantas. Hay diferentes tipos de suelo:\n\n🟤 ARCILLOSO: Retiene mucha agua, es pegajoso\n🟡 ARENOSO: El agua se va rápido, es suelto\n🟢 HÚMEDO: Perfecto para las plantas, tiene nutrientes\n⚫ ROCOSO: Tiene muchas piedras, difícil para sembrar',
            Icons.terrain,
          ),
          _buildContenidoTexto(
            '¿Para qué sirve el suelo?',
            'El suelo es muy importante porque:\n\n🌱 Las plantas crecen en él\n🍎 Nos da alimentos como frutas y verduras\n🏠 Algunas casas se construyen sobre él\n🐛 Muchos animales viven en él\n💧 Filtra y limpia el agua\n\n¡Debemos cuidar el suelo!',
            Icons.grass,
          ),
          _buildMinijuegoButton(
            '¡Conoce los Suelos!',
            'Conecta cada tipo de suelo con sus características especiales.',
            'Tipos de Suelo',
          ),
        ];

      default:
        return [
          _buildContenidoTexto(
            'Actividad en desarrollo',
            'Esta actividad estará disponible pronto. ¡Sigue explorando las otras actividades!',
            Icons.construction,
          ),
        ];
    }
  }

  // Páginas específicas para Etapa 4 Sección 2: Función del Suelo y Conservación del Suelo
  List<Widget> _getPaginasEtapa4Seccion2() {
    switch (widget.actividadIndex) {
      case 0: // Conservación del suelo
        return [
          _buildContenidoTexto(
            'Conservación del suelo',
            '🌍 El suelo es esencial para la vida:\n\n🔑 IMPORTANCIA DEL SUELO:\n• Base para la agricultura\n• Hogar de millones de organismos\n• Filtra y almacena agua\n• Recicla nutrientes\n• Regula el clima global\n\n⚠️ AMENAZAS:\n• Erosión por agua y viento\n• Contaminación química\n• Deforestación\n• Urbanización excesiva\n• Agricultura intensiva\n\n💚 CONSERVACIÓN:\n• Rotación de cultivos\n• Terrazas en laderas\n• Reforestación\n• Compostaje\n• Agricultura sostenible',
            Icons.park,
          ),
          _buildMinijuegoButton(
            '¡Protector del suelo!',
            'Aprende técnicas para conservar y proteger el suelo.',
            'Conservación del Suelo',
          ),
        ];

      case 1: // Ecosistemas locales
        return [
          _buildContenidoTexto(
            'Ecosistemas locales del Perú',
            '🇵🇪 El Perú tiene gran diversidad de ecosistemas:\n\n🌊 COSTA:\n• Desiertos costeros\n• Lomas costeras\n• Humedales y albuferas\n• Bosques secos\n\n🏔️ SIERRA:\n• Puna y jalca\n• Bosques de neblina\n• Valles interandinos\n• Nevados y glaciares\n\n🌴 SELVA:\n• Selva baja (Amazonía)\n• Selva alta (yungas)\n• Bosques tropicales\n• Aguajales y pantanos\n\n🦜 BIODIVERSIDAD:\n• Perú: uno de los 17 países megadiversos\n• Miles de especies endémicas',
            Icons.public,
          ),
          _buildMinijuegoButton(
            '¡Explorador del Perú!',
            'Descubre los ecosistemas únicos de nuestro país.',
            'Ecosistemas Locales',
          ),
        ];

      default:
        return [
          _buildContenidoTexto(
            'Actividad en desarrollo',
            'Esta actividad estará disponible pronto. ¡Sigue explorando las otras actividades sobre el suelo!',
            Icons.construction,
          ),
        ];
    }
  }

  Widget _buildMinijuegoButton(
      String titulo, String descripcion, String nombreJuego) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.games, size: 80, color: widget.color),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            descripcion,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // Determinar qué pantalla de minijuegos usar según la etapa y sección
              Widget minijuegosScreen;

              // Etapa 1 (índice 0) - Jardín de la Vida
              if (widget.etapaIndex == 0 &&
                  widget.seccionTitulo == 'Seres Vivos y Plantas') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // ¿Qué son los seres vivos?
                    minijuegosScreen = MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0, // Seres Vivos y Plantas = sección 0
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // La planta y sus partes
                    minijuegosScreen = MinijuegoNodo2Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Cuidado de las plantas
                    minijuegosScreen = MinijuegoNodo3Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Conociendo a los animales
                    minijuegosScreen = MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: 0,
                    );
                }
              } else if (widget.etapaIndex == 0 &&
                  widget.seccionTitulo == 'Animales, Agua y Suelo') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Cuidado de los animales
                    minijuegosScreen = MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // El agua y sus estados
                    minijuegosScreen = MinijuegoNodo6Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // El aire y su contaminación
                    minijuegosScreen = MinijuegoNodo7Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // El suelo y sus tipos
                    minijuegosScreen = MinijuegoNodo8Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: 0,
                    );
                }
              }

              // Etapa 2 (índice 1) - Bosque del Cuidado Ambiental
              else if (widget.etapaIndex == 1 &&
                  widget.seccionTitulo == 'Seres Vivos y Materiales') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Utilidad de las plantas
                    minijuegosScreen = Etapa2Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Animales vertebrados e invertebrados
                    minijuegosScreen = Etapa2Nodo2.MinijuegoNodo2Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Animales del Perú en peligro de extinción
                    minijuegosScreen = Etapa2Nodo3.MinijuegoNodo3Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Fenómenos del Clima
                    minijuegosScreen = Etapa2Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa2Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: 0,
                    );
                }
              } else if (widget.etapaIndex == 1 &&
                  widget.seccionTitulo == 'Cuidado Ambiental y Física') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Ahorro y cuidado del agua
                    minijuegosScreen = Etapa2Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Contaminación y cuidado del aire
                    minijuegosScreen = Etapa2Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Formación y propiedades del suelo
                    minijuegosScreen = Etapa2Nodo6.MinijuegoNodo6Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Contaminación del suelo
                    minijuegosScreen = Etapa2Nodo7.MinijuegoNodo7Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa2Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: 0,
                    );
                }
              }

              // Etapa 3 (índice 2) - Ecosistema Acuático
              else if (widget.etapaIndex == 2 &&
                  widget.seccionTitulo == 'Plantas y Ecosistemas') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Importancia de las plantas
                    minijuegosScreen = Etapa3Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Insectos y arácnidos en el ecosistema
                    minijuegosScreen = Etapa3Nodo2.MinijuegoNodo2Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // ¿Qué es un ecosistema?
                    minijuegosScreen = Etapa3Nodo3.MinijuegoNodo3Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Proyecto: Animales en extinción
                    minijuegosScreen = Etapa3Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa3Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: 0,
                    );
                }
              } else if (widget.etapaIndex == 2 &&
                  widget.seccionTitulo == 'Agua, Aire y Suelo') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // El agua y sus propiedades
                    minijuegosScreen = Etapa3Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 2,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // El ciclo del agua
                    minijuegosScreen = Etapa3Nodo6.MinijuegoNodo6Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 2,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // El aire y sus propiedades
                    minijuegosScreen = Etapa3Nodo7.MinijuegoNodo7Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 2,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Contaminación del aire
                    minijuegosScreen = Etapa3Nodo8.MinijuegoNodo8Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 2,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 4: // El suelo y su conservación
                    minijuegosScreen = Etapa3Nodo9.MinijuegoNodo9Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 2,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa3Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 2,
                      actividad: 0,
                    );
                }
              }

              // Etapa 4 (índice 3) - Región Andina
              else if (widget.etapaIndex == 3 &&
                  widget.seccionTitulo == 'Ecosistemas y Alimentación') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Ecosistemas y su clasificación
                    minijuegosScreen = Etapa4Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Cadenas y redes alimenticias
                    minijuegosScreen = Etapa4Nodo2.MinijuegoNodo2Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Ciclos biogeoquímicos
                    minijuegosScreen = Etapa4Nodo3.MinijuegoNodo3Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Cambio climático
                    minijuegosScreen = Etapa4Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa4Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: 0,
                    );
                }
              } else if (widget.etapaIndex == 3 &&
                  widget.seccionTitulo == 'Cuerpo, Materia y Energía') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Sistema Digestivo y Respiratorio
                    minijuegosScreen = Etapa4Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Cambios Físicos y Químicos
                    minijuegosScreen = Etapa4Nodo2.MinijuegoNodo2Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Tipos de Energía
                    minijuegosScreen = Etapa4Nodo3.MinijuegoNodo3Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Electricidad Básica
                    minijuegosScreen = Etapa4Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa4Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: 0,
                    );
                }
              } else if (widget.etapaIndex == 3 &&
                  widget.seccionTitulo == 'Función del Suelo') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Conservación del suelo
                    minijuegosScreen = Etapa4Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Ecosistemas locales
                    minijuegosScreen = Etapa4Nodo6.MinijuegoNodo6Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa4Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: 0,
                    );
                }
              }

              // Etapa 5 (índice 4) - Desiertos y Humedales
              else if (widget.etapaIndex == 4 &&
                  widget.seccionTitulo == 'Plantas y Factores del Ecosistema') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Importancia de las plantas (avanzado)
                    minijuegosScreen = Etapa5Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Factores del ecosistema
                    minijuegosScreen = Etapa5Nodo2.MinijuegoNodo2Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Hábitat y nicho ecológico
                    minijuegosScreen = Etapa5Nodo3.MinijuegoNodo3Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 3: // Relaciones interespecíficas
                    minijuegosScreen = Etapa5Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa5Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: 0,
                    );
                }
              } else if (widget.etapaIndex == 4 &&
                  widget.seccionTitulo ==
                      'Importancia del Agua, Aire y Suelo') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Importancia del agua
                    minijuegosScreen = Etapa5Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Importancia del aire
                    minijuegosScreen = Etapa5Nodo6.MinijuegoNodo6Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Importancia del suelo
                    minijuegosScreen = Etapa5Nodo7.MinijuegoNodo7Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa5Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: 0,
                    );
                }
              }

              // Etapa 6 (índice 5) - Ecosistema Global
              else if (widget.etapaIndex == 5 &&
                  widget.seccionTitulo == 'Biología y Biodiversidad') {
                // Cada actividad de la sección va a un minijuego específico basado en actividadIndex
                switch (widget.actividadIndex) {
                  case 0: // Introducción a la biología
                    minijuegosScreen = Etapa6Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Los seres vivos y la biodiversidad
                    minijuegosScreen = Etapa6Nodo2.MinijuegoNodo2Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Niveles de organización de los seres vivos
                    minijuegosScreen = Etapa6Nodo3.MinijuegoNodo3Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa6Nodo1.MinijuegoNodo1Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 0,
                      actividad: 0,
                    );
                }
              }

              // Etapa 6 - Sección 2: Ecosistemas y Población
              else if (widget.etapaIndex == 5 &&
                  widget.seccionTitulo == 'Ecosistemas y Población') {
                switch (widget.actividadIndex) {
                  case 0: // Nodo 4: Ecosistemas
                    minijuegosScreen = Etapa6Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 1: // Nodo 5: Factores Bióticos y Abióticos
                    minijuegosScreen = Etapa6Nodo5.MinijuegoNodo5Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  case 2: // Nodo 6: Población, comunidad, ecosistema y biosfera
                    minijuegosScreen = Etapa6Nodo6.MinijuegoNodo6Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: widget.actividadIndex,
                    );
                    break;
                  default:
                    minijuegosScreen = Etapa6Nodo4.MinijuegoNodo4Screen(
                      titulo: nombreJuego,
                      color: widget.color,
                      etapa: widget.etapaIndex,
                      seccion: 1,
                      actividad: 0,
                    );
                }
              }

              // Fallback por defecto
              else {
                minijuegosScreen = MinijuegoNodo1Screen(
                  titulo: nombreJuego,
                  color: widget.color,
                  etapa: widget.etapaIndex,
                  seccion: 0,
                  actividad: 0,
                );
              }

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => minijuegosScreen),
              ).then((result) {
                if (result == true) {
                  // El nodo fue completado exitosamente
                  setState(() {
                    _actividadCompletada = true;
                  });
                  _mostrarDialogoCompletado();
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_arrow, size: 24),
                const SizedBox(width: 8),
                Text(
                  '¡Jugar Ahora!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCompletado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 30),
            SizedBox(width: 10),
            Text('¡Actividad Completada!'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉 ¡Excelente trabajo! 🎉'),
            SizedBox(height: 10),
            Text('Has completado todos los minijuegos de esta actividad.'),
            SizedBox(height: 10),
            Text('💰 Ganaste monedas extra'),
            SizedBox(height: 10),
            Text('🔓 Siguiente actividad desbloqueada'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pop(true); // Regresa a la pantalla anterior con éxito
            },
            child: Text(
              'Continuar',
              style: TextStyle(color: widget.color),
            ),
          ),
        ],
      ),
    );
  }

  // Widgets para diferentes tipos de contenido
  Widget _buildContenidoTexto(String titulo, String contenido, IconData icono) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 60, color: widget.color),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            contenido,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenidoImagen(
      String titulo, String contenido, String imagenPath) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              imagenPath,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: widget.color.withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: widget.color,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            contenido,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiz(
      String pregunta, List<String> opciones, int respuestaCorrecta) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        int? seleccionada;
        bool mostrarRespuesta = false;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quiz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                pregunta,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                opciones.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      if (!mostrarRespuesta) {
                        setInnerState(() {
                          seleccionada = index;
                          mostrarRespuesta = true;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: seleccionada == index
                            ? (index == respuestaCorrecta
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2))
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: seleccionada == index
                              ? (index == respuestaCorrecta
                                  ? Colors.green
                                  : Colors.red)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opciones[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: seleccionada == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (mostrarRespuesta && index == respuestaCorrecta)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          if (mostrarRespuesta &&
                              seleccionada == index &&
                              index != respuestaCorrecta)
                            const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (mostrarRespuesta)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    seleccionada == respuestaCorrecta
                        ? '¡Correcto! Muy bien.'
                        : 'Incorrecto. La respuesta correcta es: ${opciones[respuestaCorrecta]}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: seleccionada == respuestaCorrecta
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInteractivo(String titulo, String instrucciones) {
    // Simulación de una actividad interactiva
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            instrucciones,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.color.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.drag_indicator,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Actividad interactiva simulada',
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aquí iría un componente interactivo real con arrastrar y soltar, juegos, etc.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ETAPA 2: BOSQUE DEL CUIDADO AMBIENTAL - SECCIÓN 1
  List<Widget> _getPaginasEtapa2Seccion1() {
    switch (widget.actividadIndex) {
      case 0: // Las Plantas y sus Funciones
        return [
          _buildMinijuegoButton(
            '🌿 Las Plantas y sus Funciones',
            '🌿 Las plantas son seres vivos increíbles. Tienen partes que cumplen funciones importantes:\n\n🌱 Raíz: Absorbe agua y sostiene la planta.\n🪴 Tallo: Transporta el agua y sostiene las hojas.\n🍃 Hojas: Fabrican el alimento con la luz del sol.\n🌸 Flor: Se encarga de la reproducción.\n🍎 Fruto: Protege las semillas.\n\n¡Presiona el botón abajo para jugar!',
            'Las Plantas',
          ),
        ];
      case 1: // Los Animales y sus Características
        return [
          _buildContenidoTexto(
            'Los Animales y sus Características',
            '🐾 Los animales son muy variados. Podemos clasificarlos por:\n\n🧥 Su cubierta: Pelos, plumas, escamas o piel desnuda.\n🏃 Su movimiento: Caminan, vuelan, nadan o reptan.\n🍽️ Su alimentación: Carnívoros (carne), Herbívoros (plantas) u Omnívoros (ambos).\n🏠 Su hábitat: Terrestres, acuáticos o aéreos.',
            Icons.pets,
          ),
          _buildMinijuegoButton(
            '¡Conoce a los Animales!',
            'Descubre cómo son y cómo viven los animales.',
            'Los Animales',
          ),
        ];
      case 2: // Clasificación de Materiales
        return [
          _buildContenidoTexto(
            'Clasificación de Materiales',
            '🧱 Todo lo que nos rodea está hecho de materiales con diferentes propiedades:\n\n🪨 Dureza: Duro (piedra) o Blando (algodón).\n✋ Textura: Áspero (lija) o Suave (seda).\n〰️ Flexibilidad: Rígido (madera) o Flexible (goma).\n🔍 Origen: Madera, metal, plástico, vidrio, papel.',
            Icons.build,
          ),
          _buildMinijuegoButton(
            '¡Investiga los Materiales!',
            'Aprende a clasificar objetos por sus propiedades.',
            'Materiales',
          ),
        ];
      case 3: // Fenómenos del Clima
        return [
          _buildContenidoTexto(
            'Fenómenos del Clima',
            '☀️ El clima cambia y afecta nuestro día a día:\n\n🌧️ Lluvia: Agua que cae de las nubes.\n� Viento: Aire en movimiento.\n☀️ Sol: Nos da luz y calor.\n❄️ Nieve: Agua congelada que cae en lugares fríos.\n\nDebemos vestirnos adecuadamente según el clima.',
            Icons.wb_sunny,
          ),
          _buildMinijuegoButton(
            '¡Observa el Clima!',
            'Aprende sobre el sol, la lluvia y las estaciones.',
            'El Clima',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 2: BOSQUE DEL CUIDADO AMBIENTAL - SECCIÓN 2
  List<Widget> _getPaginasEtapa2Seccion2() {
    switch (widget.actividadIndex) {
      case 0: // Cuidado del Ambiente
        return [
          _buildContenidoTexto(
            'Cuidado del Ambiente',
            '🌍 Cuidar nuestro planeta es tarea de todos. Podemos ayudar con las 3R:\n\n♻️ Reciclar: Separar basura (papel, plástico, vidrio).\n📉 Reducir: Usar menos bolsas y botellas.\n🔄 Reutilizar: Darle otro uso a las cosas viejas.\n\n💧 También debemos ahorrar agua y energía.',
            Icons.eco,
          ),
          _buildMinijuegoButton(
            '¡Cuida el Planeta!',
            'Aprende a reciclar y ahorrar agua.',
            'Cuidado Ambiental',
          ),
        ];
      case 1: // Fuerzas Simples
        return [
          _buildContenidoTexto(
            'Fuerzas Simples',
            '💪 Las fuerzas hacen que las cosas se muevan o cambien de forma:\n\n➡️ Empujar: Alejar un objeto de nosotros.\n⬅️ Jalar: Acercar un objeto hacia nosotros.\n🏋️ Peso: Algunos objetos son pesados y otros livianos.\n\n¡Usamos fuerzas todo el tiempo al jugar!',
            Icons.fitness_center,
          ),
          _buildMinijuegoButton(
            '¡Usa la Fuerza!',
            'Descubre cómo empujar, jalar y levantar objetos.',
            'Fuerzas',
          ),
        ];
      case 2: // El Sonido
        return [
          _buildContenidoTexto(
            'El Sonido',
            '� El sonido está en todas partes. Podemos distinguir:\n\n� Sonidos Fuertes: Como un trueno o una bocina.\n🤫 Sonidos Débiles: Como un susurro o el viento.\n🎵 Sonidos Agradables: Música, canto de pájaros.\n😖 Sonidos Desagradables: Ruido de tráfico, gritos.',
            Icons.volume_up,
          ),
          _buildMinijuegoButton(
            '¡Escucha Atentamente!',
            'Identifica sonidos fuertes, débiles y ruidos.',
            'El Sonido',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 3: ECOSISTEMA ACUÁTICO - SECCIÓN 1
  List<Widget> _getPaginasEtapa3Seccion1() {
    switch (widget.actividadIndex) {
      case 0: // Importancia de las plantas
        return [
          _buildContenidoTexto(
            'Importancia de las plantas en el ecosistema',
            '🌳 Las plantas son la base de la vida:\n\n🏭 Fábricas de oxígeno: producen el aire que respiramos\n🍯 Alimento: base de todas las cadenas alimenticias\n🏠 Hogar: refugio para miles de animales\n🌡️ Reguladores: controlan temperatura y humedad\n💧 Filtros: limpian aire y agua\n🌍 Protectores: evitan erosión del suelo\n\n🔄 Sin plantas, ¡no habría vida en la Tierra!',
            Icons.eco,
          ),
          _buildMinijuegoButton(
            '¡Explora el poder de las plantas!',
            'Descubre todas las funciones vitales de las plantas.',
            'Importancia de Plantas',
          ),
        ];
      case 1: // Insectos y arácnidos en el ecosistema
        return [
          _buildContenidoTexto(
            'Insectos y arácnidos',
            '🐛 Los pequeños trabajadores del ecosistema:\n\n🐝 INSECTOS BENEFICIOSOS:\n• Abejas: polinizan flores\n• Mariquitas: comen plagas\n• Mariposas: ayudan reproducción plantas\n• Hormigas: reciclan materia orgánica\n\n🕷️ ARÁCNIDOS ÚTILES:\n• Arañas: controlan insectos dañinos\n• Escorpiones: mantienen equilibrio\n\n🌍 ¡Son pequeños pero súper importantes para la naturaleza!',
            Icons.bug_report,
          ),
          _buildMinijuegoButton(
            '¡Mundo de pequeños trabajadores!',
            'Conoce el importante papel de insectos y arácnidos.',
            'Insectos y Arácnidos',
          ),
        ];
      case 2: // ¿Qué es un ecosistema?
        return [
          _buildContenidoTexto(
            '¿Qué es un ecosistema?',
            '🌍 Un ecosistema es como una gran familia donde todos se ayudan:\n\n🏡 COMPONENTES:\n• Seres vivos: plantas, animales, microorganismos\n• Ambiente: agua, aire, suelo, clima, luz\n• Relaciones: cómo interactúan entre ellos\n\n🔄 FUNCIONAMIENTO:\n• Los productores (plantas) hacen comida\n• Los consumidores (animales) comen plantas u otros animales\n• Los descomponedores (bacterias) reciclan\n\n🌳 Ejemplos: bosque, océano, lago, desierto',
            Icons.public,
          ),
          _buildMinijuegoButton(
            '¡Construye tu ecosistema!',
            'Aprende a identificar y crear ecosistemas equilibrados.',
            'Qué es Ecosistema',
          ),
        ];
      case 3: // Proyecto: Animales en extinción
        return [
          _buildContenidoTexto(
            'Proyecto: Animales en extinción',
            '📋 ¡Vamos a investigar y ayudar!\n\n🔍 QUÉ INVESTIGAR:\n• ¿Qué animales están en peligro?\n• ¿Por qué están desapareciendo?\n• ¿Cómo podemos ayudarlos?\n• ¿Qué organizaciones los protegen?\n\n💡 ACCIONES QUE PUEDES HACER:\n• No comprar productos de animales en peligro\n• Donar a organizaciones protectoras\n• Educar a familia y amigos\n• Participar en campañas de conservación',
            Icons.assignment,
          ),
          _buildMinijuegoButton(
            '¡Proyecto de conservación!',
            'Crea tu propio plan para ayudar a los animales en extinción.',
            'Proyecto Extinción',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 3: ECOSISTEMA ACUÁTICO - SECCIÓN 2
  List<Widget> _getPaginasEtapa3Seccion2() {
    switch (widget.actividadIndex) {
      case 0: // El agua y sus propiedades
        return [
          _buildContenidoTexto(
            'Propiedades del agua',
            '💧 El agua es única y especial:\n\n🔵 PROPIEDADES FÍSICAS:\n• Incolora (sin color)\n• Inodora (sin olor)\n• Insípida (sin sabor)\n• Hierve a 100°C\n• Se congela a 0°C\n\n⚗️ PROPIEDADES QUÍMICAS:\n• H₂O (2 hidrógenos + 1 oxígeno)\n• Disuelve muchas sustancias\n• Necesaria para la vida\n• Cambia de estado fácilmente',
            Icons.science,
          ),
          _buildMinijuegoButton(
            '¡Científico del agua!',
            'Experimenta con las propiedades únicas del agua.',
            'Propiedades del Agua',
          ),
        ];
      case 1: // El ciclo del agua
        return [
          _buildContenidoTexto(
            'El ciclo del agua',
            '💧 El agua circula constantemente:\n\n☀️ EVAPORACIÓN:\n• El sol calienta el agua\n• Se convierte en vapor\n• Sube a la atmósfera\n\n☁️ CONDENSACIÓN:\n• El vapor se enfría\n• Forma nubes y niebla\n\n🌧️ PRECIPITACIÓN:\n• El agua cae como lluvia, nieve o granizo\n• Regresa a ríos, lagos y océanos\n\n🔄 El ciclo nunca se detiene',
            Icons.water_drop,
          ),
          _buildMinijuegoButton(
            '¡Maestro del ciclo del agua!',
            'Aprende las fases del ciclo del agua jugando.',
            'El Ciclo del Agua',
          ),
        ];
      case 2: // El aire y sus propiedades
        return [
          _buildContenidoTexto(
            'Propiedades del aire',
            '💨 El aire es esencial para la vida:\n\n🌬️ COMPOSICIÓN:\n• 78% Nitrógeno\n• 21% Oxígeno\n• 1% Otros gases (CO₂, vapor de agua)\n\n⚗️ PROPIEDADES:\n• Invisible pero ocupa espacio\n• Tiene masa y peso\n• Se puede comprimir\n• Se expande con calor\n• Transmite sonido',
            Icons.air,
          ),
          _buildMinijuegoButton(
            '¡Explorador del aire!',
            'Descubre las propiedades del aire.',
            'Propiedades del Aire',
          ),
        ];
      case 3: // Contaminación del aire
        return [
          _buildContenidoTexto(
            'Contaminación del aire',
            '🏭 El aire se contamina por:\n\n🚗 FUENTES:\n• Vehículos y transporte\n• Fábricas e industrias\n• Quema de basura\n• Incendios forestales\n\n☠️ CONSECUENCIAS:\n• Enfermedades respiratorias\n• Calentamiento global\n• Lluvia ácida\n• Daño a plantas y animales\n\n💚 SOLUCIONES:\n• Usar transporte público\n• Plantar árboles\n• Energías limpias\n• Reducir emisiones',
            Icons.cloud_off,
          ),
          _buildMinijuegoButton(
            '¡Guardián del aire limpio!',
            'Combate la contaminación del aire.',
            'Contaminación del Aire',
          ),
        ];
      case 4: // El suelo y su conservación
        return [
          _buildContenidoTexto(
            'El suelo y su conservación',
            '🌱 El suelo es vida:\n\n📊 CAPAS DEL SUELO:\n• Capa orgánica (humus)\n• Subsuelo (minerales)\n• Roca madre\n\n⚠️ PROBLEMAS:\n• Erosión por viento y agua\n• Deforestación\n• Uso excesivo de químicos\n• Contaminación\n\n🛡️ CONSERVACIÓN:\n• Reforestar zonas dañadas\n• Rotación de cultivos\n• Abonos orgánicos\n• Evitar erosión',
            Icons.landscape,
          ),
          _buildMinijuegoButton(
            '¡Protector del suelo!',
            'Aprende a conservar y proteger el suelo.',
            'Conservación del Suelo',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 4: REGIÓN ANDINA - SECCIÓN 1
  List<Widget> _getPaginasEtapa4Seccion1() {
    switch (widget.actividadIndex) {
      case 0: // Ecosistemas y su clasificación
        return [
          _buildContenidoTexto(
            'Clasificación de ecosistemas',
            '🌍 Los ecosistemas se clasifican por su ambiente:\n\n🌊 ACUÁTICOS:\n• Marinos: océanos, mares\n• Dulceacuícolas: ríos, lagos, lagunas\n\n🌳 TERRESTRES:\n• Bosques: tropical, templado, boreal\n• Praderas: pastizales y sabanas\n• Desiertos: cálidos y fríos\n• Tundra: regiones polares\n\n🏔️ MIXTOS:\n• Humedales: pantanos, manglares\n• Estuarios: donde ríos llegan al mar',
            Icons.map,
          ),
          _buildMinijuegoButton(
            '¡Explorador de ecosistemas!',
            'Clasifica diferentes ecosistemas según sus características.',
            'Clasificación Ecosistemas',
          ),
        ];
      case 1: // Cadenas y redes alimenticias
        return [
          _buildContenidoTexto(
            'Cadenas y redes alimenticias',
            '🍃 La energía fluye en los ecosistemas:\n\n🔗 CADENA ALIMENTICIA:\n• Productores: plantas (fabrican alimento)\n• Consumidores primarios: herbívoros\n• Consumidores secundarios: carnívoros\n• Descomponedores: bacterias y hongos\n\n🕸️ REDES ALIMENTICIAS:\n• Múltiples cadenas conectadas\n• Un animal puede estar en varios niveles\n• Más estable que una cadena simple\n\n⚡ FLUJO DE ENERGÍA:\n• Sol → Plantas → Herbívoros → Carnívoros',
            Icons.link,
          ),
          _buildMinijuegoButton(
            '¡Constructor de cadenas!',
            'Crea cadenas y redes alimenticias equilibradas.',
            'Cadenas Alimenticias',
          ),
        ];
      case 2: // Ciclos biogeoquímicos
        return [
          _buildContenidoTexto(
            'Ciclos biogeoquímicos',
            '♻️ Los elementos circulan en la naturaleza:\n\n💧 CICLO DEL AGUA:\n• Evaporación → Condensación → Precipitación\n\n🌱 CICLO DEL CARBONO:\n• Fotosíntesis: plantas absorben CO₂\n• Respiración: animales liberan CO₂\n• Descomposición devuelve carbono al suelo\n\n🍃 CICLO DEL NITRÓGENO:\n• Bacterias fijan nitrógeno del aire\n• Plantas lo usan para crecer\n• Animales lo obtienen de plantas\n\n💨 CICLO DEL OXÍGENO:\n• Plantas producen O₂\n• Animales lo respiran',
            Icons.refresh,
          ),
          _buildMinijuegoButton(
            '¡Maestro de los ciclos!',
            'Aprende cómo circulan los elementos en la naturaleza.',
            'Ciclos Biogeoquímicos',
          ),
        ];
      case 3: // Cambio climático
        return [
          _buildContenidoTexto(
            'Cambio climático y sus efectos',
            '🌡️ El planeta está cambiando:\n\n🔥 CAUSAS PRINCIPALES:\n• Quema de combustibles fósiles\n• Deforestación masiva\n• Ganadería intensiva\n• Industria sin control\n\n🌍 EFECTOS VISIBLES:\n• Aumento de temperatura\n• Derretimiento de glaciares\n• Cambios en lluvias\n• Eventos extremos más frecuentes\n\n💚 SOLUCIONES:\n• Energías renovables\n• Reforestación\n• Consumo responsable\n• Educación ambiental',
            Icons.thermostat,
          ),
          _buildMinijuegoButton(
            '¡Guardián del clima!',
            'Aprende sobre el cambio climático y cómo combatirlo.',
            'Cambio Climático',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 5: DESIERTOS Y HUMEDALES - SECCIÓN 1
  List<Widget> _getPaginasEtapa5Seccion1() {
    switch (widget.actividadIndex) {
      case 0: // Sistemas del cuerpo humano
        return [
          _buildContenidoTexto(
            'Sistemas del cuerpo humano',
            '🫀 El cuerpo humano es una máquina increíble:\n\n🩸 SISTEMA CIRCULATORIO:\n• Corazón: bombea sangre\n• Sangre: transporta oxígeno y nutrientes\n• Vasos sanguíneos: carreteras del cuerpo\n\n🧠 SISTEMA NERVIOSO:\n• Cerebro: centro de control\n• Nervios: cables de comunicación\n• Sentidos: ventanas al mundo',
            Icons.favorite,
          ),
          _buildMinijuegoButton(
            '¡Doctor Junior!',
            'Explora cómo funciona tu cuerpo por dentro.',
            'Cuerpo Humano',
          ),
        ];
      case 1: // Propiedades de la luz y el sonido
        return [
          _buildContenidoTexto(
            'Luz y Sonido',
            '💡 LA LUZ:\n• Viaja en línea recta\n• Reflexión: rebota en espejos\n• Refracción: se dobla en agua\n\n🔊 EL SONIDO:\n• Son vibraciones\n• Necesita un medio para viajar (aire, agua)\n• Tono: agudo o grave\n• Volumen: fuerte o suave',
            Icons.light_mode,
          ),
          _buildMinijuegoButton(
            '¡Físico en acción!',
            'Experimenta con la luz y el sonido.',
            'Luz y Sonido',
          ),
        ];
      case 2: // Mezclas y soluciones
        return [
          _buildContenidoTexto(
            'Mezclas y Soluciones',
            '🧪 Todo es materia:\n\n🥣 MEZCLAS:\n• Heterogéneas: se ven los componentes (ensalada)\n• Homogéneas: no se ven (agua con sal)\n\n⚗️ SOLUCIONES:\n• Soluto: lo que se disuelve (sal)\n• Solvente: lo que disuelve (agua)\n\n🧲 SEPARACIÓN:\n• Filtración, imantación, evaporación',
            Icons.science,
          ),
          _buildMinijuegoButton(
            '¡Químico experto!',
            'Aprende a identificar y separar mezclas.',
            'Mezclas y Soluciones',
          ),
        ];
      case 3: // Fuerza, movimiento y fricción
        return [
          _buildContenidoTexto(
            'Fuerza y Movimiento',
            '🚀 Las fuerzas mueven el mundo:\n\n💪 FUERZA:\n• Empujar o jalar\n• Gravedad: nos atrae a la Tierra\n\n🛑 FRICCIÓN:\n• Fuerza que se opone al movimiento\n• Superficies rugosas = más fricción\n\n⚙️ MÁQUINAS SIMPLES:\n• Palanca, polea, plano inclinado',
            Icons.fitness_center,
          ),
          _buildMinijuegoButton(
            '¡Maestro del movimiento!',
            'Descubre cómo funcionan las fuerzas.',
            'Fuerza y Movimiento',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 5: DESIERTOS Y HUMEDALES - SECCIÓN 2
  // ETAPA 5: DESIERTOS Y HUMEDALES - SECCIÓN 2
  List<Widget> _getPaginasEtapa5Seccion2() {
    switch (widget.actividadIndex) {
      case 0: // Biodiversidad del Perú
        return [
          _buildContenidoTexto(
            'Biodiversidad del Perú',
            '🇵🇪 Perú es un país megadiverso:\n\n🌊 COSTA:\n• Pingüinos, lobos marinos, pelícanos\n\n🏔️ SIERRA:\n• Cóndor, llama, vicuña, oso de anteojos\n\n🌳 SELVA:\n• Jaguar, delfín rosado, guacamayo\n\n⚠️ CONSERVACIÓN:\n• Proteger especies en peligro de extinción',
            Icons.pets,
          ),
          _buildMinijuegoButton(
            '¡Explorador peruano!',
            'Conoce la riqueza natural de nuestro país.',
            'Biodiversidad Perú',
          ),
        ];
      case 1: // Electricidad y magnetismo
        return [
          _buildContenidoTexto(
            'Electricidad y Magnetismo',
            '⚡ Energía en acción:\n\n🔌 ELECTRICIDAD:\n• Circuitos: camino cerrado para electrones\n• Conductores: metales, agua salada\n• Aislantes: plástico, madera, goma\n\n🧲 MAGNETISMO:\n• Polos opuestos se atraen (N-S)\n• Polos iguales se repelen (N-N)',
            Icons.bolt,
          ),
          _buildMinijuegoButton(
            '¡Ingeniero eléctrico!',
            'Experimenta con circuitos e imanes.',
            'Electricidad',
          ),
        ];
      case 2: // Ecosistemas e inventos
        return [
          _buildContenidoTexto(
            'Ecosistemas e Inventos',
            '🌍 Naturaleza y Tecnología:\n\n🕸️ ECOSISTEMAS:\n• Cadena alimenticia: Productor → Consumidor → Descomponedor\n• Equilibrio natural\n\n💡 INVENTOS:\n• Solucionan problemas humanos\n• Inspirados en la naturaleza\n• Grandes inventores cambiaron el mundo',
            Icons.emoji_objects,
          ),
          _buildMinijuegoButton(
            '¡Innovador ecológico!',
            'Conecta la naturaleza con la tecnología.',
            'Ecosistemas e Inventos',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 6: ECOSISTEMA GLOBAL - SECCIÓN 1
  List<Widget> _getPaginasEtapa6Seccion1() {
    switch (widget.actividadIndex) {
      case 0: // Cuerpo y Salud
        return [
          _buildContenidoTexto(
            'Cuerpo y Salud',
            '🏥 Descubre cómo funciona nuestro cuerpo y los seres microscópicos:\n\n🧑‍🤝‍🧑 PUBERTAD:\n• Cambios físicos y emocionales\n• Crecimiento y desarrollo\n• Higiene y cuidado personal\n\n🦠 MICROORGANISMOS:\n• Virus, bacterias y hongos\n• Efectos en la salud (beneficiosos y patógenos)\n• Sistema inmunológico y defensas',
            Icons.health_and_safety,
          ),
          _buildMinijuegoButton(
            '¡Explorador de la Salud!',
            'Aprende sobre la pubertad y los microorganismos.',
            'Cuerpo y Salud',
          ),
        ];
      case 1: // Materia y Energía
        return [
          _buildContenidoTexto(
            'Materia y Energía',
            '⚡ Explora el mundo físico y tecnológico:\n\n💡 ENERGÍA Y CIRCUITOS:\n• Tipos de energía y transformaciones\n• Circuitos eléctricos simples\n• Conductores y aislantes\n\n🧪 MATERIA Y TECNOLOGÍA:\n• Estados de la materia y cambios\n• Avances tecnológicos\n• Uso responsable de la tecnología',
            Icons.bolt,
          ),
          _buildMinijuegoButton(
            '¡Ingeniero del Futuro!',
            'Experimenta con energía, materia y tecnología.',
            'Materia y Energía',
          ),
        ];
      case 2: // La Tierra y el Clima
        return [
          _buildContenidoTexto(
            'La Tierra y el Clima',
            '🌍 Nuestro planeta es dinámico y debemos cuidarlo:\n\n🔄 MOVIMIENTOS DE LA TIERRA:\n• Rotación y traslación\n• Las estaciones del año\n• El día y la noche\n\n🌡️ CALENTAMIENTO GLOBAL:\n• Efecto invernadero\n• Cambio climático\n• Acciones para proteger el planeta',
            Icons.public,
          ),
          _buildMinijuegoButton(
            '¡Guardián del Planeta!',
            'Descubre los secretos de la Tierra y el clima.',
            'La Tierra y el Clima',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }

  // ETAPA 6: ECOSISTEMA GLOBAL - SECCIÓN 2
  List<Widget> _getPaginasEtapa6Seccion2() {
    switch (widget.actividadIndex) {
      case 0: // Nodo 4: Ecosistemas
        return [
          _buildContenidoTexto(
            'Ecosistemas avanzados',
            '🌐 Los ecosistemas son sistemas complejos:\n\n⚖️ EQUILIBRIO ECOLÓGICO:\n• Cada especie tiene su función\n• Las perturbaciones afectan todo el sistema\n• La biodiversidad da estabilidad\n• Los ciclos mantienen el funcionamiento\n\n🔄 FLUJOS DE ENERGÍA:\n• Sol → Productores → Consumidores → Descomponedores\n• Se pierde energía en cada transferencia\n• Los ciclos de materia se reciclan infinitamente',
            Icons.hub,
          ),
          _buildMinijuegoButton(
            '¡Ecólogo experto!',
            'Analiza ecosistemas complejos y su funcionamiento.',
            'Ecosistemas Avanzados',
          ),
        ];
      case 1: // Nodo 5: Factores Bióticos y Abióticos
        return [
          _buildContenidoTexto(
            'Factores Bióticos y Abióticos',
            '🌍 Los ecosistemas tienen dos tipos de factores:\n\n🦎 FACTORES BIÓTICOS:\n• Todos los seres vivos\n• Plantas, animales, hongos, bacterias\n• Interacciones entre especies\n\n☀️ FACTORES ABIÓTICOS:\n• Temperatura, luz, agua\n• Suelo, aire, minerales\n• Clima y geografía\n\n⚡ Ambos factores interactúan constantemente y determinan qué organismos pueden vivir en un ecosistema.',
            Icons.nature_people,
          ),
          _buildMinijuegoButton(
            '¡Clasifica Factores!',
            'Identifica factores bióticos y abióticos en diferentes ecosistemas.',
            'Factores Ecológicos',
          ),
        ];
      case 2: // Nodo 6: Población, comunidad, ecosistema y biosfera
        return [
          _buildContenidoTexto(
            'Niveles de Organización Ecológica',
            '📊 La vida se organiza en niveles:\n\n1️⃣ ORGANISMO: Un individuo\n2️⃣ POBLACIÓN: Organismos de la misma especie\n3️⃣ COMUNIDAD: Diferentes poblaciones interactuando\n4️⃣ ECOSISTEMA: Comunidad + factores abióticos\n5️⃣ BIOSFERA: Todos los ecosistemas de la Tierra\n\n🔬 Cada nivel tiene propiedades únicas que emergen de la organización de los niveles inferiores.',
            Icons.layers,
          ),
          _buildMinijuegoButton(
            '¡Construye la Jerarquía!',
            'Organiza los niveles ecológicos y construye pirámides.',
            'Organización Ecológica',
          ),
        ];
      default:
        return [
          _buildContenidoTexto('Actividad en desarrollo',
              'Próximamente disponible.', Icons.construction)
        ];
    }
  }
}
