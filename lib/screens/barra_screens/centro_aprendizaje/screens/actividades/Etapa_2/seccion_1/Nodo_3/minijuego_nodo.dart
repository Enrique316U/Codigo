// ETAPA 2 - SECCIÓN 1 - NODO 3: CLASIFICACIÓN DE MATERIALES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo3Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo3Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo3Screen> createState() => _MinijuegoNodo3ScreenState();
}

class _MinijuegoNodo3ScreenState extends State<MinijuegoNodo3Screen> {
  int _currentGame = 0;
  int _totalScore = 0;
  List<bool> _gamesCompleted = [false, false, false, false, false];

  void _startGame(int gameIndex) {
    setState(() {
      _currentGame = gameIndex;
    });
  }

  void _completeGame(int score, int gameIndex) {
    setState(() {
      _totalScore += score;
      _gamesCompleted[gameIndex - 1] = true;
      _currentGame = 0;
    });

    if (_gamesCompleted.every((completed) => completed)) {
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    await ProgresoService().marcarActividadCompletada(
        widget.etapa, widget.seccion, widget.actividad, _totalScore);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Felicidades! Has completado todo el nodo 🏆'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CLASIFICACIÓN DE MATERIALES",
            style: TextStyle(color: Colors.white)),
        backgroundColor: widget.color,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_totalScore',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentGame) {
      case 1:
        return Juego1DuroBlando(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 1));
      case 2:
        return Juego2Texturas(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 2));
      case 3:
        return Juego3Flexibilidad(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 3));
      case 4:
        return Juego4Materiales(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 4));
      case 5:
        return Juego5QuizMateriales(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 5));
      default:
        return _buildMenu();
    }
  }

  Widget _buildMenu() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [widget.color.withOpacity(0.1), Colors.white],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFFBCAAA4)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(children: [
              Text('🧱', style: TextStyle(fontSize: 70)),
              SizedBox(height: 12),
              Text('¡Propiedades de los Materiales!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black26)
                      ])),
            ]),
          ),
          const SizedBox(height: 25),
          _buildGameCard(1, '🪨 Duro o Blando', Icons.hardware,
              '¿Resiste golpes o es suave?', Color(0xFF8D6E63)),
          _buildGameCard(2, '✋ Texturas', Icons.touch_app, 'Áspero o Suave',
              Color(0xFF78909C)),
          _buildGameCard(3, '〰️ Flexibilidad', Icons.waves, 'Rígido o Flexible',
              Color(0xFF42A5F5)),
          _buildGameCard(4, '🏗️ ¿De qué está hecho?', Icons.build,
              'Madera, Metal, Plástico', Color(0xFF9575CD)),
          _buildGameCard(5, '🏆 Quiz de Materiales', Icons.quiz,
              'Demuestra lo que sabes', Color(0xFFFFCA28)),
        ],
      ),
    );
  }

  Widget _buildGameCard(int index, String title, IconData icon,
      String description, Color cardColor) {
    bool isCompleted = _gamesCompleted[index - 1];
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [cardColor, cardColor.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: cardColor.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _startGame(index),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle),
                  child: Icon(isCompleted ? Icons.check : icon,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 6),
                      Text(description,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// JUEGO 1: Duro o Blando (Sorting)
class Juego1DuroBlando extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego1DuroBlando(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego1DuroBlando> createState() => _Juego1DuroBlandoState();
}

class _Juego1DuroBlandoState extends State<Juego1DuroBlando> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Piedra', 'type': 'Duro'},
    {'name': 'Almohada', 'type': 'Blando'},
    {'name': 'Martillo', 'type': 'Duro'},
    {'name': 'Algodón', 'type': 'Blando'},
  ];
  int _currentIndex = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _checkAnswer(String type) {
    bool isCorrect = _items[_currentIndex]['type'] == type;
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        if (_currentIndex < _items.length - 1) {
          setState(() {
            _currentIndex++;
          });
        } else {
          _timer?.cancel();
          widget.onGameCompleted(_score);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text('🔨', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Duro o Blando',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Item ${_currentIndex + 1}/${_items.length}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text('¿Es Duro o Blando?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
                child: Text(_items[_currentIndex]['name'],
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => _checkAnswer('Duro'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15)),
                      child: const Text('Duro',
                          style: TextStyle(color: Colors.white, fontSize: 18))),
                  ElevatedButton(
                      onPressed: () => _checkAnswer('Blando'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15)),
                      child: const Text('Blando',
                          style: TextStyle(color: Colors.white, fontSize: 18))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 2: Texturas (Selection)
class Juego2Texturas extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego2Texturas(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego2Texturas> createState() => _Juego2TexturasState();
}

class _Juego2TexturasState extends State<Juego2Texturas> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {
      'item': 'Lija',
      'options': ['Áspero', 'Suave'],
      'correct': 0
    },
    {
      'item': 'Seda',
      'options': ['Áspero', 'Suave'],
      'correct': 1
    },
    {
      'item': 'Tronco de árbol',
      'options': ['Áspero', 'Suave'],
      'correct': 0
    },
    {
      'item': 'Peluche',
      'options': ['Áspero', 'Suave'],
      'correct': 1
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _answer(int i) {
    bool isCorrect = i == _questions[_index]['correct'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        if (_index < _questions.length - 1) {
          setState(() => _index++);
        } else {
          _timer?.cancel();
          widget.onGameCompleted(_score);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text('✋', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Texturas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pregunta ${_index + 1}/${_questions.length}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text('¿Cómo se siente?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
              const SizedBox(height: 20),
              Text(_questions[_index]['item'],
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    2,
                    (i) => ElevatedButton(
                          onPressed: () => _answer(i),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                          child: Text(_questions[_index]['options'][i],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: Flexibilidad (True/False)
class Juego3Flexibilidad extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego3Flexibilidad(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego3Flexibilidad> createState() => _Juego3FlexibilidadState();
}

class _Juego3FlexibilidadState extends State<Juego3Flexibilidad> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {'text': 'La goma elástica es flexible', 'isTrue': true},
    {'text': 'Una piedra es flexible', 'isTrue': false},
    {'text': 'Un lápiz de madera es rígido', 'isTrue': true},
    {'text': 'La plastilina es rígida', 'isTrue': false},
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _answer(bool val) {
    bool isCorrect = val == _questions[_index]['isTrue'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        if (_index < _questions.length - 1) {
          setState(() => _index++);
        } else {
          _timer?.cancel();
          widget.onGameCompleted(_score);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text('🔄', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Flexibilidad',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pregunta ${_index + 1}/${_questions.length}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_questions[_index]['text'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => _answer(true),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Verdadero',
                          style: TextStyle(color: Colors.white))),
                  ElevatedButton(
                      onPressed: () => _answer(false),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Falso',
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 4: Materiales (Selection)
class Juego4Materiales extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego4Materiales(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego4Materiales> createState() => _Juego4MaterialesState();
}

class _Juego4MaterialesState extends State<Juego4Materiales> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {
      'item': 'Mesa',
      'options': ['Madera', 'Agua', 'Aire'],
      'correct': 0
    },
    {
      'item': 'Botella',
      'options': ['Plástico', 'Papel', 'Tela'],
      'correct': 0
    },
    {
      'item': 'Llave',
      'options': ['Metal', 'Madera', 'Algodón'],
      'correct': 0
    },
    {
      'item': 'Vaso',
      'options': ['Vidrio', 'Tela', 'Papel'],
      'correct': 0
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _answer(int i) {
    bool isCorrect = i == _questions[_index]['correct'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        if (_index < _questions.length - 1) {
          setState(() => _index++);
        } else {
          _timer?.cancel();
          widget.onGameCompleted(_score);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text('🧱', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Materiales',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pregunta ${_index + 1}/${_questions.length}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text('¿De qué está hecho?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
              const SizedBox(height: 20),
              Text(_questions[_index]['item'],
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ...List.generate(
                  3,
                  (i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _answer(i),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color,
                              minimumSize: const Size(200, 50)),
                          child: Text(_questions[_index]['options'][i],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                        ),
                      )),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 5: Quiz Final
class Juego5QuizMateriales extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego5QuizMateriales(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego5QuizMateriales> createState() => _Juego5QuizMaterialesState();
}

class _Juego5QuizMaterialesState extends State<Juego5QuizMateriales> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {
      'q': '¿Qué material es transparente y frágil?',
      'a': ['Vidrio', 'Madera', 'Metal'],
      'c': 0
    },
    {
      'q': '¿Qué material es duro y resistente?',
      'a': ['Metal', 'Algodón', 'Papel'],
      'c': 0
    },
    {
      'q': '¿Qué es suave al tacto?',
      'a': ['Lija', 'Seda', 'Piedra'],
      'c': 1
    },
    {
      'q': '¿Qué objeto es flexible?',
      'a': ['Manguera', 'Ladrillo', 'Mesa'],
      'c': 0
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _answer(int i) {
    bool isCorrect = i == _questions[_index]['c'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        if (_index < _questions.length - 1) {
          setState(() => _index++);
        } else {
          _timer?.cancel();
          widget.onGameCompleted(_score);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text('🏆', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Quiz de Materiales',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pregunta ${_index + 1}/${_questions.length}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_questions[_index]['q'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                  3,
                  (i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _answer(i),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color,
                              minimumSize: const Size(double.infinity, 50)),
                          child: Text(_questions[_index]['a'][i],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                        ),
                      )),
            ],
          ),
        ),
      ],
    );
  }
}
