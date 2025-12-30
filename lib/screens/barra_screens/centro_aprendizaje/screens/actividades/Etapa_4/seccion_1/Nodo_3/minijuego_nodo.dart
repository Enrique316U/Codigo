// ETAPA 4 - SECCIÓN 1 - NODO 3: TIPOS DE ENERGÍA
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
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
        return Juego1Renovable(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Transformacion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Ahorro(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4TiposEnergia(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizEnergia(
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
                '¡Maestro de la Energía!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Genial! Sabes cómo usar y cuidar la energía.',
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

// JUEGO 1: RENOVABLE VS NO RENOVABLE
class Juego1Renovable extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1Renovable(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1Renovable> createState() => _Juego1RenovableState();
}

class _Juego1RenovableState extends State<Juego1Renovable> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Sol', 'renovable': true, 'icon': '☀️'},
    {'name': 'Carbón', 'renovable': false, 'icon': '⚫'},
    {'name': 'Viento', 'renovable': true, 'icon': '💨'},
    {'name': 'Petróleo', 'renovable': false, 'icon': '🛢️'},
    {'name': 'Agua', 'renovable': true, 'icon': '🌊'},
    {'name': 'Gas Natural', 'renovable': false, 'icon': '🔥'},
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('¿Es Renovable o No Renovable?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              if (_streak >= 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Racha: $_streak 🔥',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Draggable<bool>(
                    data: _items[_currentItem]['renovable'],
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
                          colors: [Colors.green.shade100, Colors.blue.shade100],
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
            _buildZone('No Renovable', '🏭', false, Colors.grey),
            _buildZone('Renovable', '🌱', true, Colors.green),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, bool isRenovable, Color color) {
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
        setState(() {
          if (data == isRenovable) {
            _streak++;
            _score += 15 + (_streak >= 3 ? 5 : 0);
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

// JUEGO 2: TRANSFORMACIÓN DE ENERGÍA
class Juego2Transformacion extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Transformacion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Transformacion> createState() => _Juego2TransformacionState();
}

class _Juego2TransformacionState extends State<Juego2Transformacion> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 20;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {
      'source': 'Panel Solar',
      'output': 'Luz',
      'icon': '☀️➡️💡',
      'question': '¿Qué produce?'
    },
    {
      'source': 'Batería',
      'output': 'Movimiento',
      'icon': '🔋➡️🚗',
      'question': '¿Qué genera?'
    },
    {
      'source': 'Fuego',
      'output': 'Calor',
      'icon': '🔥➡️🌡️',
      'question': '¿Qué emite?'
    },
    {
      'source': 'Molino',
      'output': 'Electricidad',
      'icon': '🌪️➡️⚡',
      'question': '¿Qué produce?'
    },
    {
      'source': 'Comida',
      'output': 'Energía',
      'icon': '🍎➡️💪',
      'question': '¿Qué nos da?'
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

  void _handleAnswer(String answer) {
    bool correct = answer == _items[_currentItem]['output'];
    setState(() {
      if (correct) {
        _streak++;
        _score += 18 + (_streak >= 3 ? 7 : 0);
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
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItem >= _items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Transformación Completa!',
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

    final List<String> options = [
      'Luz',
      'Movimiento',
      'Calor',
      'Electricidad',
      'Energía'
    ]..shuffle(_random);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
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
            ],
          ),
          if (_streak >= 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Racha: $_streak 🔥',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 30),
          const Text('Conecta la fuente con su uso',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.8, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade100, Colors.yellow.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange, width: 3),
                  ),
                  child: Column(
                    children: [
                      Text(_items[_currentItem]['icon']!,
                          style: const TextStyle(fontSize: 60)),
                      const SizedBox(height: 15),
                      Text(_items[_currentItem]['source']!,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(_items[_currentItem]['question']!,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: options.take(3).map((option) {
              return ElevatedButton(
                onPressed: () => _handleAnswer(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(option,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// JUEGO 3: AHORRO DE ENERGÍA
class Juego3Ahorro extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Ahorro(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Ahorro> createState() => _Juego3AhorroState();
}

class _Juego3AhorroState extends State<Juego3Ahorro> {
  List<bool> _lightsOn = [true, true, true, true, true, true];
  int _score = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;

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
    widget.onGameComplete(_score.clamp(0, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int lightsOff = _lightsOn.where((isOn) => !isOn).length;
    bool allOff = _lightsOn.every((isOn) => !isOn);

    if (allOff) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Energía Ahorrada!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score pts',
                style: const TextStyle(fontSize: 20)),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('¡Apaga todas las luces!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 10),
              Text('Apagadas: $lightsOff/${_lightsOn.length}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: _lightsOn.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0.8, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: GestureDetector(
                      onTap: () {
                        if (_lightsOn[index]) {
                          setState(() {
                            _lightsOn[index] = false;
                            _streak++;
                            _score += 15 + (_streak >= 3 ? 5 : 0);
                            HapticFeedback.lightImpact();
                          });

                          if (_lightsOn.every((isOn) => !isOn)) {
                            _endGame();
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: _lightsOn[index]
                              ? LinearGradient(
                                  colors: [
                                    Colors.yellow.shade200,
                                    Colors.orange.shade200
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: _lightsOn[index] ? null : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _lightsOn[index]
                                  ? Colors.orange
                                  : Colors.black,
                              width: 3),
                          boxShadow: _lightsOn[index]
                              ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.5),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _lightsOn[index]
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                              size: 50,
                              color: _lightsOn[index]
                                  ? Colors.orange
                                  : Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _lightsOn[index] ? 'Encendido' : 'Apagado',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _lightsOn[index]
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// JUEGO 4: TIPOS DE ENERGÍA
class Juego4TiposEnergia extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4TiposEnergia(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4TiposEnergia> createState() => _Juego4TiposEnergiaState();
}

class _Juego4TiposEnergiaState extends State<Juego4TiposEnergia> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 30;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, String>> _items = [
    {'name': 'Pelota rodando', 'type': 'Cinética', 'icon': '⚽'},
    {'name': 'Fuego', 'type': 'Térmica', 'icon': '🔥'},
    {'name': 'Lámpara', 'type': 'Lumínica', 'icon': '💡'},
    {'name': 'Batería', 'type': 'Química', 'icon': '🔋'},
    {'name': 'Corredor', 'type': 'Cinética', 'icon': '🏃'},
    {'name': 'Estufa', 'type': 'Térmica', 'icon': '🔥'},
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('¿Qué tipo de energía es?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              if (_streak >= 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Racha: $_streak 🔥',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
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
                      child: Text(_items[_currentItem]['icon']!,
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
                            Colors.purple.shade100,
                            Colors.pink.shade100
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
                          Text(_items[_currentItem]['icon']!,
                              style: const TextStyle(fontSize: 80)),
                          const SizedBox(height: 10),
                          Text(_items[_currentItem]['name']!,
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
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildZone('Cinética', '⚽', Colors.blue),
            _buildZone('Térmica', '🔥', Colors.red),
            _buildZone('Lumínica', '💡', Colors.yellow),
            _buildZone('Química', '🔋', Colors.green),
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
                      color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == label) {
            _streak++;
            _score += 20 + (_streak >= 3 ? 8 : 0);
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

// JUEGO 5: QUIZ DE ENERGÍA
class Juego5QuizEnergia extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizEnergia(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizEnergia> createState() => _Juego5QuizEnergiaState();
}

class _Juego5QuizEnergiaState extends State<Juego5QuizEnergia> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  int _timeLeft = 30;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuál es la fuente de energía más grande?',
      'answers': ['El Sol', 'Una pila', 'El viento', 'El fuego'],
      'correctIndex': 0
    },
    {
      'question': '¿Qué energía usa un ventilador?',
      'answers': ['Solar', 'Eléctrica', 'Química', 'Nuclear'],
      'correctIndex': 1
    },
    {
      'question': '¿Debemos apagar la luz al salir?',
      'answers': ['No', 'A veces', 'Sí', 'Da igual'],
      'correctIndex': 2
    },
    {
      'question': '¿Qué tipo de energía tiene una batería?',
      'answers': ['Cinética', 'Química', 'Térmica', 'Lumínica'],
      'correctIndex': 1
    },
    {
      'question': '¿El petróleo es renovable?',
      'answers': ['Sí', 'No', 'A veces', 'Depende'],
      'correctIndex': 1
    },
  ];

  @override
  void initState() {
    super.initState();
    _questions.shuffle(_random);
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
    if (_currentQuestionIndex >= _questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Quiz Completado!',
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

    final question = _questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pregunta ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
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
          if (_streak >= 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Racha: $_streak 🔥',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 30),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.8, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.green.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.color, width: 3),
                  ),
                  child: Text(
                    question['question'],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
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
                    padding: const EdgeInsets.all(18),
                    backgroundColor: widget.color.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    question['answers'][index],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
    bool correct = index == _questions[_currentQuestionIndex]['correctIndex'];
    setState(() {
      if (correct) {
        _streak++;
        _score += 18 + (_streak >= 3 ? 7 : 0);
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        HapticFeedback.heavyImpact();
      }
      _currentQuestionIndex++;
    });

    if (_currentQuestionIndex >= _questions.length) {
      _endGame();
    }
  }
}
