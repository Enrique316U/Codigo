// ETAPA 2 - SECCIÓN 2 - NODO 6: FUERZAS SIMPLES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo6Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo6Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo6Screen> createState() => _MinijuegoNodo6ScreenState();
}

class _MinijuegoNodo6ScreenState extends State<MinijuegoNodo6Screen> {
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
        title: const Text("FUERZAS SIMPLES",
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
        return Juego1EmpujarJalar(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 1));
      case 2:
        return Juego2PesadoLigero(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 2));
      case 3:
        return Juego3Movimiento(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 3));
      case 4:
        return Juego4Direccion(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 4));
      case 5:
        return Juego5QuizFuerzas(
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
                  colors: [Color(0xFFF44336), Color(0xFFEF5350)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(children: [
              Text('💪', style: TextStyle(fontSize: 70)),
              SizedBox(height: 12),
              Text('¡Fuerza y Movimiento!',
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
          _buildGameCard(1, '↔️ Empujar o Jalar', Icons.compare_arrows,
              '¿Cómo lo mueves?', Color(0xFFF44336)),
          _buildGameCard(2, '🏋️ Pesado o Ligero', Icons.fitness_center,
              '¿Cuesta moverlo?', Color(0xFFFF7043)),
          _buildGameCard(3, '🚗 ¿Se mueve solo?', Icons.directions_car,
              'Seres vivos vs Objetos', Color(0xFF42A5F5)),
          _buildGameCard(4, '🧭 Direcciones', Icons.navigation,
              'Arriba, Abajo, Izquierda...', Color(0xFF9575CD)),
          _buildGameCard(5, '🏆 Quiz de Fuerzas', Icons.quiz,
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

// JUEGO 1: Empujar o Jalar (Selection)
class Juego1EmpujarJalar extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego1EmpujarJalar(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego1EmpujarJalar> createState() => _Juego1EmpujarJalarState();
}

class _Juego1EmpujarJalarState extends State<Juego1EmpujarJalar> {
  int _index = 0;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _seconds++);
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : 'Incorrecto ✗';
      _feedbackColor =
          isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _lastFeedback = null);
    });
  }

  final List<Map<String, dynamic>> _questions = [
    {
      'action': 'Mover un carrito de compras',
      'options': ['Empujar', 'Jalar'],
      'correct': 0
    },
    {
      'action': 'Sacar un juguete de una caja',
      'options': ['Empujar', 'Jalar'],
      'correct': 1
    },
    {
      'action': 'Cerrar un cajón',
      'options': ['Empujar', 'Jalar'],
      'correct': 0
    },
    {
      'action': 'Arrastrar un trineo',
      'options': ['Empujar', 'Jalar'],
      'correct': 1
    },
  ];

  void _answer(int i) {
    bool isCorrect = i == _questions[_index]['correct'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(const Duration(milliseconds: 800), () {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const Text('💪', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'EMPUJAR O JALAR',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pregunta ${_index + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 20),
              Text(_questions[_index]['action'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
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

// JUEGO 2: Pesado o Ligero (Selection)
class Juego2PesadoLigero extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego2PesadoLigero(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego2PesadoLigero> createState() => _Juego2PesadoLigeroState();
}

class _Juego2PesadoLigeroState extends State<Juego2PesadoLigero> {
  int _index = 0;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _seconds++);
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : 'Incorrecto ✗';
      _feedbackColor =
          isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _lastFeedback = null);
    });
  }

  final List<Map<String, dynamic>> _questions = [
    {
      'item': 'Elefante',
      'options': ['Pesado', 'Ligero'],
      'correct': 0
    },
    {
      'item': 'Pluma',
      'options': ['Pesado', 'Ligero'],
      'correct': 1
    },
    {
      'item': 'Coche',
      'options': ['Pesado', 'Ligero'],
      'correct': 0
    },
    {
      'item': 'Globo',
      'options': ['Pesado', 'Ligero'],
      'correct': 1
    },
  ];

  void _answer(int i) {
    bool isCorrect = i == _questions[_index]['correct'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(const Duration(milliseconds: 800), () {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const Text('⚖️', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'PESADO O LIGERO',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pregunta ${_index + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
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

// JUEGO 3: Movimiento (True/False)
class Juego3Movimiento extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego3Movimiento(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego3Movimiento> createState() => _Juego3MovimientoState();
}

class _Juego3MovimientoState extends State<Juego3Movimiento> {
  int _index = 0;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _seconds++);
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : 'Incorrecto ✗';
      _feedbackColor =
          isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _lastFeedback = null);
    });
  }

  final List<Map<String, dynamic>> _questions = [
    {'text': 'Un perro se mueve solo', 'isTrue': true},
    {'text': 'Una piedra se mueve sola', 'isTrue': false},
    {'text': 'Un pájaro vuela solo', 'isTrue': true},
    {'text': 'Una silla camina sola', 'isTrue': false},
  ];

  void _answer(bool val) {
    bool isCorrect = val == _questions[_index]['isTrue'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(const Duration(milliseconds: 800), () {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const Text('🏃', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'MOVIMIENTO',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pregunta ${_index + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 20),
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

// JUEGO 4: Direcciones (Selection)
class Juego4Direccion extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego4Direccion(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego4Direccion> createState() => _Juego4DireccionState();
}

class _Juego4DireccionState extends State<Juego4Direccion> {
  int _index = 0;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _seconds++);
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : 'Incorrecto ✗';
      _feedbackColor =
          isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _lastFeedback = null);
    });
  }

  final List<Map<String, dynamic>> _questions = [
    {
      'icon': Icons.arrow_upward,
      'options': ['Arriba', 'Abajo'],
      'correct': 0
    },
    {
      'icon': Icons.arrow_downward,
      'options': ['Arriba', 'Abajo'],
      'correct': 1
    },
    {
      'icon': Icons.arrow_forward,
      'options': ['Derecha', 'Izquierda'],
      'correct': 0
    },
    {
      'icon': Icons.arrow_back,
      'options': ['Derecha', 'Izquierda'],
      'correct': 1
    },
  ];

  void _answer(int i) {
    bool isCorrect = i == _questions[_index]['correct'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(const Duration(milliseconds: 800), () {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const Text('🧭', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'DIRECCIONES',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pregunta ${_index + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 20),
              Icon(_questions[_index]['icon'], size: 100, color: widget.color),
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

// JUEGO 5: Quiz Final
class Juego5QuizFuerzas extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego5QuizFuerzas(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego5QuizFuerzas> createState() => _Juego5QuizFuerzasState();
}

class _Juego5QuizFuerzasState extends State<Juego5QuizFuerzas> {
  int _index = 0;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _seconds++);
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : 'Incorrecto ✗';
      _feedbackColor =
          isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _lastFeedback = null);
    });
  }

  final List<Map<String, dynamic>> _questions = [
    {
      'q': 'Para mover algo pesado necesitamos...',
      'a': ['Mucha fuerza', 'Poca fuerza', 'Dormir'],
      'c': 0
    },
    {
      'q': 'Si empujo una pared...',
      'a': ['Se mueve', 'No se mueve', 'Se rompe'],
      'c': 1
    },
    {
      'q': 'Para abrir una puerta hacia mí...',
      'a': ['Empujo', 'Jalo', 'Soplo'],
      'c': 1
    },
    {
      'q': '¿Qué es más fácil de mover?',
      'a': ['Un camión', 'Una pelota', 'Una casa'],
      'c': 1
    },
  ];

  void _answer(int i) {
    bool isCorrect = i == _questions[_index]['c'];
    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
    _showFeedback(isCorrect);

    Future.delayed(const Duration(milliseconds: 800), () {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'QUIZ DE FUERZAS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pregunta ${_index + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 20),
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
