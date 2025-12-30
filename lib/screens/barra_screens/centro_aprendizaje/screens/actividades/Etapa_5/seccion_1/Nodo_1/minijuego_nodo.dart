// ETAPA 5 - SECCIÓN 1 - NODO 1: SISTEMAS DEL CUERPO HUMANO (VERSIÓN DINÁMICA)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo1Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo1Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo1Screen> createState() => _MinijuegoNodo1ScreenState();
}

class _MinijuegoNodo1ScreenState extends State<MinijuegoNodo1Screen> {
  int _currentGame = 0;
  int _totalScore = 0;
  final int _maxGames = 5;

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
        return Juego1Circulatorio(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Nervioso(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Organos(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4HabitosSaludables(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizCuerpo(
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
              Icon(Icons.accessibility_new, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Experto en Anatomía!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Increíble! Conoces muy bien cómo funciona tu cuerpo.',
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

// JUEGO 1: RITMO CARDÍACO - Toca el corazón al ritmo correcto
class Juego1Circulatorio extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1Circulatorio(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1Circulatorio> createState() => _Juego1CirculatorioState();
}

class _Juego1CirculatorioState extends State<Juego1Circulatorio>
    with SingleTickerProviderStateMixin {
  int _taps = 0;
  int _targetTaps = 10;
  int _timeLeft = 15;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _combo = 0;
  bool _isGameActive = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  void _handleTap() {
    if (!_isGameActive) return;
    setState(() {
      _taps++;
      _combo++;
      if (_taps >= _targetTaps) {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    _isGameActive = false;
    int score = (_taps * 10) + (_combo * 2);
    if (_taps >= _targetTaps) score += 50; // Bonus por completar
    widget.onGameComplete(score.clamp(0, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.red[100]!, Colors.red[50]!, Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¡Mantén el ritmo cardíaco!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Toca el corazón $_targetTaps veces',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                  'Tiempo', '$_timeLeft s', Icons.timer, Colors.orange),
              _buildStatCard(
                  'Latidos', '$_taps/$_targetTaps', Icons.favorite, Colors.red),
              _buildStatCard(
                  'Combo', 'x$_combo', Icons.bolt, Colors.yellow[700]!),
            ],
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: _handleTap,
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child:
                    const Icon(Icons.favorite, size: 100, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 40),
          LinearProgressIndicator(
            value: _taps / _targetTaps,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          const SizedBox(height: 10),
          Text(
            _taps >= _targetTaps ? '¡COMPLETADO!' : 'Sigue tocando...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _taps >= _targetTaps ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

// JUEGO 2: REFLEJOS - Toca los estímulos lo más rápido posible
class Juego2Nervioso extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Nervioso(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Nervioso> createState() => _Juego2NerviosoState();
}

class _Juego2NerviosoState extends State<Juego2Nervioso> {
  int _score = 0;
  int _tapsCompleted = 0;
  int _targetTaps = 8;
  final Random _random = Random();
  Offset? _targetPosition;
  Timer? _targetTimer;
  int _missedTargets = 0;
  int _reactionTimeTotal = 0;
  DateTime? _targetAppearTime;

  @override
  void initState() {
    super.initState();
    _spawnTarget();
  }

  void _spawnTarget() {
    if (_tapsCompleted >= _targetTaps) {
      _endGame();
      return;
    }

    setState(() {
      _targetPosition = Offset(
        _random.nextDouble() * 280 + 20, // 20-300
        _random.nextDouble() * 380 + 100, // 100-480
      );
      _targetAppearTime = DateTime.now();
    });

    // Auto-desaparecer después de 2 segundos
    _targetTimer?.cancel();
    _targetTimer = Timer(const Duration(milliseconds: 2000), () {
      if (_tapsCompleted < _targetTaps) {
        setState(() {
          _missedTargets++;
          _targetPosition = null;
        });
        Future.delayed(const Duration(milliseconds: 500), _spawnTarget);
      }
    });
  }

  void _handleTap() {
    if (_targetPosition == null) return;

    int reactionTime =
        DateTime.now().difference(_targetAppearTime!).inMilliseconds;
    _reactionTimeTotal += reactionTime;

    setState(() {
      _tapsCompleted++;
      int points = 15;
      if (reactionTime < 500) points += 10; // Bonus por rapidez
      if (reactionTime < 300) points += 15; // Super bonus
      _score += points;
      _targetPosition = null;
    });

    _targetTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 400), _spawnTarget);
  }

  void _endGame() {
    _targetTimer?.cancel();
    int avgReaction =
        _reactionTimeTotal ~/ (_tapsCompleted > 0 ? _tapsCompleted : 1);
    int finalScore = _score - (_missedTargets * 10);
    if (avgReaction < 400) finalScore += 20; // Bonus por reflejos rápidos
    widget.onGameComplete(finalScore.clamp(0, 100));
  }

  @override
  void dispose() {
    _targetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int avgReaction =
        _tapsCompleted > 0 ? _reactionTimeTotal ~/ _tapsCompleted : 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple[100]!, Colors.blue[50]!, Colors.white],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            '¡Prueba tus reflejos!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Toca los objetivos lo más rápido posible',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip('Tocados', '$_tapsCompleted/$_targetTaps',
                  Icons.touch_app, Colors.green),
              _buildStatChip(
                  'Fallados', '$_missedTargets', Icons.close, Colors.red),
              _buildStatChip(
                  'Tiempo', '${avgReaction}ms', Icons.speed, Colors.blue),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                if (_targetPosition != null)
                  Positioned(
                    left: _targetPosition!.dx,
                    top: _targetPosition!.dy,
                    child: GestureDetector(
                      onTap: _handleTap,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.yellow,
                                    Colors.orange,
                                    Colors.red
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.6),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.bolt,
                                  size: 40, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _tapsCompleted / _targetTaps,
                  minHeight: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
                const SizedBox(height: 10),
                Text(
                  'Puntuación: $_score',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
      String label, String value, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, color: color, size: 20),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}

// JUEGO 3: QUIZ DE ÓRGANOS - Responde rápido antes que se acabe el tiempo
class Juego3Organos extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Organos(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Organos> createState() => _Juego3OrganosState();
}

class _Juego3OrganosState extends State<Juego3Organos> {
  int _score = 0;
  int _currentQuestion = 0;
  int _timeLeft = 5;
  Timer? _timer;
  String? _selectedAnswer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Bombea sangre por todo el cuerpo',
      'correct': 'Corazón',
      'options': ['Corazón', 'Cerebro', 'Pulmones'],
      'icon': '❤️'
    },
    {
      'question': 'Controla los movimientos y pensamientos',
      'correct': 'Cerebro',
      'options': ['Cerebro', 'Estómago', 'Riñones'],
      'icon': '🧠'
    },
    {
      'question': 'Filtra y limpia la sangre',
      'correct': 'Riñones',
      'options': ['Riñones', 'Hígado', 'Corazón'],
      'icon': '🫘'
    },
    {
      'question': 'Digiere los alimentos',
      'correct': 'Estómago',
      'options': ['Estómago', 'Intestinos', 'Páncreas'],
      'icon': '🥣'
    },
    {
      'question': 'Permiten respirar y obtener oxígeno',
      'correct': 'Pulmones',
      'options': ['Pulmones', 'Corazón', 'Cerebro'],
      'icon': '🫁'
    },
  ];

  @override
  void initState() {
    super.initState();
    _questions.shuffle(_random);
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 5;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    setState(() {
      _selectedAnswer = null;
      _currentQuestion++;
    });
    if (_currentQuestion < _questions.length) {
      Future.delayed(const Duration(milliseconds: 500), _startTimer);
    } else {
      widget.onGameComplete(_score.clamp(0, 100));
    }
  }

  void _handleAnswer(String answer) {
    _timer?.cancel();
    bool isCorrect = answer == _questions[_currentQuestion]['correct'];

    setState(() {
      _selectedAnswer = answer;
      if (isCorrect) {
        int points = 15 + (_timeLeft * 2); // Bonus por responder rápido
        _score += points;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
      });
      if (_currentQuestion < _questions.length) {
        _startTimer();
      } else {
        widget.onGameComplete(_score.clamp(0, 100));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion >= _questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text('¡Completado!\nPuntuación: $_score',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    var question = _questions[_currentQuestion];
    var options = List<String>.from(question['options']);
    options.shuffle(_random);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal[100]!, Colors.cyan[50]!, Colors.white],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Pregunta ${_currentQuestion + 1}/${_questions.length}',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: _timeLeft / 5,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _timeLeft > 2 ? Colors.green : Colors.red,
                  ),
                ),
              ),
              Text('$_timeLeft',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _timeLeft > 2 ? Colors.green : Colors.red,
                  )),
            ],
          ),
          const SizedBox(height: 30),
          Text(question['icon'], style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              question['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: options.length,
              itemBuilder: (context, index) {
                String option = options[index];
                bool isSelected = _selectedAnswer == option;
                bool isCorrect = option == question['correct'];
                Color? bgColor;

                if (_selectedAnswer != null) {
                  if (isSelected) {
                    bgColor = isCorrect ? Colors.green : Colors.red;
                  } else if (isCorrect) {
                    bgColor = Colors.green.withOpacity(0.5);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    onPressed: _selectedAnswer == null
                        ? () => _handleAnswer(option)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor ?? Colors.blue[50],
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: bgColor != null ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Puntuación: $_score',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// JUEGO 4: DECISIONES RÁPIDAS - Clasifica hábitos saludables o no saludables
class Juego4HabitosSaludables extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4HabitosSaludables(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4HabitosSaludables> createState() =>
      _Juego4HabitosSaludablesState();
}

class _Juego4HabitosSaludablesState extends State<Juego4HabitosSaludables> {
  int _score = 0;
  int _currentItem = 0;
  int _streak = 0;
  String? _feedback;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Hacer ejercicio diario', 'good': true, 'icon': '🏃'},
    {'name': 'Comer mucha comida chatarra', 'good': false, 'icon': '🍔'},
    {'name': 'Dormir 8 horas', 'good': true, 'icon': '😴'},
    {'name': 'Fumar cigarrillos', 'good': false, 'icon': '🚬'},
    {'name': 'Beber agua regularmente', 'good': true, 'icon': '💧'},
    {'name': 'Comer frutas y verduras', 'good': true, 'icon': '🥗'},
    {'name': 'Pasar todo el día sentado', 'good': false, 'icon': '🪑'},
    {'name': 'Lavarse las manos', 'good': true, 'icon': '🧼'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
  }

  void _handleDecision(bool isGoodDecision) {
    bool correct = isGoodDecision == _items[_currentItem]['good'];

    setState(() {
      if (correct) {
        _score += 15;
        _streak++;
        if (_streak >= 3) _score += 10; // Bonus por racha
        _feedback = '¡Correcto! +${15 + (_streak >= 3 ? 10 : 0)} pts';
      } else {
        _streak = 0;
        _feedback = '¡Incorrecto!';
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _currentItem++;
        _feedback = null;
        if (_currentItem >= _items.length) {
          widget.onGameComplete(_score.clamp(0, 100));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItem >= _items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.health_and_safety, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text('¡Hábitos aprendidos!\\nPuntuación: $_score',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green[100]!, Colors.lightGreen[50]!, Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Es un hábito saludable?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Racha: $_streak 🔥',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700])),
              const SizedBox(width: 20),
              Text('Puntos: $_score',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 30),
          TweenAnimationBuilder<double>(
            key: ValueKey(_currentItem),
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  Text(_items[_currentItem]['icon'],
                      style: const TextStyle(fontSize: 100)),
                  const SizedBox(height: 20),
                  Text(
                    _items[_currentItem]['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          if (_feedback != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color:
                    _feedback!.contains('Correcto') ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _feedback!,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _handleDecision(false),
                  icon: const Text('👎', style: TextStyle(fontSize: 30)),
                  label: const Text('NO SALUDABLE',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _handleDecision(true),
                  icon: const Text('👍', style: TextStyle(fontSize: 30)),
                  label: const Text('SALUDABLE',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: _currentItem / _items.length,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
    );
  }
}

// JUEGO 5: QUIZ FINAL - Preguntas variadas sobre el cuerpo humano
class Juego5QuizCuerpo extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizCuerpo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizCuerpo> createState() => _Juego5QuizCuerpoState();
}

class _Juego5QuizCuerpoState extends State<Juego5QuizCuerpo> {
  int _score = 0;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué órgano bombea la sangre?',
      'options': ['Cerebro', 'Corazón ❤️', 'Pulmones', 'Estómago'],
      'correct': 1,
      'explanation': 'El corazón bombea sangre a todo el cuerpo'
    },
    {
      'question': '¿Cuántos huesos tiene el cuerpo humano adulto?',
      'options': ['150', '180', '206', '300'],
      'correct': 2,
      'explanation': 'Un adulto tiene 206 huesos'
    },
    {
      'question': '¿Qué sistema ayuda a respirar?',
      'options': ['Digestivo', 'Nervioso', 'Respiratorio 🫁', 'Circulatorio'],
      'correct': 2,
      'explanation': 'El sistema respiratorio permite respirar'
    },
    {
      'question': '¿Qué órgano controla el pensamiento?',
      'options': ['Corazón', 'Estómago', 'Cerebro 🧠', 'Hígado'],
      'correct': 2,
      'explanation': 'El cerebro controla todo nuestro cuerpo'
    },
    {
      'question': '¿Cuánta agua debe tomar una persona al día aprox.?',
      'options': ['1 vaso', '2-3 vasos', '6-8 vasos 💧', '20 vasos'],
      'correct': 2,
      'explanation': 'Se recomienda 6-8 vasos de agua al día'
    },
  ];

  void _handleAnswer(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentQuestion]['correct']) {
        _score += 20;
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _answered = false;
      });
      if (_currentQuestion >= _questions.length) {
        widget.onGameComplete(_score.clamp(0, 100));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion >= _questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 120, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              '¡FELICIDADES!',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700]),
            ),
            const SizedBox(height: 10),
            Text(
              'Puntuación Final: $_score',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    var question = _questions[_currentQuestion];
    List<String> options = List<String>.from(question['options']);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo[100]!, Colors.purple[50]!, Colors.pink[50]!],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, spreadRadius: 2),
              ],
            ),
            child: Text(
              'Pregunta ${_currentQuestion + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.help_outline, size: 80, color: Colors.indigo),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              question['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: options.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedAnswer == index;
                bool isCorrect = index == question['correct'];
                Color? bgColor;
                IconData? icon;

                if (_answered) {
                  if (isSelected && isCorrect) {
                    bgColor = Colors.green;
                    icon = Icons.check_circle;
                  } else if (isSelected && !isCorrect) {
                    bgColor = Colors.red;
                    icon = Icons.cancel;
                  } else if (isCorrect) {
                    bgColor = Colors.green.withOpacity(0.5);
                    icon = Icons.check_circle_outline;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    elevation: isSelected ? 8 : 2,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: () => _handleAnswer(index),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: bgColor ?? Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? (bgColor ?? Colors.blue)
                                : Colors.grey[300]!,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (icon != null)
                              Icon(icon, color: Colors.white, size: 28)
                            else
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(
                                        65 + index), // A, B, C, D
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                options[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: bgColor != null
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_answered)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _selectedAnswer == question['correct']
                    ? Colors.green[100]
                    : Colors.orange[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _selectedAnswer == question['correct']
                      ? Colors.green
                      : Colors.orange,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: _selectedAnswer == question['correct']
                        ? Colors.green[700]
                        : Colors.orange[700],
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      question['explanation'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _selectedAnswer == question['correct']
                            ? Colors.green[900]
                            : Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Puntos: $_score',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _currentQuestion / _questions.length,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.indigo),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
