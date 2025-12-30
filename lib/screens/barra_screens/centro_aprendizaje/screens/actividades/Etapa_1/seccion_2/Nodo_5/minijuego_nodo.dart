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

class _MinijuegoNodo5ScreenState extends State<MinijuegoNodo5Screen> {
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
            Text('Has completado todos los desafíos del Cuerpo Humano.'),
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
            colors: [Colors.pink[300]!, Colors.pink[800]!],
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
                            color: Colors.pink[800]),
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
        return Juego1PartesCuerpo(onCompleted: _nextLevel);
      case 1:
        return Juego2Sentidos(onCompleted: _nextLevel);
      case 2:
        return Juego3Huesos(onCompleted: _nextLevel);
      case 3:
        return Juego4Organos(onCompleted: _nextLevel);
      case 4:
        return Juego5Higiene(onCompleted: _nextLevel);
      case 5:
        return Juego6AlimentacionSaludable(onCompleted: _nextLevel);
      case 6:
        return Juego7QuizCuerpo(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Partes del Cuerpo (MEJORADO) ---
class Juego1PartesCuerpo extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1PartesCuerpo({required this.onCompleted});

  @override
  _Juego1PartesCuerpoState createState() => _Juego1PartesCuerpoState();
}

class _Juego1PartesCuerpoState extends State<Juego1PartesCuerpo> {
  final Map<String, bool> _placedParts = {
    'Cabeza': false,
    'Tronco': false,
    'Brazos': false,
    'Piernas': false,
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
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDropZone('Cabeza', Icons.face, Colors.orange),
                    _buildDropZone(
                        'Tronco', Icons.accessibility_new, Colors.blue),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDropZone('Brazos', Icons.pan_tool, Colors.green),
                        SizedBox(width: 20),
                        _buildDropZone(
                            'Piernas', Icons.directions_walk, Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),
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
                                      size: 40, color: Colors.pink[800]),
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
      case 'Cabeza':
        return Icons.face;
      case 'Tronco':
        return Icons.accessibility_new;
      case 'Brazos':
        return Icons.pan_tool;
      case 'Piernas':
        return Icons.directions_walk;
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
          margin: EdgeInsets.all(5),
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

// --- JUEGO 2: Sentidos (MEJORADO) ---
class Juego2Sentidos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2Sentidos({required this.onCompleted});

  @override
  _Juego2SentidosState createState() => _Juego2SentidosState();
}

class _Juego2SentidosState extends State<Juego2Sentidos> {
  final List<Map<String, dynamic>> _items = [
    {'object': 'Flor', 'sense': 'Olfato', 'icon': Icons.local_florist},
    {'object': 'Música', 'sense': 'Oído', 'icon': Icons.music_note},
    {'object': 'Helado', 'sense': 'Gusto', 'icon': Icons.icecream},
    {'object': 'Peluche', 'sense': 'Tacto', 'icon': Icons.pets},
    {'object': 'Arcoíris', 'sense': 'Vista', 'icon': Icons.looks},
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

  void _checkAnswer(String sense) {
    if (_items[_currentIndex]['sense'] == sense) {
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
              Text('¿Qué sentido usas?',
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
                ),
                child: Column(
                  children: [
                    Icon(_items[_currentIndex]['icon'],
                        size: 60, color: Colors.pink),
                    SizedBox(height: 10),
                    Text(_items[_currentIndex]['object'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildSenseBtn('Vista', Icons.visibility),
                  _buildSenseBtn('Oído', Icons.hearing),
                  _buildSenseBtn('Olfato', Icons.face),
                  _buildSenseBtn('Gusto', Icons.restaurant),
                  _buildSenseBtn('Tacto', Icons.touch_app),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSenseBtn(String text, IconData icon) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pink,
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

// --- JUEGO 3: Huesos (MEJORADO) ---
class Juego3Huesos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3Huesos({required this.onCompleted});

  @override
  _Juego3HuesosState createState() => _Juego3HuesosState();
}

class _Juego3HuesosState extends State<Juego3Huesos> {
  final List<Map<String, dynamic>> _bones = [
    {'name': 'Cráneo', 'location': 'Cabeza', 'icon': Icons.face},
    {'name': 'Costillas', 'location': 'Pecho', 'icon': Icons.accessibility_new},
    {'name': 'Fémur', 'location': 'Pierna', 'icon': Icons.directions_walk},
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

  void _checkAnswer(String location) {
    if (_bones[_currentIndex]['location'] == location) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _bones.length - 1) {
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
              Text('¿Dónde está este hueso?',
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
                ),
                child: Column(
                  children: [
                    Icon(Icons.accessibility, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(_bones[_currentIndex]['name'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBoneBtn('Cabeza', Colors.orange),
                  _buildBoneBtn('Pecho', Colors.blue),
                  _buildBoneBtn('Pierna', Colors.green),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoneBtn(String text, Color color) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}

// --- JUEGO 4: Órganos (MEJORADO) ---
class Juego4Organos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4Organos({required this.onCompleted});

  @override
  _Juego4OrganosState createState() => _Juego4OrganosState();
}

class _Juego4OrganosState extends State<Juego4Organos> {
  final List<Map<String, dynamic>> _organs = [
    {'name': 'Corazón', 'function': 'Bombea sangre', 'icon': Icons.favorite},
    {'name': 'Pulmones', 'function': 'Respirar', 'icon': Icons.air},
    {'name': 'Estómago', 'function': 'Digerir', 'icon': Icons.fastfood},
    {'name': 'Cerebro', 'function': 'Pensar', 'icon': Icons.psychology},
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

  void _checkAnswer(String function) {
    if (_organs[_currentIndex]['function'] == function) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _organs.length - 1) {
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
    List<String> options = _organs.map((e) => e['function'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Qué hace este órgano?',
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
                ),
                child: Column(
                  children: [
                    Icon(_organs[_currentIndex]['icon'],
                        size: 60, color: Colors.red),
                    SizedBox(height: 10),
                    Text(_organs[_currentIndex]['name'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: options.take(4).map((function) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(function),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(function, style: TextStyle(fontSize: 18)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- JUEGO 5: Higiene (MEJORADO) ---
class Juego5Higiene extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5Higiene({required this.onCompleted});

  @override
  _Juego5HigieneState createState() => _Juego5HigieneState();
}

class _Juego5HigieneState extends State<Juego5Higiene> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Jabón', 'isHygiene': true, 'icon': Icons.clean_hands},
    {'name': 'Lodo', 'isHygiene': false, 'icon': Icons.grass},
    {'name': 'Cepillo', 'isHygiene': true, 'icon': Icons.brush},
    {'name': 'Dulces', 'isHygiene': false, 'icon': Icons.cake},
    {'name': 'Toalla', 'isHygiene': true, 'icon': Icons.dry_cleaning},
    {'name': 'Basura', 'isHygiene': false, 'icon': Icons.delete},
  ];

  int _timeLeft = 40;
  Timer? _timer;
  int _score = 0;
  List<int> _foundIndices = [];

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectItem(int index) {
    if (_foundIndices.contains(index)) return;

    if (_items[index]['isHygiene']) {
      HapticFeedback.lightImpact();
      setState(() {
        _foundIndices.add(index);
        _score += 20;
      });
      if (_foundIndices.length == 3) {
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
            content: Text('¡Eso no es para higiene! -5s'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Encuentra 3 objetos de higiene',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              bool isFound = _foundIndices.contains(index);
              return GestureDetector(
                onTap: () => _selectItem(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isFound
                        ? Colors.green.withOpacity(0.8)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: isFound
                        ? Border.all(color: Colors.green, width: 3)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _items[index]['icon'],
                        size: 50,
                        color: isFound ? Colors.white : Colors.pink[400],
                      ),
                      SizedBox(height: 10),
                      Text(
                        _items[index]['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFound ? Colors.white : Colors.black87,
                        ),
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

// --- JUEGO 6: Alimentación Saludable (MEJORADO) ---
class Juego6AlimentacionSaludable extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6AlimentacionSaludable({required this.onCompleted});

  @override
  _Juego6AlimentacionSaludableState createState() =>
      _Juego6AlimentacionSaludableState();
}

class _Juego6AlimentacionSaludableState
    extends State<Juego6AlimentacionSaludable> {
  final List<Map<String, dynamic>> _pairs = [
    {
      'healthy': {'name': 'Manzana', 'icon': Icons.apple},
      'unhealthy': {'name': 'Dulces', 'icon': Icons.cake}
    },
    {
      'healthy': {'name': 'Agua', 'icon': Icons.local_drink},
      'unhealthy': {'name': 'Refresco', 'icon': Icons.local_bar}
    },
    {
      'healthy': {'name': 'Zanahoria', 'icon': Icons.eco},
      'unhealthy': {'name': 'Papas Fritas', 'icon': Icons.fastfood}
    },
    {
      'healthy': {'name': 'Pescado', 'icon': Icons.set_meal},
      'unhealthy': {'name': 'Pizza', 'icon': Icons.local_pizza}
    },
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

  void _selectOption(bool isHealthy) {
    if (isHealthy) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _pairs.length - 1) {
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
            content: Text('¡Eso no es saludable! -5s'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var pair = _pairs[_currentIndex];
    // Randomize order
    List<Map<String, dynamic>> options = [
      {...pair['healthy'], 'isHealthy': true},
      {...pair['unhealthy'], 'isHealthy': false}
    ];
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Cuál es saludable?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: options.map((opt) {
                  return GestureDetector(
                    onTap: () => _selectOption(opt['isHealthy']),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(opt['icon'],
                              size: 60,
                              color: opt['isHealthy']
                                  ? Colors.green
                                  : Colors.orange),
                          SizedBox(height: 10),
                          Text(
                            opt['name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
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
      ],
    );
  }
}

// --- JUEGO 7: Quiz Cuerpo (MEJORADO) ---
class Juego7QuizCuerpo extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7QuizCuerpo({required this.onCompleted});

  @override
  _Juego7QuizCuerpoState createState() => _Juego7QuizCuerpoState();
}

class _Juego7QuizCuerpoState extends State<Juego7QuizCuerpo> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Con qué vemos?',
      'answers': ['Ojos', 'Nariz', 'Boca'],
      'correct': 0
    },
    {
      'question': '¿Qué bombea sangre?',
      'answers': ['Pulmones', 'Corazón', 'Estómago'],
      'correct': 1
    },
    {
      'question': '¿Cuántos dientes tenemos?',
      'answers': ['10', '32', '100'],
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
                          foregroundColor: Colors.pink[800],
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
