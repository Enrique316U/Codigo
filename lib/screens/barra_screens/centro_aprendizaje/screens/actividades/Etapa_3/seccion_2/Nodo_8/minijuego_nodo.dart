import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo8Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo8Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo8Screen> createState() => _MinijuegoNodo8ScreenState();
}

class _MinijuegoNodo8ScreenState extends State<MinijuegoNodo8Screen> {
  int _currentGame = 0;
  int _totalScore = 0;
  int _streak = 0;
  int _maxStreak = 0;
  final int _maxGames = 5;

  void _onGameComplete(int score, int streak) {
    setState(() {
      _totalScore += score;
      _streak = streak;
      if (streak > _maxStreak) _maxStreak = streak;
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
          if (_streak > 1)
            Text(
              '🔥 x$_streak',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
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
        return Juego1LimpiaCielo(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2FabricaVerde(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3TransporteLimpio(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4PlantaArboles(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizContaminacion(
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
              Icon(Icons.eco, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Guardián del Aire!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Fantástico! Ahora sabes cómo proteger el aire de la contaminación.',
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

// JUEGO 1: LIMPIA EL CIELO
class Juego1LimpiaCielo extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1LimpiaCielo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1LimpiaCielo> createState() => _Juego1LimpiaCieloState();
}

class _Juego1LimpiaCieloState extends State<Juego1LimpiaCielo> {
  double smogOpacity = 1.0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 40;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || smogOpacity <= 0.1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Cielo Despejado!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('☀️', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
                'Puntos: ${(smogOpacity <= 0.1) ? 100 + (streak * 5).toInt() : _score}',
                style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(
                  (smogOpacity <= 0.1) ? 100 + (streak * 5).toInt() : _score,
                  streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 ${_score}',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Fondo limpio
              Container(color: Colors.lightBlue[200]),
              const Center(child: Text('☀️', style: TextStyle(fontSize: 150))),

              // Capa de smog
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    smogOpacity = (smogOpacity - 0.01).clamp(0.0, 1.0);
                  });
                },
                child: Opacity(
                  opacity: smogOpacity,
                  child: Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        '¡Desliza el dedo para limpiar el smog!',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 2: FÁBRICA VERDE
class Juego2FabricaVerde extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2FabricaVerde(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2FabricaVerde> createState() => _Juego2FabricaVerdeState();
}

class _Juego2FabricaVerdeState extends State<Juego2FabricaVerde>
    with SingleTickerProviderStateMixin {
  bool filterInstalled = false;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 35;
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
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
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
    if (_timeLeft == 0 || filterInstalled) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Filtro Instalado!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('🏭', style: TextStyle(fontSize: 100)),
            const Text('☁️', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 20),
            Text('Puntos: ${filterInstalled ? 100 + (streak * 5).toInt() : 0}',
                style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(
                  filterInstalled ? 100 + (streak * 5).toInt() : 0, streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 ${filterInstalled ? 100 : 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¡La fábrica contamina! Toca para poner un filtro.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 40),
              ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.2)
                    .animate(_scaleController),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      filterInstalled = true;
                      streak++;
                      HapticFeedback.mediumImpact();
                      _scaleController
                          .forward()
                          .then((_) => _scaleController.reverse());
                    });
                  },
                  child: Column(
                    children: [
                      const Text('🌫️🌫️🌫️', style: TextStyle(fontSize: 50)),
                      const Text('🏭', style: TextStyle(fontSize: 100)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: TRANSPORTE LIMPIO
class Juego3TransporteLimpio extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3TransporteLimpio(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3TransporteLimpio> createState() => _Juego3TransporteLimpioState();
}

class _Juego3TransporteLimpioState extends State<Juego3TransporteLimpio> {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;

  List<Map<String, dynamic>> vehicles = [
    {'emoji': '🚲', 'name': 'Bicicleta', 'clean': true},
    {'emoji': '🚗', 'name': 'Carro Viejo', 'clean': false},
    {'emoji': '🚶', 'name': 'Caminar', 'clean': true},
    {'emoji': '🚛', 'name': 'Camión', 'clean': false},
    {'emoji': '🚌', 'name': 'Bus Eléctrico', 'clean': true},
    {'emoji': '🛵', 'name': 'Moto', 'clean': false},
  ];

  @override
  void initState() {
    super.initState();
    vehicles.shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentItem >= vehicles.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🚲', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text('Puntos: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 $score',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿Es transporte limpio?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: vehicles[currentItem]['clean'].toString(),
              feedback: Material(
                color: Colors.transparent,
                child: Text(vehicles[currentItem]['emoji'],
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
                  Text(vehicles[currentItem]['emoji'],
                      style: const TextStyle(fontSize: 80)),
                  Text(vehicles[currentItem]['name'],
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildZone('Contamina', '🌫️', false, Colors.grey),
            _buildZone('Limpio', '🍃', true, Colors.green),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, bool isCleanZone, Color color) {
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
        bool isCleanItem = data == 'true';
        bool correct = isCleanItem == isCleanZone;

        setState(() {
          if (correct) {
            int points = 25 + (streak * 5).toInt();
            score += points;
            streak++;
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

// JUEGO 4: PLANTA ÁRBOLES
class Juego4PlantaArboles extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4PlantaArboles(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4PlantaArboles> createState() => _Juego4PlantaArbolesState();
}

class _Juego4PlantaArbolesState extends State<Juego4PlantaArboles>
    with SingleTickerProviderStateMixin {
  int treesPlanted = 0;
  List<bool> planted = List.filled(6, false);
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
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
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
    if (_timeLeft == 0 || treesPlanted >= 6) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌳', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
                'Puntos: ${(treesPlanted >= 6) ? 100 + (streak * 5).toInt() : treesPlanted * 15}',
                style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(
                  (treesPlanted >= 6)
                      ? 100 + (streak * 5).toInt()
                      : treesPlanted * 15,
                  streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 ${treesPlanted * 15}',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¡Toca la tierra para plantar árboles!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Stack(
            children: List.generate(6, (index) {
              return Positioned(
                bottom: 50.0 + (index % 2 * 40),
                left: 30.0 + (index * 70),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.2)
                      .animate(_scaleController),
                  child: GestureDetector(
                    onTap: () {
                      if (!planted[index]) {
                        setState(() {
                          planted[index] = true;
                          treesPlanted++;
                          streak++;
                          HapticFeedback.mediumImpact();
                          _scaleController
                              .forward()
                              .then((_) => _scaleController.reverse());
                        });
                      }
                    },
                    child: planted[index]
                        ? const Text('🌳', style: TextStyle(fontSize: 60))
                        : const Text('🕳️', style: TextStyle(fontSize: 40)),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// JUEGO 5: QUIZ DE CONTAMINACIÓN
class Juego5QuizContaminacion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizContaminacion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizContaminacion> createState() =>
      _Juego5QuizContaminacionState();
}

class _Juego5QuizContaminacionState extends State<Juego5QuizContaminacion> {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué ayuda a limpiar el aire?',
      'answers': ['Los árboles', 'El humo', 'El ruido', 'La basura'],
      'correctIndex': 0
    },
    {
      'question': '¿Qué transporte es mejor para el aire?',
      'answers': ['Avión', 'Bicicleta', 'Camión viejo', 'Cohete'],
      'correctIndex': 1
    },
    {
      'question': '¿Qué debemos hacer con la basura?',
      'answers': ['Quemarla', 'Tirarla al río', 'Reciclarla', 'Comerla'],
      'correctIndex': 2
    },
    {
      'question': '¿Qué contamina más el aire?',
      'answers': ['Una flor', 'Un árbol', 'Quemar plástico', 'El agua'],
      'correctIndex': 2
    },
    {
      'question': '¿Cómo podemos ayudar al aire?',
      'answers': [
        'Usar más carros',
        'Plantar árboles',
        'Quemar llantas',
        'Fumar'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Qué produce el humo de las fábricas?',
      'answers': ['Aire limpio', 'Oxígeno', 'Contaminación', 'Flores'],
      'correctIndex': 2
    },
  ];

  @override
  void initState() {
    super.initState();
    questions.shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentQuestionIndex >= questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌍', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text('Puntos: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 $score',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  question['question'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
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
          ),
        ),
      ],
    );
  }

  void _checkAnswer(int index) {
    if (index == questions[currentQuestionIndex]['correctIndex']) {
      int points = 30 + (streak * 5).toInt();
      score += points;
      streak++;
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
