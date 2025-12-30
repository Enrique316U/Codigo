// ETAPA 3 - SECCIÓN 1 - NODO 3: ¿Qué es un ecosistema?
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo3Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo3Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo3Screen> createState() => _MinijuegoNodo3ScreenState();
}

class _MinijuegoNodo3ScreenState extends State<MinijuegoNodo3Screen> {
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
        return Juego1Camuflaje(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2PicosComida(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3ClimaPiel(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4DefensaAnimal(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizAdaptaciones(
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
              Icon(Icons.visibility, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Maestro del Disfraz!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
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

// JUEGO 1: CAMUFLAJE
class Juego1Camuflaje extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1Camuflaje(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1Camuflaje> createState() => _Juego1CamuflajeState();
}

class _Juego1CamuflajeState extends State<Juego1Camuflaje>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;

  late AnimationController _scaleController;

  List<Map<String, String>> animals = [
    {'emoji': '🦎', 'name': 'Camaleón', 'env': 'Hojas Verdes'},
    {'emoji': '🐻‍❄️', 'name': 'Oso Polar', 'env': 'Nieve'},
    {'emoji': '🦁', 'name': 'León', 'env': 'Pastizales Secos'},
    {'emoji': '🦉', 'name': 'Búho', 'env': 'Tronco de Árbol'},
    {'emoji': '🐆', 'name': 'Leopardo', 'env': 'Pastizales Secos'},
    {'emoji': '🦊', 'name': 'Zorro Ártico', 'env': 'Nieve'},
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
            const Text('🎯', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= animals.length
                  ? '¡Animales Encontrados!'
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
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: _timeLeft < 10
              ? Colors.red.shade100
              : widget.color.withOpacity(0.1),
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
          child: Text('¿Dónde se esconde mejor?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: animals[currentItem]['env'],
              feedback: Material(
                color: Colors.transparent,
                child: Text(animals[currentItem]['emoji']!,
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
                  Text(animals[currentItem]['emoji']!,
                      style: const TextStyle(fontSize: 80)),
                  Text(animals[currentItem]['name']!,
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(10),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: [
              _buildEnvZone('Hojas Verdes', '🌿', Colors.green),
              _buildEnvZone('Nieve', '❄️', Colors.cyan),
              _buildEnvZone('Pastizales Secos', '🌾', Colors.orange),
              _buildEnvZone('Tronco de Árbol', '🪵', Colors.brown),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnvZone(String name, String icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
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
                      color: color, fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == name) {
            int points = 25 + (streak * 5);
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

// JUEGO 2: PICOS Y COMIDA
class Juego2PicosComida extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2PicosComida(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2PicosComida> createState() => _Juego2PicosComidaState();
}

class _Juego2PicosComidaState extends State<Juego2PicosComida>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 45;
  late AnimationController _scaleController;

  List<Map<String, String>> birds = [
    {'emoji': '🦅', 'name': 'Águila', 'food': 'Carne'},
    {'emoji': '🐦', 'name': 'Colibrí', 'food': 'Néctar'},
    {'emoji': '🦆', 'name': 'Pato', 'food': 'Peces/Plantas'},
    {'emoji': '🦜', 'name': 'Loro', 'food': 'Semillas'},
    {'emoji': '🦜', 'name': 'Guacamayo', 'food': 'Semillas'},
    {'emoji': '🦩', 'name': 'Flamenco', 'food': 'Peces/Plantas'},
  ];

  @override
  void initState() {
    super.initState();
    birds.shuffle();
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
    if (_timeLeft == 0 || currentItem >= birds.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎯', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= birds.length
                  ? '¡Alimentación Correcta!'
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
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: _timeLeft < 10
              ? Colors.red.shade100
              : widget.color.withOpacity(0.1),
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
          child: Text('¿Qué come según su pico?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: birds[currentItem]['food'],
              feedback: Material(
                color: Colors.transparent,
                child: Text(birds[currentItem]['emoji']!,
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
                  Text(birds[currentItem]['emoji']!,
                      style: const TextStyle(fontSize: 80)),
                  Text(birds[currentItem]['name']!,
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFoodZone('Carne', '🥩', Colors.red),
            _buildFoodZone('Néctar', '🌺', Colors.pink),
            _buildFoodZone('Semillas', '🌰', Colors.brown),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildFoodZone(String name, String icon, Color color) {
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
                      color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == name) {
            score += 25;
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

// JUEGO 3: CLIMA Y PIEL
class Juego3ClimaPiel extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3ClimaPiel(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3ClimaPiel> createState() => _Juego3ClimaPielState();
}

class _Juego3ClimaPielState extends State<Juego3ClimaPiel>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 40;
  late AnimationController _scaleController;

  List<Map<String, String>> animals = [
    {'emoji': '🐪', 'name': 'Camello', 'climate': 'Calor'},
    {'emoji': '🐧', 'name': 'Pingüino', 'climate': 'Frío'},
    {'emoji': '🐘', 'name': 'Elefante', 'climate': 'Calor'},
    {'emoji': '🐺', 'name': 'Lobo Ártico', 'climate': 'Frío'},
    {'emoji': '🦙', 'name': 'Llama', 'climate': 'Frío'},
    {'emoji': '🦎', 'name': 'Lagarto', 'climate': 'Calor'},
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
            const Text('🌡️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= animals.length
                  ? '¡Adaptados al Clima!'
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
          color: _timeLeft < 10
              ? Colors.red.shade100
              : widget.color.withOpacity(0.1),
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
        const SizedBox(height: 40),
        const Text('¿Para qué clima está adaptado?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        Text(animals[currentItem]['emoji']!,
            style: const TextStyle(fontSize: 100)),
        Text(animals[currentItem]['name']!,
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
                  backgroundColor: Colors.cyan,
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
    bool isCorrect = answer == animals[currentItem]['climate'];
    if (isCorrect) {
      int points = 25 + (streak * 5);
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

// JUEGO 4: DEFENSA ANIMAL
class Juego4DefensaAnimal extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4DefensaAnimal(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4DefensaAnimal> createState() => _Juego4DefensaAnimalState();
}

class _Juego4DefensaAnimalState extends State<Juego4DefensaAnimal>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;
  late AnimationController _scaleController;

  List<Map<String, String>> animals = [
    {'emoji': '🐢', 'name': 'Tortuga', 'defense': 'Caparazón'},
    {'emoji': '🦔', 'name': 'Erizo', 'defense': 'Púas'},
    {'emoji': '🐙', 'name': 'Pulpo', 'defense': 'Tinta'},
    {'emoji': '🦨', 'name': 'Zorrillo', 'defense': 'Olor'},
    {'emoji': '🦏', 'name': 'Rinoceronte', 'defense': 'Cuerno'},
    {'emoji': '🐝', 'name': 'Abeja', 'defense': 'Aguijón'},
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
            const Text('🛡️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              currentItem >= animals.length
                  ? '¡Defensas Activadas!'
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
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: _timeLeft < 10
              ? Colors.red.shade100
              : widget.color.withOpacity(0.1),
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
          child: Text('¿Cómo se defiende?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: animals[currentItem]['defense'],
              feedback: Material(
                color: Colors.transparent,
                child: Text(animals[currentItem]['emoji']!,
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
                  Text(animals[currentItem]['emoji']!,
                      style: const TextStyle(fontSize: 80)),
                  Text(animals[currentItem]['name']!,
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(10),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.0,
            children: [
              _buildDefenseZone('Caparazón', '🛡️', Colors.green),
              _buildDefenseZone('Púas', '🌵', Colors.brown),
              _buildDefenseZone('Tinta', '⚫', Colors.black),
              _buildDefenseZone('Olor', '💨', Colors.purple),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefenseZone(String name, String icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: candidateData.isNotEmpty ? color : Colors.transparent,
                width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 10),
              Text(name,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == name) {
            int points = 25 + (streak * 5);
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

// JUEGO 5: QUIZ DE ADAPTACIONES
class Juego5QuizAdaptaciones extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizAdaptaciones(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizAdaptaciones> createState() => _Juego5QuizAdaptacionesState();
}

class _Juego5QuizAdaptacionesState extends State<Juego5QuizAdaptaciones>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué es una adaptación?',
      'answers': [
        'Un cambio para sobrevivir',
        'Un juego',
        'Dormir mucho',
        'Comer dulces'
      ],
      'correctIndex': 0
    },
    {
      'question': '¿Por qué los osos polares son blancos?',
      'answers': [
        'Porque les gusta',
        'Para camuflarse en la nieve',
        'Porque tienen frío',
        'Para asustar'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Para qué sirven las aletas de los peces?',
      'answers': ['Para volar', 'Para caminar', 'Para nadar', 'Para comer'],
      'correctIndex': 2
    },
    {
      'question': '¿Cómo sobreviven los cactus en el desierto?',
      'answers': [
        'Bebiendo mucha agua',
        'Almacenando agua en su tallo',
        'Pidiendo agua',
        'No necesitan agua'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Por qué las jirafas tienen cuellos largos?',
      'answers': [
        'Para verse bonitas',
        'Para alcanzar hojas altas',
        'Para nadar mejor',
        'Para correr rápido'
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
      int points = 30 + (streak * 5);
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
