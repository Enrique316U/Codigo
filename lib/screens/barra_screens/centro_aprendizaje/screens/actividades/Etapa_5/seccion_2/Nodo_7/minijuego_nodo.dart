// ETAPA 5 - SECCIÓN 2 - NODO 7: ECOSISTEMAS E INVENTOS
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
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
        return Juego1CadenaAlimenticia(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Inventos(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3QuizFinal(
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
              Icon(Icons.emoji_objects, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Innovador Ecológico!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Has completado la Etapa 5! Eres un experto en ciencia y tecnología.',
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

// JUEGO 1: CADENA ALIMENTICIA
class Juego1CadenaAlimenticia extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1CadenaAlimenticia(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1CadenaAlimenticia> createState() =>
      _Juego1CadenaAlimenticiaState();
}

class _Juego1CadenaAlimenticiaState extends State<Juego1CadenaAlimenticia> {
  int _score = 0;
  int _attempts = 0;
  int _timeLeft = 50;
  Timer? _timer;
  String? _feedbackMessage;
  Color? _feedbackColor;

  final List<String?> _slots = [null, null, null];
  final List<Map<String, dynamic>> _options = [
    {'name': 'Pasto', 'type': 'Productor', 'icon': '🌿'},
    {'name': 'Vaca', 'type': 'Consumidor', 'icon': '🐄'},
    {'name': 'Hongo', 'type': 'Descomponedor', 'icon': '🍄'},
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
    bool isComplete = _slots.every((element) => element != null);

    if (isComplete) {
      bool correct = _slots[0] == 'Productor' &&
          _slots[1] == 'Consumidor' &&
          _slots[2] == 'Descomponedor';

      if (correct && _score == 0) {
        _score = 100 + (_timeLeft * 2);
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) _endGame();
        });
      } else if (!correct && _feedbackMessage == null) {
        _attempts++;
        _feedbackMessage = 'Orden incorrecto, intenta de nuevo';
        _feedbackColor = Colors.red;
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              for (int i = 0; i < 3; i++) _slots[i] = null;
              _feedbackMessage = null;
              _feedbackColor = null;
            });
          }
        });
      }
    }

    if (_score > 0) {
      return _buildCompletionScreen();
    }

    return Column(
      children: [
        _buildHeader(),
        if (_feedbackMessage != null) _buildFeedback(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Ordena la Cadena Alimenticia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Text('(Productor → Consumidor → Descomponedor)',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              final labels = [
                '1º\nProductor',
                '2º\nConsumidor',
                '3º\nDescomp.'
              ];
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            _slots[index] != null ? Colors.green : widget.color,
                        width: 3),
                    borderRadius: BorderRadius.circular(15),
                    color: _slots[index] != null
                        ? Colors.green.withOpacity(0.2)
                        : widget.color.withOpacity(0.1),
                  ),
                  child: Center(
                    child: _slots[index] != null
                        ? TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.5, end: 1.0),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: Text(_getIconForType(_slots[index]!),
                                    style: const TextStyle(fontSize: 50)),
                              );
                            },
                          )
                        : Text(labels[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 40),
        const Text('Selecciona en orden:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: _options.map((opt) {
            final isUsed = _slots.contains(opt['type']);
            return GestureDetector(
              onTap: isUsed
                  ? null
                  : () {
                      setState(() {
                        final nextSlot = _slots.indexOf(null);
                        if (nextSlot != -1) {
                          _slots[nextSlot] = opt['type'];
                          HapticFeedback.lightImpact();
                        }
                      });
                    },
              child: Opacity(
                opacity: isUsed ? 0.3 : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: widget.color, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(opt['icon'], style: const TextStyle(fontSize: 50)),
                      const SizedBox(height: 5),
                      Text(opt['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_slots.any((s) => s != null))
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 3; i++) _slots[i] = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
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
          Text('Intentos: $_attempts',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
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

  Widget _buildCompletionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('¡Cadena Correcta!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score',
                style: TextStyle(fontSize: 24, color: widget.color)),
            const SizedBox(height: 10),
            Text('Intentos: $_attempts', style: const TextStyle(fontSize: 18)),
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

  String _getIconForType(String type) {
    final opt = _options.firstWhere((element) => element['type'] == type,
        orElse: () => {'icon': '?'});
    return opt['icon'];
  }
}

// JUEGO 2: INVENTOS Y PROBLEMAS
class Juego2Inventos extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Inventos(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Inventos> createState() => _Juego2InventosState();
}

class _Juego2InventosState extends State<Juego2Inventos> {
  int _score = 0;
  int _currentItem = 0;
  int _streak = 0;
  int _timeLeft = 50;
  Timer? _timer;
  final Random _random = Random();
  String? _feedbackMessage;
  Color? _feedbackColor;

  final List<Map<String, dynamic>> _items = [
    {
      'problem': 'Necesito ver en la oscuridad',
      'invention': 'Bombilla',
      'icon': '💡'
    },
    {
      'problem': 'Quiero hablar con alguien lejos',
      'invention': 'Teléfono',
      'icon': '📞'
    },
    {'problem': 'Necesito viajar rápido', 'invention': 'Avión', 'icon': '✈️'},
    {
      'problem': 'Quiero guardar comida fría',
      'invention': 'Refrigerador',
      'icon': '❄️'
    },
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text('Problema:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                const SizedBox(height: 8),
                Text(_items[_currentItem]['problem'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text('¿Qué invento lo resuelve?',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(20),
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.0,
            children: [
              _buildOption('Bombilla', '💡'),
              _buildOption('Teléfono', '📞'),
              _buildOption('Avión', '✈️'),
              _buildOption('Refrigerador', '❄️'),
            ],
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

  Widget _buildOption(String invention, String icon) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: ElevatedButton(
            onPressed: () => _checkAnswer(invention),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color.withOpacity(0.8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              padding: const EdgeInsets.all(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 45)),
                const SizedBox(height: 10),
                Text(invention,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkAnswer(String invention) {
    final correctInvention = _items[_currentItem]['invention'];
    final isCorrect = invention == correctInvention;

    setState(() {
      if (isCorrect) {
        int points = 25;
        _streak++;
        if (_streak >= 3) points += 15;
        _score += points;
        _feedbackMessage = _streak >= 3
            ? '¡Correcto! +$points pts (Racha x$_streak)'
            : '¡Correcto! +$points pts';
        _feedbackColor = Colors.green;
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        _feedbackMessage = '¡Incorrecto! Era $correctInvention';
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
            Text('Inventos: $_currentItem/${_items.length}',
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

// JUEGO 3: QUIZ FINAL
class Juego3QuizFinal extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3QuizFinal(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3QuizFinal> createState() => _Juego3QuizFinalState();
}

class _Juego3QuizFinalState extends State<Juego3QuizFinal> {
  int score = 0;
  int currentQuestionIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '¿Quién inventó la bombilla eléctrica?',
      'answers': ['Edison', 'Einstein', 'Newton', 'Tesla'],
      'correctIndex': 0
    },
    {
      'question': '¿Qué animal es un productor?',
      'answers': ['León', 'Ninguno (son plantas)', 'Vaca', 'Águila'],
      'correctIndex': 1
    },
    {
      'question': 'Un ecosistema incluye...',
      'answers': [
        'Solo animales',
        'Solo plantas',
        'Seres vivos y su medio',
        'Rocas'
      ],
      'correctIndex': 2
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (currentQuestionIndex >= questions.length) {
      return Center(
        child: ElevatedButton(
          onPressed: () => widget.onGameComplete(score),
          child: Text('¡Quiz Completado! ($score pts)'),
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question['question'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...List.generate(question['answers'].length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: widget.color.withOpacity(0.8),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    question['answers'][index],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _checkAnswer(int index) {
    if (index == questions[currentQuestionIndex]['correctIndex']) {
      score += 30;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentQuestionIndex++;
    });
  }
}
