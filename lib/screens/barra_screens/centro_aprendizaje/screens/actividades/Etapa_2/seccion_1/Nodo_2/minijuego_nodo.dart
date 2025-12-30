// ETAPA 2 - SECCIÓN 1 - NODO 2: LOS ANIMALES Y SUS CARACTERÍSTICAS
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo2Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo2Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo2Screen> createState() => _MinijuegoNodo2ScreenState();
}

class _MinijuegoNodo2ScreenState extends State<MinijuegoNodo2Screen> {
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
        title: const Text("LOS ANIMALES Y SUS CARACTERÍSTICAS",
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
        return Juego1CubiertaCorporal(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 1));
      case 2:
        return Juego2Desplazamiento(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 2));
      case 3:
        return Juego3Alimentacion(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 3));
      case 4:
        return Juego4Habitat(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 4));
      case 5:
        return Juego5QuizAnimales(
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
                  colors: [Color(0xFFFF7043), Color(0xFFFFAB40)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(children: [
              Text('🐾', style: TextStyle(fontSize: 70)),
              SizedBox(height: 12),
              Text('¡Explora el Mundo Animal!',
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
          _buildGameCard(1, '🦊 Piel, Plumas o Escamas', Icons.pets,
              '¿Qué cubre su cuerpo?', Color(0xFFFF8A65)),
          _buildGameCard(2, '🦅 ¿Cómo se mueven?', Icons.directions_run,
              'Nadar, volar o caminar', Color(0xFF42A5F5)),
          _buildGameCard(3, '🍖 ¿Qué comen?', Icons.restaurant,
              'Carnívoros y Herbívoros', Color(0xFF66BB6A)),
          _buildGameCard(4, '🏔️ ¿Dónde viven?', Icons.home,
              'Su hábitat natural', Color(0xFF8BC34A)),
          _buildGameCard(5, '🏆 Quiz Animal', Icons.quiz,
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
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
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
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
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

// JUEGO 1: Cubierta Corporal (Selection)
class Juego1CubiertaCorporal extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego1CubiertaCorporal(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego1CubiertaCorporal> createState() => _Juego1CubiertaCorporalState();
}

class _Juego1CubiertaCorporalState extends State<Juego1CubiertaCorporal> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {
      'animal': 'Perro',
      'icon': Icons.pets,
      'options': ['Pelos', 'Plumas', 'Escamas'],
      'correct': 0
    },
    {
      'animal': 'Pájaro',
      'icon': Icons.flutter_dash,
      'options': ['Pelos', 'Plumas', 'Escamas'],
      'correct': 1
    },
    {
      'animal': 'Pez',
      'icon': Icons.set_meal,
      'options': ['Pelos', 'Plumas', 'Escamas'],
      'correct': 2
    },
    {
      'animal': 'Gato',
      'icon': Icons.pets,
      'options': ['Pelos', 'Plumas', 'Escamas'],
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

  void _answer(int optionIndex) {
    bool isCorrect = optionIndex == _questions[_index]['correct'];

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
          setState(() {
            _index++;
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
              Text('🐾', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Cubierta Corporal',
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
              Text('¿Qué cubre su cuerpo?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
              SizedBox(height: 16),
              Icon(_questions[_index]['icon'], size: 100, color: widget.color),
              SizedBox(height: 16),
              Text(_questions[_index]['animal'],
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ...List.generate(
                  3,
                  (i) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32),
                        child: ElevatedButton(
                          onPressed: () => _answer(i),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color,
                              padding: const EdgeInsets.all(16)),
                          child: Text(_questions[_index]['options'][i],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                        ),
                      )),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 2: Desplazamiento (Drag Target)
class Juego2Desplazamiento extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego2Desplazamiento(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego2Desplazamiento> createState() => _Juego2DesplazamientoState();
}

class _Juego2DesplazamientoState extends State<Juego2Desplazamiento> {
  int _seconds = 0;
  Timer? _timer;
  final Map<String, String> _animals = {
    'Pájaro': 'Vuela',
    'Pez': 'Nada',
    'Perro': 'Camina',
    'Serpiente': 'Repta'
  };
  final Map<String, bool> _matched = {};
  int _score = 0;

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
              Text('🐾', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Desplazamiento',
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Arrastra el animal a su forma de moverse',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _animals.keys
                    .map((animal) => Draggable<String>(
                          data: animal,
                          feedback: Material(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: widget.color,
                                  child: Text(animal,
                                      style: const TextStyle(
                                          color: Colors.white)))),
                          childWhenDragging: Container(
                              width: 80, height: 40, color: Colors.grey[300]),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: _matched.containsKey(animal)
                                      ? Colors.green
                                      : widget.color,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(animal,
                                  style: const TextStyle(color: Colors.white))),
                        ))
                    .toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _animals.values
                    .toSet()
                    .map((action) => DragTarget<String>(
                          onAccept: (data) {
                            if (_animals[data] == action) {
                              setState(() {
                                _matched[data] = true;
                                _score += 25;
                              });
                              HapticFeedback.mediumImpact();
                              if (_matched.length == _animals.length) {
                                _timer?.cancel();
                                Future.delayed(Duration(milliseconds: 500), () {
                                  widget.onGameCompleted(_score);
                                });
                              }
                            } else {
                              HapticFeedback.vibrate();
                            }
                          },
                          builder: (context, _, __) => Container(
                            width: 100,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: widget.color),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(action),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: Alimentación (True/False)
class Juego3Alimentacion extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego3Alimentacion(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego3Alimentacion> createState() => _Juego3AlimentacionState();
}

class _Juego3AlimentacionState extends State<Juego3Alimentacion> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {'text': 'El León come carne (Carnívoro)', 'isTrue': true},
    {'text': 'La Vaca come carne', 'isTrue': false},
    {'text': 'El Conejo come plantas (Herbívoro)', 'isTrue': true},
    {'text': 'El Tigre come pasto', 'isTrue': false},
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

  void _answer(bool value) {
    bool isCorrect = value == _questions[_index]['isTrue'];
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
              Text('🐾', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Alimentación',
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
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20)),
                      child: const Text('Verdadero',
                          style: TextStyle(fontSize: 18, color: Colors.white))),
                  ElevatedButton(
                      onPressed: () => _answer(false),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20)),
                      child: const Text('Falso',
                          style: TextStyle(fontSize: 18, color: Colors.white))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 4: Hábitat (Selection)
class Juego4Habitat extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego4Habitat(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego4Habitat> createState() => _Juego4HabitatState();
}

class _Juego4HabitatState extends State<Juego4Habitat> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {
      'animal': 'Ballena',
      'options': ['Mar', 'Bosque', 'Desierto'],
      'correct': 0
    },
    {
      'animal': 'Mono',
      'options': ['Mar', 'Selva', 'Polo Norte'],
      'correct': 1
    },
    {
      'animal': 'Camello',
      'options': ['Río', 'Desierto', 'Selva'],
      'correct': 1
    },
    {
      'animal': 'Pingüino',
      'options': ['Desierto', 'Hielo/Polo', 'Selva'],
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
              Text('🐾', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Hábitat',
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
              Text('¿Dónde vive el/la ${_questions[_index]['animal']}?',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
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
class Juego5QuizAnimales extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego5QuizAnimales(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego5QuizAnimales> createState() => _Juego5QuizAnimalesState();
}

class _Juego5QuizAnimalesState extends State<Juego5QuizAnimales> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {
      'q': '¿Qué animal tiene plumas?',
      'a': ['Perro', 'Águila', 'Serpiente'],
      'c': 1
    },
    {
      'q': '¿Qué animal vive en el agua?',
      'a': ['Gato', 'Delfín', 'Elefante'],
      'c': 1
    },
    {
      'q': '¿Qué animal es carnívoro?',
      'a': ['Vaca', 'León', 'Conejo'],
      'c': 1
    },
    {
      'q': '¿Qué animal repta (se arrastra)?',
      'a': ['Serpiente', 'Pájaro', 'Caballo'],
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
                'Quiz de Animales',
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
