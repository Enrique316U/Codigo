// ETAPA 3 - SECCIÓN 1 - NODO 1: EL CUERPO Y LA MATERIA
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
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
        return Juego1MasaVolumen(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Balanza(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Probeta(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4Flotabilidad(
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
              Icon(Icons.science, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Científico de la Materia!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Excelente! Ahora entiendes las propiedades de la materia.',
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

// JUEGO 1: MASA VS VOLUMEN
class Juego1MasaVolumen extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1MasaVolumen(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1MasaVolumen> createState() => _Juego1MasaVolumenState();
}

class _Juego1MasaVolumenState extends State<Juego1MasaVolumen>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 45;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  List<Map<String, dynamic>> items = [
    {'emoji': '⚖️', 'name': 'Peso', 'type': 'Masa'},
    {'emoji': '🥛', 'name': 'Espacio', 'type': 'Volumen'},
    {'emoji': '🐘', 'name': 'Pesado', 'type': 'Masa'},
    {'emoji': '🎈', 'name': 'Grande', 'type': 'Volumen'},
    {'emoji': '📦', 'name': 'Caja Llena', 'type': 'Volumen'},
    {'emoji': '🏋️', 'name': 'Pesa', 'type': 'Masa'},
  ];

  @override
  void initState() {
    super.initState();
    items.shuffle();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
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
            const Icon(Icons.science, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              currentItem >= items.length
                  ? '¡Clasificación Completa!'
                  : '¡Tiempo agotado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score pts',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
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
          padding: const EdgeInsets.all(8),
          color:
              _timeLeft < 10 ? Colors.red.withOpacity(0.2) : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('¿Es Masa o Volumen?',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeLeft < 10 ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '$_timeLeft s',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Draggable<String>(
                data: items[currentItem]['type'],
                feedback: Material(
                  color: Colors.transparent,
                  child: Text(items[currentItem]['emoji'],
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
                    Text(items[currentItem]['emoji'],
                        style: const TextStyle(fontSize: 80)),
                    Text(items[currentItem]['name'],
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildZone('Masa', '⚖️', Colors.orange),
            _buildZone('Volumen', '📏', Colors.blue),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
        bool correct = data == label;

        setState(() {
          if (correct) {
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

// JUEGO 2: BALANZA
class Juego2Balanza extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2Balanza(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Balanza> createState() => _Juego2BalanzaState();
}

class _Juego2BalanzaState extends State<Juego2Balanza> {
  double leftWeight = 0;
  double rightWeight = 0;
  bool balanced = false;
  Timer? _timer;
  int _timeLeft = 50;
  int streak = 0;
  int score = 0;

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

  @override
  Widget build(BuildContext context) {
    if (balanced || _timeLeft == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.balance,
                size: 100, color: balanced ? Colors.green : Colors.grey),
            const SizedBox(height: 20),
            Text(
              balanced ? '¡Equilibrado!' : '¡Tiempo agotado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score pts',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
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
          padding: const EdgeInsets.all(8),
          color:
              _timeLeft < 10 ? Colors.red.withOpacity(0.2) : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Equilibra la balanza',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeLeft < 10 ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⏰ $_timeLeft s',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildScaleSide(leftWeight, Colors.red),
              const Icon(Icons.arrow_drop_up, size: 50),
              _buildScaleSide(rightWeight, Colors.blue),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() => leftWeight += 1);
                    HapticFeedback.selectionClick();
                  },
                  child: const Text('+1 Izq')),
              ElevatedButton(
                  onPressed: () {
                    setState(() => rightWeight += 1);
                    HapticFeedback.selectionClick();
                  },
                  child: const Text('+1 Der')),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (leftWeight == rightWeight && leftWeight > 0) {
              setState(() {
                balanced = true;
                score = 100 + (streak * 10);
                streak++;
              });
              HapticFeedback.mediumImpact();
            } else {
              streak = 0;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡No está equilibrado!')),
              );
              HapticFeedback.heavyImpact();
            }
          },
          child: const Text('Verificar'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildScaleSide(double weight, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 100 + (weight * 10),
            width: 100,
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('${weight.toInt()} kg',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(height: 10, width: 120, color: Colors.black),
        ],
      ),
    );
  }
}

// JUEGO 3: PROBETA (VOLUMEN)
class Juego3Probeta extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3Probeta(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Probeta> createState() => _Juego3ProbetaState();
}

class _Juego3ProbetaState extends State<Juego3Probeta> {
  double waterLevel = 50.0;
  bool stoneDropped = false;
  Timer? _timer;
  int _timeLeft = 40;
  int streak = 0;
  int score = 0;

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

  @override
  Widget build(BuildContext context) {
    if ((stoneDropped && waterLevel >= 80) || _timeLeft == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science,
                size: 100, color: stoneDropped ? Colors.green : Colors.grey),
            const SizedBox(height: 20),
            Text(
              stoneDropped ? '¡Desplazamiento!' : '¡Tiempo agotado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (stoneDropped)
              const Text('El volumen subió al agregar la piedra.',
                  textAlign: TextAlign.center),
            Text('Puntuación: $score pts',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
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
          padding: const EdgeInsets.all(8),
          color:
              _timeLeft < 10 ? Colors.red.withOpacity(0.2) : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Toca la piedra para medir volumen',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeLeft < 10 ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⏰ $_timeLeft s',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Probeta
              Container(
                width: 100,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      height: waterLevel * 3,
                      width: 100,
                      color: Colors.blue.withOpacity(0.5),
                    ),
                    if (stoneDropped)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('🪨', style: TextStyle(fontSize: 40)),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              if (!stoneDropped)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      stoneDropped = true;
                      waterLevel = 80.0;
                      score = 100 + (streak * 10);
                      streak++;
                      HapticFeedback.mediumImpact();
                    });
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🪨', style: TextStyle(fontSize: 60)),
                      Text('Tócame'),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// JUEGO 4: FLOTABILIDAD
class Juego4Flotabilidad extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4Flotabilidad(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Flotabilidad> createState() => _Juego4FlotabilidadState();
}

class _Juego4FlotabilidadState extends State<Juego4Flotabilidad>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;

  late AnimationController _scaleController;

  List<Map<String, dynamic>> items = [
    {'emoji': '🪨', 'name': 'Piedra', 'floats': false},
    {'emoji': '🪵', 'name': 'Madera', 'floats': true},
    {'emoji': '⚓', 'name': 'Ancla', 'floats': false},
    {'emoji': '🦆', 'name': 'Pato', 'floats': true},
    {'emoji': '🏐', 'name': 'Pelota', 'floats': true},
    {'emoji': '🔧', 'name': 'Llave', 'floats': false},
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
            const Icon(Icons.water, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              currentItem >= items.length
                  ? '¡Experimento Terminado!'
                  : '¡Tiempo agotado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score pts',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
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
          padding: const EdgeInsets.all(8),
          color:
              _timeLeft < 10 ? Colors.red.withOpacity(0.2) : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('¿Flota o se Hunde?',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeLeft < 10 ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⏰ $_timeLeft s',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Draggable<bool>(
              data: items[currentItem]['floats'],
              feedback: Material(
                color: Colors.transparent,
                child: Text(items[currentItem]['emoji'],
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
                  Text(items[currentItem]['emoji'],
                      style: const TextStyle(fontSize: 80)),
                  Text(items[currentItem]['name'],
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildZone('Se Hunde', '⬇️', false, Colors.blue[900]!),
            _buildZone('Flota', '🌊', true, Colors.lightBlue),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, bool floatsZone, Color color) {
    return DragTarget<bool>(
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
        bool correct = data == floatsZone;

        setState(() {
          if (correct) {
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

// JUEGO 5: QUIZ DE MATERIA
class Juego5QuizMateria extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizMateria(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizMateria> createState() => _Juego5QuizMateriaState();
}

class _Juego5QuizMateriaState extends State<Juego5QuizMateria> {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué es la masa?',
      'answers': ['Cantidad de materia', 'Espacio que ocupa', 'Color', 'Sabor'],
      'correctIndex': 0
    },
    {
      'question': '¿Qué es el volumen?',
      'answers': ['Peso', 'Espacio que ocupa', 'Dureza', 'Brillo'],
      'correctIndex': 1
    },
    {
      'question': '¿Con qué medimos la masa?',
      'answers': ['Regla', 'Reloj', 'Balanza', 'Termómetro'],
      'correctIndex': 2
    },
    {
      'question': '¿Qué mide el volumen?',
      'answers': ['Peso', 'Color', 'Temperatura', 'Espacio ocupado'],
      'correctIndex': 3
    },
    {
      'question': '¿Qué objetos tienen masa?',
      'answers': [
        'Solo los pesados',
        'Todos los objetos',
        'Solo los grandes',
        'Solo los líquidos'
      ],
      'correctIndex': 1
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentQuestionIndex >= questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              currentQuestionIndex >= questions.length
                  ? '¡Quiz Completado!'
                  : '¡Tiempo agotado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score pts',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
              child: const Text('Continuar'),
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
            padding: const EdgeInsets.all(8),
            color: _timeLeft < 15
                ? Colors.red.withOpacity(0.2)
                : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pregunta ${currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _timeLeft < 15 ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '⏰ $_timeLeft s',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
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
          const Spacer(),
        ],
      ),
    );
  }

  void _checkAnswer(int index) {
    if (index == questions[currentQuestionIndex]['correctIndex']) {
      int points = 30 + (streak * 10);
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
