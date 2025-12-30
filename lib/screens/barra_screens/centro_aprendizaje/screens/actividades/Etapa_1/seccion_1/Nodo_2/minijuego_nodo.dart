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

class _MinijuegoNodo2ScreenState extends State<MinijuegoNodo2Screen> {
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
            Text('Has completado todos los desafíos de Las Plantas.'),
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
            colors: [Colors.green[300]!, Colors.green[800]!],
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
                            color: Colors.green[800]),
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
        return Juego1ArmaPlanta(onCompleted: _nextLevel);
      case 1:
        return Juego2Fotosintesis(onCompleted: _nextLevel);
      case 2:
        return Juego3TiposHojas(onCompleted: _nextLevel);
      case 3:
        return Juego4CuidadoPlanta(onCompleted: _nextLevel);
      case 4:
        return Juego5FrutosSemillas(onCompleted: _nextLevel);
      case 5:
        return Juego6Polinizacion(onCompleted: _nextLevel);
      case 6:
        return Juego7QuizPlantas(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Arma la Planta (MEJORADO) ---
class Juego1ArmaPlanta extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1ArmaPlanta({required this.onCompleted});

  @override
  _Juego1ArmaPlantaState createState() => _Juego1ArmaPlantaState();
}

class _Juego1ArmaPlantaState extends State<Juego1ArmaPlanta> {
  final Map<String, bool> _placedParts = {
    'Flor': false,
    'Hojas': false,
    'Tallo': false,
    'Raíz': false,
  };

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Arrastra las partes de la planta',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        Expanded(
          child: Row(
            children: [
              // Plant Structure
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDropZone('Flor', Icons.local_florist, Colors.pink),
                    _buildDropZone('Hojas', Icons.eco, Colors.green),
                    _buildDropZone('Tallo', Icons.height, Colors.brown),
                    _buildDropZone('Raíz', Icons.grass, Colors.brown[800]!),
                  ],
                ),
              ),
              // Parts to Drag
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _placedParts.entries
                      .where((entry) => !entry.value)
                      .map((entry) => Draggable<String>(
                            data: entry.key,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Icon(_getIcon(entry.key),
                                  size: 50, color: Colors.white),
                            ),
                            childWhenDragging: Opacity(
                                opacity: 0.5,
                                child: Icon(_getIcon(entry.key),
                                    size: 50, color: Colors.white)),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(_getIcon(entry.key),
                                      size: 40, color: Colors.green[800]),
                                  Text(entry.key),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIcon(String part) {
    switch (part) {
      case 'Flor':
        return Icons.local_florist;
      case 'Hojas':
        return Icons.eco;
      case 'Tallo':
        return Icons.height;
      case 'Raíz':
        return Icons.grass;
      default:
        return Icons.error;
    }
  }

  Widget _buildDropZone(String part, IconData icon, Color color) {
    bool isPlaced = _placedParts[part]!;
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 80,
          width: 80,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isPlaced ? color : Colors.white.withOpacity(0.3),
            border: Border.all(
                color: Colors.white,
                style: isPlaced ? BorderStyle.solid : BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isPlaced
                ? Icon(icon, size: 40, color: Colors.white)
                : Text(part, style: TextStyle(color: Colors.white70)),
          ),
        );
      },
      onAccept: (data) {
        if (data == part) {
          setState(() {
            _placedParts[part] = true;
            HapticFeedback.lightImpact();
            if (_placedParts.values.every((v) => v)) {
              _timer?.cancel();
              widget.onCompleted(100 + _timeLeft);
            }
          });
        }
      },
    );
  }
}

// --- JUEGO 2: Fotosíntesis (MEJORADO) ---
class Juego2Fotosintesis extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2Fotosintesis({required this.onCompleted});

  @override
  _Juego2FotosintesisState createState() => _Juego2FotosintesisState();
}

class _Juego2FotosintesisState extends State<Juego2Fotosintesis> {
  final List<String> _needed = ['Sol', 'Agua', 'Aire'];
  final List<String> _options = [
    'Sol',
    'Agua',
    'Aire',
    'Fuego',
    'Piedra',
    'Plástico'
  ];
  List<String> _collected = [];
  int _timeLeft = 40;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _options.shuffle();
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
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('¿Qué necesita la planta para comer?',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.green[100],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_florist, size: 60, color: Colors.green),
              Text('${_collected.length}/3',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(20),
            children: _options.map((option) {
              bool isCollected = _collected.contains(option);
              return GestureDetector(
                onTap: isCollected
                    ? null
                    : () {
                        if (_needed.contains(option)) {
                          setState(() {
                            _collected.add(option);
                            HapticFeedback.mediumImpact();
                            if (_collected.length == 3) {
                              _timer?.cancel();
                              widget.onCompleted(100 + _timeLeft);
                            }
                          });
                        } else {
                          setState(() {
                            _timeLeft = max(0, _timeLeft - 5);
                            HapticFeedback.heavyImpact();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('¡Eso no! -5s'),
                              backgroundColor: Colors.red));
                        }
                      },
                child: Card(
                  color: isCollected ? Colors.grey : Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_getIcon(option), size: 40, color: Colors.blue),
                      Text(option),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'Sol':
        return Icons.wb_sunny;
      case 'Agua':
        return Icons.water_drop;
      case 'Aire':
        return Icons.air;
      case 'Fuego':
        return Icons.local_fire_department;
      case 'Piedra':
        return Icons.landscape;
      case 'Plástico':
        return Icons.shopping_bag;
      default:
        return Icons.help;
    }
  }
}

// --- JUEGO 3: Tipos de Hojas (MEJORADO) ---
class Juego3TiposHojas extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3TiposHojas({required this.onCompleted});

  @override
  _Juego3TiposHojasState createState() => _Juego3TiposHojasState();
}

class _Juego3TiposHojasState extends State<Juego3TiposHojas> {
  // Simplified matching game
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
          widget.onCompleted(50); // Auto complete for demo
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
        GameTimer(timeLeft: _timeLeft, totalTime: 30),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Selecciona la hoja con forma de corazón',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLeafOption(Icons.eco, false),
                    _buildLeafOption(Icons.favorite, true),
                    _buildLeafOption(Icons.grass, false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeafOption(IconData icon, bool isCorrect) {
    return GestureDetector(
      onTap: () {
        if (isCorrect) {
          _timer?.cancel();
          widget.onCompleted(100 + _timeLeft);
        } else {
          setState(() {
            _timeLeft = max(0, _timeLeft - 5);
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 50, color: Colors.green),
      ),
    );
  }
}

// --- JUEGO 4: Cuidado de la Planta (MEJORADO) ---
class Juego4CuidadoPlanta extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4CuidadoPlanta({required this.onCompleted});

  @override
  _Juego4CuidadoPlantaState createState() => _Juego4CuidadoPlantaState();
}

class _Juego4CuidadoPlantaState extends State<Juego4CuidadoPlanta> {
  double _hydration = 0.5;
  double _sunlight = 0.5;
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
          _hydration = max(0, _hydration - 0.05);
          _sunlight = max(0, _sunlight - 0.05);
        } else {
          _timer?.cancel();
          if (_hydration > 0.3 && _sunlight > 0.3) {
            widget.onCompleted(100);
          } else {
            // Fail
            widget.onCompleted(0); // Retry logic needed in real app
          }
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
        GameTimer(timeLeft: _timeLeft, totalTime: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('¡Mantén la planta viva!',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, color: Colors.blue, size: 40),
                  SizedBox(height: 10),
                  RotatedBox(
                    quarterTurns: -1,
                    child: Container(
                      width: 100,
                      height: 20,
                      alignment: Alignment.center,
                      child: LinearProgressIndicator(
                          value: _hydration,
                          backgroundColor: Colors.white,
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () =>
                          setState(() => _hydration = min(1, _hydration + 0.2)),
                      child: Text('Regar')),
                ],
              ),
              Icon(Icons.local_florist,
                  size: 150,
                  color: _hydration > 0.3 && _sunlight > 0.3
                      ? Colors.green
                      : Colors.brown),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
                  SizedBox(height: 10),
                  RotatedBox(
                    quarterTurns: -1,
                    child: Container(
                      width: 100,
                      height: 20,
                      alignment: Alignment.center,
                      child: LinearProgressIndicator(
                          value: _sunlight,
                          backgroundColor: Colors.white,
                          color: Colors.orange),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () =>
                          setState(() => _sunlight = min(1, _sunlight + 0.2)),
                      child: Text('Sol')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- JUEGO 5: Frutos y Semillas (MEJORADO) ---
class Juego5FrutosSemillas extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5FrutosSemillas({required this.onCompleted});

  @override
  _Juego5FrutosSemillasState createState() => _Juego5FrutosSemillasState();
}

class _Juego5FrutosSemillasState extends State<Juego5FrutosSemillas> {
  final Map<String, String> _items = {
    'Manzana': 'Fruto',
    'Frijol': 'Semilla',
    'Naranja': 'Fruto',
    'Maíz': 'Semilla',
    'Durazno': 'Fruto',
    'Lenteja': 'Semilla',
  };

  final Map<String, bool> _classified = {};
  int _score = 0;
  int _timeLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _items.keys.forEach((key) => _classified[key] = false);
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

  void _checkCompletion() {
    if (_classified.values.every((val) => val)) {
      _timer?.cancel();
      widget.onCompleted(100 + _timeLeft);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 45),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Clasifica: Frutos vs Semillas',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Row(
            children: [
              // Drop Zones
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDropZone('Fruto', Colors.orange, Icons.apple),
                    _buildDropZone('Semilla', Colors.brown, Icons.grain),
                  ],
                ),
              ),
              // Draggable Items
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _items.keys
                        .where((key) => !_classified[key]!)
                        .map((item) {
                      return Draggable<String>(
                        data: item,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildItemChip(item, true),
                        ),
                        childWhenDragging: Opacity(
                            opacity: 0.5, child: _buildItemChip(item, false)),
                        child: _buildItemChip(item, false),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemChip(String label, bool isFeedback) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isFeedback) BoxShadow(color: Colors.black26, blurRadius: 4)
        ],
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[800])),
    );
  }

  Widget _buildDropZone(String type, Color color, IconData icon) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(type,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        if (_items[data] == type) {
          setState(() {
            _classified[data] = true;
            _score += 10;
          });
          _checkCompletion();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('¡Incorrecto! Intenta de nuevo'),
                duration: Duration(milliseconds: 500),
                backgroundColor: Colors.red),
          );
          setState(() {
            _timeLeft = max(0, _timeLeft - 5);
          });
        }
      },
    );
  }
}

// --- JUEGO 6: Polinización (MEJORADO) ---
class Juego6Polinizacion extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6Polinizacion({required this.onCompleted});

  @override
  _Juego6PolinizacionState createState() => _Juego6PolinizacionState();
}

class _Juego6PolinizacionState extends State<Juego6Polinizacion> {
  int _timeLeft = 30;
  Timer? _timer;
  int _flowersPollinated = 0;
  final int _targetFlowers = 10;
  List<bool> _flowers =
      List.generate(12, (index) => false); // 12 possible flower spots

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

  void _pollinate(int index) {
    if (!_flowers[index]) {
      setState(() {
        _flowers[index] = true;
        _flowersPollinated++;
      });
      if (_flowersPollinated >= _targetFlowers) {
        _timer?.cancel();
        widget.onCompleted(100 + _timeLeft);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Poliniza las flores: $_flowersPollinated/$_targetFlowers',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Icon(Icons.bug_report, color: Colors.yellow, size: 30),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: _flowers.length,
            itemBuilder: (context, index) {
              bool isPollinated = _flowers[index];
              return GestureDetector(
                onTap: () => _pollinate(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5)
                    ],
                  ),
                  child: Icon(
                    isPollinated ? Icons.check_circle : Icons.local_florist,
                    size: 50,
                    color: isPollinated ? Colors.green : Colors.pink,
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

// --- JUEGO 7: Quiz Plantas (MEJORADO) ---
class Juego7QuizPlantas extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7QuizPlantas({required this.onCompleted});

  @override
  _Juego7QuizPlantasState createState() => _Juego7QuizPlantasState();
}

class _Juego7QuizPlantasState extends State<Juego7QuizPlantas> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Por dónde absorben agua las plantas?',
      'answers': ['Hojas', 'Raíz', 'Flores'],
      'correct': 1
    },
    {
      'question': '¿Qué necesitan para hacer fotosíntesis?',
      'answers': ['Sol', 'Luna', 'Estrellas'],
      'correct': 0
    },
    {
      'question': '¿Cuál es la parte reproductiva?',
      'answers': ['Tallo', 'Flor', 'Raíz'],
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
                          foregroundColor: Colors.green[800],
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
