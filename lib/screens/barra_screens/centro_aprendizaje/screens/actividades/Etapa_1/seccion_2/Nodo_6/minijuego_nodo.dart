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

class _MinijuegoNodo6ScreenState extends State<MinijuegoNodo6Screen> {
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
            Text('Has completado todos los desafíos de los Sentidos.'),
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
            colors: [Colors.purple[300]!, Colors.purple[800]!],
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
                            color: Colors.purple[800]),
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
        return Juego1AsociaSentidos(onCompleted: _nextLevel);
      case 1:
        return Juego2Sonidos(onCompleted: _nextLevel);
      case 2:
        return Juego3Texturas(onCompleted: _nextLevel);
      case 3:
        return Juego4Sabores(onCompleted: _nextLevel);
      case 4:
        return Juego5Olores(onCompleted: _nextLevel);
      case 5:
        return Juego6Colores(onCompleted: _nextLevel);
      case 6:
        return Juego7QuizSentidos(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Asocia Sentidos (MEJORADO) ---
class Juego1AsociaSentidos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1AsociaSentidos({required this.onCompleted});

  @override
  _Juego1AsociaSentidosState createState() => _Juego1AsociaSentidosState();
}

class _Juego1AsociaSentidosState extends State<Juego1AsociaSentidos> {
  final List<Map<String, dynamic>> _items = [
    {'sense': 'Vista', 'organ': 'Ojos', 'icon': Icons.remove_red_eye},
    {'sense': 'Oído', 'organ': 'Oídos', 'icon': Icons.hearing},
    {
      'sense': 'Olfato',
      'organ': 'Nariz',
      'icon': Icons.person
    }, // Using person as nose placeholder
    {'sense': 'Gusto', 'organ': 'Boca', 'icon': Icons.fastfood},
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

  void _checkAnswer(String organ) {
    if (_items[_currentIndex]['organ'] == organ) {
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
              Text('¿Qué usas para el sentido de:',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Text(_items[_currentIndex]['sense'],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _items.map((item) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(item['organ']),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                    ),
                    child: Column(
                      children: [
                        Icon(item['icon'], size: 40, color: Colors.purple),
                        Text(item['organ'],
                            style: TextStyle(color: Colors.purple)),
                      ],
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

// --- JUEGO 2: Sonidos (MEJORADO) ---
class Juego2Sonidos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2Sonidos({required this.onCompleted});

  @override
  _Juego2SonidosState createState() => _Juego2SonidosState();
}

class _Juego2SonidosState extends State<Juego2Sonidos> {
  final List<Map<String, dynamic>> _sounds = [
    {'sound': '¡Muuu!', 'source': 'Vaca', 'icon': Icons.grass},
    {'sound': '¡Ring Ring!', 'source': 'Teléfono', 'icon': Icons.phone},
    {'sound': '¡Guau Guau!', 'source': 'Perro', 'icon': Icons.pets},
    {'sound': '¡Brum Brum!', 'source': 'Carro', 'icon': Icons.directions_car},
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

  void _checkAnswer(String source) {
    if (_sounds[_currentIndex]['source'] == source) {
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
    List<String> options = _sounds.map((e) => e['source'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Qué hace este sonido?',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _sounds[_currentIndex]['sound'],
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: options.take(4).map((source) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(source),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(source, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 3: Texturas (MEJORADO) ---
class Juego3Texturas extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3Texturas({required this.onCompleted});

  @override
  _Juego3TexturasState createState() => _Juego3TexturasState();
}

class _Juego3TexturasState extends State<Juego3Texturas> {
  final List<Map<String, dynamic>> _textures = [
    {'object': 'Conejo', 'texture': 'Suave', 'icon': Icons.pets},
    {'object': 'Roca', 'texture': 'Dura', 'icon': Icons.landscape},
    {'object': 'Lija', 'texture': 'Áspera', 'icon': Icons.build},
    {'object': 'Gelatina', 'texture': 'Blanda', 'icon': Icons.cake},
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

  void _checkAnswer(String texture) {
    if (_textures[_currentIndex]['texture'] == texture) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _textures.length - 1) {
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
    List<String> options =
        _textures.map((e) => e['texture'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Cómo se siente?',
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
                    Icon(_textures[_currentIndex]['icon'],
                        size: 60, color: Colors.purple),
                    SizedBox(height: 10),
                    Text(_textures[_currentIndex]['object'],
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
                children: options.take(4).map((texture) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(texture),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(texture, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 4: Sabores (MEJORADO) ---
class Juego4Sabores extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4Sabores({required this.onCompleted});

  @override
  _Juego4SaboresState createState() => _Juego4SaboresState();
}

class _Juego4SaboresState extends State<Juego4Sabores> {
  final List<Map<String, dynamic>> _tastes = [
    {'food': 'Limón', 'taste': 'Ácido', 'icon': Icons.eco},
    {'food': 'Pastel', 'taste': 'Dulce', 'icon': Icons.cake},
    {'food': 'Papas Fritas', 'taste': 'Salado', 'icon': Icons.fastfood},
    {'food': 'Café', 'taste': 'Amargo', 'icon': Icons.local_cafe},
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

  void _checkAnswer(String taste) {
    if (_tastes[_currentIndex]['taste'] == taste) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _tastes.length - 1) {
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
    List<String> options = _tastes.map((e) => e['taste'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿A qué sabe?',
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
                    Icon(_tastes[_currentIndex]['icon'],
                        size: 60, color: Colors.purple),
                    SizedBox(height: 10),
                    Text(_tastes[_currentIndex]['food'],
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
                children: options.take(4).map((taste) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(taste),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(taste, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 5: Olores (MEJORADO) ---
class Juego5Olores extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5Olores({required this.onCompleted});

  @override
  _Juego5OloresState createState() => _Juego5OloresState();
}

class _Juego5OloresState extends State<Juego5Olores> {
  final List<Map<String, dynamic>> _smells = [
    {'object': 'Flor', 'smell': 'Rico', 'icon': Icons.local_florist},
    {'object': 'Basura', 'smell': 'Feo', 'icon': Icons.delete},
    {'object': 'Perfume', 'smell': 'Rico', 'icon': Icons.spa},
    {'object': 'Calcetín Sucio', 'smell': 'Feo', 'icon': Icons.accessibility},
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

  void _checkAnswer(String smell) {
    if (_smells[_currentIndex]['smell'] == smell) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _smells.length - 1) {
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
              Text('¿Huele Rico o Feo?',
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
                    Icon(_smells[_currentIndex]['icon'],
                        size: 60, color: Colors.purple),
                    SizedBox(height: 10),
                    Text(_smells[_currentIndex]['object'],
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
                    onPressed: () => _checkAnswer('Rico'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Rico', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _checkAnswer('Feo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Feo', style: TextStyle(fontSize: 20)),
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

// --- JUEGO 6: Colores (MEJORADO) ---
class Juego6Colores extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6Colores({required this.onCompleted});

  @override
  _Juego6ColoresState createState() => _Juego6ColoresState();
}

class _Juego6ColoresState extends State<Juego6Colores> {
  final List<Map<String, dynamic>> _colors = [
    {'object': 'Sol', 'color': 'Amarillo', 'icon': Icons.wb_sunny},
    {'object': 'Pasto', 'color': 'Verde', 'icon': Icons.grass},
    {'object': 'Cielo', 'color': 'Azul', 'icon': Icons.cloud},
    {'object': 'Fresa', 'color': 'Rojo', 'icon': Icons.favorite},
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

  void _checkAnswer(String color) {
    if (_colors[_currentIndex]['color'] == color) {
      HapticFeedback.lightImpact();
      if (_currentIndex < _colors.length - 1) {
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
    List<String> options = _colors.map((e) => e['color'] as String).toList();
    options.shuffle();

    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿De qué color es?',
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
                    Icon(_colors[_currentIndex]['icon'],
                        size: 60, color: Colors.purple),
                    SizedBox(height: 10),
                    Text(_colors[_currentIndex]['object'],
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
                children: options.take(4).map((color) {
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(color),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(color, style: TextStyle(fontSize: 18)),
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

// --- JUEGO 7: Quiz Sentidos (MEJORADO) ---
class Juego7QuizSentidos extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7QuizSentidos({required this.onCompleted});

  @override
  _Juego7QuizSentidosState createState() => _Juego7QuizSentidosState();
}

class _Juego7QuizSentidosState extends State<Juego7QuizSentidos> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Con qué olemos?',
      'answers': ['Ojos', 'Nariz', 'Boca'],
      'correct': 1
    },
    {
      'question': '¿Con qué escuchamos música?',
      'answers': ['Oídos', 'Manos', 'Pies'],
      'correct': 0
    },
    {
      'question': '¿Con qué saboreamos?',
      'answers': ['Lengua', 'Dientes', 'Labios'],
      'correct': 0
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
                          foregroundColor: Colors.purple[800],
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
