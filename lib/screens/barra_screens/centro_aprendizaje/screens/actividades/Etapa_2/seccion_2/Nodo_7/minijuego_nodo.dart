// ETAPA 2 - SECCIÓN 2 - NODO 7: EL SONIDO
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo7Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo7Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo7Screen> createState() => _MinijuegoNodo7ScreenState();
}

class _MinijuegoNodo7ScreenState extends State<MinijuegoNodo7Screen> {
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
        title: const Text("EL SONIDO", style: TextStyle(color: Colors.white)),
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
        return Juego1FuerteDebil(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 1));
      case 2:
        return Juego2AgradableDesagradable(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 2));
      case 3:
        return Juego3IdentificaSonido(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 3));
      case 4:
        return Juego4Instrumentos(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 4));
      case 5:
        return Juego5QuizSonido(
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
                  colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(children: [
              Text('🔊', style: TextStyle(fontSize: 70)),
              SizedBox(height: 12),
              Text('¡El Mundo de los Sonidos!',
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
          _buildGameCard(1, '📢 Fuerte o Débil', Icons.volume_up,
              'Intensidad del sonido', Color(0xFF9C27B0)),
          _buildGameCard(2, '👍 ¿Te gusta?', Icons.thumb_up,
              'Agradable o Molesto', Color(0xFFEC407A)),
          _buildGameCard(3, '👂 ¿Quién suena así?', Icons.hearing,
              'Identifica la fuente', Color(0xFF42A5F5)),
          _buildGameCard(4, '🎸 Instrumentos', Icons.music_note,
              'Música y ritmo', Color(0xFFFF7043)),
          _buildGameCard(5, '🏆 Quiz Sonoro', Icons.quiz,
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

// JUEGO 1: Fuerte o Débil (Selection)
class Juego1FuerteDebil extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego1FuerteDebil(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego1FuerteDebil> createState() => _Juego1FuerteDebilState();
}

class _Juego1FuerteDebilState extends State<Juego1FuerteDebil> {
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
      'sound': 'Rugido de León',
      'options': ['Fuerte', 'Débil'],
      'correct': 0
    },
    {
      'sound': 'Susurro',
      'options': ['Fuerte', 'Débil'],
      'correct': 1
    },
    {
      'sound': 'Trueno',
      'options': ['Fuerte', 'Débil'],
      'correct': 0
    },
    {
      'sound': 'Caída de una hoja',
      'options': ['Fuerte', 'Débil'],
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
              const Text('🔊', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'FUERTE O DÉBIL',
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
              Text(_questions[_index]['sound'],
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

// JUEGO 2: Agradable o Desagradable (Selection)
class Juego2AgradableDesagradable extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego2AgradableDesagradable(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego2AgradableDesagradable> createState() =>
      _Juego2AgradableDesagradableState();
}

class _Juego2AgradableDesagradableState
    extends State<Juego2AgradableDesagradable> {
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
      'sound': 'Música suave',
      'options': ['Agradable', 'Molesto'],
      'correct': 0
    },
    {
      'sound': 'Taladro en la calle',
      'options': ['Agradable', 'Molesto'],
      'correct': 1
    },
    {
      'sound': 'Canto de pájaros',
      'options': ['Agradable', 'Molesto'],
      'correct': 0
    },
    {
      'sound': 'Grito fuerte',
      'options': ['Agradable', 'Molesto'],
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
              const Text('🎵', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'AGRADABLE O MOLESTO',
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
              Text(_questions[_index]['sound'],
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

// JUEGO 3: Identifica el Sonido (Selection)
class Juego3IdentificaSonido extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego3IdentificaSonido(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego3IdentificaSonido> createState() => _Juego3IdentificaSonidoState();
}

class _Juego3IdentificaSonidoState extends State<Juego3IdentificaSonido> {
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
      'sound': 'Muuu',
      'options': ['Vaca', 'Gato', 'Pato'],
      'correct': 0
    },
    {
      'sound': 'Ring Ring',
      'options': ['Teléfono', 'Puerta', 'Perro'],
      'correct': 0
    },
    {
      'sound': 'Tic Tac',
      'options': ['Reloj', 'Corazón', 'Tambor'],
      'correct': 0
    },
    {
      'sound': 'Guau Guau',
      'options': ['Perro', 'Gato', 'Vaca'],
      'correct': 0
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
              const Text('👂', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'IDENTIFICA EL SONIDO',
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
              Text('¿Qué hace este sonido?',
                  style: TextStyle(fontSize: 22, color: widget.color)),
              const SizedBox(height: 20),
              Text(_questions[_index]['sound'],
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 40),
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

// JUEGO 4: Instrumentos (Selection)
class Juego4Instrumentos extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego4Instrumentos(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego4Instrumentos> createState() => _Juego4InstrumentosState();
}

class _Juego4InstrumentosState extends State<Juego4Instrumentos> {
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
      'item': 'Guitarra',
      'options': ['Cuerdas', 'Viento', 'Percusión'],
      'correct': 0
    },
    {
      'item': 'Tambor',
      'options': ['Percusión', 'Cuerdas', 'Viento'],
      'correct': 0
    },
    {
      'item': 'Flauta',
      'options': ['Viento', 'Percusión', 'Cuerdas'],
      'correct': 0
    },
    {
      'item': 'Violín',
      'options': ['Cuerdas', 'Viento', 'Percusión'],
      'correct': 0
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
              const Text('🎸', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'INSTRUMENTOS',
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
              Text('¿Qué tipo de instrumento es?',
                  style: TextStyle(fontSize: 22, color: widget.color)),
              const SizedBox(height: 20),
              Text(_questions[_index]['item'],
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
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
class Juego5QuizSonido extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego5QuizSonido(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego5QuizSonido> createState() => _Juego5QuizSonidoState();
}

class _Juego5QuizSonidoState extends State<Juego5QuizSonido> {
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
      'q': '¿Con qué sentido escuchamos?',
      'a': ['Oído', 'Vista', 'Tacto'],
      'c': 0
    },
    {
      'q': 'El sonido de una ambulancia es...',
      'a': ['Fuerte', 'Débil', 'Silencioso'],
      'c': 0
    },
    {
      'q': '¿Qué produce música?',
      'a': ['Instrumentos', 'Piedras', 'Sillas'],
      'c': 0
    },
    {
      'q': 'El ruido muy fuerte puede...',
      'a': ['Dañar los oídos', 'Ayudar a dormir', 'Curar'],
      'c': 0
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
                'QUIZ DEL SONIDO',
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
