import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:green_cloud/services/progreso_service.dart';

// Widget de Temporizador Reutilizable
class GameTimer extends StatelessWidget {
  final int timeLeft;
  final int totalTime;

  const GameTimer({
    Key? key,
    required this.timeLeft,
    required this.totalTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = timeLeft / totalTime;
    Color color = progress > 0.5
        ? Colors.green
        : progress > 0.2
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: color),
          SizedBox(width: 10),
          Text(
            '$timeLeft s',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 15),
          Container(
            width: 100,
            height: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class _MinijuegoNodo3ScreenState extends State<MinijuegoNodo3Screen> {
  int _currentLevel = 0;
  int _score = 0;
  final int _totalLevels = 7;

  void _nextLevel(int scoreToAdd) {
    setState(() {
      _score += scoreToAdd;
      if (_currentLevel < _totalLevels - 1) {
        _currentLevel++;
      } else {
        _showVictoryDialog();
      }
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            SizedBox(height: 20),
            Text('Has completado todos los desafíos de Materiales.'),
            Text('Puntaje Final: $_score',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Guardar progreso
              await ProgresoService().marcarActividadCompletada(
                  widget.etapa, widget.seccion, widget.actividad, _score);

              if (mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              }
            },
            child: Text('Terminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[300]!, Colors.blueGrey[800]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Nivel ${_currentLevel + 1}/$_totalLevels',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Puntos: $_score',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildCurrentLevel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLevel() {
    switch (_currentLevel) {
      case 0:
        return Juego1ClasificaMateriales(onCompleted: _nextLevel);
      case 1:
        return Juego2Propiedades(onCompleted: _nextLevel);
      case 2:
        return Juego3Reciclaje(onCompleted: _nextLevel);
      case 3:
        return Juego4EstadosMateria(onCompleted: _nextLevel);
      case 4:
        return Juego5OrigenMaterial(onCompleted: _nextLevel);
      case 5:
        return Juego6Construccion(onCompleted: _nextLevel);
      case 6:
        return Juego7QuizMateriales(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Clasifica Materiales (MEJORADO) ---
class Juego1ClasificaMateriales extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1ClasificaMateriales({required this.onCompleted});

  @override
  _Juego1ClasificaMaterialesState createState() =>
      _Juego1ClasificaMaterialesState();
}

class _Juego1ClasificaMaterialesState extends State<Juego1ClasificaMateriales> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Madera', 'type': 'Natural', 'icon': Icons.park},
    {'name': 'Plástico', 'type': 'Artificial', 'icon': Icons.shopping_bag},
    {'name': 'Lana', 'type': 'Natural', 'icon': Icons.checkroom},
    {'name': 'Vidrio', 'type': 'Artificial', 'icon': Icons.wine_bar},
  ];
  int _currentIndex = 0;
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkAnswer(String type) {
    if (_items[_currentIndex]['type'] == type) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _items.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        widget.onCompleted(100 + _timeLeft);
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _timeLeft = max(0, _timeLeft - 5);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Incorrecto -5s'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 30),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Natural o Artificial?',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 20),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_items[_currentIndex]['icon'],
                        size: 60, color: Colors.blueGrey),
                    Text(_items[_currentIndex]['name'],
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Natural'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: Text('Natural', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Artificial'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: Text('Artificial', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- JUEGO 2: Propiedades (MEJORADO) ---
class Juego2Propiedades extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2Propiedades({required this.onCompleted});

  @override
  _Juego2PropiedadesState createState() => _Juego2PropiedadesState();
}

class _Juego2PropiedadesState extends State<Juego2Propiedades> {
  int _timeLeft = 60;
  Timer? _timer;
  int _currentLevel = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _levels = [
    {
      'property': 'DURO',
      'instruction': 'Toca los objetos DUROS',
      'objects': [
        {'name': 'Roca', 'icon': Icons.landscape, 'isCorrect': true},
        {'name': 'Almohada', 'icon': Icons.cloud, 'isCorrect': false},
        {'name': 'Martillo', 'icon': Icons.build, 'isCorrect': true},
        {'name': 'Peluche', 'icon': Icons.pets, 'isCorrect': false},
      ]
    },
    {
      'property': 'SUAVE',
      'instruction': 'Toca los objetos SUAVES',
      'objects': [
        {'name': 'Algodón', 'icon': Icons.cloud_queue, 'isCorrect': true},
        {'name': 'Ladrillo', 'icon': Icons.house, 'isCorrect': false},
        {'name': 'Pluma', 'icon': Icons.edit, 'isCorrect': true},
        {'name': 'Mesa', 'icon': Icons.table_restaurant, 'isCorrect': false},
      ]
    },
    {
      'property': 'FLEXIBLE',
      'instruction': 'Toca los objetos FLEXIBLES',
      'objects': [
        {'name': 'Goma', 'icon': Icons.circle_outlined, 'isCorrect': true},
        {'name': 'Vaso', 'icon': Icons.local_drink, 'isCorrect': false},
        {'name': 'Manguera', 'icon': Icons.gesture, 'isCorrect': true},
        {'name': 'Lápiz', 'icon': Icons.edit, 'isCorrect': false},
      ]
    },
    {
      'property': 'TRANSPARENTE',
      'instruction': 'Toca los objetos TRANSPARENTES',
      'objects': [
        {'name': 'Ventana', 'icon': Icons.window, 'isCorrect': true},
        {'name': 'Libro', 'icon': Icons.book, 'isCorrect': false},
        {
          'name': 'Vaso de Vidrio',
          'icon': Icons.local_drink,
          'isCorrect': true
        },
        {'name': 'Puerta', 'icon': Icons.door_front_door, 'isCorrect': false},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(_score);
        }
      });
    });
  }

  void _checkAnswer(bool isCorrect) {
    if (isCorrect) {
      HapticFeedback.lightImpact();
      setState(() {
        _score += 10;
        if (_score > 100) _score = 100;

        if (_currentLevel < _levels.length - 1) {
          _currentLevel++;
        } else {
          _timer?.cancel();
          widget.onCompleted(_score);
        }
      });
    } else {
      HapticFeedback.heavyImpact();
      if (_timeLeft > 5) _timeLeft -= 5;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Inténtalo de nuevo! -5 segundos'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = _levels[_currentLevel];
    final objects = level['objects'] as List<Map<String, dynamic>>;

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 60),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            level['instruction'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: objects.length,
            itemBuilder: (context, index) {
              final obj = objects[index];
              return GestureDetector(
                onTap: () => _checkAnswer(obj['isCorrect']),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        obj['icon'],
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        obj['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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

// --- JUEGO 3: Reciclaje (MEJORADO) ---
class Juego3Reciclaje extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3Reciclaje({required this.onCompleted});

  @override
  _Juego3ReciclajeState createState() => _Juego3ReciclajeState();
}

class _Juego3ReciclajeState extends State<Juego3Reciclaje> {
  final List<Map<String, dynamic>> _trash = [
    {'name': 'Botella', 'type': 'Plástico', 'icon': Icons.local_drink},
    {'name': 'Periódico', 'type': 'Papel', 'icon': Icons.article},
    {'name': 'Vaso', 'type': 'Vidrio', 'icon': Icons.wine_bar},
  ];
  int _timeLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 45),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _trash.map((item) {
                    return Draggable<String>(
                      data: item['type'],
                      feedback:
                          Icon(item['icon'], size: 50, color: Colors.white),
                      childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: Icon(item['icon'],
                              size: 50, color: Colors.white)),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(item['icon'], size: 40, color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBin('Plástico', Colors.yellow),
                  _buildBin('Papel', Colors.blue),
                  _buildBin('Vidrio', Colors.green),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBin(String type, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 100,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text(type, style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
      onAccept: (data) {
        if (data == type) {
          HapticFeedback.lightImpact();
          setState(() {
            _trash.removeWhere((item) =>
                item['type'] == type); // Remove first match logic simplified
            if (_trash.isEmpty) {
              // Logic needs refinement for real list removal
              _timer?.cancel();
              widget.onCompleted(100 + _timeLeft);
            }
          });
        } else {
          HapticFeedback.heavyImpact();
          setState(() {
            _timeLeft = max(0, _timeLeft - 5);
          });
        }
      },
    );
  }
}

// --- JUEGO 4: Estados de la Materia (MEJORADO) ---
class Juego4EstadosMateria extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4EstadosMateria({required this.onCompleted});

  @override
  _Juego4EstadosMateriaState createState() => _Juego4EstadosMateriaState();
}

class _Juego4EstadosMateriaState extends State<Juego4EstadosMateria> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Hielo', 'state': 'Sólido', 'icon': Icons.ac_unit},
    {'name': 'Agua', 'state': 'Líquido', 'icon': Icons.water_drop},
    {'name': 'Vapor', 'state': 'Gaseoso', 'icon': Icons.cloud},
    {'name': 'Roca', 'state': 'Sólido', 'icon': Icons.landscape},
    {'name': 'Jugo', 'state': 'Líquido', 'icon': Icons.local_drink},
    {'name': 'Aire', 'state': 'Gaseoso', 'icon': Icons.air},
  ];

  int _currentIndex = 0;
  int _timeLeft = 40;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkAnswer(String selectedState) {
    if (_items[_currentIndex]['state'] == selectedState) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _items.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        widget.onCompleted(100 + _timeLeft);
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _timeLeft = max(0, _timeLeft - 5);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrecto -5s'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿En qué estado está?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Icon(_items[_currentIndex]['icon'],
                        size: 60, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(_items[_currentIndex]['name'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionBtn('Sólido', Colors.brown),
                  _buildOptionBtn('Líquido', Colors.blue),
                  _buildOptionBtn('Gaseoso', Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionBtn(String text, Color color) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}

// --- JUEGO 5: Origen de los Materiales (MEJORADO) ---
class Juego5OrigenMaterial extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5OrigenMaterial({required this.onCompleted});

  @override
  _Juego5OrigenMaterialState createState() => _Juego5OrigenMaterialState();
}

class _Juego5OrigenMaterialState extends State<Juego5OrigenMaterial> {
  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Mesa de Madera',
      'origin': 'Vegetal',
      'icon': Icons.table_restaurant
    },
    {'name': 'Chompa de Lana', 'origin': 'Animal', 'icon': Icons.checkroom},
    {
      'name': 'Anillo de Oro',
      'origin': 'Mineral',
      'icon': Icons.circle_outlined
    },
    {'name': 'Papel', 'origin': 'Vegetal', 'icon': Icons.article},
    {'name': 'Cuero', 'origin': 'Animal', 'icon': Icons.shopping_bag},
  ];

  int _currentIndex = 0;
  int _timeLeft = 40;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkAnswer(String origin) {
    if (_items[_currentIndex]['origin'] == origin) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _items.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        widget.onCompleted(100 + _timeLeft);
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _timeLeft = max(0, _timeLeft - 5);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrecto -5s'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Cuál es su origen?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(_items[_currentIndex]['icon'],
                        size: 70, color: Colors.green[800]),
                    SizedBox(height: 10),
                    Text(_items[_currentIndex]['name'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionBtn('Vegetal', Icons.grass, Colors.green),
                  _buildOptionBtn('Animal', Icons.pets, Colors.orange),
                  _buildOptionBtn('Mineral', Icons.terrain, Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionBtn(String text, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30),
          SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// --- JUEGO 6: Construcción (MEJORADO) ---
class Juego6Construccion extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6Construccion({required this.onCompleted});

  @override
  _Juego6ConstruccionState createState() => _Juego6ConstruccionState();
}

class _Juego6ConstruccionState extends State<Juego6Construccion> {
  final List<Map<String, dynamic>> _challenges = [
    {
      'task': 'Necesito ver a través de la pared.',
      'target': 'Ventana',
      'options': ['Madera', 'Vidrio', 'Ladrillo'],
      'correct': 'Vidrio',
      'icon': Icons.window
    },
    {
      'task': 'Necesito algo suave para dormir.',
      'target': 'Almohada',
      'options': ['Roca', 'Algodón', 'Metal'],
      'correct': 'Algodón',
      'icon': Icons.bed
    },
    {
      'task': 'Necesito algo fuerte para una llave.',
      'target': 'Llave',
      'options': ['Papel', 'Plástico', 'Metal'],
      'correct': 'Metal',
      'icon': Icons.vpn_key
    },
  ];

  int _currentIndex = 0;
  int _timeLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkAnswer(String material) {
    if (_challenges[_currentIndex]['correct'] == material) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _challenges.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        widget.onCompleted(100 + _timeLeft);
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _timeLeft = max(0, _timeLeft - 5);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ese material no sirve aquí'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 45),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¡Elige el material correcto!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(_challenges[_currentIndex]['icon'],
                          size: 60, color: Colors.blueGrey),
                      SizedBox(height: 10),
                      Text(_challenges[_currentIndex]['task'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children:
                      (_challenges[_currentIndex]['options'] as List<String>)
                          .map((option) {
                    return ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      ),
                      child: Text(option, style: TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- JUEGO 7: Quiz Materiales (MEJORADO) ---
class Juego7QuizMateriales extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7QuizMateriales({required this.onCompleted});

  @override
  _Juego7QuizMaterialesState createState() => _Juego7QuizMaterialesState();
}

class _Juego7QuizMaterialesState extends State<Juego7QuizMateriales> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué material es transparente?',
      'answers': ['Madera', 'Vidrio', 'Metal'],
      'correct': 1
    },
    {
      'question': '¿De dónde viene el papel?',
      'answers': ['Árboles', 'Rocas', 'Animales'],
      'correct': 0
    },
    {
      'question': '¿Qué material es duro?',
      'answers': ['Algodón', 'Piedra', 'Agua'],
      'correct': 1
    },
  ];

  int _currentQuestion = 0;
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _answerQuestion(int index) {
    if (index == _questions[_currentQuestion]['correct']) {
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _timeLeft += 10;
        });
      } else {
        _timer?.cancel();
        widget.onCompleted(200 + _timeLeft);
      }
    } else {
      setState(() {
        _timeLeft = max(0, _timeLeft - 10);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Incorrecto -10s'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 60),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _questions[_currentQuestion]['question'],
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                ...List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _answerQuestion(index),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueGrey[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          _questions[_currentQuestion]['answers'][index],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
