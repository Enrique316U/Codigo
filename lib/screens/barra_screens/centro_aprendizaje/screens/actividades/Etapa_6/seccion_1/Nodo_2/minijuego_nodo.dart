import 'package:flutter/material.dart';
import 'package:green_cloud/services/progreso_service.dart';
import 'dart:async';

class MinijuegoNodo2Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo2Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo2ScreenState createState() => _MinijuegoNodo2ScreenState();
}

class _MinijuegoNodo2ScreenState extends State<MinijuegoNodo2Screen>
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
        backgroundColor: Colors.orange,
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
            Tab(icon: Icon(Icons.bolt), text: 'Energía y Circuitos'),
            Tab(icon: Icon(Icons.science), text: 'Materia y Tecnología'),
            Tab(icon: Icon(Icons.quiz), text: 'Test Final'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _EnergiaCircuitosTab(onPuntosGanados: _agregarPuntos),
          _MateriaTecnologiaTab(onPuntosGanados: _agregarPuntos),
          _TestFinalTab(onPuntosGanados: _agregarPuntos),
        ],
      ),
    );
  }
}

// --- TAB 1: ENERGÍA Y CIRCUITOS ---
class _EnergiaCircuitosTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _EnergiaCircuitosTab({required this.onPuntosGanados});

  @override
  __EnergiaCircuitosTabState createState() => __EnergiaCircuitosTabState();
}

class __EnergiaCircuitosTabState extends State<_EnergiaCircuitosTab> {
  bool _interruptorEncendido = false;
  bool _bateriaConectada = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Construye el Circuito',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb,
                  size: 100,
                  color: (_interruptorEncendido && _bateriaConectada)
                      ? Colors.yellow
                      : Colors.grey,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Batería'),
                        Switch(
                          value: _bateriaConectada,
                          onChanged: (val) {
                            setState(() {
                              _bateriaConectada = val;
                              if (_bateriaConectada && _interruptorEncendido)
                                widget.onPuntosGanados(10);
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Interruptor'),
                        Switch(
                          value: _interruptorEncendido,
                          onChanged: (val) {
                            setState(() {
                              _interruptorEncendido = val;
                              if (_bateriaConectada && _interruptorEncendido)
                                widget.onPuntosGanados(10);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  (_interruptorEncendido && _bateriaConectada)
                      ? '¡Luz encendida! El circuito está cerrado.'
                      : 'El circuito está abierto o sin energía.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Text('Tipos de Energía',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _buildEnergyCard(
              'Solar', Icons.wb_sunny, Colors.orangeAccent, 'Energía del sol.'),
          _buildEnergyCard('Eólica', Icons.air, Colors.lightBlueAccent,
              'Energía del viento.'),
          _buildEnergyCard(
              'Hidráulica', Icons.water_drop, Colors.blue, 'Energía del agua.'),
        ],
      ),
    );
  }

  Widget _buildEnergyCard(
      String title, IconData icon, Color color, String desc) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }
}

// --- TAB 2: MATERIA Y TECNOLOGÍA ---
class _MateriaTecnologiaTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _MateriaTecnologiaTab({required this.onPuntosGanados});

  @override
  __MateriaTecnologiaTabState createState() => __MateriaTecnologiaTabState();
}

class __MateriaTecnologiaTabState extends State<_MateriaTecnologiaTab> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Hielo', 'state': 'Sólido', 'icon': Icons.ac_unit},
    {'name': 'Agua', 'state': 'Líquido', 'icon': Icons.water_drop},
    {'name': 'Vapor', 'state': 'Gaseoso', 'icon': Icons.cloud},
    {'name': 'Roca', 'state': 'Sólido', 'icon': Icons.landscape},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Estados de la Materia',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildDropZone('Sólido', Colors.brown.shade100)),
              Expanded(child: _buildDropZone('Líquido', Colors.blue.shade100)),
              Expanded(child: _buildDropZone('Gaseoso', Colors.grey.shade100)),
            ],
          ),
        ),
        Container(
          height: 100,
          padding: EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _items.map((item) => _buildDraggable(item)).toList(),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Tecnología'),
                  content: Text(
                      'La tecnología usa el conocimiento científico para resolver problemas. ¡Como este juego!'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Entendido'))
                  ],
                ),
              );
              widget.onPuntosGanados(20);
            },
            child: Text('Dato Tecnológico (+20 pts)'),
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

  Widget _buildDropZone(String state, Color color) {
    return DragTarget<Map>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Center(
            child: Text(state, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        if (data['state'] == state) {
          widget.onPuntosGanados(15);
          setState(() {
            _items.remove(data);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Incorrecto'), backgroundColor: Colors.red),
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
      'pregunta': '¿Qué es la biodiversidad?',
      'opciones': [
        'Un solo tipo de planta',
        'Variedad de seres vivos',
        'Solo animales',
        'Solo insectos'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'Los ecosistemas incluyen:',
      'opciones': [
        'Solo plantas',
        'Solo animales',
        'Seres vivos y factores no vivos',
        'Solo agua'
      ],
      'correcta': 2,
    },
    {
      'pregunta': '¿Qué es una especie endémica?',
      'opciones': [
        'Existe en todo el mundo',
        'Solo en una región específica',
        'Está extinta',
        'Es un animal doméstico'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'La pérdida de biodiversidad afecta:',
      'opciones': [
        'Solo a los animales',
        'Solo a las plantas',
        'A todo el ecosistema',
        'A nada importante'
      ],
      'correcta': 2,
    },
    {
      'pregunta': 'Un hábitat es:',
      'opciones': [
        'Un tipo de comida',
        'Lugar donde vive un organismo',
        'Una enfermedad',
        'Un tipo de clima'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'Las cadenas alimentarias muestran:',
      'opciones': [
        'Tipos de clima',
        'Flujo de energía entre organismos',
        'Solo plantas',
        'Solo carnívoros'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'Los descomponedores:',
      'opciones': [
        'Solo comen plantas',
        'Reciclan nutrientes',
        'Son depredadores',
        'No sirven para nada'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'La conservación de especies es importante para:',
      'opciones': [
        'Solo el turismo',
        'Mantener el equilibrio ecológico',
        'Solo la ciencia',
        'No es importante'
      ],
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
            Icon(Icons.quiz, size: 100, color: Colors.orange),
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
                backgroundColor: Colors.orange,
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
                backgroundColor: Colors.orange,
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
                    : [Colors.orange[400]!, Colors.orange[200]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_tiempoRestante <= 20 ? Colors.red : Colors.orange)
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            minHeight: 10,
          ),
          SizedBox(height: 35),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange, width: 3),
            ),
            child: Text(
              pregunta['pregunta'] as String,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[900],
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
                        side: BorderSide(color: Colors.orange, width: 2),
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
