import 'package:flutter/material.dart';
import 'package:green_cloud/services/progreso_service.dart';
import 'dart:async';
import 'dart:math' as math;

class MinijuegoNodo3Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo3Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo3ScreenState createState() => _MinijuegoNodo3ScreenState();
}

class _MinijuegoNodo3ScreenState extends State<MinijuegoNodo3Screen>
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
            Tab(icon: Icon(Icons.public), text: 'Movimientos Tierra'),
            Tab(icon: Icon(Icons.thermostat), text: 'Clima y Planeta'),
            Tab(icon: Icon(Icons.quiz), text: 'Test Final'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MovimientosTierraTab(onPuntosGanados: _agregarPuntos),
          _ClimaPlanetaTab(onPuntosGanados: _agregarPuntos),
          _TestFinalTab(onPuntosGanados: _agregarPuntos),
        ],
      ),
    );
  }
}

// --- TAB 1: MOVIMIENTOS TIERRA ---
class _MovimientosTierraTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _MovimientosTierraTab({required this.onPuntosGanados});

  @override
  __MovimientosTierraTabState createState() => __MovimientosTierraTabState();
}

class __MovimientosTierraTabState extends State<_MovimientosTierraTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'La Danza de la Tierra',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 20),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Sol
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.orange, blurRadius: 20)
                      ],
                    ),
                    child: Icon(Icons.wb_sunny, color: Colors.orange, size: 50),
                  ),
                  // Órbita
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                  ),
                  // Tierra orbitando (Traslación)
                  Transform.rotate(
                    angle: _controller.value * 2 * math.pi,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Transform.translate(
                        offset: Offset(0, -125), // Radio de la órbita
                        child: Column(
                          children: [
                            // Tierra rotando (Rotación)
                            Transform.rotate(
                              angle: _controller.value * 20 * math.pi,
                              child: Icon(Icons.public,
                                  color: Colors.blue, size: 40),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 30),
          _buildInfoCard(
              'Rotación',
              'Giro sobre su eje. Dura 24 horas. Causa el día y la noche.',
              Icons.rotate_right),
          _buildInfoCard(
              'Traslación',
              'Giro alrededor del Sol. Dura 365 días. Causa las estaciones.',
              Icons.sync),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('¿Sabías qué?'),
                  content: Text(
                      'La Tierra gira a 1,670 km/h en el ecuador, ¡pero no lo sentimos!'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('¡Increíble!'))
                  ],
                ),
              );
              widget.onPuntosGanados(20);
            },
            child: Text('Dato Curioso (+20 pts)'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String desc, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }
}

// --- TAB 2: CLIMA Y PLANETA ---
class _ClimaPlanetaTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _ClimaPlanetaTab({required this.onPuntosGanados});

  @override
  __ClimaPlanetaTabState createState() => __ClimaPlanetaTabState();
}

class __ClimaPlanetaTabState extends State<_ClimaPlanetaTab> {
  final List<Map<String, dynamic>> _actions = [
    {'text': 'Reciclar plástico', 'good': true},
    {'text': 'Dejar luces encendidas', 'good': false},
    {'text': 'Plantar árboles', 'good': true},
    {'text': 'Usar mucho el coche', 'good': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Salva el Planeta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Selecciona las acciones que ayudan a combatir el calentamiento global.',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _actions.length,
            itemBuilder: (context, index) {
              var action = _actions[index];
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(action['text']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.green),
                        onPressed: () {
                          if (action['good']) {
                            widget.onPuntosGanados(20);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('¡Correcto! Ayudas al planeta.')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('¡Cuidado! Eso daña el planeta.'),
                                backgroundColor: Colors.red));
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.thumb_down, color: Colors.red),
                        onPressed: () {
                          if (!action['good']) {
                            widget.onPuntosGanados(20);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('¡Bien! Evitaste una mala acción.')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('¡Ups! Eso era bueno.'),
                                backgroundColor: Colors.red));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
      'pregunta': '¿Qué movimiento causa el día y la noche?',
      'opciones': ['Traslación', 'Rotación', 'Precesión', 'Nutación'],
      'correcta': 1,
    },
    {
      'pregunta': 'El movimiento de traslación dura:',
      'opciones': ['24 horas', '365 días', '12 meses exactos', '1 año lunar'],
      'correcta': 1,
    },
    {
      'pregunta': '¿Qué causa las estaciones del año?',
      'opciones': [
        'Distancia al Sol',
        'Inclinación del eje terrestre',
        'Velocidad de rotación',
        'La Luna'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'El clima se refiere a:',
      'opciones': [
        'Condiciones meteorológicas actuales',
        'Promedio de condiciones a largo plazo',
        'Solo temperatura',
        'Solo precipitaciones'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'La atmósfera protege de:',
      'opciones': [
        'Solo lluvia',
        'Radiación solar dañina',
        'Solo viento',
        'Nada importante'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'El efecto invernadero natural:',
      'opciones': [
        'Es malo siempre',
        'Mantiene la temperatura habitable',
        'No existe',
        'Solo afecta a las plantas'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'Los océanos influyen en el clima porque:',
      'opciones': [
        'Son azules',
        'Absorben y liberan calor lentamente',
        'Tienen sal',
        'Son profundos'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'La capa de ozono nos protege de:',
      'opciones': ['Lluvia ácida', 'Rayos UV', 'Meteoritos', 'Contaminación'],
      'correcta': 1,
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
            Icon(Icons.quiz, size: 100, color: Colors.teal),
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
                backgroundColor: Colors.teal,
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
                backgroundColor: Colors.teal,
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
                    : [Colors.teal[400]!, Colors.teal[200]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_tiempoRestante <= 20 ? Colors.red : Colors.teal)
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            minHeight: 10,
          ),
          SizedBox(height: 35),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal, width: 3),
            ),
            child: Text(
              pregunta['pregunta'] as String,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
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
                        side: BorderSide(color: Colors.teal, width: 2),
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
