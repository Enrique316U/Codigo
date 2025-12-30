// ETAPA 3 - SECCIÓN 2 - NODO 5: El agua y sus propiedades
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
  final int _maxGames = 5;
  int _streak = 0;
  int _maxStreak = 0;

  void _onGameComplete(int score, int streak) {
    setState(() {
      _totalScore += score;
      _streak = streak;
      if (_streak > _maxStreak) _maxStreak = _streak;
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nivel ${_currentGame + 1}/$_maxGames',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.color),
              ),
              if (_streak > 1)
                Text(
                  '🔥 Racha: $_streak',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
            ],
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
        return Juego1DerretirCongelar(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2EstadosAgua(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Termometro(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4Reversible(
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
              Icon(Icons.water_drop, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Científico del Agua!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Genial! Ahora sabes cómo cambia el agua con el calor y el frío.',
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

// JUEGO 1: DERRETIR O CONGELAR
class Juego1DerretirCongelar extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1DerretirCongelar(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1DerretirCongelar> createState() => _Juego1DerretirCongelarState();
}

class _Juego1DerretirCongelarState extends State<Juego1DerretirCongelar>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 45;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> items = [
    {'emoji': '🧊', 'action': 'Calor', 'result': '💧', 'text': 'Hielo + Sol'},
    {'emoji': '💧', 'action': 'Frío', 'result': '🧊', 'text': 'Agua + Frío'},
    {
      'emoji': '🍫',
      'action': 'Calor',
      'result': '🫠',
      'text': 'Chocolate + Sol'
    },
    {'emoji': '🍦', 'action': 'Calor', 'result': '🫠', 'text': 'Helado + Sol'},
    {'emoji': '☕', 'action': 'Frío', 'result': '🧊', 'text': 'Café + Frío'},
    {
      'emoji': '🧈',
      'action': 'Calor',
      'result': '🫠',
      'text': 'Mantequilla + Sol'
    },
  ];

  @override
  void initState() {
    super.initState();
    items.shuffle();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentItem >= items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌡️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= items.length
                  ? '¡Cambios Completados!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 1)
              Text('🔥 Racha máxima: $streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
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
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _timeLeft < 10
                ? Colors.red.shade100
                : widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('🎯 $score pts',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              if (streak > 1)
                Text('🔥 $streak',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(items[currentItem]['text'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(items[currentItem]['emoji'],
                style: const TextStyle(fontSize: 80)),
            const Icon(Icons.arrow_forward, size: 40),
            const Text('❓', style: TextStyle(fontSize: 80)),
          ],
        ),
        const SizedBox(height: 40),
        const Text('¿Qué pasa?', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _checkAnswer('🫠'), // Derretido/Líquido
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              child:
                  const Text('Se Derrite 🫠', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () => _checkAnswer('🧊'), // Sólido/Congelado
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              child:
                  const Text('Se Congela 🧊', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ],
    );
  }

  void _checkAnswer(String answer) {
    // Simplificación: Si la acción es Calor, se derrite (🫠 o 💧). Si es Frío, se congela (🧊).

    // Ajuste lógico real
    String expected = items[currentItem]['result'];
    bool correct = false;
    if (expected == '💧' && answer == '🫠')
      correct = true; // Aceptamos derretir como agua
    else if (expected == '🫠' && answer == '🫠')
      correct = true;
    else if (expected == '🧊' && answer == '🧊') correct = true;

    if (correct) {
      int points = 25 + (streak * 5).toInt();
      score += points;
      streak++;
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      streak = 0;
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentItem++;
    });
  }
}

// JUEGO 2: ESTADOS DEL AGUA
class Juego2EstadosAgua extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2EstadosAgua(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2EstadosAgua> createState() => _Juego2EstadosAguaState();
}

class _Juego2EstadosAguaState extends State<Juego2EstadosAgua>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;
  late AnimationController _scaleController;

  List<Map<String, String>> items = [
    {'emoji': '🧊', 'name': 'Hielo', 'state': 'Sólido'},
    {'emoji': '💧', 'name': 'Agua', 'state': 'Líquido'},
    {'emoji': '💨', 'name': 'Vapor', 'state': 'Gas'},
    {'emoji': '🌨️', 'name': 'Nieve', 'state': 'Sólido'},
    {'emoji': '🌧️', 'name': 'Lluvia', 'state': 'Líquido'},
    {'emoji': '☁️', 'name': 'Nube', 'state': 'Gas'},
  ];

  @override
  void initState() {
    super.initState();
    items.shuffle();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentItem >= items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💧', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= items.length
                  ? '¡Estados Clasificados!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 1)
              Text('🔥 Racha máxima: $streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
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
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: _timeLeft < 10
              ? Colors.red.shade100
              : widget.color.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('🎯 $score pts',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              if (streak > 1)
                Text('🔥 $streak',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
            ],
          ),
        ),
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
                child: Text(items[currentItem]['emoji']!,
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
                  Text(items[currentItem]['emoji']!,
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
            _buildStateZone('Sólido', '🧱', Colors.brown),
            _buildStateZone('Líquido', '💧', Colors.blue),
            _buildStateZone('Gas', '☁️', Colors.grey),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStateZone(String name, String icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 120,
          width: 100,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: candidateData.isNotEmpty ? color : Colors.transparent,
                width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),
              Text(name,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == name) {
            int points = 20 + (streak * 5).toInt();
            score += points;
            streak++;
            _scaleController.forward().then((_) => _scaleController.reverse());
            HapticFeedback.mediumImpact();
          } else {
            streak = 0;
            HapticFeedback.heavyImpact();
          }
          currentItem++;
        });
      },
    );
  }
}

// JUEGO 3: TERMÓMETRO
class Juego3Termometro extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3Termometro(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Termometro> createState() => _Juego3TermometroState();
}

class _Juego3TermometroState extends State<Juego3Termometro>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 40;
  late AnimationController _scaleController;

  List<Map<String, String>> scenes = [
    {'emoji': '🏖️', 'name': 'Playa', 'temp': 'Calor'},
    {'emoji': '☃️', 'name': 'Muñeco de Nieve', 'temp': 'Frío'},
    {'emoji': '🌵', 'name': 'Desierto', 'temp': 'Calor'},
    {'emoji': '🐧', 'name': 'Polo Sur', 'temp': 'Frío'},
    {'emoji': '🌋', 'name': 'Volcán', 'temp': 'Calor'},
    {'emoji': '🏔️', 'name': 'Montaña Nevada', 'temp': 'Frío'},
  ];

  @override
  void initState() {
    super.initState();
    scenes.shuffle();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentItem >= scenes.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌡️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= scenes.length
                  ? '¡Temperatura Medida!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 1)
              Text('🔥 Racha máxima: $streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
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
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _timeLeft < 10
                ? Colors.red.shade100
                : widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('🎯 $score pts',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              if (streak > 1)
                Text('🔥 $streak',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('¿Hace calor o frío?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        Text(scenes[currentItem]['emoji']!,
            style: const TextStyle(fontSize: 100)),
        Text(scenes[currentItem]['name']!,
            style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _checkAnswer('Frío'),
              icon: const Icon(Icons.ac_unit),
              label: const Text('Frío'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            ElevatedButton.icon(
              onPressed: () => _checkAnswer('Calor'),
              icon: const Icon(Icons.wb_sunny),
              label: const Text('Calor'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
          ],
        ),
      ],
    );
  }

  void _checkAnswer(String answer) {
    bool isCorrect = answer == scenes[currentItem]['temp'];
    if (isCorrect) {
      int points = 25 + (streak * 5).toInt();
      score += points;
      streak++;
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      streak = 0;
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentItem++;
    });
  }
}

// JUEGO 4: CAMBIOS REVERSIBLES
class Juego4Reversible extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4Reversible(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Reversible> createState() => _Juego4ReversibleState();
}

class _Juego4ReversibleState extends State<Juego4Reversible>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> changes = [
    {'emoji': '🧊', 'text': 'Hielo derretido', 'reversible': true},
    {'emoji': '🔥', 'text': 'Papel quemado', 'reversible': false},
    {'emoji': '🍫', 'text': 'Chocolate derretido', 'reversible': true},
    {'emoji': '🍳', 'text': 'Huevo frito', 'reversible': false},
    {'emoji': '🧈', 'text': 'Mantequilla derretida', 'reversible': true},
    {'emoji': '🍞', 'text': 'Pan tostado', 'reversible': false},
  ];

  @override
  void initState() {
    super.initState();
    changes.shuffle();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentItem >= changes.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔄', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= changes.length
                  ? '¡Cambios Entendidos!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 1)
              Text('🔥 Racha máxima: $streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
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
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _timeLeft < 10
                ? Colors.red.shade100
                : widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('🎯 $score pts',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              if (streak > 1)
                Text('🔥 $streak',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('¿Puede volver a ser como antes?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 40),
        Text(changes[currentItem]['emoji'],
            style: const TextStyle(fontSize: 100)),
        Text(changes[currentItem]['text'],
            style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _checkAnswer(false),
              icon: const Icon(Icons.close),
              label: const Text('No'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            ElevatedButton.icon(
              onPressed: () => _checkAnswer(true),
              icon: const Icon(Icons.check),
              label: const Text('Sí'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
          ],
        ),
      ],
    );
  }

  void _checkAnswer(bool answer) {
    bool isCorrect = answer == changes[currentItem]['reversible'];
    if (isCorrect) {
      int points = 25 + (streak * 5).toInt();
      score += points;
      streak++;
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      streak = 0;
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentItem++;
    });
  }
}

// JUEGO 5: QUIZ DE MATERIA
class Juego5QuizMateria extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizMateria(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizMateria> createState() => _Juego5QuizMateriaState();
}

class _Juego5QuizMateriaState extends State<Juego5QuizMateria>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué pasa si calientas agua?',
      'answers': [
        'Se congela',
        'Se convierte en vapor',
        'Se pone dura',
        'Nada'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Qué pasa si pones agua en el congelador?',
      'answers': [
        'Se vuelve hielo',
        'Se calienta',
        'Desaparece',
        'Se vuelve gas'
      ],
      'correctIndex': 0
    },
    {
      'question': '¿El aire es materia?',
      'answers': ['No', 'Sí, es un gas', 'Solo si sopla', 'Es magia'],
      'correctIndex': 1
    },
    {
      'question': '¿Qué es el vapor de agua?',
      'answers': [
        'Agua fría',
        'Agua en estado gaseoso',
        'Hielo pequeño',
        'Aire sucio'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Qué necesita el hielo para derretirse?',
      'answers': ['Frío', 'Calor', 'Oscuridad', 'Nada'],
      'correctIndex': 1
    },
  ];

  @override
  void initState() {
    super.initState();
    questions.shuffle();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentQuestionIndex >= questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🧠', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentQuestionIndex >= questions.length
                  ? '¡Quiz Completado!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 1)
              Text('🔥 Racha máxima: $streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
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
      );
    }

    final question = questions[currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _timeLeft < 10
                  ? Colors.red.shade100
                  : widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('⏱️ $_timeLeft s',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _timeLeft < 10 ? Colors.red : Colors.black)),
                Text('🎯 $score pts',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                if (streak > 1)
                  Text('🔥 $streak',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
              ],
            ),
          ),
          const SizedBox(height: 30),
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
      int points = 20 + (streak * 5).toInt();
      score += points;
      streak++;
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      streak = 0;
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentQuestionIndex++;
    });
  }
}
