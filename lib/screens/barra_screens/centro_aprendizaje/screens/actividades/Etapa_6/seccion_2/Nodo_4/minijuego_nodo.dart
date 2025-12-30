import 'package:flutter/material.dart';
import 'package:green_cloud/services/progreso_service.dart';
import 'dart:async';

class MinijuegoNodo4Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo4Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo4ScreenState createState() => _MinijuegoNodo4ScreenState();
}

class _MinijuegoNodo4ScreenState extends State<MinijuegoNodo4Screen>
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
    print('🔍 Verificando completado: Puntos actuales = $_puntos');
    if (_puntos >= 100) {
      print('✅ Puntos suficientes! Marcando actividad como completada...');
      print(
          '   Etapa: ${widget.etapa}, Sección: ${widget.seccion}, Actividad: ${widget.actividad}');
      ProgresoService().marcarActividadCompletada(
          widget.etapa, widget.seccion, widget.actividad, _puntos);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 ¡Felicidades! Has dominado los ecosistemas'),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );
      print('✅ Actividad marcada como completada exitosamente');
    } else {
      print('⚠️ Puntos insuficientes: $_puntos/100');
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
            Tab(icon: Icon(Icons.quiz), text: 'Test Rápido'),
            Tab(icon: Icon(Icons.link), text: 'Relacionar'),
            Tab(icon: Icon(Icons.drag_indicator), text: 'Clasificar'),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                'Puntos: $_puntos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TestCronometradoTab(onPuntosGanados: _agregarPuntos),
          _RelacionarTab(onPuntosGanados: _agregarPuntos),
          _ClasificarTab(onPuntosGanados: _agregarPuntos),
        ],
      ),
    );
  }
}

// ============================================
// TAB 1: TEST CRONOMETRADO
// ============================================
class _TestCronometradoTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _TestCronometradoTab({required this.onPuntosGanados});

  @override
  __TestCronometradoTabState createState() => __TestCronometradoTabState();
}

class __TestCronometradoTabState extends State<_TestCronometradoTab> {
  int _preguntaActual = 0;
  int _respuestasCorrectas = 0;
  bool _juegoTerminado = false;
  bool _juegoIniciado = false;
  int _tiempoRestante = 60; // 60 segundos
  Timer? _timer;

  final List<Map<String, dynamic>> _preguntas = [
    {
      'pregunta': '¿Qué es un ecosistema?',
      'opciones': [
        'Solo los animales de una región',
        'El conjunto de seres vivos, ambiente y sus interacciones',
        'Solo las plantas de un lugar',
        'El clima de una región'
      ],
      'correcta': 1,
    },
    {
      'pregunta': '¿Cuál NO es un tipo de ecosistema?',
      'opciones': ['Terrestre', 'Acuático', 'Mixto', 'Urbano artificial'],
      'correcta': 3,
    },
    {
      'pregunta': 'El ecosistema marino es un tipo de ecosistema:',
      'opciones': ['Terrestre', 'Acuático', 'Aéreo', 'Artificial'],
      'correcta': 1,
    },
    {
      'pregunta': '¿Qué caracteriza a un ecosistema desértico?',
      'opciones': [
        'Mucha lluvia',
        'Temperaturas extremas y poca agua',
        'Mucha vegetación',
        'Animales grandes'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'La selva tropical es un ecosistema con:',
      'opciones': [
        'Poca biodiversidad',
        'Gran biodiversidad y humedad',
        'Temperaturas frías',
        'Sin vegetación'
      ],
      'correcta': 1,
    },
    {
      'pregunta': '¿Cuál es un ejemplo de ecosistema acuático dulce?',
      'opciones': ['Océano', 'Río', 'Playa', 'Arrecife de coral'],
      'correcta': 1,
    },
    {
      'pregunta': 'Los ecosistemas artificiales son:',
      'opciones': [
        'Creados por la naturaleza',
        'Creados o modificados por humanos',
        'Solo en el agua',
        'Solo en el desierto'
      ],
      'correcta': 1,
    },
    {
      'pregunta': '¿Qué ecosistema tiene temperatura baja y nieve?',
      'opciones': ['Selva', 'Desierto', 'Tundra', 'Sabana'],
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
      _tiempoRestante = 60;
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

    final puntos = (_respuestasCorrectas * 5).toInt();
    widget.onPuntosGanados(puntos);
  }

  @override
  Widget build(BuildContext context) {
    if (!_juegoIniciado) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              'Test Cronometrado',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '8 preguntas en 60 segundos',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _iniciarJuego,
              icon: Icon(Icons.play_arrow, color: Colors.white, size: 24),
              label: Text(
                'Iniciar Test',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      );
    }

    if (_juegoTerminado) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _respuestasCorrectas >= 6 ? Icons.emoji_events : Icons.pending,
              size: 80,
              color: _respuestasCorrectas >= 6 ? Colors.amber : Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              _respuestasCorrectas >= 6 ? '¡Excelente!' : 'Sigue practicando',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Respuestas correctas: $_respuestasCorrectas/${_preguntas.length}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _juegoIniciado = false;
                });
              },
              icon: Icon(Icons.replay),
              label: Text('Intentar de nuevo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
          // Temporizador
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _tiempoRestante <= 10 ? Colors.red[100] : Colors.blue[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer,
                    color: _tiempoRestante <= 10 ? Colors.red : Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Tiempo: $_tiempoRestante s',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _tiempoRestante <= 10 ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Progreso
          Text(
            'Pregunta ${_preguntaActual + 1} de ${_preguntas.length}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          LinearProgressIndicator(
            value: (_preguntaActual + 1) / _preguntas.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          SizedBox(height: 30),
          // Pregunta
          Text(
            pregunta['pregunta'] as String,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          // Opciones
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
                      padding: EdgeInsets.all(20),
                      elevation: 3,
                    ),
                    child: Text(
                      pregunta['opciones'][index] as String,
                      style: TextStyle(fontSize: 16),
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

// ============================================
// TAB 2: RELACIONAR ECOSISTEMAS
// ============================================
class _RelacionarTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _RelacionarTab({required this.onPuntosGanados});

  @override
  __RelacionarTabState createState() => __RelacionarTabState();
}

class __RelacionarTabState extends State<_RelacionarTab> {
  Map<String, String?> _respuestas = {};
  bool _mostrarResultados = false;

  final Map<String, String> _parejas = {
    'Desierto': 'Poca agua, temperaturas extremas',
    'Selva': 'Alta biodiversidad, mucha lluvia',
    'Tundra': 'Frío extremo, poca vegetación',
    'Océano': 'Agua salada, mayor ecosistema',
    'Bosque templado': 'Cuatro estaciones, árboles caducos',
    'Sabana': 'Pastizales, estación seca y húmeda',
  };

  List<String> _caracteristicasDesordenadas = [];

  @override
  void initState() {
    super.initState();
    _caracteristicasDesordenadas = _parejas.values.toList()..shuffle();
  }

  void _verificarRespuestas() {
    int correctas = 0;
    _parejas.forEach((ecosistema, caracteristica) {
      if (_respuestas[ecosistema] == caracteristica) {
        correctas++;
      }
    });

    setState(() {
      _mostrarResultados = true;
    });

    final puntos = (correctas * 8).toInt();
    widget.onPuntosGanados(puntos);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$correctas/${_parejas.length} correctas'),
        backgroundColor: correctas >= 4 ? Colors.green : Colors.orange,
      ),
    );
  }

  void _reiniciar() {
    setState(() {
      _respuestas.clear();
      _mostrarResultados = false;
      _caracteristicasDesordenadas = _parejas.values.toList()..shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Relaciona cada ecosistema con su característica',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ..._parejas.keys.map((ecosistema) {
            final caracteristicaCorrecta = _parejas[ecosistema]!;
            final respuestaUsuario = _respuestas[ecosistema];
            final esCorrecta = respuestaUsuario == caracteristicaCorrecta;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _mostrarResultados
                    ? (esCorrecta ? Colors.green[100] : Colors.red[100])
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _mostrarResultados
                      ? (esCorrecta ? Colors.green : Colors.red)
                      : Colors.blue,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.forest, color: Colors.green[700]),
                      SizedBox(width: 10),
                      Text(
                        ecosistema,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: respuestaUsuario,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: Text('Selecciona una característica'),
                    items: _caracteristicasDesordenadas.map((caracteristica) {
                      return DropdownMenuItem(
                        value: caracteristica,
                        child: Text(caracteristica,
                            style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: _mostrarResultados
                        ? null
                        : (valor) {
                            setState(() {
                              _respuestas[ecosistema] = valor;
                            });
                          },
                  ),
                  if (_mostrarResultados && !esCorrecta)
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Correcta: $caracteristicaCorrecta',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed:
                    _respuestas.length == _parejas.length && !_mostrarResultados
                        ? _verificarRespuestas
                        : null,
                icon: Icon(Icons.check_circle),
                label: Text('Verificar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              if (_mostrarResultados)
                ElevatedButton.icon(
                  onPressed: _reiniciar,
                  icon: Icon(Icons.replay),
                  label: Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 3: CLASIFICAR ORGANISMOS
// ============================================
class _ClasificarTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _ClasificarTab({required this.onPuntosGanados});

  @override
  __ClasificarTabState createState() => __ClasificarTabState();
}

class __ClasificarTabState extends State<_ClasificarTab> {
  Map<String, List<String>> _ecosistemas = {
    'Terrestre': [],
    'Acuático': [],
    'Mixto': [],
  };

  List<Map<String, String>> _organismos = [
    {'nombre': 'León', 'ecosistema': 'Terrestre'},
    {'nombre': 'Delfín', 'ecosistema': 'Acuático'},
    {'nombre': 'Cocodrilo', 'ecosistema': 'Mixto'},
    {'nombre': 'Águila', 'ecosistema': 'Terrestre'},
    {'nombre': 'Tiburón', 'ecosistema': 'Acuático'},
    {'nombre': 'Nutria', 'ecosistema': 'Mixto'},
    {'nombre': 'Serpiente', 'ecosistema': 'Terrestre'},
    {'nombre': 'Pulpo', 'ecosistema': 'Acuático'},
    {'nombre': 'Rana', 'ecosistema': 'Mixto'},
    {'nombre': 'Cactus', 'ecosistema': 'Terrestre'},
  ];

  List<Map<String, String>> _organismosDisponibles = [];
  bool _juegoTerminado = false;

  @override
  void initState() {
    super.initState();
    _organismosDisponibles = List.from(_organismos)..shuffle();
  }

  void _verificarClasificacion() {
    int correctos = 0;
    int total = 0;

    _ecosistemas.forEach((ecosistema, organismos) {
      organismos.forEach((organismo) {
        total++;
        final correcto = _organismos
                .firstWhere((o) => o['nombre'] == organismo)['ecosistema'] ==
            ecosistema;
        if (correcto) correctos++;
      });
    });

    setState(() {
      _juegoTerminado = true;
    });

    final puntos = (correctos * 5).toInt();
    widget.onPuntosGanados(puntos);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(correctos == total ? '¡Perfecto!' : 'Buen intento'),
        content: Text('$correctos de $total correctos'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reiniciar();
            },
            child: Text('Reintentar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _reiniciar() {
    setState(() {
      _ecosistemas = {
        'Terrestre': [],
        'Acuático': [],
        'Mixto': [],
      };
      _organismosDisponibles = List.from(_organismos)..shuffle();
      _juegoTerminado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Arrastra cada organismo a su ecosistema',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // Organismos disponibles
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _organismosDisponibles.map((organismo) {
              return Draggable<String>(
                data: organismo['nombre']!,
                feedback: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      organismo['nombre']!,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Chip(
                    label: Text(organismo['nombre']!),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                child: Chip(
                  label: Text(organismo['nombre']!),
                  backgroundColor: Colors.amber[200],
                  avatar: Icon(Icons.pets, size: 18),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 30),
          // Zonas de ecosistemas
          ..._ecosistemas.keys.map((ecosistema) {
            final color = ecosistema == 'Terrestre'
                ? Colors.brown
                : ecosistema == 'Acuático'
                    ? Colors.blue
                    : Colors.green;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: DragTarget<String>(
                onAccept: (organismo) {
                  setState(() {
                    _ecosistemas[ecosistema]!.add(organismo);
                    _organismosDisponibles
                        .removeWhere((o) => o['nombre'] == organismo);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 100),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? color.withOpacity(0.3)
                          : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: color, width: 3),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                                ecosistema == 'Terrestre'
                                    ? Icons.terrain
                                    : ecosistema == 'Acuático'
                                        ? Icons.water
                                        : Icons.water_drop,
                                color: color),
                            SizedBox(width: 10),
                            Text(
                              ecosistema,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _ecosistemas[ecosistema]!.map((organismo) {
                            final esCorrecta = _juegoTerminado &&
                                _organismos.firstWhere((o) =>
                                        o['nombre'] ==
                                        organismo)['ecosistema'] ==
                                    ecosistema;
                            return Chip(
                              label: Text(organismo),
                              backgroundColor: _juegoTerminado
                                  ? (esCorrecta
                                      ? Colors.green[200]
                                      : Colors.red[200])
                                  : color.withOpacity(0.3),
                              deleteIcon: _juegoTerminado
                                  ? null
                                  : Icon(Icons.close, size: 18),
                              onDeleted: _juegoTerminado
                                  ? null
                                  : () {
                                      setState(() {
                                        _ecosistemas[ecosistema]!
                                            .remove(organismo);
                                        _organismosDisponibles.add(
                                            _organismos.firstWhere((o) =>
                                                o['nombre'] == organismo));
                                      });
                                    },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _organismosDisponibles.isEmpty && !_juegoTerminado
                ? _verificarClasificacion
                : null,
            icon: Icon(Icons.check_circle),
            label: Text('Verificar Clasificación'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
