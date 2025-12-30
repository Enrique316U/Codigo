import 'package:flutter/material.dart';
import 'package:green_cloud/services/progreso_service.dart';
import 'dart:async';

class MinijuegoNodo1Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo1Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo1ScreenState createState() => _MinijuegoNodo1ScreenState();
}

class _MinijuegoNodo1ScreenState extends State<MinijuegoNodo1Screen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _puntos = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _agregarPuntos(int cantidad) {
    setState(() {
      _puntos += cantidad;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡+$cantidad Puntos! Total: $_puntos'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
    _verificarCompletado();
  }

  void _verificarCompletado() {
    if (_puntos >= 150) {
      // Umbral para completar
      ProgresoService().marcarActividadCompletada(
          widget.etapa, widget.seccion, widget.actividad, _puntos);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Felicidades! Has completado la actividad.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: widget.color,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.face), text: 'Pubertad'),
            Tab(icon: Icon(Icons.bug_report), text: 'Microorganismos'),
            Tab(icon: Icon(Icons.quiz), text: 'Test Final'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PubertadTab(onPuntosGanados: _agregarPuntos),
          _MicroorganismosTab(onPuntosGanados: _agregarPuntos),
          _TestFinalTab(onPuntosGanados: _agregarPuntos),
        ],
      ),
    );
  }
}

// --- TAB 1: PUBERTAD ---
class _PubertadTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _PubertadTab({required this.onPuntosGanados});

  @override
  __PubertadTabState createState() => __PubertadTabState();
}

class __PubertadTabState extends State<_PubertadTab> {
  final List<Map<String, dynamic>> _infoCards = [
    {
      'title': 'Cambios Físicos',
      'content':
          'El cuerpo crece rápidamente. Aparece vello corporal, cambia la voz y la piel puede volverse más grasa.',
      'icon': Icons.accessibility_new,
      'color': Colors.blue.shade100,
    },
    {
      'title': 'Cambios Emocionales',
      'content':
          'Es normal sentir cambios de humor repentinos, querer más independencia y valorar más la amistad.',
      'icon': Icons.sentiment_satisfied_alt,
      'color': Colors.orange.shade100,
    },
    {
      'title': 'Higiene Personal',
      'content':
          'Es importante bañarse diariamente, usar desodorante y lavar la cara para prevenir el acné.',
      'icon': Icons.clean_hands,
      'color': Colors.green.shade100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'La Aventura de Crecer',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 20),
          ..._infoCards.asMap().entries.map((entry) {
            Map card = entry.value;
            return Card(
              color: card['color'],
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(card['icon'], size: 30, color: Colors.black54),
                        SizedBox(width: 10),
                        Text(
                          card['title'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(card['content'], style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) =>
                    _QuizDialog(onCorrect: () => widget.onPuntosGanados(50)),
              );
            },
            icon: Icon(Icons.quiz),
            label: Text('¡Pon a prueba tu conocimiento!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizDialog extends StatelessWidget {
  final VoidCallback onCorrect;
  const _QuizDialog({required this.onCorrect});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Quiz Rápido'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              '¿Qué es fundamental durante la pubertad para mantener la salud?'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Incorrecto, intenta de nuevo.')));
            },
            child: Text('Comer solo dulces'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onCorrect();
            },
            child: Text('Buena higiene y alimentación'),
          ),
        ],
      ),
    );
  }
}

// --- TAB 2: MICROORGANISMOS ---
class _MicroorganismosTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _MicroorganismosTab({required this.onPuntosGanados});

  @override
  __MicroorganismosTabState createState() => __MicroorganismosTabState();
}

class __MicroorganismosTabState extends State<_MicroorganismosTab> {
  final List<Map<String, dynamic>> _microbios = [
    {'name': 'Lactobacillus', 'type': 'good', 'icon': Icons.check_circle},
    {'name': 'Salmonella', 'type': 'bad', 'icon': Icons.warning},
    {'name': 'Levadura', 'type': 'good', 'icon': Icons.local_pizza},
    {'name': 'Virus Gripe', 'type': 'bad', 'icon': Icons.coronavirus},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Clasifica los Microorganismos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Arrastra los microorganismos a la zona correcta (Beneficiosos o Dañinos)',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildDropZone(
                    'Beneficiosos', 'good', Colors.green.shade100),
              ),
              Expanded(
                child: _buildDropZone('Dañinos', 'bad', Colors.red.shade100),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          padding: EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _microbios.map((m) => _buildDraggable(m)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggable(Map<String, dynamic> item) {
    return Draggable<Map>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Icon(item['icon'], size: 50, color: Colors.purple),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Column(
          children: [
            Icon(item['icon'], size: 40, color: Colors.grey),
            Text(item['name'], style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
      child: Column(
        children: [
          Icon(item['icon'], size: 40, color: Colors.purple),
          Text(item['name'], style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDropZone(String title, String acceptType, Color color) {
    return DragTarget<Map>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (candidateData.isNotEmpty)
                  Icon(Icons.add_circle_outline, size: 40),
              ],
            ),
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        if (data['type'] == acceptType) {
          widget.onPuntosGanados(20);
          setState(() {
            _microbios.remove(data);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('¡Ups! Ese no va ahí.'),
                backgroundColor: Colors.red),
          );
        }
      },
    );
  }
}

// --- TAB 3: TEST FINAL CRONOMETRADO ---
class _TestFinalTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _TestFinalTab({required this.onPuntosGanados});

  @override
  __TestFinalTabState createState() => __TestFinalTabState();
}

class __TestFinalTabState extends State<_TestFinalTab> {
  int _preguntaActual = 0;
  int _respuestasCorrectas = 0;
  bool _juegoTerminado = false;
  bool _juegoIniciado = false;
  int _tiempoRestante = 75;
  Timer? _timer;

  final List<Map<String, dynamic>> _preguntas = [
    {
      'pregunta': '¿Qué es la pubertad?',
      'opciones': [
        'Una enfermedad',
        'Etapa de cambios físicos y emocionales',
        'Un tipo de ejercicio',
        'Una dieta especial'
      ],
      'correcta': 1,
    },
    {
      'pregunta': '¿Qué son los microorganismos?',
      'opciones': [
        'Plantas grandes',
        'Animales vertebrados',
        'Seres vivos microscópicos',
        'Rocas pequeñas'
      ],
      'correcta': 2,
    },
    {
      'pregunta': 'Los cambios en la pubertad incluyen:',
      'opciones': [
        'Solo cambios físicos',
        'Solo cambios emocionales',
        'Cambios físicos, emocionales y sociales',
        'No hay cambios'
      ],
      'correcta': 2,
    },
    {
      'pregunta': '¿Qué tipo de microorganismo causa enfermedades?',
      'opciones': ['Todos', 'Solo bacterias', 'Patógenos', 'Ninguno'],
      'correcta': 2,
    },
    {
      'pregunta': 'Durante la pubertad, el cuerpo produce:',
      'opciones': [
        'Menos hormonas',
        'Más hormonas',
        'Las mismas hormonas',
        'No produce hormonas'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'Las bacterias beneficiosas ayudan a:',
      'opciones': [
        'Causar enfermedades',
        'Digestión y producción de vitaminas',
        'Destruir células',
        'Nada útil'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'La higiene personal en la pubertad es:',
      'opciones': [
        'Menos importante',
        'Igual de importante',
        'Más importante',
        'No importa'
      ],
      'correcta': 2,
    },
    {
      'pregunta': 'Los virus son:',
      'opciones': [
        'Células vivas',
        'Animales microscópicos',
        'Partículas que necesitan células huésped',
        'Plantas pequeñas'
      ],
      'correcta': 2,
    },
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciarJuego() {
    setState(() {
      _juegoIniciado = true;
      _preguntaActual = 0;
      _respuestasCorrectas = 0;
      _juegoTerminado = false;
      _tiempoRestante = 75;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_tiempoRestante > 0) {
          _tiempoRestante--;
        } else {
          _finalizarJuego();
        }
      });
    });
  }

  void _responder(int indice) {
    if (_juegoTerminado) return;

    final esCorrecta = indice == _preguntas[_preguntaActual]['correcta'] as int;

    if (esCorrecta) {
      setState(() {
        _respuestasCorrectas++;
      });
    }

    if (_preguntaActual < _preguntas.length - 1) {
      setState(() {
        _preguntaActual++;
      });
    } else {
      _finalizarJuego();
    }
  }

  void _finalizarJuego() {
    _timer?.cancel();
    setState(() {
      _juegoTerminado = true;
    });

    final puntos = (_respuestasCorrectas * 10).toInt();
    widget.onPuntosGanados(puntos);
  }

  @override
  Widget build(BuildContext context) {
    if (!_juegoIniciado) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 100, color: Colors.green),
            SizedBox(height: 30),
            Text(
              'Test Final',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              '8 preguntas en 75 segundos',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _iniciarJuego,
              icon: Icon(Icons.play_arrow, size: 32),
              label: Text('Comenzar Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_juegoTerminado) {
      final porcentaje =
          (_respuestasCorrectas / _preguntas.length * 100).round();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _respuestasCorrectas >= 6 ? Icons.emoji_events : Icons.star_half,
              size: 100,
              color: _respuestasCorrectas >= 6 ? Colors.amber : Colors.orange,
            ),
            SizedBox(height: 30),
            Text(
              _respuestasCorrectas >= 6 ? '¡Excelente!' : 'Sigue practicando',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Respuestas correctas: $_respuestasCorrectas/${_preguntas.length}',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 10),
            Text(
              'Porcentaje: $porcentaje%',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _juegoIniciado = false;
                });
              },
              icon: Icon(Icons.replay, size: 28),
              label: Text('Intentar de nuevo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final pregunta = _preguntas[_preguntaActual];

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _tiempoRestante <= 20
                    ? [Colors.red[400]!, Colors.red[200]!]
                    : [Colors.green[400]!, Colors.green[200]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_tiempoRestante <= 20 ? Colors.red : Colors.green)
                      .withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: Colors.white, size: 32),
                SizedBox(width: 15),
                Text(
                  'Tiempo: $_tiempoRestante s',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Pregunta ${_preguntaActual + 1} de ${_preguntas.length}',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_preguntaActual + 1) / _preguntas.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 10,
          ),
          SizedBox(height: 35),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green, width: 3),
            ),
            child: Text(
              pregunta['pregunta'] as String,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: (pregunta['opciones'] as List).length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => _responder(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.all(22),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    child: Text(
                      pregunta['opciones'][index] as String,
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
