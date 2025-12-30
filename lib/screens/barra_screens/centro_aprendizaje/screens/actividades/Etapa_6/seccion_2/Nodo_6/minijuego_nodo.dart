import 'package:flutter/material.dart';
import 'package:green_cloud/services/progreso_service.dart';
import 'dart:async';

class MinijuegoNodo6Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo6Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo6ScreenState createState() => _MinijuegoNodo6ScreenState();
}

class _MinijuegoNodo6ScreenState extends State<MinijuegoNodo6Screen>
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
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 1),
      ),
    );
    _verificarCompletado();
  }

  void _verificarCompletado() {
    print('🔍 [Nodo 6] Verificando completado: Puntos actuales = $_puntos');
    if (_puntos >= 100) {
      print(
          '✅ [Nodo 6] Puntos suficientes! Marcando actividad como completada...');
      print(
          '   Etapa: ${widget.etapa}, Sección: ${widget.seccion}, Actividad: ${widget.actividad}');
      ProgresoService().marcarActividadCompletada(
          widget.etapa, widget.seccion, widget.actividad, _puntos);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🏆 ¡Has completado los niveles de organización!'),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );
      print('✅ [Nodo 6] Actividad marcada como completada exitosamente');
    } else {
      print('⚠️ [Nodo 6] Puntos insuficientes: $_puntos/100');
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
            Tab(icon: Icon(Icons.layers), text: 'Pirámide'),
            Tab(icon: Icon(Icons.account_tree), text: 'Jerarquía'),
            Tab(icon: Icon(Icons.quiz), text: 'Test Final'),
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
          _PiramideEcologicaTab(onPuntosGanados: _agregarPuntos),
          _JerarquiaTab(onPuntosGanados: _agregarPuntos),
          _TestFinalTab(onPuntosGanados: _agregarPuntos),
        ],
      ),
    );
  }
}

// ============================================
// TAB 1: CONSTRUIR PIRÁMIDE ECOLÓGICA
// ============================================
class _PiramideEcologicaTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _PiramideEcologicaTab({required this.onPuntosGanados});

  @override
  __PiramideEcologicaTabState createState() => __PiramideEcologicaTabState();
}

class __PiramideEcologicaTabState extends State<_PiramideEcologicaTab> {
  Map<String, List<String>> _niveles = {
    'Productores': [],
    'Consumidores 1º': [],
    'Consumidores 2º': [],
    'Descomponedores': [],
  };

  List<Map<String, String>> _organismos = [
    {'nombre': '🌱 Pasto', 'nivel': 'Productores'},
    {'nombre': '🌳 Árbol', 'nivel': 'Productores'},
    {'nombre': '🌿 Algas', 'nivel': 'Productores'},
    {'nombre': '🦌 Venado', 'nivel': 'Consumidores 1º'},
    {'nombre': '🐰 Conejo', 'nivel': 'Consumidores 1º'},
    {'nombre': '🦒 Jirafa', 'nivel': 'Consumidores 1º'},
    {'nombre': '🦁 León', 'nivel': 'Consumidores 2º'},
    {'nombre': '🐍 Serpiente', 'nivel': 'Consumidores 2º'},
    {'nombre': '🦅 Águila', 'nivel': 'Consumidores 2º'},
    {'nombre': '🍄 Hongos', 'nivel': 'Descomponedores'},
    {'nombre': '🦠 Bacterias', 'nivel': 'Descomponedores'},
  ];

  List<Map<String, String>> _organismosDisponibles = [];
  bool _juegoTerminado = false;
  bool _mostrarAyuda = true;

  @override
  void initState() {
    super.initState();
    _organismosDisponibles = List.from(_organismos)..shuffle();
  }

  void _verificarPiramide() {
    int correctos = 0;
    int total = 0;

    _niveles.forEach((nivel, organismos) {
      organismos.forEach((organismo) {
        total++;
        final correcto =
            _organismos.firstWhere((o) => o['nombre'] == organismo)['nivel'] ==
                nivel;
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
        title: Row(
          children: [
            Icon(
              correctos == total ? Icons.emoji_events : Icons.star,
              color: correctos == total ? Colors.amber : Colors.blue,
              size: 32,
            ),
            SizedBox(width: 10),
            Text(correctos == total ? '¡Perfecto!' : 'Buen intento'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$correctos de $total correctos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (correctos == total)
              Text(
                '¡Construiste una pirámide ecológica perfecta!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
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
      _niveles = {
        'Productores': [],
        'Consumidores 1º': [],
        'Consumidores 2º': [],
        'Descomponedores': [],
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
            'Construye la Pirámide Ecológica',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          // Ayuda
          if (_mostrarAyuda)
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'Guía de la Pirámide',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() {
                            _mostrarAyuda = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('• Productores: Plantas que hacen fotosíntesis'),
                  Text('• Consumidores 1º: Herbívoros que comen plantas'),
                  Text('• Consumidores 2º: Carnívoros que comen herbívoros'),
                  Text('• Descomponedores: Descomponen materia orgánica'),
                ],
              ),
            ),
          if (!_mostrarAyuda)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _mostrarAyuda = true;
                });
              },
              icon: Icon(Icons.help_outline),
              label: Text('Mostrar ayuda'),
            ),
          SizedBox(height: 20),
          // Organismos disponibles
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  'Organismos disponibles:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _organismosDisponibles.map((organismo) {
                    return Draggable<String>(
                      data: organismo['nombre']!,
                      feedback: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.purpleAccent],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            organismo['nombre']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
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
                        label: Text(
                          organismo['nombre']!,
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.purple[100],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Pirámide - Niveles
          ..._buildPiramideNiveles(),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _organismosDisponibles.isEmpty && !_juegoTerminado
                ? _verificarPiramide
                : null,
            icon: Icon(Icons.check_circle_outline, size: 28),
            label: Text('Verificar Pirámide'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPiramideNiveles() {
    final orden = [
      'Consumidores 2º',
      'Consumidores 1º',
      'Productores',
      'Descomponedores'
    ];
    final colores = {
      'Consumidores 2º': Colors.red,
      'Consumidores 1º': Colors.orange,
      'Productores': Colors.green,
      'Descomponedores': Colors.brown,
    };

    return orden.map((nivel) {
      final color = colores[nivel]!;
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: DragTarget<String>(
          onAccept: (organismo) {
            setState(() {
              _niveles[nivel]!.add(organismo);
              _organismosDisponibles
                  .removeWhere((o) => o['nombre'] == organismo);
            });
          },
          builder: (context, candidateData, rejectedData) {
            final anchoPiramide = nivel == 'Consumidores 2º'
                ? 0.5
                : nivel == 'Consumidores 1º'
                    ? 0.7
                    : nivel == 'Productores'
                        ? 1.0
                        : 0.6;

            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * anchoPiramide,
                constraints: BoxConstraints(minHeight: 90),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: candidateData.isNotEmpty
                      ? color.withOpacity(0.4)
                      : color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: candidateData.isNotEmpty
                        ? color
                        : color.withOpacity(0.5),
                    width: candidateData.isNotEmpty ? 4 : 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      nivel,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (_niveles[nivel]!.isNotEmpty) SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: _niveles[nivel]!.map((organismo) {
                        final esCorrecta = _juegoTerminado &&
                            _organismos.firstWhere(
                                    (o) => o['nombre'] == organismo)['nivel'] ==
                                nivel;
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
                                    _niveles[nivel]!.remove(organismo);
                                    _organismosDisponibles.add(
                                        _organismos.firstWhere(
                                            (o) => o['nombre'] == organismo));
                                  });
                                },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

// ============================================
// TAB 2: JERARQUÍA DE NIVELES
// ============================================
class _JerarquiaTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _JerarquiaTab({required this.onPuntosGanados});

  @override
  __JerarquiaTabState createState() => __JerarquiaTabState();
}

class __JerarquiaTabState extends State<_JerarquiaTab> {
  final List<Map<String, String>> _niveles = [
    {'nombre': 'Organismo', 'ejemplo': 'Una hormiga'},
    {'nombre': 'Población', 'ejemplo': 'Todas las hormigas del hormiguero'},
    {'nombre': 'Comunidad', 'ejemplo': 'Hormigas + plantas + otros animales'},
    {'nombre': 'Ecosistema', 'ejemplo': 'Comunidad + factores abióticos'},
    {'nombre': 'Biosfera', 'ejemplo': 'Todos los ecosistemas del planeta'},
  ];

  List<Map<String, String>> _nivelesDesordenados = [];
  List<Map<String, String>> _respuestaUsuario = [];
  bool _mostrarResultados = false;

  @override
  void initState() {
    super.initState();
    _nivelesDesordenados = List.from(_niveles)..shuffle();
  }

  void _agregarNivel(Map<String, String> nivel) {
    if (_mostrarResultados) return;
    setState(() {
      _respuestaUsuario.add(nivel);
      _nivelesDesordenados.remove(nivel);
    });
  }

  void _removerNivel(Map<String, String> nivel) {
    if (_mostrarResultados) return;
    setState(() {
      _respuestaUsuario.remove(nivel);
      _nivelesDesordenados.add(nivel);
    });
  }

  void _verificarOrden() {
    int correctos = 0;
    for (int i = 0; i < _respuestaUsuario.length; i++) {
      if (i < _niveles.length &&
          _respuestaUsuario[i]['nombre'] == _niveles[i]['nombre']) {
        correctos++;
      }
    }

    setState(() {
      _mostrarResultados = true;
    });

    final puntos = (correctos * 12).toInt();
    widget.onPuntosGanados(puntos);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(correctos == _niveles.length ? '¡Excelente!' : 'Buen intento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              correctos == _niveles.length
                  ? Icons.emoji_events
                  : Icons.lightbulb,
              size: 60,
              color:
                  correctos == _niveles.length ? Colors.amber : Colors.orange,
            ),
            SizedBox(height: 10),
            Text(
              '$correctos de ${_niveles.length} en orden correcto',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
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
      _nivelesDesordenados = List.from(_niveles)..shuffle();
      _respuestaUsuario.clear();
      _mostrarResultados = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Ordena los niveles de organización',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Del más simple al más complejo',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          // Niveles disponibles
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'Toca para agregar',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _nivelesDesordenados.map((nivel) {
                    return GestureDetector(
                      onTap: () => _agregarNivel(nivel),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.purple, width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(
                              nivel['nombre']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              nivel['ejemplo']!,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Jerarquía construida
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      'Tu orden (más simple → más complejo)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                if (_respuestaUsuario.isEmpty)
                  Text(
                    'Agrega los niveles aquí',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                else
                  Column(
                    children: _respuestaUsuario.asMap().entries.map((entry) {
                      final index = entry.key;
                      final nivel = entry.value;
                      final esCorrecta = _mostrarResultados &&
                          index < _niveles.length &&
                          nivel['nombre'] == _niveles[index]['nombre'];

                      return GestureDetector(
                        onTap: () => _removerNivel(nivel),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _mostrarResultados
                                ? (esCorrecta
                                    ? Colors.green[200]
                                    : Colors.red[200])
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _mostrarResultados
                                  ? (esCorrecta ? Colors.green : Colors.red)
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: _mostrarResultados
                                      ? (esCorrecta ? Colors.green : Colors.red)
                                      : Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nivel['nombre']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      nivel['ejemplo']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_mostrarResultados)
                                Icon(
                                  esCorrecta
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: esCorrecta ? Colors.green : Colors.red,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _respuestaUsuario.length == _niveles.length &&
                        !_mostrarResultados
                    ? _verificarOrden
                    : null,
                icon: Icon(Icons.check_circle, size: 24),
                label: Text('Verificar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              if (_mostrarResultados)
                ElevatedButton.icon(
                  onPressed: _reiniciar,
                  icon: Icon(Icons.replay, size: 24),
                  label: Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
// TAB 3: TEST FINAL CRONOMETRADO
// ============================================
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
  int _tiempoRestante = 90; // 90 segundos
  Timer? _timer;

  final List<Map<String, dynamic>> _preguntas = [
    {
      'pregunta': '¿Qué es una población?',
      'opciones': [
        'Un solo organismo',
        'Organismos de la misma especie en un área',
        'Diferentes especies juntas',
        'Toda la vida en la Tierra'
      ],
      'correcta': 1,
    },
    {
      'pregunta': 'Una comunidad ecológica incluye:',
      'opciones': [
        'Solo plantas',
        'Solo animales',
        'Todas las poblaciones que interact\u00faan',
        'Factores abióticos'
      ],
      'correcta': 2,
    },
    {
      'pregunta': '¿Qué es la biosfera?',
      'opciones': [
        'Un ecosistema pequeño',
        'Una comunidad de plantas',
        'Toda la zona de la Tierra con vida',
        'Solo los océanos'
      ],
      'correcta': 2,
    },
    {
      'pregunta': 'Un ecosistema incluye:',
      'opciones': [
        'Solo seres vivos',
        'Seres vivos + factores abióticos',
        'Solo el agua y suelo',
        'Solo plantas y animales'
      ],
      'correcta': 1,
    },
    {
      'pregunta': '¿Qué nivel es más pequeño?',
      'opciones': ['Ecosistema', 'Comunidad', 'Población', 'Organismo'],
      'correcta': 3,
    },
    {
      'pregunta': '¿Qué nivel es más grande?',
      'opciones': ['Población', 'Comunidad', 'Ecosistema', 'Biosfera'],
      'correcta': 3,
    },
    {
      'pregunta': 'Los factores abióticos son parte de:',
      'opciones': ['Población', 'Comunidad', 'Ecosistema', 'Ninguno'],
      'correcta': 2,
    },
    {
      'pregunta': 'Ejemplo de población:',
      'opciones': [
        'Todos los árboles de un bosque',
        'Un bosque completo',
        'El planeta Tierra',
        'Un árbol'
      ],
      'correcta': 0,
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
      _tiempoRestante = 90;
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

    final puntos = (_respuestasCorrectas * 8).toInt();
    widget.onPuntosGanados(puntos);
  }

  @override
  Widget build(BuildContext context) {
    if (!_juegoIniciado) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 100, color: Colors.deepOrange),
            SizedBox(height: 30),
            Text(
              'Test Final',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              '8 preguntas en 90 segundos',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _iniciarJuego,
              icon: Icon(Icons.play_arrow, size: 32),
              label: Text('Comenzar Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
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
              _respuestasCorrectas >= 6
                  ? '¡Sobresaliente!'
                  : 'Sigue practicando',
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
                backgroundColor: Colors.deepOrange,
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
          // Temporizador
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _tiempoRestante <= 20
                    ? [Colors.red[400]!, Colors.red[200]!]
                    : [Colors.blue[400]!, Colors.blue[200]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_tiempoRestante <= 20 ? Colors.red : Colors.blue)
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
          // Progreso
          Text(
            'Pregunta ${_preguntaActual + 1} de ${_preguntas.length}',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_preguntaActual + 1) / _preguntas.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
            minHeight: 10,
          ),
          SizedBox(height: 35),
          // Pregunta
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepOrange[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepOrange, width: 3),
            ),
            child: Text(
              pregunta['pregunta'] as String,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[900],
              ),
              textAlign: TextAlign.center,
            ),
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
                      padding: EdgeInsets.all(22),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.deepOrange, width: 2),
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
