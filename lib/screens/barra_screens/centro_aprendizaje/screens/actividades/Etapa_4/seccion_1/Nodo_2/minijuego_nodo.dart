// ETAPA 4 - SECCIÓN 1 - NODO 2: CAMBIOS FÍSICOS Y QUÍMICOS
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
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
        return Juego1FisicoVsQuimico(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Mezclas(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Reversible(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4EstadosMateria(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizMateria(
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
              Icon(Icons.science, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Científico de la Materia!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Excelente! Entiendes cómo cambia la materia.',
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

// JUEGO 1: FÍSICO VS QUÍMICO
class Juego1FisicoVsQuimico extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1FisicoVsQuimico(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1FisicoVsQuimico> createState() => _Juego1FisicoVsQuimicoState();
}

class _Juego1FisicoVsQuimicoState extends State<Juego1FisicoVsQuimico> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Hielo derritiéndose', 'type': 'Físico', 'icon': '🧊'},
    {'name': 'Papel quemándose', 'type': 'Químico', 'icon': '🔥'},
    {'name': 'Romper un lápiz', 'type': 'Físico', 'icon': '✏️'},
    {'name': 'Oxidar un clavo', 'type': 'Químico', 'icon': '🔩'},
    {'name': 'Cortar fruta', 'type': 'Físico', 'icon': '🍎'},
    {'name': 'Cocinar un huevo', 'type': 'Químico', 'icon': '🍳'},
    {'name': 'Hervir agua', 'type': 'Físico', 'icon': '💧'},
    {'name': 'Hornear pan', 'type': 'Químico', 'icon': '🍞'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
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

  void _endGame() {
    _timer?.cancel();
    widget.onGameComplete(_score.clamp(0, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItem >= _items.length || _timeLeft == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Clasificación Completa!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score pts',
                style: const TextStyle(fontSize: 20)),
            if (_streak >= 3)
              Text('¡Racha máxima: $_streak! 🔥',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(_score.clamp(0, 100)),
              child: const Text('Finalizar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Item ${_currentItem + 1}/${_items.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.red),
                  const SizedBox(width: 5),
                  Text('$_timeLeft s',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
              if (_streak >= 3)
                Text('Racha: $_streak 🔥',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Text('¿Es un cambio Físico o Químico?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Draggable<String>(
                    data: _items[_currentItem]['type'],
                    feedback: Material(
                      color: Colors.transparent,
                      child: Text(_items[_currentItem]['icon'],
                          style: const TextStyle(fontSize: 80)),
                    ),
                    childWhenDragging: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade100,
                            Colors.blue.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.purple, width: 3),
                      ),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildZone('Físico', '🧊', Colors.blue),
            _buildZone('Químico', '🔥', Colors.orange),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: candidateData.isNotEmpty ? color : Colors.transparent,
                width: 3),
            boxShadow: candidateData.isNotEmpty
                ? [
                    BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 50)),
              Text(label,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        bool correct = data == label;
        setState(() {
          if (correct) {
            _streak++;
            _score += 12 + (_streak >= 3 ? 5 : 0);
            HapticFeedback.mediumImpact();
          } else {
            _streak = 0;
            HapticFeedback.heavyImpact();
          }
          _currentItem++;
        });
        if (_currentItem >= _items.length) {
          _endGame();
        }
      },
    );
  }
}

// JUEGO 2: MEZCLAS
class Juego2Mezclas extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Mezclas(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Mezclas> createState() => _Juego2MezclasState();
}

class _Juego2MezclasState extends State<Juego2Mezclas> {
  int _score = 0;
  int _currentExperiment = 0;
  int _timeLeft = 30;
  int _streak = 0;
  Timer? _timer;
  bool _showingResult = false;
  String? _feedback;
  final Random _random = Random();

  final List<Map<String, dynamic>> _experiments = [
    {
      'question': 'Vinagre + Bicarbonato',
      'reaction': 'Química',
      'icon': '🧪',
      'effect': '¡BURBUJAS! 💥'
    },
    {
      'question': 'Agua + Sal',
      'reaction': 'Física',
      'icon': '🧂',
      'effect': 'Se disuelve'
    },
    {
      'question': 'Limón + Bicarbonato',
      'reaction': 'Química',
      'icon': '🍋',
      'effect': '¡Efervescencia! 🫧'
    },
    {
      'question': 'Agua + Azúcar',
      'reaction': 'Física',
      'icon': '🍬',
      'effect': 'Se disuelve'
    },
    {
      'question': 'Vinagre + Leche',
      'reaction': 'Química',
      'icon': '🥛',
      'effect': '¡Se corta! 🧀'
    },
    {
      'question': 'Agua + Arena',
      'reaction': 'Física',
      'icon': '🏖️',
      'effect': 'Mezcla heterogénea'
    },
  ];

  @override
  void initState() {
    super.initState();
    _experiments.shuffle(_random);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_showingResult) {
        setState(() => _timeLeft--);
      } else if (_timeLeft == 0) {
        _endGame();
      }
    });
  }

  void _checkReaction(String answer) {
    if (_showingResult) return;

    bool correct = answer == _experiments[_currentExperiment]['reaction'];
    setState(() {
      _showingResult = true;
      if (correct) {
        _streak++;
        _score += 15 + (_streak >= 3 ? 7 : 0);
        _feedback = '¡Correcto! ${_experiments[_currentExperiment]['effect']}';
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        _feedback =
            'Era ${_experiments[_currentExperiment]['reaction']}. ${_experiments[_currentExperiment]['effect']}';
        HapticFeedback.heavyImpact();
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _currentExperiment++;
        _showingResult = false;
        _feedback = null;
      });
      if (_currentExperiment >= _experiments.length) {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    widget.onGameComplete(_score.clamp(0, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentExperiment >= _experiments.length || _timeLeft == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Experimentos Completados!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score pts',
                style: const TextStyle(fontSize: 20)),
            if (_streak >= 3)
              Text('¡Racha científica: $_streak! 🔬',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(_score.clamp(0, 100)),
              child: const Text('Finalizar'),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Exp. ${_currentExperiment + 1}/${_experiments.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.red),
                  const SizedBox(width: 5),
                  Text('$_timeLeft s',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
              if (_streak >= 3)
                Text('Racha: $_streak 🔥',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Text('¿Qué tipo de reacción es?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: 0.8, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade100, Colors.pink.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ],
                ),
                child: Column(
                  children: [
                    Text(_experiments[_currentExperiment]['icon'],
                        style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 15),
                    Text(_experiments[_currentExperiment]['question'],
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        if (_feedback != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _feedback!.contains('Correcto')
                  ? Colors.green
                  : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(_feedback!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton('Física', '🧂', Colors.blue),
              const SizedBox(width: 30),
              _buildButton('Química', '🧪', Colors.orange),
            ],
          ),
      ],
    );
  }

  Widget _buildButton(String label, String icon, Color color) {
    return ElevatedButton(
      onPressed: () => _checkReaction(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 35)),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// JUEGO 3: REVERSIBLE VS IRREVERSIBLE
class Juego3Reversible extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Reversible(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Reversible> createState() => _Juego3ReversibleState();
}

class _Juego3ReversibleState extends State<Juego3Reversible> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Derretir Chocolate', 'reversible': true, 'icon': '🍫'},
    {'name': 'Quemar Madera', 'reversible': false, 'icon': '🔥'},
    {'name': 'Congelar Agua', 'reversible': true, 'icon': '❄️'},
    {'name': 'Freír un Huevo', 'reversible': false, 'icon': '🍳'},
    {'name': 'Evaporar Agua', 'reversible': true, 'icon': '💧'},
    {'name': 'Hornear Pastel', 'reversible': false, 'icon': '🎂'},
    {'name': 'Doblar Papel', 'reversible': true, 'icon': '📄'},
    {'name': 'Oxidar Hierro', 'reversible': false, 'icon': '🔩'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
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

  void _endGame() {
    _timer?.cancel();
    widget.onGameComplete(_score.clamp(0, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItem >= _items.length || _timeLeft == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Clasificación Completa!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score pts',
                style: const TextStyle(fontSize: 20)),
            if (_streak >= 3)
              Text('¡Racha máxima: $_streak! 🔥',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(_score.clamp(0, 100)),
              child: const Text('Finalizar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cambio ${_currentItem + 1}/${_items.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.red),
                  const SizedBox(width: 5),
                  Text('$_timeLeft s',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
              if (_streak >= 3)
                Text('Racha: $_streak 🔥',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Text('¿Se puede deshacer el cambio?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Draggable<bool>(
                    data: _items[_currentItem]['reversible'],
                    feedback: Material(
                      color: Colors.transparent,
                      child: Text(_items[_currentItem]['icon'],
                          style: const TextStyle(fontSize: 80)),
                    ),
                    childWhenDragging: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade100,
                            Colors.yellow.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 3),
                      ),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildZone('Irreversible', '🚫', false, Colors.red),
            _buildZone('Reversible', '🔄', true, Colors.green),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, bool isReversible, Color color) {
    return DragTarget<bool>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: candidateData.isNotEmpty ? color : Colors.transparent,
                width: 3),
            boxShadow: candidateData.isNotEmpty
                ? [
                    BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 50)),
              Text(label,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == isReversible) {
            _streak++;
            _score += 13 + (_streak >= 3 ? 5 : 0);
            HapticFeedback.mediumImpact();
          } else {
            _streak = 0;
            HapticFeedback.heavyImpact();
          }
          _currentItem++;
        });
        if (_currentItem >= _items.length) {
          _endGame();
        }
      },
    );
  }
}

// JUEGO 4: ESTADOS DE LA MATERIA
class Juego4EstadosMateria extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4EstadosMateria(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4EstadosMateria> createState() => _Juego4EstadosMateriaState();
}

class _Juego4EstadosMateriaState extends State<Juego4EstadosMateria> {
  int score = 0;
  int currentItem = 0;

  final List<Map<String, String>> items = [
    {'name': 'Roca', 'state': 'Sólido', 'icon': '🪨'},
    {'name': 'Agua', 'state': 'Líquido', 'icon': '💧'},
    {'name': 'Vapor', 'state': 'Gaseoso', 'icon': '💨'},
    {'name': 'Hielo', 'state': 'Sólido', 'icon': '🧊'},
    {'name': 'Jugo', 'state': 'Líquido', 'icon': '🧃'},
    {'name': 'Aire', 'state': 'Gaseoso', 'icon': '🎈'},
  ];

  @override
  Widget build(BuildContext context) {
    if (currentItem >= items.length) {
      return Center(
        child: ElevatedButton(
          onPressed: () => widget.onGameComplete(score),
          child: Text('¡Clasificación Completa! ($score pts)'),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿En qué estado está?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: items[currentItem]['state'],
              feedback: Material(
                color: Colors.transparent,
                child: Text(items[currentItem]['icon']!,
                    style: const TextStyle(fontSize: 80)),
              ),
              childWhenDragging: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(items[currentItem]['icon']!,
                      style: const TextStyle(fontSize: 80)),
                  Text(items[currentItem]['name']!,
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildZone('Sólido', '🪨', Colors.brown),
            _buildZone('Líquido', '💧', Colors.blue),
            _buildZone('Gaseoso', '💨', Colors.grey),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: candidateData.isNotEmpty ? color : Colors.transparent,
                width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 30)),
              Text(label,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == label) {
            score += 20;
            HapticFeedback.mediumImpact();
          } else {
            HapticFeedback.heavyImpact();
          }
          currentItem++;
        });
      },
    );
  }
}

// JUEGO 5: QUIZ DE MATERIA
class Juego5QuizMateria extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizMateria(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizMateria> createState() => _Juego5QuizMateriaState();
}

class _Juego5QuizMateriaState extends State<Juego5QuizMateria> {
  int score = 0;
  int currentQuestionIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué pasa si calientas hielo?',
      'answers': ['Se congela', 'Se derrite', 'Se rompe', 'Nada'],
      'correctIndex': 1
    },
    {
      'question': '¿El fuego es un cambio...?',
      'answers': ['Físico', 'Químico', 'Mágico', 'Líquido'],
      'correctIndex': 1
    },
    {
      'question': '¿El agua es...?',
      'answers': ['Sólido', 'Gas', 'Líquido', 'Plasma'],
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
