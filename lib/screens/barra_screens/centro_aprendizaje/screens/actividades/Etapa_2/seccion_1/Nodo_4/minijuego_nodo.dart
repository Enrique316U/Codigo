// ETAPA 2 - SECCIÓN 1 - NODO 4: CUIDADO DEL AMBIENTE
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
        title: const Text("CUIDADO DEL AMBIENTE",
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
        return Juego1AccionesEcologicas(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 1));
      case 2:
        return Juego2AhorroEnergia(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 2));
      case 3:
        return Juego3PlantarArboles(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 3));
      case 4:
        return Juego4ReduceReutiliza(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 4));
      case 5:
        return Juego5DefensorPlaneta(
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
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(children: [
              Text('♻️', style: TextStyle(fontSize: 70)),
              SizedBox(height: 12),
              Text('¡Cuidemos el Planeta!',
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
          _buildGameCard(1, '🌱 Acciones Ecológicas', Icons.eco,
              'Bueno o malo para el planeta', Color(0xFF4CAF50)),
          _buildGameCard(2, '🔋 Ahorro de Energía', Icons.power,
              'Apaga y ahorra', Color(0xFFFF9800)),
          _buildGameCard(3, '🌳 Plantar Árboles', Icons.park,
              '¿Dónde plantamos?', Color(0xFF8BC34A)),
          _buildGameCard(4, '🚮 Reduce y Reutiliza', Icons.recycling,
              'Menos basura, más vida', Color(0xFF00BCD4)),
          _buildGameCard(5, '🌍 Defensor del Planeta', Icons.public,
              'Quiz de ecología', Color(0xFF2196F3)),
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

// JUEGO 1: Reciclaje (Drag Target)
class Juego1AccionesEcologicas extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego1AccionesEcologicas(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego1AccionesEcologicas> createState() =>
      _Juego1AccionesEcologicasState();
}

class _Juego1AccionesEcologicasState extends State<Juego1AccionesEcologicas> {
  final List<Map<String, dynamic>> _actions = [
    {'action': 'Usar bolsas de tela', 'isGood': true},
    {'action': 'Tirar basura en la calle', 'isGood': false},
    {'action': 'Plantar un árbol', 'isGood': true},
    {'action': 'Desperdiciar agua', 'isGood': false},
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
    _actions.shuffle();
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
    bool correctAnswer = _actions[_currentIndex]['isGood'];
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
          if (_currentIndex >= _actions.length) {
            _timer?.cancel();
            widget.onGameCompleted(_score);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _actions.length) {
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
              const Text('🌱', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'ACCIONES ECOLÓGICAS',
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
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('¿Esta acción es buena o mala para el planeta?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    _actions[_currentIndex]['action'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _checkAnswer(true),
                      icon: const Icon(Icons.thumb_up, size: 30),
                      label:
                          const Text('BUENO', style: TextStyle(fontSize: 18)),
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
                      icon: const Icon(Icons.thumb_down, size: 30),
                      label: const Text('MALO', style: TextStyle(fontSize: 18)),
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
                  'Pregunta ${_currentIndex + 1} de ${_actions.length}',
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

// JUEGO 2: Ahorro de Energía
class Juego2AhorroEnergia extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego2AhorroEnergia(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego2AhorroEnergia> createState() => _Juego2AhorroEnergiaState();
}

class _Juego2AhorroEnergiaState extends State<Juego2AhorroEnergia> {
  final List<Map<String, dynamic>> _devices = [
    {'name': 'TV', 'icon': Icons.tv, 'isOn': true},
    {'name': 'Foco', 'icon': Icons.lightbulb, 'isOn': true},
    {'name': 'Computadora', 'icon': Icons.computer, 'isOn': true},
    {'name': 'Ventilador', 'icon': Icons.mode_fan_off, 'isOn': true},
  ];
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

  void _toggleDevice(int index) {
    if (_devices[index]['isOn']) {
      setState(() {
        _devices[index]['isOn'] = false;
        _score += 25;
      });
      HapticFeedback.mediumImpact();
      _showFeedback(true);

      if (_devices.every((device) => !device['isOn'])) {
        _timer?.cancel();
        widget.onGameCompleted(_score);
      }
    }
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
              const Text('🔋', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'AHORRO DE ENERGÍA',
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
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('¡Apaga todos los dispositivos para ahorrar energía!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1,
            ),
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final device = _devices[index];
              final isOn = device['isOn'];
              return GestureDetector(
                onTap: () => _toggleDevice(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isOn ? Colors.orange : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isOn ? Colors.orange : Colors.green)
                            .withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        device['icon'],
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        device['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isOn ? 'ENCENDIDO' : 'APAGADO',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: Plantar Árboles
class Juego3PlantarArboles extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego3PlantarArboles(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego3PlantarArboles> createState() => _Juego3PlantarArbolesState();
}

class _Juego3PlantarArbolesState extends State<Juego3PlantarArboles> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Dónde plantamos árboles?',
      'options': ['En el parque', 'En el desierto', 'En el mar'],
      'correct': 0
    },
    {
      'question': '¿Qué necesitan los árboles?',
      'options': ['Basura', 'Agua y sol', 'Ruido'],
      'correct': 1
    },
    {
      'question': '¿Los árboles producen...?',
      'options': ['Oxígeno', 'Contaminación', 'Basura'],
      'correct': 0
    },
    {
      'question': '¿Cuándo plantamos árboles?',
      'options': ['En invierno', 'En primavera', 'En verano seco'],
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
              const Text('🌳', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'PLANTAR ÁRBOLES',
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
                    color: Color(0xFF2E7D32),
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
                        backgroundColor: const Color(0xFF8BC34A),
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

// JUEGO 4: Reduce y Reutiliza
class Juego4ReduceReutiliza extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego4ReduceReutiliza(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego4ReduceReutiliza> createState() => _Juego4ReduceReutilizaState();
}

class _Juego4ReduceReutilizaState extends State<Juego4ReduceReutiliza> {
  final List<Map<String, dynamic>> _scenarios = [
    {
      'scenario': 'Tienes una botella de plástico',
      'options': ['Tirarla', 'Reutilizarla como maceta', 'Quemarla'],
      'correct': 1
    },
    {
      'scenario': 'Quieres un juguete nuevo',
      'options': ['Comprar muchos', 'Intercambiar con un amigo', 'Pedir 10'],
      'correct': 1
    },
    {
      'scenario': 'Tienes papel usado',
      'options': ['Tirarlo', 'Usarlo para dibujar atrás', 'Dejarlo tirado'],
      'correct': 1
    },
    {
      'scenario': 'Vas al supermercado',
      'options': [
        'Pedir muchas bolsas',
        'Llevar bolsa reutilizable',
        'No llevar nada'
      ],
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

  void _selectOption(int selectedIndex) {
    bool isCorrect = selectedIndex == _scenarios[_currentIndex]['correct'];

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
          if (_currentIndex >= _scenarios.length) {
            _timer?.cancel();
            widget.onGameCompleted(_score);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _scenarios.length) {
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
              const Text('🚮', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'REDUCE Y REUTILIZA',
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
                    border: Border.all(color: Colors.cyan, width: 2),
                  ),
                  child: Text(
                    _scenarios[_currentIndex]['scenario'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00796B),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '¿Qué harías?',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ...List.generate(
                  (_scenarios[_currentIndex]['options'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _selectOption(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BCD4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: Text(
                        _scenarios[_currentIndex]['options'][index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Escenario ${_currentIndex + 1} de ${_scenarios.length}',
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

// JUEGO 5: Defensor del Planeta
class Juego5DefensorPlaneta extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego5DefensorPlaneta(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego5DefensorPlaneta> createState() => _Juego5DefensorPlanetaState();
}

class _Juego5DefensorPlanetaState extends State<Juego5DefensorPlaneta> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuál es la fuente de energía más limpia?',
      'options': ['Carbón', 'Petróleo', 'Energía solar'],
      'correct': 2
    },
    {
      'question': '¿Qué gas producen los árboles?',
      'options': ['Dióxido de carbono', 'Oxígeno', 'Metano'],
      'correct': 1
    },
    {
      'question': '¿Cuánto tiempo tarda un plástico en degradarse?',
      'options': ['1 año', '10 años', 'Más de 100 años'],
      'correct': 2
    },
    {
      'question': '¿Qué es el efecto invernadero?',
      'options': [
        'Un invernadero de plantas',
        'Calentamiento global por gases',
        'Una casa con vidrios'
      ],
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
              const Text('🌍', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 8),
              const Text(
                'DEFENSOR DEL PLANETA',
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
                      colors: [Colors.blue.shade100, Colors.green.shade100],
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
                      color: Color(0xFF1565C0),
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
                        backgroundColor: const Color(0xFF2196F3),
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
                      color: Color(0xFF1565C0),
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
