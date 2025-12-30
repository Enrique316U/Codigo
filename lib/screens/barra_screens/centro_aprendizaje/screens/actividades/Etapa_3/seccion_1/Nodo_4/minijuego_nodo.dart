import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo4Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo4Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo4Screen> createState() => _MinijuegoNodo4ScreenState();
}

class _MinijuegoNodo4ScreenState extends State<MinijuegoNodo4Screen> {
  int _currentGame = 0;
  int _totalScore = 0;
  final int _maxGames = 4;
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
        return Juego1Identifica(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego3Habitat(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego4Proteccion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego5QuizExtincion(
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
                '¡Protector de Animales!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Gracias por aprender a cuidar a nuestros animales en peligro!',
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

// JUEGO 1: IDENTIFICA AL AMENAZADO
class Juego1Identifica extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1Identifica(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1Identifica> createState() => _Juego1IdentificaState();
}

class _Juego1IdentificaState extends State<Juego1Identifica>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 45;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> animals = [
    {'emoji': '🐻', 'name': 'Oso de Anteojos', 'endangered': true},
    {'emoji': '�', 'name': 'Perro', 'endangered': false},
    {'emoji': '🦅', 'name': 'Cóndor Andino', 'endangered': true},
    {'emoji': '🐱', 'name': 'Gato', 'endangered': false},
    {'emoji': '🐬', 'name': 'Delfín Rosado', 'endangered': true},
    {'emoji': '\ud83d\udc35', 'name': 'Mono Ara\u00f1a', 'endangered': true},
  ];

  @override
  void initState() {
    super.initState();
    animals.shuffle();
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
    if (_timeLeft == 0 || currentItem >= animals.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🐾', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= animals.length
                  ? '¡Identificación Completa!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Puntuación: $score',
              style: const TextStyle(fontSize: 20),
            ),
            if (streak > 1)
              Text(
                '🔥 Racha máxima: $streak',
                style: const TextStyle(fontSize: 18, color: Colors.orange),
              ),
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
              Text(
                '⏱️ $_timeLeft s',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft < 10 ? Colors.red : Colors.black,
                ),
              ),
              Text(
                '🎯 $score pts',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (streak > 1)
                Text(
                  '🔥 $streak',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('¿Está en peligro de extinción?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 40),
        Text(animals[currentItem]['emoji'],
            style: const TextStyle(fontSize: 100)),
        Text(animals[currentItem]['name'],
            style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _checkAnswer(false),
              icon: const Icon(Icons.thumb_down),
              label: const Text('No'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            ElevatedButton.icon(
              onPressed: () => _checkAnswer(true),
              icon: const Icon(Icons.warning),
              label: const Text('Sí, ¡Peligro!'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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
    bool isCorrect = answer == animals[currentItem]['endangered'];
    if (isCorrect) {
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
      currentItem++;
    });
  }
}

// JUEGO 3: HÁBITAT SEGURO
class Juego3Habitat extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3Habitat(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Habitat> createState() => _Juego3HabitatState();
}

class _Juego3HabitatState extends State<Juego3Habitat>
    with SingleTickerProviderStateMixin {
  bool isSafe = false;
  int score = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 30;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
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
    if (_timeLeft == 0 || isSafe) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏞️', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              isSafe ? '¡A Salvo!' : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Puntuación: $score',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '⏱️ $_timeLeft s',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft < 10 ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Lleva al animal a la Reserva Natural',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Draggable<String>(
                data: 'animal',
                feedback: const Text('🐆',
                    style: TextStyle(
                        fontSize: 80, decoration: TextDecoration.none)),
                childWhenDragging: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey[300], shape: BoxShape.circle),
                ),
                child: const Text('🐆', style: TextStyle(fontSize: 80)),
              ),
              DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('🏞️', style: TextStyle(fontSize: 50)),
                        Text('Reserva',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
                onAccept: (data) {
                  setState(() {
                    isSafe = true;
                    score = 100;
                    streak = 1;
                    _scaleController
                        .forward()
                        .then((_) => _scaleController.reverse());
                    HapticFeedback.mediumImpact();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 4: PROTECCIÓN
class Juego4Proteccion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4Proteccion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Proteccion> createState() => _Juego4ProteccionState();
}

class _Juego4ProteccionState extends State<Juego4Proteccion>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> actions = [
    {'text': 'Comprar animales silvestres', 'good': false},
    {'text': 'Plantar árboles', 'good': true},
    {'text': 'Tirar basura al río', 'good': false},
    {'text': 'Denunciar el tráfico ilegal', 'good': true},
    {'text': 'Reciclar y reutilizar', 'good': true},
    {'text': 'Usar menos plástico', 'good': true},
  ];

  @override
  void initState() {
    super.initState();
    actions.shuffle();
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
    if (_timeLeft == 0 || currentItem >= actions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✅', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= actions.length
                  ? '¡Evaluación Completa!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Puntuación: $score',
              style: const TextStyle(fontSize: 20),
            ),
            if (streak > 1)
              Text(
                '🔥 Racha máxima: $streak',
                style: const TextStyle(fontSize: 18, color: Colors.orange),
              ),
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
              Text(
                '⏱️ $_timeLeft s',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft < 10 ? Colors.red : Colors.black,
                ),
              ),
              Text(
                '🎯 $score pts',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (streak > 1)
                Text(
                  '🔥 $streak',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿Esta acción ayuda a los animales?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: widget.color),
          ),
          child: Text(
            actions[currentItem]['text'],
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _checkAnswer(false),
              icon: const Icon(Icons.thumb_down),
              label: const Text('Malo'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            ElevatedButton.icon(
              onPressed: () => _checkAnswer(true),
              icon: const Icon(Icons.thumb_up),
              label: const Text('Bueno'),
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

  void _checkAnswer(bool isGood) {
    bool correct = isGood == actions[currentItem]['good'];
    if (correct) {
      int points = 15 + (streak * 3);
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

// JUEGO 5: QUIZ EXTINCIÓN
class Juego5QuizExtincion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizExtincion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizExtincion> createState() => _Juego5QuizExtincionState();
}

class _Juego5QuizExtincionState extends State<Juego5QuizExtincion>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué significa "en peligro de extinción"?',
      'answers': [
        'Que hay muchos',
        'Que pueden desaparecer para siempre',
        'Que están durmiendo',
        'Que son peligrosos'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Cuál es una causa de la extinción?',
      'answers': [
        'Plantar árboles',
        'Cuidar el agua',
        'Destruir sus bosques',
        'Tomar fotos'
      ],
      'correctIndex': 2
    },
    {
      'question': '¿Qué animal peruano está en peligro?',
      'answers': ['Perro', 'Gato', 'Gallito de las Rocas', 'Paloma'],
      'correctIndex': 2
    },
    {
      'question': '¿Qué podemos hacer para ayudar?',
      'answers': [
        'Ignorar el problema',
        'Proteger sus hábitats',
        'Comprar animales silvestres',
        'Hacer ruido en el bosque'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Por qué son importantes las reservas naturales?',
      'answers': [
        'Para construir casas',
        'Para que los animales vivan seguros',
        'Para hacer fiestas',
        'Para tener mascotas'
      ],
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
            Text(
              'Puntuación: $score',
              style: const TextStyle(fontSize: 20),
            ),
            if (streak > 1)
              Text(
                '🔥 Racha máxima: $streak',
                style: const TextStyle(fontSize: 18, color: Colors.orange),
              ),
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
                Text(
                  '⏱️ $_timeLeft s',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _timeLeft < 10 ? Colors.red : Colors.black,
                  ),
                ),
                Text(
                  '🎯 $score pts',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (streak > 1)
                  Text(
                    '🔥 $streak',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
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
      int points = 20 + (streak * 5);
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
