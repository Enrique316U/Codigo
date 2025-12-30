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

class MinijuegoNodo7Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo7Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo7ScreenState createState() => _MinijuegoNodo7ScreenState();
}

class _MinijuegoNodo7ScreenState extends State<MinijuegoNodo7Screen> {
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
            Text('Has completado todos los desafíos del Agua.'),
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
            colors: [Colors.blue[300]!, Colors.blue[800]!],
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
                            color: Colors.blue[800]),
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
        return Juego1EstadosAgua(onCompleted: _nextLevel);
      case 1:
        return Juego2CicloAgua(onCompleted: _nextLevel);
      case 2:
        return Juego3UsosAgua(onCompleted: _nextLevel);
      case 3:
        return Juego4AhorroAgua(onCompleted: _nextLevel);
      case 4:
        return Juego5FlotaHunde(onCompleted: _nextLevel);
      case 5:
        return Juego6Contaminacion(onCompleted: _nextLevel);
      case 6:
        return Juego7QuizAgua(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Estados del Agua (MEJORADO) ---
class Juego1EstadosAgua extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1EstadosAgua({required this.onCompleted});

  @override
  _Juego1EstadosAguaState createState() => _Juego1EstadosAguaState();
}

class _Juego1EstadosAguaState extends State<Juego1EstadosAgua> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Hielo', 'state': 'Sólido', 'icon': Icons.ac_unit},
    {'name': 'Río', 'state': 'Líquido', 'icon': Icons.water},
    {'name': 'Nube', 'state': 'Gaseoso', 'icon': Icons.cloud},
    {'name': 'Vapor', 'state': 'Gaseoso', 'icon': Icons.air},
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

  void _checkAnswer(String state) {
    if (_items[_currentIndex]['state'] == state) {
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
              Text('¿En qué estado está?',
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
                        size: 60, color: Colors.blue),
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
                    onPressed: () => _checkAnswer('Sólido'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[100],
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    child: Text('Sólido',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Líquido'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    child: Text('Líquido',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Gaseoso'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    child: Text('Gaseoso',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
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

// --- JUEGO 2: Ciclo del Agua (MEJORADO) ---
class Juego2CicloAgua extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2CicloAgua({required this.onCompleted});

  @override
  _Juego2CicloAguaState createState() => _Juego2CicloAguaState();
}

class _Juego2CicloAguaState extends State<Juego2CicloAgua> {
  final List<Map<String, dynamic>> _stages = [
    {
      'question': 'El sol calienta el agua y sube...',
      'answer': 'Evaporación',
      'icon': Icons.wb_sunny
    },
    {
      'question': 'El vapor forma nubes...',
      'answer': 'Condensación',
      'icon': Icons.cloud
    },
    {
      'question': 'El agua cae de las nubes...',
      'answer': 'Precipitación',
      'icon': Icons.grain
    },
    {
      'question': 'El agua regresa a los ríos...',
      'answer': 'Recolección',
      'icon': Icons.water
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

  void _checkAnswer(String answer) {
    if (_stages[_currentIndex]['answer'] == answer) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _stages.length - 1) {
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
    List<String> options = _stages.map((e) => e['answer'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ciclo del Agua',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(_stages[_currentIndex]['icon'],
                        size: 60, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      _stages[_currentIndex]['question'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: options.map((answer) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(answer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: Text(answer, style: TextStyle(fontSize: 16)),
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

// --- JUEGO 3: Usos del Agua (MEJORADO) ---
class Juego3UsosAgua extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3UsosAgua({required this.onCompleted});

  @override
  _Juego3UsosAguaState createState() => _Juego3UsosAguaState();
}

class _Juego3UsosAguaState extends State<Juego3UsosAgua> {
  final List<Map<String, dynamic>> _situations = [
    {'situation': 'Tengo sed', 'use': 'Beber', 'icon': Icons.local_drink},
    {'situation': 'Estoy sucio', 'use': 'Bañarse', 'icon': Icons.bathtub},
    {'situation': 'Plantas secas', 'use': 'Regar', 'icon': Icons.grass},
    {
      'situation': 'Ropa sucia',
      'use': 'Lavar',
      'icon': Icons.local_laundry_service
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

  void _checkAnswer(String use) {
    if (_situations[_currentIndex]['use'] == use) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _situations.length - 1) {
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
    List<String> options = _situations.map((e) => e['use'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Para qué usas el agua?',
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
                    Icon(_situations[_currentIndex]['icon'],
                        size: 60, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(_situations[_currentIndex]['situation'],
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
                children: options.take(4).map((use) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(use),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(use, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 4: Ahorro de Agua (MEJORADO) ---
class Juego4AhorroAgua extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4AhorroAgua({required this.onCompleted});

  @override
  _Juego4AhorroAguaState createState() => _Juego4AhorroAguaState();
}

class _Juego4AhorroAguaState extends State<Juego4AhorroAgua> {
  final List<Map<String, dynamic>> _actions = [
    {'action': 'Cerrar el grifo', 'isGood': true, 'icon': Icons.check_circle},
    {'action': 'Dejar manguera abierta', 'isGood': false, 'icon': Icons.cancel},
    {'action': 'Ducha corta', 'isGood': true, 'icon': Icons.timer},
    {'action': 'Jugar con agua', 'isGood': false, 'icon': Icons.toys},
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

  void _checkAnswer(bool isGood) {
    if (_actions[_currentIndex]['isGood'] == isGood) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _actions.length - 1) {
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
              Text('¿Ahorra o Desperdicia?',
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
                    Icon(_actions[_currentIndex]['icon'],
                        size: 60, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(_actions[_currentIndex]['action'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
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
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Ahorra', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Desperdicia', style: TextStyle(fontSize: 20)),
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

// --- JUEGO 5: Flota o Se Hunde (MEJORADO) ---
class Juego5FlotaHunde extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5FlotaHunde({required this.onCompleted});

  @override
  _Juego5FlotaHundeState createState() => _Juego5FlotaHundeState();
}

class _Juego5FlotaHundeState extends State<Juego5FlotaHunde> {
  final List<Map<String, dynamic>> _objects = [
    {'object': 'Barco', 'floats': true, 'icon': Icons.directions_boat},
    {'object': 'Piedra', 'floats': false, 'icon': Icons.landscape},
    {'object': 'Pato de hule', 'floats': true, 'icon': Icons.toys},
    {'object': 'Llave', 'floats': false, 'icon': Icons.vpn_key},
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

  void _checkAnswer(bool floats) {
    if (_objects[_currentIndex]['floats'] == floats) {
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
              Text('¿Flota o Se Hunde?',
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
                        size: 60, color: Colors.blue),
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
                      backgroundColor: Colors.lightBlue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Flota', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Se Hunde', style: TextStyle(fontSize: 20)),
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

// --- JUEGO 6: Contaminación (MEJORADO) ---
class Juego6Contaminacion extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6Contaminacion({required this.onCompleted});

  @override
  _Juego6ContaminacionState createState() => _Juego6ContaminacionState();
}

class _Juego6ContaminacionState extends State<Juego6Contaminacion> {
  final List<Map<String, dynamic>> _items = [
    {'item': 'Botella plástico', 'pollutes': true, 'icon': Icons.delete},
    {'item': 'Pez', 'pollutes': false, 'icon': Icons.set_meal},
    {'item': 'Aceite', 'pollutes': true, 'icon': Icons.opacity},
    {'item': 'Algas', 'pollutes': false, 'icon': Icons.grass},
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

  void _checkAnswer(bool pollutes) {
    if (_items[_currentIndex]['pollutes'] == pollutes) {
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
              Text('¿Contamina el agua?',
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
                        size: 60, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(_items[_currentIndex]['item'],
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
                      backgroundColor: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Sí', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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

// --- JUEGO 7: Quiz Agua (MEJORADO) ---
class Juego7QuizAgua extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7QuizAgua({required this.onCompleted});

  @override
  _Juego7QuizAguaState createState() => _Juego7QuizAguaState();
}

class _Juego7QuizAguaState extends State<Juego7QuizAgua> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿El hielo es agua en estado...?',
      'answers': ['Líquido', 'Sólido', 'Gaseoso'],
      'correct': 1
    },
    {
      'question': '¿Debemos cerrar el grifo al cepillarnos?',
      'answers': ['Sí', 'No', 'A veces'],
      'correct': 0
    },
    {
      'question': '¿El agua de mar es...?',
      'answers': ['Dulce', 'Salada', 'Picante'],
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
                          foregroundColor: Colors.blue[800],
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
