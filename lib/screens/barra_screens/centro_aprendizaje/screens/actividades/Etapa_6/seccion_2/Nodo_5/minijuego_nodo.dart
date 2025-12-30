import 'package:flutter/material.dart';
import 'package:green_cloud/services/progreso_service.dart';
// import 'dart:async';

class MinijuegoNodo5Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo5Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo5ScreenState createState() => _MinijuegoNodo5ScreenState();
}

class _MinijuegoNodo5ScreenState extends State<MinijuegoNodo5Screen>
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
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 1),
      ),
    );
    _verificarCompletado();
  }

  void _verificarCompletado() {
    print('🔍 [Nodo 5] Verificando completado: Puntos actuales = $_puntos');
    if (_puntos >= 100) {
      print(
          '✅ [Nodo 5] Puntos suficientes! Marcando actividad como completada...');
      print(
          '   Etapa: ${widget.etapa}, Sección: ${widget.seccion}, Actividad: ${widget.actividad}');
      ProgresoService().marcarActividadCompletada(
          widget.etapa, widget.seccion, widget.actividad, _puntos);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 ¡Dominas los factores bióticos y abióticos!'),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );
      print('✅ [Nodo 5] Actividad marcada como completada exitosamente');
    } else {
      print('⚠️ [Nodo 5] Puntos insuficientes: $_puntos/100');
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
            Tab(icon: Icon(Icons.category), text: 'Clasificar'),
            Tab(icon: Icon(Icons.swap_horiz), text: 'Relacionar'),
            Tab(icon: Icon(Icons.science), text: 'Identificar'),
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
          _ClasificarTab(onPuntosGanados: _agregarPuntos),
          _RelacionarTab(onPuntosGanados: _agregarPuntos),
          _IdentificarTab(onPuntosGanados: _agregarPuntos),
        ],
      ),
    );
  }
}

// ============================================
// TAB 1: CLASIFICAR FACTORES
// ============================================
class _ClasificarTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _ClasificarTab({required this.onPuntosGanados});

  @override
  __ClasificarTabState createState() => __ClasificarTabState();
}

class __ClasificarTabState extends State<_ClasificarTab> {
  Map<String, List<String>> _categorias = {
    'Biótico': [],
    'Abiótico': [],
  };

  List<Map<String, String>> _factores = [
    {'nombre': 'Agua', 'tipo': 'Abiótico'},
    {'nombre': 'Plantas', 'tipo': 'Biótico'},
    {'nombre': 'Luz solar', 'tipo': 'Abiótico'},
    {'nombre': 'Animales', 'tipo': 'Biótico'},
    {'nombre': 'Temperatura', 'tipo': 'Abiótico'},
    {'nombre': 'Hongos', 'tipo': 'Biótico'},
    {'nombre': 'Suelo', 'tipo': 'Abiótico'},
    {'nombre': 'Bacterias', 'tipo': 'Biótico'},
    {'nombre': 'Viento', 'tipo': 'Abiótico'},
    {'nombre': 'Insectos', 'tipo': 'Biótico'},
    {'nombre': 'Humedad', 'tipo': 'Abiótico'},
    {'nombre': 'Algas', 'tipo': 'Biótico'},
  ];

  List<Map<String, String>> _factoresDisponibles = [];
  bool _juegoTerminado = false;

  @override
  void initState() {
    super.initState();
    _factoresDisponibles = List.from(_factores)..shuffle();
  }

  void _verificarClasificacion() {
    int correctos = 0;
    int total = 0;

    _categorias.forEach((categoria, factores) {
      factores.forEach((factor) {
        total++;
        final correcto =
            _factores.firstWhere((f) => f['nombre'] == factor)['tipo'] ==
                categoria;
        if (correcto) correctos++;
      });
    });

    setState(() {
      _juegoTerminado = true;
    });

    final puntos = (correctos * 4).toInt();
    widget.onPuntosGanados(puntos);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(correctos == total ? '¡Perfecto!' : 'Buen intento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              correctos == total ? Icons.emoji_events : Icons.star,
              size: 60,
              color: correctos == total ? Colors.amber : Colors.blue,
            ),
            SizedBox(height: 10),
            Text('$correctos de $total correctos',
                style: TextStyle(fontSize: 18)),
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
      _categorias = {
        'Biótico': [],
        'Abiótico': [],
      };
      _factoresDisponibles = List.from(_factores)..shuffle();
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
            'Arrastra cada factor a su categoría',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Biótico: Seres vivos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Abiótico: Elementos sin vida',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Factores disponibles
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _factoresDisponibles.map((factor) {
              return Draggable<String>(
                data: factor['nombre']!,
                feedback: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      factor['nombre']!,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Chip(
                    label: Text(factor['nombre']!),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                child: Chip(
                  label: Text(factor['nombre']!,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.purple[100],
                  avatar: Icon(Icons.circle, size: 12, color: Colors.purple),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 30),
          // Categorías
          ..._categorias.keys.map((categoria) {
            final color = categoria == 'Biótico' ? Colors.green : Colors.blue;
            final icon = categoria == 'Biótico' ? Icons.pets : Icons.terrain;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: DragTarget<String>(
                onAccept: (factor) {
                  setState(() {
                    _categorias[categoria]!.add(factor);
                    _factoresDisponibles
                        .removeWhere((f) => f['nombre'] == factor);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 120),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          candidateData.isNotEmpty
                              ? color.withOpacity(0.4)
                              : color.withOpacity(0.15),
                          candidateData.isNotEmpty
                              ? color.withOpacity(0.2)
                              : color.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: candidateData.isNotEmpty
                            ? color
                            : color.withOpacity(0.5),
                        width: candidateData.isNotEmpty ? 4 : 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, color: color, size: 30),
                            SizedBox(width: 15),
                            Text(
                              categoria,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        if (_categorias[categoria]!.isNotEmpty)
                          SizedBox(height: 15),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categorias[categoria]!.map((factor) {
                            final esCorrecta = _juegoTerminado &&
                                _factores.firstWhere(
                                        (f) => f['nombre'] == factor)['tipo'] ==
                                    categoria;
                            return Chip(
                              label: Text(factor,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              backgroundColor: _juegoTerminado
                                  ? (esCorrecta
                                      ? Colors.green[200]
                                      : Colors.red[200])
                                  : color.withOpacity(0.3),
                              deleteIcon: _juegoTerminado
                                  ? (esCorrecta
                                      ? Icon(Icons.check)
                                      : Icon(Icons.close))
                                  : Icon(Icons.remove_circle_outline, size: 20),
                              onDeleted: _juegoTerminado
                                  ? null
                                  : () {
                                      setState(() {
                                        _categorias[categoria]!.remove(factor);
                                        _factoresDisponibles.add(
                                            _factores.firstWhere(
                                                (f) => f['nombre'] == factor));
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
            onPressed: _factoresDisponibles.isEmpty && !_juegoTerminado
                ? _verificarClasificacion
                : null,
            icon: Icon(Icons.check_circle_outline, size: 28),
            label: Text('Verificar Clasificación'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
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
}

// ============================================
// TAB 2: RELACIONAR FACTORES CON EJEMPLOS
// ============================================
class _RelacionarTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _RelacionarTab({required this.onPuntosGanados});

  @override
  __RelacionarTabState createState() => __RelacionarTabState();
}

class __RelacionarTabState extends State<_RelacionarTab> {
  final Map<String, String> _parejas = {
    'Productores': 'Plantas que realizan fotosíntesis',
    'Consumidores primarios': 'Animales herbívoros',
    'Consumidores secundarios': 'Animales carnívoros',
    'Descomponedores': 'Hongos y bacterias',
    'Luz solar': 'Fuente de energía para las plantas',
    'Agua': 'Esencial para todos los seres vivos',
  };

  Map<String, String?> _respuestas = {};
  List<String> _descripcionesDesordenadas = [];
  bool _mostrarResultados = false;

  @override
  void initState() {
    super.initState();
    _descripcionesDesordenadas = _parejas.values.toList()..shuffle();
  }

  void _verificarRespuestas() {
    int correctas = 0;
    _parejas.forEach((factor, descripcion) {
      if (_respuestas[factor] == descripcion) {
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
        content:
            Text('$correctas/${_parejas.length} correctas - +$puntos puntos'),
        backgroundColor: correctas >= 4 ? Colors.green : Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reiniciar() {
    setState(() {
      _respuestas.clear();
      _mostrarResultados = false;
      _descripcionesDesordenadas = _parejas.values.toList()..shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Relaciona cada concepto con su descripción',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ..._parejas.keys.map((factor) {
            final descripcionCorrecta = _parejas[factor]!;
            final respuestaUsuario = _respuestas[factor];
            final esCorrecta = respuestaUsuario == descripcionCorrecta;

            final Color colorBorde;
            final Color colorFondo;
            if (_mostrarResultados) {
              colorBorde = esCorrecta ? Colors.green : Colors.red;
              colorFondo = esCorrecta ? Colors.green[100]! : Colors.red[100]!;
            } else {
              colorBorde = Colors.teal;
              colorFondo = Colors.teal[50]!;
            }

            return Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colorFondo,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorBorde, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: colorBorde.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _mostrarResultados
                            ? (esCorrecta ? Icons.check_circle : Icons.cancel)
                            : Icons.label,
                        color: colorBorde,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          factor,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: colorBorde,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: respuestaUsuario,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorBorde, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 2),
                      ),
                    ),
                    hint: Text('Selecciona la descripción correcta'),
                    items: _descripcionesDesordenadas.map((descripcion) {
                      return DropdownMenuItem(
                        value: descripcion,
                        child: Text(
                          descripcion,
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: _mostrarResultados
                        ? null
                        : (valor) {
                            setState(() {
                              _respuestas[factor] = valor;
                            });
                          },
                  ),
                  if (_mostrarResultados && !esCorrecta)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Correcta: $descripcionCorrecta',
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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
// TAB 3: IDENTIFICAR FACTORES EN ESCENARIOS
// ============================================
class _IdentificarTab extends StatefulWidget {
  final Function(int) onPuntosGanados;
  const _IdentificarTab({required this.onPuntosGanados});

  @override
  __IdentificarTabState createState() => __IdentificarTabState();
}

class __IdentificarTabState extends State<_IdentificarTab> {
  int _escenarioActual = 0;
  Map<int, Set<String>> _selecciones = {};
  bool _mostrarResultados = false;

  final List<Map<String, dynamic>> _escenarios = [
    {
      'titulo': '🏞️ Bosque Tropical',
      'descripcion':
          'Un bosque con muchos árboles, animales diversos, mucha lluvia y temperatura cálida',
      'factores': [
        {'nombre': 'Árboles', 'tipo': 'Biótico', 'correcto': true},
        {'nombre': 'Animales', 'tipo': 'Biótico', 'correcto': true},
        {'nombre': 'Lluvia', 'tipo': 'Abiótico', 'correcto': true},
        {'nombre': 'Temperatura', 'tipo': 'Abiótico', 'correcto': true},
        {'nombre': 'Nieve', 'tipo': 'Abiótico', 'correcto': false},
        {'nombre': 'Peces', 'tipo': 'Biótico', 'correcto': false},
      ],
    },
    {
      'titulo': '🏜️ Desierto',
      'descripcion':
          'Un lugar con poca agua, cactus, escorpiones, mucho sol y temperaturas extremas',
      'factores': [
        {'nombre': 'Cactus', 'tipo': 'Biótico', 'correcto': true},
        {'nombre': 'Escorpiones', 'tipo': 'Biótico', 'correcto': true},
        {'nombre': 'Sol intenso', 'tipo': 'Abiótico', 'correcto': true},
        {'nombre': 'Poca agua', 'tipo': 'Abiótico', 'correcto': true},
        {'nombre': 'Mucha lluvia', 'tipo': 'Abiótico', 'correcto': false},
        {'nombre': 'Algas', 'tipo': 'Biótico', 'correcto': false},
      ],
    },
    {
      'titulo': '🌊 Arrecife de Coral',
      'descripcion':
          'Un ecosistema marino con corales, peces de colores, agua salada y luz solar',
      'factores': [
        {'nombre': 'Corales', 'tipo': 'Biótico', 'correcto': true},
        {'nombre': 'Peces', 'tipo': 'Biótico', 'correcto': true},
        {'nombre': 'Agua salada', 'tipo': 'Abiótico', 'correcto': true},
        {'nombre': 'Luz solar', 'tipo': 'Abiótico', 'correcto': true},
        {'nombre': 'Hielo', 'tipo': 'Abiótico', 'correcto': false},
        {'nombre': 'Cactus', 'tipo': 'Biótico', 'correcto': false},
      ],
    },
  ];

  void _seleccionarFactor(int indice) {
    if (_mostrarResultados) return;

    setState(() {
      if (_selecciones[_escenarioActual] == null) {
        _selecciones[_escenarioActual] = {};
      }

      final factorNombre =
          _escenarios[_escenarioActual]['factores'][indice]['nombre'];

      if (_selecciones[_escenarioActual]!.contains(factorNombre)) {
        _selecciones[_escenarioActual]!.remove(factorNombre);
      } else {
        _selecciones[_escenarioActual]!.add(factorNombre);
      }
    });
  }

  void _verificarSelecciones() {
    final escenario = _escenarios[_escenarioActual];
    final factoresCorrectos = (escenario['factores'] as List)
        .where((f) => f['correcto'] == true)
        .map((f) => f['nombre'] as String)
        .toSet();

    final seleccionUsuario = _selecciones[_escenarioActual] ?? {};
    final correctas = factoresCorrectos.intersection(seleccionUsuario).length;
    final total = factoresCorrectos.length;

    setState(() {
      _mostrarResultados = true;
    });

    final puntos = (correctas * 6).toInt();
    widget.onPuntosGanados(puntos);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(correctas == total ? '¡Perfecto!' : 'Buen intento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              correctas == total ? Icons.star : Icons.star_half,
              size: 60,
              color: correctas == total ? Colors.amber : Colors.blue,
            ),
            SizedBox(height: 10),
            Text('$correctas de $total correctos',
                style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          if (_escenarioActual < _escenarios.length - 1)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _escenarioActual++;
                  _mostrarResultados = false;
                });
              },
              child: Text('Siguiente Escenario'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_escenarioActual >= _escenarios.length - 1) {
                setState(() {
                  _escenarioActual = 0;
                  _mostrarResultados = false;
                });
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final escenario = _escenarios[_escenarioActual];
    final seleccionUsuario = _selecciones[_escenarioActual] ?? {};

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Identifica los factores presentes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Escenario ${_escenarioActual + 1} de ${_escenarios.length}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo[300]!, Colors.indigo[100]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  escenario['titulo'],
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  escenario['descripcion'],
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Selecciona todos los factores que encuentres:',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(
              (escenario['factores'] as List).length,
              (index) {
                final factor = escenario['factores'][index];
                final nombre = factor['nombre'] as String;
                // final tipo = factor['tipo'] as String;
                final correcto = factor['correcto'] as bool;
                final seleccionado = seleccionUsuario.contains(nombre);

                Color colorFondo;
                Color colorBorde;
                IconData icono;

                if (_mostrarResultados) {
                  if (correcto && seleccionado) {
                    colorFondo = Colors.green[200]!;
                    colorBorde = Colors.green;
                    icono = Icons.check_circle;
                  } else if (!correcto && seleccionado) {
                    colorFondo = Colors.red[200]!;
                    colorBorde = Colors.red;
                    icono = Icons.cancel;
                  } else if (correcto && !seleccionado) {
                    colorFondo = Colors.orange[200]!;
                    colorBorde = Colors.orange;
                    icono = Icons.info;
                  } else {
                    colorFondo = Colors.grey[300]!;
                    colorBorde = Colors.grey;
                    icono = Icons.circle_outlined;
                  }
                } else {
                  colorFondo =
                      seleccionado ? Colors.teal[200]! : Colors.grey[200]!;
                  colorBorde = seleccionado ? Colors.teal : Colors.grey;
                  icono =
                      seleccionado ? Icons.check_circle : Icons.circle_outlined;
                }

                return GestureDetector(
                  onTap: () => _seleccionarFactor(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorFondo,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: colorBorde, width: 3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icono, color: colorBorde, size: 22),
                        SizedBox(width: 8),
                        Text(
                          nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: colorBorde,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: seleccionUsuario.isNotEmpty && !_mostrarResultados
                ? _verificarSelecciones
                : null,
            icon: Icon(Icons.check_circle_outline, size: 28),
            label: Text('Verificar Selección'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
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
}
