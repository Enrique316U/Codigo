// ETAPA 5 - SECCIÓN 2 - NODO 6: ELECTRICIDAD Y MAGNETISMO
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo6Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo6Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo6Screen> createState() => _MinijuegoNodo6ScreenState();
}

class _MinijuegoNodo6ScreenState extends State<MinijuegoNodo6Screen> {
  int _currentGame = 0;
  int _totalScore = 0;
  final int _maxGames = 4;

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
        return Juego1Circuito(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Conductores(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Imanes(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4QuizElectricidad(
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
              Icon(Icons.bolt, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Ingeniero Eléctrico!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Electrizante! Dominas los circuitos y el magnetismo.',
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

// JUEGO 1: ARMAR CIRCUITO
class Juego1Circuito extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1Circuito(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1Circuito> createState() => _Juego1CircuitoState();
}

class _Juego1CircuitoState extends State<Juego1Circuito> {
  bool _batteryPlaced = false;
  bool _bulbPlaced = false;
  bool _switchClosed = false;
  int _score = 0;
  int _timeLeft = 45;
  Timer? _timer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0 && !_completed) {
          _timeLeft--;
        } else if (_timeLeft == 0) {
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
    bool circuitComplete = _batteryPlaced && _bulbPlaced && _switchClosed;

    if (circuitComplete && !_completed) {
      _completed = true;
      _score = 100 + (_timeLeft * 2);
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _endGame();
      });
    }

    return Column(
      children: [
        _buildHeader(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Arma el circuito para encender la luz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Container(
              width: 300,
              height: 400,
              child: Stack(
                children: [
                  // Circuito visual
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: circuitComplete
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Zona Batería
                  Positioned(
                    left: 10,
                    top: 100,
                    child: _buildSlot(
                        _batteryPlaced, Icons.battery_full, 'Batería'),
                  ),
                  // Zona Foco
                  Positioned(
                    right: 10,
                    top: 100,
                    child: _buildSlot(_bulbPlaced, Icons.lightbulb, 'Foco',
                        circuitComplete ? Colors.yellow : null),
                  ),
                  // Interruptor
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: (_batteryPlaced && _bulbPlaced)
                            ? () {
                                setState(() => _switchClosed = !_switchClosed);
                                HapticFeedback.lightImpact();
                              }
                            : null,
                        icon: Icon(
                            _switchClosed ? Icons.toggle_on : Icons.toggle_off),
                        label: Text(_switchClosed ? 'ON' : 'OFF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _switchClosed ? Colors.green : Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Botones de componentes
        if (!circuitComplete)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_batteryPlaced)
                  _buildComponentButton(
                      Icons.battery_full, 'Batería', Colors.blue, () {
                    setState(() => _batteryPlaced = true);
                    HapticFeedback.mediumImpact();
                  }),
                if (!_bulbPlaced)
                  _buildComponentButton(Icons.lightbulb, 'Foco', Colors.orange,
                      () {
                    setState(() => _bulbPlaced = true);
                    HapticFeedback.mediumImpact();
                  }),
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
          const Text('Arma el circuito',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSlot(bool filled, IconData icon, String label,
      [Color? glowColor]) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        border:
            Border.all(color: filled ? Colors.green : Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: filled ? Colors.green.withOpacity(0.2) : Colors.transparent,
        boxShadow: glowColor != null
            ? [BoxShadow(color: glowColor, blurRadius: 20, spreadRadius: 5)]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 40,
              color: glowColor ?? (filled ? Colors.green : Colors.grey)),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: filled ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildComponentButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// JUEGO 2: CONDUCTORES VS AISLANTES
class Juego2Conductores extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Conductores(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Conductores> createState() => _Juego2ConductoresState();
}

class _Juego2ConductoresState extends State<Juego2Conductores> {
  int _score = 0;
  int _currentItem = 0;
  int _streak = 0;
  int _timeLeft = 55;
  Timer? _timer;
  final Random _random = Random();
  String? _feedbackMessage;
  Color? _feedbackColor;

  final List<Map<String, dynamic>> _items = [
    {'name': 'Cobre', 'type': 'Conductor', 'icon': '🪝'},
    {'name': 'Goma', 'type': 'Aislante', 'icon': '🧤'},
    {'name': 'Oro', 'type': 'Conductor', 'icon': '💍'},
    {'name': 'Plástico', 'type': 'Aislante', 'icon': '🥤'},
    {'name': 'Agua salada', 'type': 'Conductor', 'icon': '💧'},
    {'name': 'Madera seca', 'type': 'Aislante', 'icon': '🪵'},
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
        const Text('¿Conduce electricidad?',
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
                child: _buildTypeButton(
                    'Conductor', Icons.flash_on, Colors.orange.shade600),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildTypeButton(
                    'Aislante', Icons.block, Colors.blue.shade600),
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

  Widget _buildTypeButton(String type, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(type),
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
          Text(type,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _checkAnswer(String selectedType) {
    final correctType = _items[_currentItem]['type'];
    final isCorrect = selectedType == correctType;

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
        _feedbackMessage = '¡Incorrecto! Era $correctType';
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
            Text('Materiales: $_currentItem/${_items.length}',
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

// JUEGO 3: IMANES (ATRAER O REPELAR)
class Juego3Imanes extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Imanes(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Imanes> createState() => _Juego3ImanesState();
}

class _Juego3ImanesState extends State<Juego3Imanes> {
  int _score = 0;
  int _currentItem = 0;
  int _streak = 0;
  int _timeLeft = 40;
  Timer? _timer;
  final Random _random = Random();
  String? _feedbackMessage;
  Color? _feedbackColor;

  final List<Map<String, dynamic>> _items = [
    {'poles': 'N - S', 'action': 'Atraen', 'icon': '🧲 🧲'},
    {'poles': 'N - N', 'action': 'Repelen', 'icon': '🧲 🔄 🧲'},
    {'poles': 'S - S', 'action': 'Repelen', 'icon': '🧲 🔄 🧲'},
    {'poles': 'S - N', 'action': 'Atraen', 'icon': '🧲 🧲'},
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
        const Text('¿Se atraen o se repelen?',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_items[_currentItem]['icon'],
                          style: const TextStyle(fontSize: 60)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(_items[_currentItem]['poles'],
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
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
                child: ElevatedButton.icon(
                  onPressed: () => _checkAnswer('Atraen'),
                  icon: const Icon(Icons.center_focus_strong, size: 30),
                  label: const Text('Se Atraen',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _checkAnswer('Repelen'),
                  icon: const Icon(Icons.open_in_full, size: 30),
                  label: const Text('Se Repelen',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                ),
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

  void _checkAnswer(String answer) {
    final correctAction = _items[_currentItem]['action'];
    final isCorrect = answer == correctAction;

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
        _feedbackMessage = '¡Incorrecto! Se $correctAction';
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
            Text('Imanes: $_currentItem/${_items.length}',
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

// JUEGO 4: QUIZ ELECTRICIDAD
class Juego4QuizElectricidad extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4QuizElectricidad(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4QuizElectricidad> createState() => _Juego4QuizElectricidadState();
}

class _Juego4QuizElectricidadState extends State<Juego4QuizElectricidad> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  int _streak = 0;
  int _timeLeft = 40;
  Timer? _timer;
  String? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué partícula lleva la carga eléctrica?',
      'answers': ['Electrón', 'Protón', 'Neutrón', 'Átomo'],
      'correctIndex': 0
    },
    {
      'question': 'Para que fluya la corriente, el circuito debe estar...',
      'answers': ['Abierto', 'Cerrado', 'Roto', 'Mojado'],
      'correctIndex': 1
    },
    {
      'question': 'La Tierra es un imán gigante.',
      'answers': ['Verdadero', 'Falso'],
      'correctIndex': 0
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
