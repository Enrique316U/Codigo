// ETAPA 2 - SECCIÓN 2 - NODO 5: EL AGUA Y SUS ESTADOS
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo5Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo5Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo5Screen> createState() => _MinijuegoNodo5ScreenState();
}

class _MinijuegoNodo5ScreenState extends State<MinijuegoNodo5Screen> {
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
        title: const Text("EL AGUA Y SUS ESTADOS",
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
        return Juego1EstadosDelAgua(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 1));
      case 2:
        return Juego2CicloDelAgua(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 2));
      case 3:
        return Juego3DondeHayAgua(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 3));
      case 4:
        return Juego4UsosDelAgua(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 4));
      case 5:
        return Juego5ExpertoAgua(
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
                  colors: [Color(0xFF2196F3), Color(0xFF42A5F5)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(children: [
              Text('💧', style: TextStyle(fontSize: 70)),
              SizedBox(height: 12),
              Text('¡El Agua es Vida!',
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
          _buildGameCard(1, '🧊 Estados del Agua', Icons.water_drop,
              'Sólido, Líquido, Gas', Color(0xFF2196F3)),
          _buildGameCard(2, '☁️ Ciclo del Agua', Icons.cloud,
              'Evaporación y Lluvia', Color(0xFF03A9F4)),
          _buildGameCard(3, '🌊 ¿Dónde hay Agua?', Icons.water,
              'Ríos, Mares, Lagos', Color(0xFF00BCD4)),
          _buildGameCard(4, '🚿 Usos del Agua', Icons.shower,
              '¿Para qué la usamos?', Color(0xFF0097A7)),
          _buildGameCard(5, '💦 Experto del Agua', Icons.verified,
              'Quiz completo', Color(0xFF006064)),
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

// JUEGO 1: Estados del Agua
class Juego1EstadosDelAgua extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego1EstadosDelAgua(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego1EstadosDelAgua> createState() => _Juego1EstadosDelAguaState();
}

class _Juego1EstadosDelAguaState extends State<Juego1EstadosDelAgua> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'El hielo es agua en estado...',
      'options': ['Sólido', 'Líquido', 'Gas'],
      'correct': 0
    },
    {
      'question': 'El vapor es agua en estado...',
      'options': ['Sólido', 'Líquido', 'Gas'],
      'correct': 2
    },
    {
      'question': 'El agua del río está en estado...',
      'options': ['Sólido', 'Líquido', 'Gas'],
      'correct': 1
    },
    {
      'question': 'La nieve es agua en estado...',
      'options': ['Sólido', 'Líquido', 'Gas'],
      'correct': 0
    },
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
    _questions.shuffle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _checkAnswer(int selectedIndex) {
    bool isCorrect = selectedIndex == _questions[_currentIndex]['correct'];

    if (isCorrect) {
      setState(() => _score += 25);
      HapticFeedback.mediumImpact();
      _showFeedback(true);
    } else {
      HapticFeedback.vibrate();
      _showFeedback(false);
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          if (_currentIndex >= _questions.length) {
            _timer?.cancel();
            widget.onGameCompleted(_score);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

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
              const Text('🧊', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'ESTADOS DEL AGUA',
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _questions[_currentIndex]['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(
                  (_questions[_currentIndex]['options'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: Text(
                        _questions[_currentIndex]['options'][index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pregunta ${_currentIndex + 1} de ${_questions.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// JUEGO 2: Ciclo del Agua
class Juego2CicloDelAgua extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego2CicloDelAgua(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego2CicloDelAgua> createState() => _Juego2CicloDelAguaState();
}

class _Juego2CicloDelAguaState extends State<Juego2CicloDelAgua> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué hace que el agua se evapore?',
      'options': ['El frío', 'El sol', 'La luna'],
      'correct': 1
    },
    {
      'question': '¿Qué son las nubes?',
      'options': ['Vapor de agua', 'Humo', 'Algodón'],
      'correct': 0
    },
    {
      'question': '¿Cómo se llama el agua que cae?',
      'options': ['Nieve', 'Lluvia', 'Ambas'],
      'correct': 2
    },
    {
      'question': '¿A dónde va el agua de lluvia?',
      'options': ['Desaparece', 'Ríos y mares', 'Al espacio'],
      'correct': 1
    },
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _checkAnswer(int selectedIndex) {
    bool isCorrect = selectedIndex == _questions[_currentIndex]['correct'];

    if (isCorrect) {
      setState(() => _score += 25);
      HapticFeedback.mediumImpact();
      _showFeedback(true);
    } else {
      HapticFeedback.vibrate();
      _showFeedback(false);
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          if (_currentIndex >= _questions.length) {
            _timer?.cancel();
            widget.onGameCompleted(_score);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

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
              const Text('☁️', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'CICLO DEL AGUA',
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.lightBlue, width: 2),
                  ),
                  child: Text(
                    _questions[_currentIndex]['question'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03A9F4),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(
                  (_questions[_currentIndex]['options'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF03A9F4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: Text(
                        _questions[_currentIndex]['options'][index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pregunta ${_currentIndex + 1} de ${_questions.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: ¿Dónde hay Agua?
class Juego3DondeHayAgua extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego3DondeHayAgua(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego3DondeHayAgua> createState() => _Juego3DondeHayAguaState();
}

class _Juego3DondeHayAguaState extends State<Juego3DondeHayAgua> {
  final List<Map<String, dynamic>> _questions = [
    {'question': '¿Hay agua en los ríos?', 'answer': true},
    {'question': '¿Hay agua en el desierto seco?', 'answer': false},
    {'question': '¿Hay agua en el mar?', 'answer': true},
    {'question': '¿Hay agua en las nubes?', 'answer': true},
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
    _questions.shuffle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _checkAnswer(bool userAnswer) {
    bool correctAnswer = _questions[_currentIndex]['answer'];
    bool isCorrect = userAnswer == correctAnswer;

    if (isCorrect) {
      setState(() => _score += 25);
      HapticFeedback.mediumImpact();
      _showFeedback(true);
    } else {
      HapticFeedback.vibrate();
      _showFeedback(false);
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          if (_currentIndex >= _questions.length) {
            _timer?.cancel();
            widget.onGameCompleted(_score);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

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
              const Text('🌊', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                '¿DÓNDE HAY AGUA?',
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    _questions[_currentIndex]['question'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BCD4),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _checkAnswer(true),
                      icon: const Icon(Icons.check_circle, size: 30),
                      label: const Text('SÍ', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () => _checkAnswer(false),
                      icon: const Icon(Icons.cancel, size: 30),
                      label: const Text('NO', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Pregunta ${_currentIndex + 1} de ${_questions.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// JUEGO 4: Usos del Agua
class Juego4UsosDelAgua extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego4UsosDelAgua(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego4UsosDelAgua> createState() => _Juego4UsosDelAguaState();
}

class _Juego4UsosDelAguaState extends State<Juego4UsosDelAgua> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Para qué usamos el agua en casa?',
      'options': ['Beber', 'Decorar', 'Dormir'],
      'correct': 0
    },
    {
      'question': '¿Qué necesita agua para crecer?',
      'options': ['El televisor', 'Las plantas', 'La computadora'],
      'correct': 1
    },
    {
      'question': '¿Dónde usamos agua para limpiarnos?',
      'options': ['En la cocina', 'En el baño', 'En la sala'],
      'correct': 1
    },
    {
      'question': '¿Los animales necesitan agua?',
      'options': ['Sí, para vivir', 'No', 'Solo algunos'],
      'correct': 0
    },
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _checkAnswer(int selectedIndex) {
    bool isCorrect = selectedIndex == _questions[_currentIndex]['correct'];

    if (isCorrect) {
      setState(() => _score += 25);
      HapticFeedback.mediumImpact();
      _showFeedback(true);
    } else {
      HapticFeedback.vibrate();
      _showFeedback(false);
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          if (_currentIndex >= _questions.length) {
            _timer?.cancel();
            widget.onGameCompleted(_score);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

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
              const Text('🚿', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'USOS DEL AGUA',
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.cyan.shade700, width: 2),
                  ),
                  child: Text(
                    _questions[_currentIndex]['question'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0097A7),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(
                  (_questions[_currentIndex]['options'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0097A7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: Text(
                        _questions[_currentIndex]['options'][index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pregunta ${_currentIndex + 1} de ${_questions.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// JUEGO 5: Experto del Agua
class Juego5ExpertoAgua extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego5ExpertoAgua(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego5ExpertoAgua> createState() => _Juego5ExpertoAguaState();
}

class _Juego5ExpertoAguaState extends State<Juego5ExpertoAgua> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Por qué es importante el agua?',
      'options': ['Para vivir', 'Para jugar', 'Para ver TV'],
      'correct': 0
    },
    {
      'question': '¿Debemos cuidar el agua?',
      'options': ['Sí, es limitada', 'No importa', 'Solo a veces'],
      'correct': 0
    },
    {
      'question': '¿Qué pasa si no hay agua?',
      'options': ['Todo sigue igual', 'No podemos vivir', 'Solo pasa calor'],
      'correct': 1
    },
    {
      'question': '¿Cómo cuidamos el agua?',
      'options': ['Desperdiciándola', 'Cerrando el grifo', 'Dejándola correr'],
      'correct': 1
    },
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _checkAnswer(int selectedIndex) {
    bool isCorrect = selectedIndex == _questions[_currentIndex]['correct'];

    if (isCorrect) {
      setState(() => _score += 25);
      HapticFeedback.mediumImpact();
      _showFeedback(true);
    } else {
      HapticFeedback.vibrate();
      _showFeedback(false);
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          if (_currentIndex >= _questions.length) {
            _timer?.cancel();
            widget.onGameCompleted(_score);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

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
              const Text('💦', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'EXPERTO DEL AGUA',
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.cyan.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    _questions[_currentIndex]['question'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006064),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(
                  (_questions[_currentIndex]['options'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006064),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                        elevation: 5,
                      ),
                      child: Text(
                        _questions[_currentIndex]['options'][index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    'Pregunta ${_currentIndex + 1} de ${_questions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006064),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
