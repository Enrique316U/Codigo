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

class _MinijuegoNodo4ScreenState extends State<MinijuegoNodo4Screen> {
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
            Text('Has completado todos los desafíos de Animales.'),
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
            colors: [Colors.orange[300]!, Colors.orange[800]!],
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
                            color: Colors.orange[800]),
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
        return Juego1DomesticoSalvaje(onCompleted: _nextLevel);
      case 1:
        return Juego2Habitat(onCompleted: _nextLevel);
      case 2:
        return Juego3Sonidos(onCompleted: _nextLevel);
      case 3:
        return Juego4Alimentacion(onCompleted: _nextLevel);
      case 4:
        return Juego5Crias(onCompleted: _nextLevel);
      case 5:
        return Juego6Huellas(onCompleted: _nextLevel);
      case 6:
        return Juego7QuizAnimales(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Doméstico vs Salvaje (MEJORADO) ---
class Juego1DomesticoSalvaje extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1DomesticoSalvaje({required this.onCompleted});

  @override
  _Juego1DomesticoSalvajeState createState() => _Juego1DomesticoSalvajeState();
}

class _Juego1DomesticoSalvajeState extends State<Juego1DomesticoSalvaje> {
  final List<Map<String, dynamic>> _animals = [
    {'name': 'Perro', 'type': 'Doméstico', 'icon': Icons.pets},
    {'name': 'León', 'type': 'Salvaje', 'icon': Icons.cruelty_free},
    {'name': 'Gato', 'type': 'Doméstico', 'icon': Icons.pets},
    {'name': 'Elefante', 'type': 'Salvaje', 'icon': Icons.park},
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
    if (_animals[_currentIndex]['type'] == type) {
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
              Text('¿Doméstico o Salvaje?',
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
                    Icon(_animals[_currentIndex]['icon'],
                        size: 60, color: Colors.orange),
                    Text(_animals[_currentIndex]['name'],
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Doméstico'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: Text('Doméstico', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Salvaje'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: Text('Salvaje', style: TextStyle(fontSize: 18)),
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

// --- JUEGO 2: Hábitat (MEJORADO) ---
class Juego2Habitat extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2Habitat({required this.onCompleted});

  @override
  _Juego2HabitatState createState() => _Juego2HabitatState();
}

class _Juego2HabitatState extends State<Juego2Habitat> {
  final List<Map<String, dynamic>> _animals = [
    {'name': 'Pez', 'habitat': 'Agua', 'icon': Icons.water},
    {'name': 'Pájaro', 'habitat': 'Aire', 'icon': Icons.air},
    {'name': 'Perro', 'habitat': 'Tierra', 'icon': Icons.grass},
    {'name': 'Ballena', 'habitat': 'Agua', 'icon': Icons.waves},
    {'name': 'Águila', 'habitat': 'Aire', 'icon': Icons.cloud},
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

  void _checkAnswer(String habitat) {
    if (_animals[_currentIndex]['habitat'] == habitat) {
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
              Text('¿Dónde vive?',
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
                    Icon(Icons.pets, size: 60, color: Colors.brown),
                    SizedBox(height: 10),
                    Text(_animals[_currentIndex]['name'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildHabitatBtn('Tierra', Icons.grass, Colors.green),
                  _buildHabitatBtn('Agua', Icons.water, Colors.blue),
                  _buildHabitatBtn('Aire', Icons.air, Colors.lightBlueAccent),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHabitatBtn(String text, IconData icon, Color color) {
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

// --- JUEGO 3: Sonidos (MEJORADO) ---
class Juego3Sonidos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3Sonidos({required this.onCompleted});

  @override
  _Juego3SonidosState createState() => _Juego3SonidosState();
}

class _Juego3SonidosState extends State<Juego3Sonidos> {
  final List<Map<String, dynamic>> _sounds = [
    {'animal': 'Perro', 'sound': 'Guau Guau', 'icon': Icons.pets},
    {'animal': 'Gato', 'sound': 'Miau Miau', 'icon': Icons.pets},
    {'animal': 'Vaca', 'sound': 'Muuu', 'icon': Icons.grass},
    {'animal': 'Pato', 'sound': 'Cuac Cuac', 'icon': Icons.water},
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

  void _checkAnswer(String animal) {
    if (_sounds[_currentIndex]['animal'] == animal) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _sounds.length - 1) {
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
    List<String> options = _sounds.map((e) => e['animal'] as String).toList();
    options.shuffle(); // Mezclar opciones para hacerlo más dinámico

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Quién hace este sonido?',
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
                    Icon(Icons.volume_up, size: 60, color: Colors.blue),
                    SizedBox(height: 10),
                    Text('"${_sounds[_currentIndex]['sound']}"',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: options.take(3).map((animal) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(animal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    ),
                    child: Text(animal, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 4: Alimentación (MEJORADO) ---
class Juego4Alimentacion extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4Alimentacion({required this.onCompleted});

  @override
  _Juego4AlimentacionState createState() => _Juego4AlimentacionState();
}

class _Juego4AlimentacionState extends State<Juego4Alimentacion> {
  final List<Map<String, dynamic>> _animals = [
    {'name': 'León', 'diet': 'Carne', 'icon': Icons.pets},
    {'name': 'Vaca', 'diet': 'Plantas', 'icon': Icons.grass},
    {'name': 'Conejo', 'diet': 'Plantas', 'icon': Icons.cruelty_free},
    {'name': 'Tiburón', 'diet': 'Carne', 'icon': Icons.waves},
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

  void _checkAnswer(String diet) {
    if (_animals[_currentIndex]['diet'] == diet) {
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
              Text('¿Qué come este animal?',
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
                    Icon(_animals[_currentIndex]['icon'],
                        size: 60, color: Colors.brown),
                    SizedBox(height: 10),
                    Text(_animals[_currentIndex]['name'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDietBtn('Plantas', Icons.grass, Colors.green),
                  _buildDietBtn('Carne', Icons.restaurant, Colors.red),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDietBtn(String text, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30),
          SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// --- JUEGO 5: Crías (MEJORADO) ---
class Juego5Crias extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5Crias({required this.onCompleted});

  @override
  _Juego5CriasState createState() => _Juego5CriasState();
}

class _Juego5CriasState extends State<Juego5Crias> {
  final List<Map<String, dynamic>> _pairs = [
    {'parent': 'Gallina', 'baby': 'Pollito', 'icon': Icons.egg},
    {'parent': 'Vaca', 'baby': 'Ternero', 'icon': Icons.grass},
    {'parent': 'Perro', 'baby': 'Cachorro', 'icon': Icons.pets},
    {'parent': 'Gato', 'baby': 'Gatito', 'icon': Icons.pets},
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

  void _checkAnswer(String baby) {
    if (_pairs[_currentIndex]['baby'] == baby) {
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
        SnackBar(content: Text('Incorrecto -5s'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = _pairs.map((e) => e['baby'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Cómo se llama su cría?',
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
                    Icon(_pairs[_currentIndex]['icon'],
                        size: 60, color: Colors.orange),
                    SizedBox(height: 10),
                    Text(_pairs[_currentIndex]['parent'],
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
                children: options.take(4).map((baby) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(baby),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(baby, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 6: Huellas (MEJORADO) ---
class Juego6Huellas extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6Huellas({required this.onCompleted});

  @override
  _Juego6HuellasState createState() => _Juego6HuellasState();
}

class _Juego6HuellasState extends State<Juego6Huellas> {
  final List<Map<String, dynamic>> _tracks = [
    {'animal': 'Pato', 'icon': Icons.water, 'track': Icons.pets},
    {'animal': 'Oso', 'icon': Icons.park, 'track': Icons.fingerprint},
    {'animal': 'Caballo', 'icon': Icons.agriculture, 'track': Icons.circle},
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

  void _checkAnswer(String animal) {
    if (_tracks[_currentIndex]['animal'] == animal) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _tracks.length - 1) {
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
    List<String> options = _tracks.map((e) => e['animal'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿De quién es esta huella?',
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
                child: Icon(_tracks[_currentIndex]['track'],
                    size: 80, color: Colors.brown),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: options.map((animal) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(animal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    ),
                    child: Text(animal, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 7: Quiz Animales (MEJORADO) ---
class Juego7QuizAnimales extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7QuizAnimales({required this.onCompleted});

  @override
  _Juego7QuizAnimalesState createState() => _Juego7QuizAnimalesState();
}

class _Juego7QuizAnimalesState extends State<Juego7QuizAnimales> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuál es el rey de la selva?',
      'answers': ['León', 'Tigre', 'Elefante'],
      'correct': 0
    },
    {
      'question': '¿Qué animal pone huevos?',
      'answers': ['Perro', 'Gallina', 'Vaca'],
      'correct': 1
    },
    {
      'question': '¿Cuál vive en el agua?',
      'answers': ['Gato', 'Pez', 'Pájaro'],
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
                          foregroundColor: Colors.orange[800],
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
