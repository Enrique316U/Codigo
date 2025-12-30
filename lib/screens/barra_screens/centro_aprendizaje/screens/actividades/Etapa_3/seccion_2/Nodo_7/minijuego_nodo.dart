import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
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
        return Juego2VientoEnergia(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego3PesoAire(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego4Contaminacion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego5QuizAire(
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
              Icon(Icons.air, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Maestro del Aire!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Excelente! Sabes que el aire es invisible pero poderoso.',
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

// JUEGO 1: VIENTO Y ENERGÍA MEJORADO
class Juego2VientoEnergia extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2VientoEnergia(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2VientoEnergia> createState() => _Juego2VientoEnergiaState();
}

class _Juego2VientoEnergiaState extends State<Juego2VientoEnergia>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _windController;
  int energy = 0;
  int score = 0;
  int streak = 0;
  int tapCount = 0;
  Timer? _timer;
  Timer? _energyDecay;
  int _timeLeft = 45;
  double _windStrength = 0.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _windController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _startTimer();
    _startEnergyDecay();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _energyDecay?.cancel();
            if (energy >= 100) {
              score = 120;
              streak = 3;
            } else {
              score = energy;
              streak = 1;
            }
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  void _startEnergyDecay() {
    _energyDecay = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && energy > 0) {
        setState(() {
          energy = (energy - 1).clamp(0, 100);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _energyDecay?.cancel();
    _rotationController.dispose();
    _windController.dispose();
    super.dispose();
  }

  void _blow() {
    setState(() {
      tapCount++;
      energy = (energy + 8).clamp(0, 100);
      _windStrength = 1.0;

      // Si alcanza 100%, detener todo y completar automáticamente
      if (energy >= 100) {
        _timer?.cancel();
        _energyDecay?.cancel();
        score = 120;
        streak = 3;
        // Completar automáticamente después de breve pausa
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            widget.onGameComplete(score, streak);
          }
        });
      }
    });

    _windController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() => _windStrength = 0.0);
      }
    });

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar pantalla de finalización cuando el tiempo se acaba o se alcanza 100%
    bool gameEnded = _timeLeft == 0 || energy >= 100;

    if (gameEnded) {
      // Detener timers cuando el juego termina
      _timer?.cancel();
      _energyDecay?.cancel();

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚡', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              energy >= 100 ? '¡100% de Energía!' : '¡Juego Terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Energía generada: $energy%',
                style: const TextStyle(fontSize: 20)),
            Text('Soplidos: $tapCount',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text(
                '💡 El viento mueve el molino\ny genera electricidad limpia',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                int finalScore;
                int finalStreak;
                if (energy >= 100) {
                  finalScore = 120;
                  finalStreak = 3;
                } else {
                  finalScore = energy;
                  finalStreak = 1;
                }
                widget.onGameComplete(finalScore, finalStreak);
              },
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
          decoration: BoxDecoration(
            color: _timeLeft < 10
                ? Colors.red.shade100
                : widget.color.withOpacity(0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('⚡ $energy%',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: energy >= 100 ? Colors.green : Colors.black)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¡Sopla para generar energía eólica!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _blow,
            child: Container(
              color: Colors.lightBlue[50],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Molino giratorio
                  RotationTransition(
                    turns: _rotationController,
                    child: Icon(Icons.wind_power,
                        size: 200,
                        color: energy > 50 ? Colors.blue : Colors.grey),
                  ),
                  // Efecto de viento
                  if (_windStrength > 0)
                    Positioned(
                      left: 50,
                      child: AnimatedOpacity(
                        opacity: _windStrength,
                        duration: const Duration(milliseconds: 500),
                        child: const Text('💨💨💨',
                            style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  // Barra de energía
                  Positioned(
                    bottom: 80,
                    child: Container(
                      width: 200,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 200 * (energy / 100),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow,
                                  Colors.orange,
                                  Colors.red
                                ],
                              ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Toca rápidamente para soplar más fuerte',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ],
    );
  }
}

// JUEGO 2: PESO DEL AIRE MEJORADO
class Juego3PesoAire extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3PesoAire(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3PesoAire> createState() => _Juego3PesoAireState();
}

class _Juego3PesoAireState extends State<Juego3PesoAire> {
  final List<Map<String, dynamic>> _availableItems = [
    {'emoji': '🎈', 'name': 'Globo lleno', 'weight': 3, 'placed': false},
    {'emoji': '🎈', 'name': 'Globo vacío', 'weight': 1, 'placed': false},
    {'emoji': '⚽', 'name': 'Pelota', 'weight': 4, 'placed': false},
    {'emoji': '📄', 'name': 'Papel', 'weight': 1, 'placed': false},
    {'emoji': '📚', 'name': 'Libro', 'weight': 5, 'placed': false},
  ];

  List<Map<String, dynamic>> _leftSide = [];
  List<Map<String, dynamic>> _rightSide = [];
  int score = 0;
  int streak = 0;
  int _timeLeft = 50;
  Timer? _timer;
  bool _isBalanced = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
            _checkBalance();
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
    super.dispose();
  }

  int get _leftWeight =>
      _leftSide.fold(0, (sum, item) => sum + (item['weight'] as int));
  int get _rightWeight =>
      _rightSide.fold(0, (sum, item) => sum + (item['weight'] as int));

  double get _balanceAngle {
    int difference = _leftWeight - _rightWeight;
    return (difference / 8).clamp(-0.4, 0.4);
  }

  void _checkBalance() {
    int difference = (_leftWeight - _rightWeight).abs();
    if (difference <= 1 && _leftSide.isNotEmpty && _rightSide.isNotEmpty) {
      if (!_isBalanced) {
        setState(() {
          _isBalanced = true;
          score = 120;
          streak = 3;
        });
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) widget.onGameComplete(score, streak);
        });
      }
    } else {
      _isBalanced = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || _isBalanced) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isBalanced ? '⚖️' : '⏰',
                style: const TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              _isBalanced ? '¡Balanza Equilibrada!' : '¡Tiempo Terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Peso izquierdo: $_leftWeight',
                style: const TextStyle(fontSize: 16)),
            Text('Peso derecho: $_rightWeight',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('💡 El aire tiene peso, aunque\nno podamos verlo',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            if (!_isBalanced)
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
          color: widget.color.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text('⬅️ $_leftWeight kg',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text('⚖️',
                  style: TextStyle(
                      fontSize: 24,
                      color: _isBalanced ? Colors.green : Colors.black)),
              Text('$_rightWeight kg ➡️',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Equilibra la balanza arrastrando objetos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        // Items disponibles
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableItems.length,
            itemBuilder: (context, index) {
              final item = _availableItems[index];
              if (item['placed']) return const SizedBox();

              return Draggable<int>(
                data: index,
                feedback:
                    Text(item['emoji'], style: const TextStyle(fontSize: 50)),
                childWhenDragging: const SizedBox(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['emoji'], style: const TextStyle(fontSize: 40)),
                      Text('${item['weight']}kg',
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                onDragCompleted: () {},
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Balanza con física
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Punto de apoyo
              const Positioned(
                top: 120,
                child: Text('▼', style: TextStyle(fontSize: 40)),
              ),
              // Barra de balanza
              Positioned(
                top: 100,
                child: Transform.rotate(
                  angle: _balanceAngle,
                  child: Container(
                    width: 300,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isBalanced ? Colors.green : Colors.brown,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              // Platos
              Positioned(
                top: 50,
                left: 30,
                child: DragTarget<int>(
                  onAcceptWithDetails: (details) {
                    setState(() {
                      _availableItems[details.data]['placed'] = true;
                      _leftSide.add(_availableItems[details.data]);
                    });
                    _checkBalance();
                    HapticFeedback.selectionClick();
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.brown),
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _leftSide.isEmpty
                            ? const Icon(Icons.add, size: 40)
                            : Wrap(
                                children: _leftSide
                                    .map((item) => Text(item['emoji'],
                                        style: const TextStyle(fontSize: 30)))
                                    .toList(),
                              ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: DragTarget<int>(
                  onAcceptWithDetails: (details) {
                    setState(() {
                      _availableItems[details.data]['placed'] = true;
                      _rightSide.add(_availableItems[details.data]);
                    });
                    _checkBalance();
                    HapticFeedback.selectionClick();
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.brown),
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _rightSide.isEmpty
                            ? const Icon(Icons.add, size: 40)
                            : Wrap(
                                children: _rightSide
                                    .map((item) => Text(item['emoji'],
                                        style: const TextStyle(fontSize: 30)))
                                    .toList(),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Diferencia máxima permitida: 1 kg',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
      ],
    );
  }
}

// JUEGO 3: FILTROS DE AIRE (NUEVO)
class Juego4Contaminacion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4Contaminacion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Contaminacion> createState() => _Juego4ContaminacionState();
}

class _Juego4ContaminacionState extends State<Juego4Contaminacion> {
  final List<Map<String, double>> _particles = [];
  final List<Map<String, double>> _filters = [
    {'x': 0.2, 'y': 0.5, 'active': 0.0},
    {'x': 0.5, 'y': 0.3, 'active': 0.0},
    {'x': 0.8, 'y': 0.6, 'active': 0.0},
  ];

  int particlesCaptured = 0;
  int score = 0;
  int streak = 0;
  Timer? _timer;
  Timer? _particleSpawner;
  Timer? _particleMover;
  int _timeLeft = 45;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startParticleSpawner();
    _startParticleMovement();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _cleanup();
            if (particlesCaptured >= 15) {
              score = 120;
              streak = 3;
            } else {
              score = particlesCaptured * 7;
              streak = 1;
            }
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  void _startParticleSpawner() {
    _particleSpawner =
        Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (mounted && _timeLeft > 0) {
        setState(() {
          _particles.add({
            'x': (0.1 + (0.8 * ((_particles.length * 37) % 100) / 100)),
            'y': 0.0,
            'speed': 0.015 + (0.01 * ((_particles.length % 3) / 3)),
          });
        });
      }
    });
  }

  void _startParticleMovement() {
    _particleMover = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted && _timeLeft > 0) {
        setState(() {
          for (int i = _particles.length - 1; i >= 0; i--) {
            _particles[i]['y'] =
                (_particles[i]['y']! + _particles[i]['speed']!);

            // Verificar captura por filtros activos
            for (var filter in _filters) {
              if (filter['active']! > 0) {
                double dx = (_particles[i]['x']! - filter['x']!).abs();
                double dy = (_particles[i]['y']! - filter['y']!).abs();
                if (dx < 0.15 && dy < 0.15) {
                  _particles.removeAt(i);
                  particlesCaptured++;
                  HapticFeedback.lightImpact();
                  break;
                }
              }
            }

            // Eliminar partículas que salieron de pantalla
            if (i < _particles.length && _particles[i]['y']! > 1.0) {
              _particles.removeAt(i);
            }
          }

          // Reducir tiempo activo de filtros
          for (var filter in _filters) {
            if (filter['active']! > 0) {
              filter['active'] = (filter['active']! - 0.05).clamp(0.0, 1.0);
            }
          }
        });
      }
    });
  }

  void _activateFilter(int index) {
    setState(() {
      _filters[index]['active'] = 1.0;
    });
    HapticFeedback.selectionClick();
  }

  void _cleanup() {
    _timer?.cancel();
    _particleSpawner?.cancel();
    _particleMover?.cancel();
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || particlesCaptured >= 15) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(particlesCaptured >= 15 ? '🌿' : '⏰',
                style: const TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              particlesCaptured >= 15
                  ? '¡Aire Purificado!'
                  : '¡Juego Terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Partículas capturadas: $particlesCaptured/15',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text(
                '💡 Los filtros limpian el aire\natrapando partículas dañinas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (particlesCaptured >= 15) {
                  score = 120;
                  streak = 3;
                } else {
                  score = particlesCaptured * 7;
                  streak = 1;
                }
                widget.onGameComplete(score, streak);
              },
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
          color: widget.color.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text('🎯 $particlesCaptured/15',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Activa los filtros para atrapar partículas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Stack(
            children: [
              // Partículas cayendo
              ...List.generate(_particles.length, (index) {
                final particle = _particles[index];
                return Positioned(
                  left: MediaQuery.of(context).size.width * particle['x']!,
                  top:
                      MediaQuery.of(context).size.height * 0.7 * particle['y']!,
                  child: const Text('⚫', style: TextStyle(fontSize: 20)),
                );
              }),

              // Filtros activables
              ...List.generate(_filters.length, (index) {
                final filter = _filters[index];
                bool isActive = filter['active']! > 0;
                return Positioned(
                  left: MediaQuery.of(context).size.width * filter['x']!,
                  top: MediaQuery.of(context).size.height * 0.7 * filter['y']!,
                  child: GestureDetector(
                    onTap: () => _activateFilter(index),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withOpacity(filter['active']!)
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: isActive ? Colors.green : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.air,
                          size: 40,
                          color: isActive ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Toca los filtros para activarlos temporalmente',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
      ],
    );
  }
}

// JUEGO 5: QUIZ DEL AIRE
class Juego5QuizAire extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizAire(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizAire> createState() => _Juego5QuizAireState();
}

class _Juego5QuizAireState extends State<Juego5QuizAire>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Podemos ver el aire?',
      'answers': ['Sí, es azul', 'No, es invisible', 'Es rojo', 'Es verde'],
      'correctIndex': 1
    },
    {
      'question': '¿El aire pesa?',
      'answers': ['No pesa nada', 'Sí, tiene peso', 'Solo de noche', 'A veces'],
      'correctIndex': 1
    },
    {
      'question': '¿Qué necesitamos del aire para vivir?',
      'answers': ['Oxígeno', 'Polvo', 'Humo', 'Nada'],
      'correctIndex': 0
    },
    {
      'question': '¿Qué mueve el viento?',
      'answers': ['Montañas', 'El aire en movimiento', 'Robots', 'La luna'],
      'correctIndex': 1
    },
    {
      'question': '¿Qué contamina el aire?',
      'answers': ['Árboles', 'Flores', 'Humo de carros', 'Nubes'],
      'correctIndex': 2
    },
    {
      'question': '¿Cómo ayudan los árboles al aire?',
      'answers': [
        'Lo ensucian',
        'Lo limpian y dan oxígeno',
        'No hacen nada',
        'Lo calientan'
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

  String? _selectedAnswer;
  bool _showingFeedback = false;

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentQuestionIndex >= questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌬️', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              currentQuestionIndex >= questions.length
                  ? '¡Quiz Completado!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            Text(
                'Preguntas correctas: $currentQuestionIndex/${questions.length}',
                style: const TextStyle(fontSize: 16)),
            if (streak > 1)
              Text('🔥 Racha máxima: $streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            const Text('💡 El aire es vital para la vida\nen nuestro planeta',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
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
                Text('Pregunta ${currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text('🎯 $score',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (streak > 1)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('🔥 Racha: $streak',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange)),
            ),
          const SizedBox(height: 30),
          const Text('🌬️', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 20),
          Text(
            question['question'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: question['answers'].length,
              itemBuilder: (context, index) {
                bool isCorrect = index == question['correctIndex'];
                bool isSelected = _selectedAnswer == question['answers'][index];

                Color buttonColor = widget.color.withOpacity(0.8);
                if (_showingFeedback && isSelected) {
                  buttonColor = isCorrect ? Colors.green : Colors.red;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _showingFeedback ? null : () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              question['answers'][index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          if (_showingFeedback && isSelected)
                            Text(isCorrect ? '✓' : '✗',
                                style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _checkAnswer(int index) {
    bool isCorrect = index == questions[currentQuestionIndex]['correctIndex'];

    setState(() {
      _selectedAnswer = questions[currentQuestionIndex]['answers'][index];
      _showingFeedback = true;
    });

    if (isCorrect) {
      int points = 20 + (streak * 5).toInt();
      score += points;
      streak++;
      HapticFeedback.mediumImpact();
    } else {
      streak = 0;
      HapticFeedback.heavyImpact();
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          currentQuestionIndex++;
          _selectedAnswer = null;
          _showingFeedback = false;
        });
      }
    });
  }
}
