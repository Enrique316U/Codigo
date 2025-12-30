// ETAPA 5 - SECCIÓN 2 - NODO 5: BIODIVERSIDAD DEL PERÚ
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
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
  final int _maxGames = 3;

  void _onGameComplete(int score) {
    setState(() {
      _totalScore += score;
      _currentGame++;
    });

    if (_currentGame >= _maxGames) {
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    await ProgresoService().marcarActividadCompletada(widget.etapa,
        widget.seccion, widget.actividad, _totalScore ~/ _maxGames);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentGame >= _maxGames) {
      return _buildCompletionScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: widget.color,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: _buildCurrentGame(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.color.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Nivel ${_currentGame + 1}/$_maxGames',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: widget.color),
          ),
          Text(
            'Puntos: $_totalScore',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: widget.color),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentGame() {
    switch (_currentGame) {
      case 0:
        return Juego1RegionesNaturales(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2EspeciesPeligro(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3QuizBiodiversidad(
            color: widget.color, onGameComplete: _onGameComplete);
      default:
        return const Center(child: Text('¡Juego Terminado!'));
    }
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: widget.color,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Guardián de la Naturaleza!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Fantástico! Conoces muy bien la riqueza natural del Perú.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: widget.color),
                child: const Text('Volver al Mapa',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// JUEGO 1: REGIONES NATURALES (COSTA, SIERRA, SELVA)
class Juego1RegionesNaturales extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1RegionesNaturales(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1RegionesNaturales> createState() =>
      _Juego1RegionesNaturalesState();
}

class _Juego1RegionesNaturalesState extends State<Juego1RegionesNaturales> {
  int _score = 0;
  int _currentItem = 0;
  int _streak = 0;
  int _timeLeft = 60;
  Timer? _timer;
  final Random _random = Random();
  String? _feedbackMessage;
  Color? _feedbackColor;

  final List<Map<String, dynamic>> _items = [
    {'name': 'Pingüino de Humboldt', 'region': 'Costa', 'icon': '🐧'},
    {'name': 'Cóndor Andino', 'region': 'Sierra', 'icon': '🦅'},
    {'name': 'Jaguar', 'region': 'Selva', 'icon': '🐆'},
    {'name': 'Llama', 'region': 'Sierra', 'icon': '🦙'},
    {'name': 'Delfín Rosado', 'region': 'Selva', 'icon': '🐬'},
    {'name': 'Lobo Marino', 'region': 'Costa', 'icon': '🦭'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    widget.onGameComplete(_score);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItem >= _items.length || _timeLeft == 0) {
      return _buildCompletionScreen();
    }

    return Column(
      children: [
        _buildHeader(),
        if (_feedbackMessage != null) _buildFeedback(),
        const SizedBox(height: 20),
        const Text('¿A qué región pertenece?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_items[_currentItem]['icon'],
                          style: const TextStyle(fontSize: 80)),
                      const SizedBox(height: 10),
                      Text(_items[_currentItem]['name'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRegionButton('Costa', Colors.yellow.shade700),
              _buildRegionButton('Sierra', Colors.brown.shade600),
              _buildRegionButton('Selva', Colors.green.shade700),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.color.withOpacity(0.7), widget.color],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white),
              const SizedBox(width: 8),
              Text('$_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 8),
              Text('$_score pts',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          if (_streak >= 2)
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                Text('x$_streak',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      onEnd: () {
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            setState(() {
              _feedbackMessage = null;
              _feedbackColor = null;
            });
          }
        });
      },
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _feedbackColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_feedbackMessage!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
        );
      },
    );
  }

  Widget _buildRegionButton(String region, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () => _checkAnswer(region),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
          ),
          child: Text(region,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _checkAnswer(String selectedRegion) {
    final correctRegion = _items[_currentItem]['region'];
    final isCorrect = selectedRegion == correctRegion;

    setState(() {
      if (isCorrect) {
        int points = 20;
        _streak++;
        if (_streak >= 3) points += 10;
        if (_streak >= 5) points += 20;
        _score += points;
        _feedbackMessage = _streak >= 3
            ? '¡Correcto! +$points pts (Racha x$_streak)'
            : '¡Correcto! +$points pts';
        _feedbackColor = Colors.green;
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        _feedbackMessage = '¡Incorrecto! Era $correctRegion';
        _feedbackColor = Colors.red;
        HapticFeedback.heavyImpact();
      }
      _currentItem++;
    });
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('¡Nivel Completado!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score',
                style: TextStyle(fontSize: 24, color: widget.color)),
            const SizedBox(height: 10),
            Text('Especies: $_currentItem/${_items.length}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// JUEGO 2: ESPECIES EN PELIGRO
class Juego2EspeciesPeligro extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2EspeciesPeligro(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2EspeciesPeligro> createState() => _Juego2EspeciesPeligroState();
}

class _Juego2EspeciesPeligroState extends State<Juego2EspeciesPeligro> {
  int _score = 0;
  int _currentItem = 0;
  int _streak = 0;
  int _timeLeft = 50;
  Timer? _timer;
  final Random _random = Random();
  String? _feedbackMessage;
  Color? _feedbackColor;

  final List<Map<String, dynamic>> _items = [
    {'name': 'Oso de Anteojos', 'status': 'Peligro', 'icon': '🐻'},
    {'name': 'Perro', 'status': 'Seguro', 'icon': '🐕'},
    {'name': 'Gallito de las Rocas', 'status': 'Peligro', 'icon': '🐦'},
    {'name': 'Gato', 'status': 'Seguro', 'icon': '🐈'},
    {'name': 'Pava Aliblanca', 'status': 'Peligro', 'icon': '🦃'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    widget.onGameComplete(_score);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItem >= _items.length || _timeLeft == 0) {
      return _buildCompletionScreen();
    }

    return Column(
      children: [
        _buildHeader(),
        if (_feedbackMessage != null) _buildFeedback(),
        const SizedBox(height: 20),
        const Text('¿Está en peligro de extinción?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_items[_currentItem]['icon'],
                          style: const TextStyle(fontSize: 80)),
                      const SizedBox(height: 10),
                      Text(_items[_currentItem]['name'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _buildStatusButton(
                    'En Peligro', Icons.warning, Colors.red.shade600),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatusButton(
                    'A Salvo', Icons.check_circle, Colors.green.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.color.withOpacity(0.7), widget.color],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white),
              const SizedBox(width: 8),
              Text('$_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 8),
              Text('$_score pts',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          if (_streak >= 2)
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                Text('x$_streak',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      onEnd: () {
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            setState(() {
              _feedbackMessage = null;
              _feedbackColor = null;
            });
          }
        });
      },
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _feedbackColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_feedbackMessage!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(String status, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(status,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _checkAnswer(String selectedStatus) {
    final correctStatus = _items[_currentItem]['status'];
    final statusKey = selectedStatus == 'En Peligro' ? 'Peligro' : 'Seguro';
    final isCorrect = statusKey == correctStatus;

    setState(() {
      if (isCorrect) {
        int points = 20;
        _streak++;
        if (_streak >= 3) points += 10;
        if (_streak >= 5) points += 20;
        _score += points;
        _feedbackMessage = _streak >= 3
            ? '¡Correcto! +$points pts (Racha x$_streak)'
            : '¡Correcto! +$points pts';
        _feedbackColor = Colors.green;
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        final correctLabel =
            correctStatus == 'Peligro' ? 'En Peligro' : 'A Salvo';
        _feedbackMessage = '¡Incorrecto! Era $correctLabel';
        _feedbackColor = Colors.red;
        HapticFeedback.heavyImpact();
      }
      _currentItem++;
    });
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('¡Nivel Completado!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score',
                style: TextStyle(fontSize: 24, color: widget.color)),
            const SizedBox(height: 10),
            Text('Especies: $_currentItem/${_items.length}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// JUEGO 3: QUIZ BIODIVERSIDAD
class Juego3QuizBiodiversidad extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3QuizBiodiversidad(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3QuizBiodiversidad> createState() =>
      _Juego3QuizBiodiversidadState();
}

class _Juego3QuizBiodiversidadState extends State<Juego3QuizBiodiversidad> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  int _streak = 0;
  int _timeLeft = 45;
  Timer? _timer;
  String? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuál es el ave nacional del Perú?',
      'answers': ['Cóndor', 'Gallito de las Rocas', 'Águila', 'Loro'],
      'correctIndex': 1
    },
    {
      'question': '¿Qué región tiene más vegetación?',
      'answers': ['Costa', 'Sierra', 'Selva', 'Mar'],
      'correctIndex': 2
    },
    {
      'question': '¿Qué animal vive en los Andes?',
      'answers': ['León', 'Vicuña', 'Elefante', 'Ballena'],
      'correctIndex': 1
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    widget.onGameComplete(_score);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= _questions.length || _timeLeft == 0) {
      return _buildCompletionScreen();
    }

    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    question['question'],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                ...List.generate(question['answers'].length, (index) {
                  final isSelected =
                      _selectedAnswer == question['answers'][index];
                  final isCorrect = index == question['correctIndex'];
                  Color buttonColor;

                  if (_answered) {
                    if (isSelected && isCorrect) {
                      buttonColor = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      buttonColor = Colors.red;
                    } else if (isCorrect) {
                      buttonColor = Colors.green.shade300;
                    } else {
                      buttonColor = Colors.grey;
                    }
                  } else {
                    buttonColor = widget.color.withOpacity(0.8);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 200 + (index * 100)),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _answered ? null : () => _checkAnswer(index),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(18),
                                backgroundColor: buttonColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: _answered ? 2 : 5,
                              ),
                              child: Text(
                                question['answers'][index],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.color.withOpacity(0.7), widget.color],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white),
              const SizedBox(width: 8),
              Text('$_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 8),
              Text('$_score pts',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          if (_streak >= 2)
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                Text('x$_streak',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ),
    );
  }

  void _checkAnswer(int index) {
    final isCorrect =
        index == _questions[_currentQuestionIndex]['correctIndex'];

    setState(() {
      _answered = true;
      _selectedAnswer = _questions[_currentQuestionIndex]['answers'][index];
    });

    if (isCorrect) {
      int points = 30;
      _streak++;
      if (_streak >= 3) points += 15;
      _score += points;
      HapticFeedback.mediumImpact();
    } else {
      _streak = 0;
      HapticFeedback.heavyImpact();
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
          _selectedAnswer = null;
        });
      }
    });
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('¡Quiz Completado!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score',
                style: TextStyle(fontSize: 24, color: widget.color)),
            const SizedBox(height: 10),
            Text('Preguntas: $_currentQuestionIndex/${_questions.length}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
