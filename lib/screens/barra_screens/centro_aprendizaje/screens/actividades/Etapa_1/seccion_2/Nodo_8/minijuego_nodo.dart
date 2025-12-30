import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../../../../../../../../services/progreso_service.dart';

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

class MinijuegoNodo8Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo8Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo8ScreenState createState() => _MinijuegoNodo8ScreenState();
}

class _MinijuegoNodo8ScreenState extends State<MinijuegoNodo8Screen> {
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
            Text('Has completado todos los desafíos del Día y la Noche.'),
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
            colors: [Colors.indigo[300]!, Colors.indigo[900]!],
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
                            color: Colors.indigo[900]),
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
        return Juego1DiaNoche(onCompleted: _nextLevel);
      case 1:
        return Juego2SolLuna(onCompleted: _nextLevel);
      case 2:
        return Juego3Rutinas(onCompleted: _nextLevel);
      case 3:
        return Juego4Sombras(onCompleted: _nextLevel);
      case 4:
        return Juego5Estrellas(onCompleted: _nextLevel);
      case 5:
        return Juego6AnimalesNocturnos(onCompleted: _nextLevel);
      case 6:
        return Juego7QuizTiempo(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Día y Noche (MEJORADO) ---
class Juego1DiaNoche extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1DiaNoche({required this.onCompleted});

  @override
  _Juego1DiaNocheState createState() => _Juego1DiaNocheState();
}

class _Juego1DiaNocheState extends State<Juego1DiaNoche> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Sol', 'time': 'Día', 'icon': Icons.wb_sunny},
    {'name': 'Luna', 'time': 'Noche', 'icon': Icons.nightlight_round},
    {'name': 'Desayuno', 'time': 'Día', 'icon': Icons.free_breakfast},
    {'name': 'Dormir', 'time': 'Noche', 'icon': Icons.bed},
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

  void _checkAnswer(String time) {
    if (_items[_currentIndex]['time'] == time) {
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
              Text('¿Día o Noche?',
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
                        size: 60, color: Colors.indigo),
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
                    onPressed: () => _checkAnswer('Día'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: Text('Día', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Noche'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: Text('Noche', style: TextStyle(fontSize: 18)),
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

// --- JUEGO 2: Sol y Luna (MEJORADO) ---
class Juego2SolLuna extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2SolLuna({required this.onCompleted});

  @override
  _Juego2SolLunaState createState() => _Juego2SolLunaState();
}

class _Juego2SolLunaState extends State<Juego2SolLuna> {
  final List<Map<String, dynamic>> _items = [
    {'activity': 'Jugar', 'isDay': true, 'icon': Icons.sports_soccer},
    {'activity': 'Dormir', 'isDay': false, 'icon': Icons.bed},
    {'activity': 'Escuela', 'isDay': true, 'icon': Icons.school},
    {'activity': 'Cenar', 'isDay': false, 'icon': Icons.dinner_dining},
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

  void _checkAnswer(bool isDay) {
    if (_items[_currentIndex]['isDay'] == isDay) {
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
              Text('¿Sol o Luna?',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Icon(_items[_currentIndex]['icon'],
                        size: 60, color: Colors.indigo),
                    SizedBox(height: 10),
                    Text(_items[_currentIndex]['activity'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Icon(Icons.wb_sunny, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Icon(Icons.nightlight_round,
                        size: 40, color: Colors.white),
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

// --- JUEGO 3: Rutinas (MEJORADO) ---
class Juego3Rutinas extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3Rutinas({required this.onCompleted});

  @override
  _Juego3RutinasState createState() => _Juego3RutinasState();
}

class _Juego3RutinasState extends State<Juego3Rutinas> {
  final List<Map<String, dynamic>> _routines = [
    {'routine': 'Despertar', 'time': 'Mañana', 'icon': Icons.alarm},
    {'routine': 'Almorzar', 'time': 'Tarde', 'icon': Icons.restaurant},
    {'routine': 'Cenar', 'time': 'Noche', 'icon': Icons.dinner_dining},
    {'routine': 'Ir a la escuela', 'time': 'Mañana', 'icon': Icons.school},
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

  void _checkAnswer(String time) {
    if (_routines[_currentIndex]['time'] == time) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _routines.length - 1) {
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
              Text('¿Cuándo haces esto?',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Icon(_routines[_currentIndex]['icon'],
                        size: 60, color: Colors.indigo),
                    SizedBox(height: 10),
                    Text(_routines[_currentIndex]['routine'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Mañana'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent),
                    child: Text('Mañana'),
                  ),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Tarde'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700]),
                    child: Text('Tarde'),
                  ),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Noche'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: Text('Noche', style: TextStyle(color: Colors.white)),
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

// --- JUEGO 4: Sombras (MEJORADO) ---
class Juego4Sombras extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4Sombras({required this.onCompleted});

  @override
  _Juego4SombrasState createState() => _Juego4SombrasState();
}

class _Juego4SombrasState extends State<Juego4Sombras> {
  final List<Map<String, dynamic>> _objects = [
    {'object': 'Pared', 'hasShadow': true, 'icon': Icons.house},
    {'object': 'Vidrio', 'hasShadow': false, 'icon': Icons.window},
    {'object': 'Árbol', 'hasShadow': true, 'icon': Icons.park},
    {'object': 'Aire', 'hasShadow': false, 'icon': Icons.air},
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

  void _checkAnswer(bool hasShadow) {
    if (_objects[_currentIndex]['hasShadow'] == hasShadow) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _objects.length - 1) {
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
              Text('¿Hace sombra?',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Icon(_objects[_currentIndex]['icon'],
                        size: 60, color: Colors.black87),
                    SizedBox(height: 10),
                    Text(_objects[_currentIndex]['object'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Sí',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('No', style: TextStyle(fontSize: 20)),
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

// --- JUEGO 5: Estrellas (MEJORADO) ---
class Juego5Estrellas extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5Estrellas({required this.onCompleted});

  @override
  _Juego5EstrellasState createState() => _Juego5EstrellasState();
}

class _Juego5EstrellasState extends State<Juego5Estrellas> {
  int _starCount = 0;
  int _currentLevel = 0;
  int _timeLeft = 40;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateLevel();
    _startTimer();
  }

  void _generateLevel() {
    setState(() {
      _starCount = _random.nextInt(5) + 3; // 3 to 7 stars
    });
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

  void _checkAnswer(int answer) {
    if (answer == _starCount) {
      HapticFeedback.lightImpact();
      if (_currentLevel < 3) {
        _currentLevel++;
        _generateLevel();
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
              Text('¿Cuántas estrellas hay?',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 20),
              Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: List.generate(_starCount, (index) {
                    return Positioned(
                      left: _random.nextDouble() * 250,
                      top: _random.nextDouble() * 150,
                      child: Icon(Icons.star, color: Colors.yellow, size: 30),
                    );
                  }),
                ),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: List.generate(4, (index) {
                  int number = index + 3; // Options 3, 4, 5, 6... wait
                  // Better options generation
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(number +
                        (index > 1 ? 1 : 0)), // Just simple 3,4,5,6,7 range
                    // Actually let's just show 3, 4, 5, 6, 7, 8
                    child: Text(
                        '${number + (index > 1 ? 1 : 0)}'), // This logic is bad.
                  );
                }).take(0).toList(), // Clearing this logic
              ),
              // New buttons logic
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [3, 4, 5, 6, 7].map((number) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(number),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.indigoAccent,
                      ),
                      child: Text('$number', style: TextStyle(fontSize: 20)),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// --- JUEGO 6: Animales Nocturnos (MEJORADO) ---
class Juego6AnimalesNocturnos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6AnimalesNocturnos({required this.onCompleted});

  @override
  _Juego6AnimalesNocturnosState createState() =>
      _Juego6AnimalesNocturnosState();
}

class _Juego6AnimalesNocturnosState extends State<Juego6AnimalesNocturnos> {
  final List<Map<String, dynamic>> _animals = [
    {'animal': 'Búho', 'isNocturnal': true, 'icon': Icons.visibility},
    {'animal': 'Gallina', 'isNocturnal': false, 'icon': Icons.pets},
    {'animal': 'Murciélago', 'isNocturnal': true, 'icon': Icons.nights_stay},
    {'animal': 'Vaca', 'isNocturnal': false, 'icon': Icons.grass},
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

  void _checkAnswer(bool isNocturnal) {
    if (_animals[_currentIndex]['isNocturnal'] == isNocturnal) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _animals.length - 1) {
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
              Text('¿Es un animal nocturno?',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Icon(_animals[_currentIndex]['icon'],
                        size: 60, color: Colors.indigo),
                    SizedBox(height: 10),
                    Text(_animals[_currentIndex]['animal'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Sí', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('No', style: TextStyle(fontSize: 20)),
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

// --- JUEGO 7: Quiz Tiempo (MEJORADO) ---
class Juego7QuizTiempo extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7QuizTiempo({required this.onCompleted});

  @override
  _Juego7QuizTiempoState createState() => _Juego7QuizTiempoState();
}

class _Juego7QuizTiempoState extends State<Juego7QuizTiempo> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuándo sale el Sol?',
      'answers': ['Día', 'Noche', 'Nunca'],
      'correct': 0
    },
    {
      'question': '¿Cuándo vemos las estrellas?',
      'answers': ['Día', 'Noche', 'Tarde'],
      'correct': 1
    },
    {
      'question': '¿Qué hacemos de noche?',
      'answers': ['Ir al colegio', 'Dormir', 'Jugar en el parque'],
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
                          foregroundColor: Colors.indigo[800],
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
