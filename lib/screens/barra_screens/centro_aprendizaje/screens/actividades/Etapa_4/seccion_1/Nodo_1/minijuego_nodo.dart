// ETAPA 4 - SECCIÓN 1 - NODO 1: SISTEMA DIGESTIVO Y RESPIRATORIO
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo1Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo1Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo1Screen> createState() => _MinijuegoNodo1ScreenState();
}

class _MinijuegoNodo1ScreenState extends State<MinijuegoNodo1Screen> {
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
        return Juego1OrdenDigestivo(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Respiracion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3ClasificaOrganos(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4Nutrientes(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizCuerpo(
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
              Icon(Icons.health_and_safety, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Experto en el Cuerpo Humano!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Increíble! Conoces muy bien cómo funciona tu cuerpo.',
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

// JUEGO 1: ORDEN DIGESTIVO - Memoria Rápida
class Juego1OrdenDigestivo extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1OrdenDigestivo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1OrdenDigestivo> createState() => _Juego1OrdenDigestivoState();
}

class _Juego1OrdenDigestivoState extends State<Juego1OrdenDigestivo> {
  final Random _random = Random();
  Timer? _timer;
  int _timeLeft = 45;
  int _score = 0;
  int _streak = 0;
  bool _showingSequence = true;

  final List<Map<String, dynamic>> _digestiveSteps = [
    {'name': 'Boca', 'icon': '👄', 'desc': 'Masticación'},
    {'name': 'Esófago', 'icon': '⬇️', 'desc': 'Transporte'},
    {'name': 'Estómago', 'icon': '🥣', 'desc': 'Digestión'},
    {'name': 'Intestinos', 'icon': '➰', 'desc': 'Absorción'},
  ];

  List<Map<String, dynamic>> _shuffledOptions = [];
  List<Map<String, dynamic>> _selectedOrder = [];

  @override
  void initState() {
    super.initState();
    _shuffledOptions = List.from(_digestiveSteps);
    _shuffledOptions.shuffle(_random);
    _startTimer();

    // Mostrar secuencia por 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showingSequence = false;
        });
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _finishGame();
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

  void _checkAnswer(Map<String, dynamic> selected) {
    if (_selectedOrder.length >= _digestiveSteps.length) return;

    bool isCorrect =
        selected['name'] == _digestiveSteps[_selectedOrder.length]['name'];

    setState(() {
      _selectedOrder.add(selected);

      if (isCorrect) {
        _streak++;
        int points = 20 + (_streak >= 3 ? 10 : 0);
        _score += points;
        HapticFeedback.mediumImpact();

        if (_selectedOrder.length == _digestiveSteps.length) {
          _timer?.cancel();
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) _finishGame();
          });
        }
      } else {
        _streak = 0;
        _score = (_score - 10).clamp(0, 1000);
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _finishGame() {
    widget.onGameComplete(_score);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (value * 0.2),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          _buildHeader(),
          if (_showingSequence) _buildSequenceDisplay() else _buildGameArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.color.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 10 ? Colors.red : widget.color)),
              Text('Puntos: $_score',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
            ],
          ),
          if (_streak >= 3)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('🔥 Racha x$_streak',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildSequenceDisplay() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡MEMORIZA EL ORDEN!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const Text('El camino de la comida:',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 30),
            ..._digestiveSteps.asMap().entries.map((entry) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: widget.color, width: 2),
                ),
                child: Row(
                  children: [
                    Text('${entry.key + 1}. ',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(entry.value['icon'],
                        style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.value['name'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(entry.value['desc'],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameArea() {
    return Expanded(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('¡Ordena el proceso digestivo!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _shuffledOptions.length,
                    itemBuilder: (context, index) {
                      final item = _shuffledOptions[index];
                      bool isUsed =
                          _selectedOrder.any((s) => s['name'] == item['name']);

                      return AnimatedOpacity(
                        opacity: isUsed ? 0.3 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: isUsed ? null : () => _checkAnswer(item),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  widget.color.withOpacity(isUsed ? 0.1 : 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: widget.color, width: 2),
                            ),
                            child: Row(
                              children: [
                                Text(item['icon'],
                                    style: const TextStyle(fontSize: 32)),
                                const SizedBox(width: 12),
                                Text(item['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: widget.color, width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool hasItem = index < _selectedOrder.length;
                        bool isCorrect = hasItem &&
                            _selectedOrder[index]['name'] ==
                                _digestiveSteps[index]['name'];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: hasItem
                                ? (isCorrect
                                    ? Colors.green.shade100
                                    : Colors.red.shade100)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: hasItem
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text('${index + 1}. ',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              if (hasItem) ...[
                                Text(_selectedOrder[index]['icon'],
                                    style: const TextStyle(fontSize: 28)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(_selectedOrder[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color:
                                        isCorrect ? Colors.green : Colors.red),
                              ] else
                                const Text('???',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey)),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// JUEGO 2: RESPIRACIÓN - Timing Perfecto
class Juego2Respiracion extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Respiracion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Respiracion> createState() => _Juego2RespiracionState();
}

class _Juego2RespiracionState extends State<Juego2Respiracion>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Timer? _breathTimer;
  int _timeLeft = 30;
  int _score = 0;
  int _streak = 0;
  int _breathsCompleted = 0;
  final int _targetBreaths = 8;

  bool _canTap = true;
  int _breathPhase = 0; // 0=inhale, 1=hold, 2=exhale, 3=hold
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _startTimer();
    _startBreathCycle();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _breathTimer?.cancel();
            _finishGame();
          }
        });
      }
    });
  }

  void _startBreathCycle() {
    _breathTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _breathPhase = (_breathPhase + 1) % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_canTap) return;

    bool correctTiming = (_breathPhase == 0 || _breathPhase == 2);

    setState(() {
      if (correctTiming) {
        _streak++;
        int points = 15 + (_streak >= 3 ? 10 : 0);
        _score += points;
        _breathsCompleted++;
        HapticFeedback.mediumImpact();

        if (_breathsCompleted >= _targetBreaths) {
          _timer?.cancel();
          _breathTimer?.cancel();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _finishGame();
          });
        }
      } else {
        _streak = 0;
        _score = (_score - 5).clamp(0, 1000);
        HapticFeedback.heavyImpact();
      }

      _canTap = false;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _canTap = true;
          });
        }
      });
    });
  }

  void _finishGame() {
    widget.onGameComplete(_score);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (value * 0.2),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildGameArea()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.color.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 10 ? Colors.red : widget.color)),
              Text('Puntos: $_score',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _breathsCompleted / _targetBreaths,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text('Respiraciones: $_breathsCompleted/$_targetBreaths',
              style: const TextStyle(fontSize: 16)),
          if (_streak >= 3)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('🔥 Racha x$_streak',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    String instruction = '';
    Color phaseColor = Colors.blue;

    switch (_breathPhase) {
      case 0:
        instruction = '¡INHALA! 🌬️';
        phaseColor = Colors.blue;
        break;
      case 1:
        instruction = 'Sostén...';
        phaseColor = Colors.purple;
        break;
      case 2:
        instruction = '¡EXHALA! 💨';
        phaseColor = Colors.green;
        break;
      case 3:
        instruction = 'Sostén...';
        phaseColor = Colors.orange;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(instruction,
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: phaseColor)),
        const SizedBox(height: 20),
        const Text('¡Toca cuando veas INHALA o EXHALA!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              double scale = 1.0 + (_pulseController.value * 0.2);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: phaseColor.withOpacity(0.3),
                    border: Border.all(color: phaseColor, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: phaseColor.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _breathPhase == 0 || _breathPhase == 1
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    size: 60,
                    color: phaseColor,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: const Text(
            '💡 Respira profundamente\nMejora la oxigenación',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: CLASIFICA ÓRGANOS - Clasificación Rápida
class Juego3ClasificaOrganos extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3ClasificaOrganos(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3ClasificaOrganos> createState() => _Juego3ClasificaOrganosState();
}

class _Juego3ClasificaOrganosState extends State<Juego3ClasificaOrganos> {
  final Random _random = Random();
  Timer? _timer;
  int _timeLeft = 40;
  int _score = 0;
  int _streak = 0;
  int _currentItem = 0;
  Color? _feedbackColor;

  final List<Map<String, String>> _organs = [
    {'name': 'Estómago', 'system': 'Digestivo', 'icon': '🥣'},
    {'name': 'Pulmones', 'system': 'Respiratorio', 'icon': '🫁'},
    {'name': 'Intestinos', 'system': 'Digestivo', 'icon': '➰'},
    {'name': 'Nariz', 'system': 'Respiratorio', 'icon': '👃'},
    {'name': 'Boca', 'system': 'Digestivo', 'icon': '👄'},
    {'name': 'Tráquea', 'system': 'Respiratorio', 'icon': '🗣️'},
    {'name': 'Hígado', 'system': 'Digestivo', 'icon': '🍖'},
    {'name': 'Bronquios', 'system': 'Respiratorio', 'icon': '🌿'},
  ];

  @override
  void initState() {
    super.initState();
    _organs.shuffle(_random);
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
            _finishGame();
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

  void _selectSystem(String system) {
    if (_currentItem >= _organs.length) return;

    bool isCorrect = _organs[_currentItem]['system'] == system;

    setState(() {
      _feedbackColor = isCorrect ? Colors.green : Colors.red;

      if (isCorrect) {
        _streak++;
        int points = 15 + (_streak >= 3 ? 10 : 0);
        _score += points;
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        _score = (_score - 5).clamp(0, 1000);
        HapticFeedback.heavyImpact();
      }

      _currentItem++;

      if (_currentItem >= _organs.length) {
        _timer?.cancel();
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _finishGame();
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _feedbackColor = null;
        });
      }
    });
  }

  void _finishGame() {
    widget.onGameComplete(_score);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (value * 0.2),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildGameArea()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.color.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 10 ? Colors.red : widget.color)),
              Text('Puntos: $_score',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _currentItem / _organs.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text('Órgano: $_currentItem/${_organs.length}',
              style: const TextStyle(fontSize: 16)),
          if (_streak >= 3)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('🔥 Racha x$_streak',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    if (_currentItem >= _organs.length) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿A qué sistema pertenece?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _feedbackColor?.withOpacity(0.2) ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _feedbackColor ?? widget.color,
              width: 3,
            ),
          ),
          child: Column(
            children: [
              Text(_organs[_currentItem]['icon']!,
                  style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(_organs[_currentItem]['name']!,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSystemButton('Digestivo', '🥣', Colors.orange),
            _buildSystemButton('Respiratorio', '🫁', Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildSystemButton(String label, String icon, Color color) {
    return GestureDetector(
      onTap: () => _selectSystem(label),
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// JUEGO 4: NUTRIENTES VS DESECHOS - Quick Decision
class Juego4Nutrientes extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4Nutrientes(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Nutrientes> createState() => _Juego4NutrientesState();
}

class _Juego4NutrientesState extends State<Juego4Nutrientes> {
  final Random _random = Random();
  Timer? _timer;
  int _timeLeft = 35;
  int _score = 0;
  int _streak = 0;
  int _currentItem = 0;
  Color? _feedbackColor;

  final List<Map<String, dynamic>> _items = [
    {'name': 'Vitaminas', 'keep': true, 'icon': '🍎'},
    {'name': 'CO₂', 'keep': false, 'icon': '💨'},
    {'name': 'Energía', 'keep': true, 'icon': '⚡'},
    {'name': 'Desechos', 'keep': false, 'icon': '💩'},
    {'name': 'Oxígeno', 'keep': true, 'icon': '🌬️'},
    {'name': 'Toxinas', 'keep': false, 'icon': '☠️'},
    {'name': 'Proteínas', 'keep': true, 'icon': '🥩'},
    {'name': 'Urea', 'keep': false, 'icon': '💧'},
    {'name': 'Glucosa', 'keep': true, 'icon': '🍯'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
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
            _finishGame();
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

  void _makeDecision(bool keep) {
    if (_currentItem >= _items.length) return;

    bool isCorrect = _items[_currentItem]['keep'] == keep;

    setState(() {
      _feedbackColor = isCorrect ? Colors.green : Colors.red;

      if (isCorrect) {
        _streak++;
        int points = 12 + (_streak >= 3 ? 8 : 0);
        _score += points;
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        _score = (_score - 5).clamp(0, 1000);
        HapticFeedback.heavyImpact();
      }

      _currentItem++;

      if (_currentItem >= _items.length) {
        _timer?.cancel();
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _finishGame();
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _feedbackColor = null;
        });
      }
    });
  }

  void _finishGame() {
    widget.onGameComplete(_score);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (value * 0.2),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildGameArea()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.color.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 10 ? Colors.red : widget.color)),
              Text('Puntos: $_score',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _currentItem / _items.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text('Elemento: $_currentItem/${_items.length}',
              style: const TextStyle(fontSize: 16)),
          if (_streak >= 3)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('🔥 Racha x$_streak',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    if (_currentItem >= _items.length) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿El cuerpo lo NECESITA o lo EXPULSA?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 40),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _feedbackColor?.withOpacity(0.2) ?? Colors.purple.shade50,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: _feedbackColor ?? widget.color,
              width: 4,
            ),
          ),
          child: Column(
            children: [
              Text(_items[_currentItem]['icon'],
                  style: const TextStyle(fontSize: 90)),
              const SizedBox(height: 16),
              Text(_items[_currentItem]['name'],
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDecisionButton('EXPULSAR', '🗑️', false, Colors.red),
            _buildDecisionButton('GUARDAR', '💪', true, Colors.green),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: const Text(
            '💡 El cuerpo guarda lo útil\ny expulsa lo nocivo',
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDecisionButton(
      String label, String icon, bool keep, Color color) {
    return GestureDetector(
      onTap: () => _makeDecision(keep),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 10),
            Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// JUEGO 5: QUIZ DEL CUERPO - Quiz Rápido Educativo
class Juego5QuizCuerpo extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizCuerpo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizCuerpo> createState() => _Juego5QuizCuerpoState();
}

class _Juego5QuizCuerpoState extends State<Juego5QuizCuerpo> {
  final Random _random = Random();
  Timer? _timer;
  int _timeLeft = 50;
  int _score = 0;
  int _streak = 0;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _showingExplanation = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué órgano bombea sangre?',
      'answers': ['Corazón', 'Pulmón', 'Estómago', 'Cerebro'],
      'correctIndex': 0,
      'explanation':
          'El corazón bombea sangre a todo el cuerpo, llevando oxígeno y nutrientes.'
    },
    {
      'question': '¿Dónde se digiere la comida?',
      'answers': ['Pulmones', 'Estómago', 'Corazón', 'Huesos'],
      'correctIndex': 1,
      'explanation':
          'El estómago descompone los alimentos con ácidos para obtener nutrientes.'
    },
    {
      'question': '¿Qué usamos para respirar?',
      'answers': ['Estómago', 'Intestinos', 'Pulmones', 'Músculos'],
      'correctIndex': 2,
      'explanation':
          'Los pulmones capturan oxígeno del aire y expulsan dióxido de carbono.'
    },
    {
      'question': '¿Qué órgano absorbe nutrientes?',
      'answers': ['Corazón', 'Cerebro', 'Intestinos', 'Riñones'],
      'correctIndex': 2,
      'explanation': 'Los intestinos absorben nutrientes de la comida digerida.'
    },
    {
      'question': '¿Qué gas necesitamos respirar?',
      'answers': ['Oxígeno', 'CO₂', 'Nitrógeno', 'Hidrógeno'],
      'correctIndex': 0,
      'explanation':
          'El oxígeno es esencial para que las células produzcan energía.'
    },
    {
      'question': '¿Qué órgano filtra la sangre?',
      'answers': ['Pulmones', 'Hígado', 'Riñones', 'Bazo'],
      'correctIndex': 2,
      'explanation':
          'Los riñones limpian la sangre y eliminan desechos a través de la orina.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _questions.shuffle(_random);
    for (var q in _questions) {
      List answers = q['answers'];
      int correctIndex = q['correctIndex'];
      String correctAnswer = answers[correctIndex];
      answers.shuffle(_random);
      q['correctIndex'] = answers.indexOf(correctAnswer);
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_showingExplanation) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _finishGame();
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

  void _selectAnswer(int index) {
    if (_selectedAnswer != null || _showingExplanation) return;

    int correctIndex = _questions[_currentQuestion]['correctIndex'];
    bool isCorrect = index == correctIndex;

    setState(() {
      _selectedAnswer = index;
      _showingExplanation = true;

      if (isCorrect) {
        _streak++;
        int points = 20 + (_streak >= 3 ? 15 : 0);
        _score += points;
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        _score = (_score - 5).clamp(0, 1000);
        HapticFeedback.heavyImpact();
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentQuestion++;
          _selectedAnswer = null;
          _showingExplanation = false;

          if (_currentQuestion >= _questions.length) {
            _timer?.cancel();
            _finishGame();
          }
        });
      }
    });
  }

  void _finishGame() {
    widget.onGameComplete(_score);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (value * 0.2),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildGameArea()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.color.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 10 ? Colors.red : widget.color)),
              Text('Puntos: $_score',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _currentQuestion / _questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text('Pregunta: ${_currentQuestion + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 16)),
          if (_streak >= 3)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('🔥 Racha x$_streak',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    if (_currentQuestion >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final question = _questions[_currentQuestion];
    final correctIndex = question['correctIndex'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: widget.color, width: 2),
            ),
            child: Text(
              question['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...List.generate(question['answers'].length, (index) {
            Color? buttonColor;
            if (_selectedAnswer != null) {
              if (index == correctIndex) {
                buttonColor = Colors.green;
              } else if (index == _selectedAnswer) {
                buttonColor = Colors.red;
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedAnswer == null
                      ? () => _selectAnswer(index)
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    backgroundColor:
                        buttonColor ?? widget.color.withOpacity(0.7),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: buttonColor,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          question['answers'][index],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_selectedAnswer != null && index == correctIndex)
                        const Icon(Icons.check_circle, size: 24),
                      if (_selectedAnswer == index && index != correctIndex)
                        const Icon(Icons.cancel, size: 24),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_showingExplanation) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question['explanation'],
                      style: const TextStyle(fontSize: 15),
                    ),
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
