// ETAPA 4 - SECCIÓN 1 - NODO 4: ELECTRICIDAD BÁSICA
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
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
        return Juego1Circuito(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Conductores(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Seguridad(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4Componentes(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizElectrico(
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
              Icon(Icons.electric_bolt, size: 100, color: widget.color),
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
                '¡Brillante! Sabes cómo funciona la electricidad.',
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

// JUEGO 1: CIRCUITO SIMPLE
class Juego1Circuito extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1Circuito(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1Circuito> createState() => _Juego1CircuitoState();
}

class _Juego1CircuitoState extends State<Juego1Circuito> {
  int _score = 0;
  bool batteryPlaced = false;
  bool bulbPlaced = false;
  bool switchPlaced = false;
  bool isSwitchOn = false;
  int _timeLeft = 30;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
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
    if (batteryPlaced && bulbPlaced && switchPlaced && isSwitchOn) {
      _score = 100;
    } else {
      _score = ((batteryPlaced ? 20 : 0) +
          (bulbPlaced ? 20 : 0) +
          (switchPlaced ? 20 : 0) +
          (isSwitchOn ? 40 : 0));
    }
    widget.onGameComplete(_score.clamp(0, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isComplete = batteryPlaced && bulbPlaced && switchPlaced;

    if (isComplete && isSwitchOn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.5, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: const Icon(Icons.lightbulb,
                      size: 100, color: Colors.yellow),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('¡Hágase la luz!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Tiempo restante: $_timeLeft s',
                style: const TextStyle(fontSize: 18, color: Colors.blue)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                widget.onGameComplete(100);
              },
              child: const Text('Continuar'),
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
              const Text('Arma el circuito',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Circuito base (cables)
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 5),
                  ),
                ),
              ),
              // Slots
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: bulbPlaced
                            ? Icon(Icons.lightbulb_outline,
                                size: 50,
                                color: isSwitchOn ? Colors.yellow : Colors.grey)
                            : const Icon(Icons.add, color: Colors.grey),
                      ),
                    );
                  },
                  onAccept: (data) {
                    if (data == 'bulb') {
                      setState(() => bulbPlaced = true);
                      HapticFeedback.mediumImpact();
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: batteryPlaced
                            ? const Icon(Icons.battery_full,
                                size: 50, color: Colors.green)
                            : const Icon(Icons.add, color: Colors.grey),
                      ),
                    );
                  },
                  onAccept: (data) {
                    if (data == 'battery') {
                      setState(() => batteryPlaced = true);
                      HapticFeedback.mediumImpact();
                    }
                  },
                ),
              ),
              Positioned(
                left: 20,
                top: 0,
                bottom: 0,
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          if (switchPlaced && isComplete) {
                            setState(() => isSwitchOn = !isSwitchOn);
                            HapticFeedback.mediumImpact();
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: switchPlaced
                              ? Icon(
                                  isSwitchOn
                                      ? Icons.toggle_on
                                      : Icons.toggle_off,
                                  size: 50,
                                  color: isSwitchOn ? Colors.green : Colors.red)
                              : const Icon(Icons.add, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                  onAccept: (data) {
                    if (data == 'switch') {
                      setState(() => switchPlaced = true);
                      HapticFeedback.mediumImpact();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        // Piezas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!batteryPlaced)
              Draggable<String>(
                data: 'battery',
                feedback: const Icon(Icons.battery_full,
                    size: 50, color: Colors.green),
                child: const Column(
                  children: [
                    Icon(Icons.battery_full, size: 50, color: Colors.green),
                    Text('Batería'),
                  ],
                ),
              ),
            if (!bulbPlaced)
              Draggable<String>(
                data: 'bulb',
                feedback: const Icon(Icons.lightbulb_outline,
                    size: 50, color: Colors.grey),
                child: const Column(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 50, color: Colors.grey),
                    Text('Bombilla'),
                  ],
                ),
              ),
            if (!switchPlaced)
              Draggable<String>(
                data: 'switch',
                feedback:
                    const Icon(Icons.toggle_off, size: 50, color: Colors.red),
                child: const Column(
                  children: [
                    Icon(Icons.toggle_off, size: 50, color: Colors.red),
                    Text('Interruptor'),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
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
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Cobre', 'conductor': true, 'icon': '🪝'},
    {'name': 'Madera', 'conductor': false, 'icon': '🪵'},
    {'name': 'Agua', 'conductor': true, 'icon': '💧'},
    {'name': 'Plástico', 'conductor': false, 'icon': '🥤'},
    {'name': 'Oro', 'conductor': true, 'icon': '💍'},
    {'name': 'Goma', 'conductor': false, 'icon': '👟'},
    {'name': 'Aluminio', 'conductor': true, 'icon': '🥫'},
    {'name': 'Vidrio', 'conductor': false, 'icon': '🪩'},
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
    if (_currentItem >= _items.length) {
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
              Text('Material ${_currentItem + 1}/${_items.length}',
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
        const Text('¿Conduce electricidad o aísla?',
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
                    data: _items[_currentItem]['conductor'],
                    feedback: Material(
                      color: Colors.transparent,
                      child: Text(_items[_currentItem]['icon'],
                          style: const TextStyle(fontSize: 80)),
                    ),
                    childWhenDragging: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow.shade100,
                            Colors.blue.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_items[_currentItem]['icon'],
                              style: const TextStyle(fontSize: 80)),
                          const SizedBox(height: 10),
                          Text(_items[_currentItem]['name'],
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
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
            _buildZone('Aislante', '🚫', false, Colors.orange),
            _buildZone('Conductor', '⚡', true, Colors.blue),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, bool isConductor, Color color) {
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
        bool correct = data == isConductor;
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

// JUEGO 3: SEGURIDAD ELÉCTRICA
class Juego3Seguridad extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Seguridad(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Seguridad> createState() => _Juego3SeguridadState();
}

class _Juego3SeguridadState extends State<Juego3Seguridad> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Manos mojadas', 'safe': false, 'icon': '✋💧'},
    {'name': 'Cable pelado', 'safe': false, 'icon': '🔌💥'},
    {'name': 'Apagar luz', 'safe': true, 'icon': '💡⬇️'},
    {'name': 'Sobrecarga', 'safe': false, 'icon': '🔌🔌🔌'},
    {'name': 'Protector', 'safe': true, 'icon': '🛡️'},
    {'name': 'Enchufar seguro', 'safe': true, 'icon': '🔌✔️'},
    {'name': 'Cables expuestos', 'safe': false, 'icon': '⚡⚠️'},
    {'name': 'Desconectar', 'safe': true, 'icon': '🔌❌'},
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
    if (_currentItem >= _items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Inspección Completa!',
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
              Text('Situación ${_currentItem + 1}/${_items.length}',
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
        const Text('¿Es Seguro o Peligroso?',
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
                    data: _items[_currentItem]['safe'],
                    feedback: Material(
                      color: Colors.transparent,
                      child: Text(_items[_currentItem]['icon'],
                          style: const TextStyle(fontSize: 80)),
                    ),
                    childWhenDragging: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade100, Colors.green.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_items[_currentItem]['icon'],
                              style: const TextStyle(fontSize: 80)),
                          const SizedBox(height: 10),
                          Text(_items[_currentItem]['name'],
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
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
            _buildZone('Peligroso', '⚠️', false, Colors.red),
            _buildZone('Seguro', '✅', true, Colors.green),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, bool isSafe, Color color) {
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
        bool correct = data == isSafe;
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

// JUEGO 4: COMPONENTES
class Juego4Componentes extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4Componentes(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Componentes> createState() => _Juego4ComponentesState();
}

class _Juego4ComponentesState extends State<Juego4Componentes> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 20;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Batería', 'icon': Icons.battery_full},
    {'name': 'Bombilla', 'icon': Icons.lightbulb},
    {'name': 'Interruptor', 'icon': Icons.toggle_on},
    {'name': 'Cable', 'icon': Icons.linear_scale},
    {'name': 'Resistencia', 'icon': Icons.show_chart},
    {'name': 'Motor', 'icon': Icons.settings},
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
    if (_currentItem >= _items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Identificación Completa!',
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
              Text('Componente ${_currentItem + 1}/${_items.length}',
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
        const Text('¿Cómo se llama este componente?',
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
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade100, Colors.cyan.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(_items[_currentItem]['icon'],
                        size: 100, color: widget.color),
                  ),
                );
              },
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _items.map((item) {
            return ElevatedButton(
              onPressed: () {
                bool correct = item['name'] == _items[_currentItem]['name'];
                setState(() {
                  if (correct) {
                    _streak++;
                    _score += 16 + (_streak >= 3 ? 7 : 0);
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
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color.withOpacity(0.8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(item['name'],
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            );
          }).toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// JUEGO 5: QUIZ ELÉCTRICO
class Juego5QuizElectrico extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizElectrico(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizElectrico> createState() => _Juego5QuizElectricoState();
}

class _Juego5QuizElectricoState extends State<Juego5QuizElectrico> {
  int _score = 0;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _timeLeft = 10;
  Timer? _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué necesitamos para que la luz encienda?',
      'answers': ['Circuito cerrado', 'Circuito abierto', 'Agua', 'Nada'],
      'correctIndex': 0,
      'explanation':
          'Un circuito cerrado permite que la electricidad fluya continuamente desde la batería hasta la bombilla.'
    },
    {
      'question': '¿Qué material es mejor conductor?',
      'answers': ['Plástico', 'Madera', 'Metal', 'Goma'],
      'correctIndex': 2,
      'explanation':
          'Los metales como el cobre y el oro son excelentes conductores porque permiten el flujo de electrones.'
    },
    {
      'question': '¿Es seguro tocar enchufes mojados?',
      'answers': ['Sí', 'No', 'A veces', 'Solo si es rápido'],
      'correctIndex': 1,
      'explanation':
          'El agua conduce electricidad y puede causar descargas eléctricas peligrosas. Nunca toques enchufes con manos mojadas.'
    },
    {
      'question': '¿Qué hace un interruptor?',
      'answers': [
        'Genera electricidad',
        'Abre/cierra el circuito',
        'Guarda energía',
        'Nada'
      ],
      'correctIndex': 1,
      'explanation':
          'Un interruptor abre o cierra el circuito, permitiendo o deteniendo el flujo de electricidad.'
    },
    {
      'question': '¿Cuál es un aislante eléctrico?',
      'answers': ['Aluminio', 'Agua salada', 'Goma', 'Hierro'],
      'correctIndex': 2,
      'explanation':
          'La goma es un aislante que no permite el paso de electricidad, por eso se usa para cables eléctricos.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_answered) {
        setState(() => _timeLeft--);
      } else if (_timeLeft == 0 && !_answered) {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    setState(() {
      _answered = true;
      _selectedAnswer = -1;
    });
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(seconds: 2), _nextQuestion);
  }

  void _handleAnswer(int index) {
    if (_answered) return;

    bool correct = index == _questions[_currentQuestion]['correctIndex'];
    setState(() {
      _answered = true;
      _selectedAnswer = index;
      if (correct) {
        _score += 20;
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    });

    Future.delayed(const Duration(seconds: 2), _nextQuestion);
  }

  void _nextQuestion() {
    _timer?.cancel();
    if (_currentQuestion + 1 < _questions.length) {
      setState(() {
        _currentQuestion++;
        _answered = false;
        _selectedAnswer = null;
      });
      _startTimer();
    } else {
      widget.onGameComplete(_score.clamp(0, 100));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final correctIndex = question['correctIndex'] as int;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pregunta ${_currentQuestion + 1}/${_questions.length}',
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
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Text(
              question['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...List.generate((question['answers'] as List).length, (index) {
            Color? bgColor;
            if (_answered) {
              if (index == correctIndex) {
                bgColor = Colors.green;
              } else if (index == _selectedAnswer) {
                bgColor = Colors.red;
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Material(
                elevation: _answered && index == correctIndex ? 8 : 2,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => _handleAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor ?? Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAnswer == index
                            ? Colors.blue
                            : Colors.grey.shade300,
                        width: _selectedAnswer == index ? 3 : 1,
                      ),
                    ),
                    child: Text(
                      '${String.fromCharCode(65 + index)}. ${question['answers'][index]}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _answered &&
                                (index == correctIndex ||
                                    index == _selectedAnswer)
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _answered &&
                                (index == correctIndex ||
                                    index == _selectedAnswer)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          if (_answered) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _selectedAnswer == correctIndex
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedAnswer == correctIndex
                      ? Colors.green
                      : Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _selectedAnswer == correctIndex
                        ? '¡Correcto! 🎉'
                        : _selectedAnswer == -1
                            ? '¡Tiempo agotado! ⏱️'
                            : '¡Incorrecto! 😕',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question['explanation'],
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
