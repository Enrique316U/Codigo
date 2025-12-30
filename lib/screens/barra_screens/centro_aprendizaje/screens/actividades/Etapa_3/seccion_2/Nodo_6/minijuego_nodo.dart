import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
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
        return Juego1OrdenaCiclo(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Evaporacion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Condensacion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4Precipitacion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizCiclo(
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
              Icon(Icons.water, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Experto del Ciclo del Agua!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Fantástico! Entiendes cómo el agua viaja por nuestro planeta.',
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

// JUEGO 1: ORDENA EL CICLO
class Juego1OrdenaCiclo extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1OrdenaCiclo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1OrdenaCiclo> createState() => _Juego1OrdenaCicloState();
}

class _Juego1OrdenaCicloState extends State<Juego1OrdenaCiclo>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;
  late AnimationController _scaleController;
  List<String> correctOrder = [
    'Evaporación',
    'Condensación',
    'Precipitación',
    'Recolección',
    'Infiltración',
    'Escorrentía'
  ];
  List<String> userOrder = [];
  List<Map<String, String>> options = [
    {'name': 'Evaporación', 'emoji': '♨️'},
    {'name': 'Condensación', 'emoji': '☁️'},
    {'name': 'Precipitación', 'emoji': '🌧️'},
    {'name': 'Recolección', 'emoji': '🌊'},
    {'name': 'Infiltración', 'emoji': '🏞️'},
    {'name': 'Escorrentía', 'emoji': '🚰'},
  ];

  @override
  void initState() {
    super.initState();
    options.shuffle();
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
    if (_timeLeft == 0 || userOrder.length == 6) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💧', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              userOrder.length == 6
                  ? '¡Ciclo Completado!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Verificar Orden',
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
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('🎯 $score pts',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              if (streak > 1)
                Text('🔥 $streak',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Ordena los pasos del Ciclo del Agua',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        Expanded(
          child: Row(
            children: [
              // Zona de opciones
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: options.map((opt) {
                    if (userOrder.contains(opt['name']))
                      return const SizedBox(height: 60);
                    return Draggable<String>(
                      data: opt['name'],
                      feedback: Material(
                        color: Colors.transparent,
                        child: _buildOptionCard(opt, true),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: _buildOptionCard(opt, false),
                      ),
                      child: _buildOptionCard(opt, false),
                    );
                  }).toList(),
                ),
              ),
              // Zona de destino (Ciclo)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return DragTarget<String>(
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            height: 70,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: userOrder.length > index
                                  ? Text(
                                      '${index + 1}. ${userOrder[index]}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text('${index + 1}. ?',
                                      style: const TextStyle(fontSize: 20)),
                            ),
                          );
                        },
                        onAccept: (data) {
                          setState(() {
                            if (userOrder.length == index) {
                              userOrder.add(data);
                              HapticFeedback.mediumImpact();
                            }
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (userOrder.isNotEmpty)
          TextButton(
            onPressed: () {
              setState(() {
                userOrder.clear();
              });
            },
            child: const Text('Reiniciar Orden'),
          ),
      ],
    );
  }

  Widget _buildOptionCard(Map<String, String> opt, bool isFeedback) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(opt['emoji']!, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 10),
          Text(opt['name']!,
              style: TextStyle(
                  fontSize: isFeedback ? 20 : 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _checkOrder() {
    bool correct = true;
    for (int i = 0; i < 6; i++) {
      if (i >= userOrder.length || userOrder[i] != correctOrder[i]) {
        correct = false;
        break;
      }
    }

    if (correct) {
      int points = 100 + (streak * 10).toInt();
      score = points;
      streak++;
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      score = 20;
      streak = 0;
      HapticFeedback.heavyImpact();
    }
    widget.onGameComplete(score, streak);
  }
}

// JUEGO 2: EVAPORACIÓN
class Juego2Evaporacion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2Evaporacion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Evaporacion> createState() => _Juego2EvaporacionState();
}

class _Juego2EvaporacionState extends State<Juego2Evaporacion>
    with SingleTickerProviderStateMixin {
  int taps = 0;
  int score = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 40;
  late AnimationController _scaleController;
  double waterLevel = 1.0; // 1.0 = lleno, 0.0 = vacío (evaporado)

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
            if (waterLevel <= 0.1) {
              score = 100 + (taps * 2); // Bonus por eficiencia
              streak = 3;
            }
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
    if (_timeLeft == 0 || waterLevel <= 0.1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('☁️', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              waterLevel <= 0.1
                  ? '¡El agua se evaporó!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (waterLevel <= 0.1) {
                  score = 100 + (taps * 2);
                  streak = 3;
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
          color: _timeLeft < 10
              ? Colors.red.shade100
              : widget.color.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('Toques: $taps',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¡Toca el Sol para calentar el agua!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              taps++;
              waterLevel -= 0.05;
              HapticFeedback.lightImpact();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orangeAccent,
              boxShadow: [BoxShadow(color: Colors.orange, blurRadius: 20)],
            ),
            child: const Text('☀️', style: TextStyle(fontSize: 80)),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Fondo
              Container(color: Colors.lightBlue[50]),
              // Agua
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: MediaQuery.of(context).size.height * 0.4 * waterLevel,
                width: double.infinity,
                color: Colors.blue,
                child: const Center(
                  child: Text('🌊', style: TextStyle(fontSize: 40)),
                ),
              ),
              // Vapor (aparece al tocar)
              if (taps > 0)
                Positioned(
                  bottom:
                      MediaQuery.of(context).size.height * 0.4 * waterLevel +
                          20,
                  child: const Text('♨️', style: TextStyle(fontSize: 40)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: CONDENSACIÓN
class Juego3Condensacion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3Condensacion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Condensacion> createState() => _Juego3CondensacionState();
}

class _Juego3CondensacionState extends State<Juego3Condensacion>
    with SingleTickerProviderStateMixin {
  int cloudsMerged = 0;
  int score = 0;
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
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            if (cloudsMerged >= 5) {
              score = 100;
              streak = 2;
            }
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
    if (_timeLeft == 0 || cloudsMerged >= 5) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌧️', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              cloudsMerged >= 5
                  ? '¡Nube de Lluvia Formada!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Nubes juntadas: $cloudsMerged/5',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (cloudsMerged >= 5) {
                  score = 100;
                  streak = 2;
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

    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(12),
            color: _timeLeft < 10
                ? Colors.red.shade100
                : widget.color.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('⏱️ $_timeLeft s',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _timeLeft < 10 ? Colors.red : Colors.black)),
                Text('Nubes: $cloudsMerged/5',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 80,
          left: 0,
          right: 0,
          child: Center(
            child: Text('Junta las nubes pequeñas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        // Nube Grande (Objetivo)
        Center(
          child: DragTarget<int>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                height: 150 + (cloudsMerged * 20),
                width: 150 + (cloudsMerged * 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(
                      (0.3 + (cloudsMerged * 0.2)).clamp(0.0, 1.0)),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('☁️',
                      style: TextStyle(fontSize: 60 + (cloudsMerged * 10))),
                ),
              );
            },
            onAccept: (data) {
              setState(() {
                cloudsMerged++;
                _scaleController
                    .forward()
                    .then((_) => _scaleController.reverse());
                HapticFeedback.mediumImpact();
              });
            },
          ),
        ),
        // Nubes pequeñas arrastrables (5 total)
        if (cloudsMerged < 5)
          Positioned(
            bottom: 50,
            left: 50,
            child: Draggable<int>(
              data: 1,
              feedback: const Material(
                color: Colors.transparent,
                child: Text('☁️', style: TextStyle(fontSize: 50)),
              ),
              childWhenDragging: Container(),
              child: const Text('☁️', style: TextStyle(fontSize: 50)),
            ),
          ),
        if (cloudsMerged < 4)
          Positioned(
            bottom: 150,
            right: 50,
            child: Draggable<int>(
              data: 1,
              feedback: const Material(
                color: Colors.transparent,
                child: Text('☁️', style: TextStyle(fontSize: 50)),
              ),
              childWhenDragging: Container(),
              child: const Text('☁️', style: TextStyle(fontSize: 50)),
            ),
          ),
        if (cloudsMerged < 3)
          Positioned(
            top: 120,
            right: 100,
            child: Draggable<int>(
              data: 1,
              feedback: const Material(
                color: Colors.transparent,
                child: Text('☁️', style: TextStyle(fontSize: 50)),
              ),
              childWhenDragging: Container(),
              child: const Text('☁️', style: TextStyle(fontSize: 50)),
            ),
          ),
        if (cloudsMerged < 2)
          Positioned(
            bottom: 200,
            left: 150,
            child: Draggable<int>(
              data: 1,
              feedback: const Material(
                color: Colors.transparent,
                child: Text('☁️', style: TextStyle(fontSize: 50)),
              ),
              childWhenDragging: Container(),
              child: const Text('☁️', style: TextStyle(fontSize: 50)),
            ),
          ),
        if (cloudsMerged < 1)
          Positioned(
            top: 150,
            left: 80,
            child: Draggable<int>(
              data: 1,
              feedback: const Material(
                color: Colors.transparent,
                child: Text('☁️', style: TextStyle(fontSize: 50)),
              ),
              childWhenDragging: Container(),
              child: const Text('☁️', style: TextStyle(fontSize: 50)),
            ),
          ),
      ],
    );
  }
}

// JUEGO 4: PRECIPITACIÓN
class Juego4Precipitacion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4Precipitacion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Precipitacion> createState() => _Juego4PrecipitacionState();
}

class _Juego4PrecipitacionState extends State<Juego4Precipitacion>
    with TickerProviderStateMixin {
  int dropsCaught = 0;
  int dropsMissed = 0;
  int score = 0;
  int streak = 0;
  Timer? _timer;
  Timer? _dropTimer;
  int _timeLeft = 45;
  late AnimationController _scaleController;
  double bucketPosition = 0.5; // Posición horizontal (0.0 a 1.0)

  // Lista de gotas activas
  List<Map<String, double>> activeDrops = [];
  int _dropIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _startTimer();
    _startDroppingRain();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _dropTimer?.cancel();
            score = dropsCaught * 10;
            if (dropsCaught >= 12) streak = 3;
            widget.onGameComplete(score, streak);
          }
        });
      }
    });
  }

  void _startDroppingRain() {
    // Crear nuevas gotas cada 800ms
    _dropTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted && dropsCaught < 12) {
        setState(() {
          // Posición horizontal aleatoria
          double randomX = ((_dropIdCounter * 37) % 100) / 100.0;
          activeDrops.add({
            'id': _dropIdCounter.toDouble(),
            'x': randomX,
            'y': 0.0, // Empieza arriba
          });
          _dropIdCounter++;
        });

        // Animar la caída de las gotas
        _animateDrops();
      }
    });
  }

  void _animateDrops() {
    // Actualizar posición de gotas cada 50ms
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          List<Map<String, double>> dropsToRemove = [];

          for (var drop in activeDrops) {
            drop['y'] = (drop['y'] ?? 0.0) + 0.02; // Velocidad de caída

            // Verificar si la gota llegó al fondo (zona de la cubeta)
            if (drop['y']! >= 0.85) {
              double dropX = drop['x']!;
              // Verificar colisión con cubeta (±0.1 de margen)
              if ((dropX - bucketPosition).abs() < 0.12) {
                // ¡Gota atrapada!
                dropsCaught++;
                streak++;
                _scaleController
                    .forward()
                    .then((_) => _scaleController.reverse());
                HapticFeedback.lightImpact();
              } else {
                // Gota perdida
                dropsMissed++;
                streak = 0;
              }
              dropsToRemove.add(drop);
            }
          }

          // Eliminar gotas que llegaron al fondo
          for (var drop in dropsToRemove) {
            activeDrops.remove(drop);
          }
        });

        // Continuar animando si hay gotas activas
        if (activeDrops.isNotEmpty && dropsCaught < 12) {
          _animateDrops();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dropTimer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || dropsCaught >= 12) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💧', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              dropsCaught >= 12
                  ? '¡Lluvia Recolectada!'
                  : '⏰ ¡Tiempo terminado!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Gotas atrapadas: $dropsCaught',
                style: const TextStyle(fontSize: 18)),
            Text('Gotas perdidas: $dropsMissed',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                score = dropsCaught * 10;
                if (dropsCaught >= 12) streak = 3;
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
          color: _timeLeft < 10
              ? Colors.red.shade100
              : widget.color.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.black)),
              Text('💧 $dropsCaught/12',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('¡Atrapa las gotas con la cubeta!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                // Actualizar posición de la cubeta según el arrastre
                double screenWidth = MediaQuery.of(context).size.width;
                bucketPosition =
                    (details.globalPosition.dx / screenWidth).clamp(0.1, 0.9);
              });
            },
            child: Container(
              color: Colors.lightBlue[50],
              child: Stack(
                children: [
                  // Nubes en la parte superior
                  const Positioned(
                    top: 20,
                    left: 30,
                    child: Text('☁️', style: TextStyle(fontSize: 40)),
                  ),
                  const Positioned(
                    top: 10,
                    right: 50,
                    child: Text('☁️', style: TextStyle(fontSize: 50)),
                  ),
                  const Positioned(
                    top: 30,
                    left: 150,
                    child: Text('⛈️', style: TextStyle(fontSize: 45)),
                  ),

                  // Gotas cayendo
                  ...activeDrops.map((drop) {
                    double screenWidth = MediaQuery.of(context).size.width;
                    double screenHeight =
                        MediaQuery.of(context).size.height - 200;

                    return Positioned(
                      left: drop['x']! * screenWidth,
                      top: drop['y']! * screenHeight,
                      child: const Text('💧', style: TextStyle(fontSize: 35)),
                    );
                  }).toList(),

                  // Cubeta del jugador
                  Positioned(
                    bottom: 30,
                    left: (bucketPosition * MediaQuery.of(context).size.width) -
                        30,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 1.3)
                          .animate(_scaleController),
                      child: const Text('🪣', style: TextStyle(fontSize: 60)),
                    ),
                  ),

                  // Instrucción
                  const Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Arrastra para mover la cubeta',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// JUEGO 5: QUIZ DEL CICLO
class Juego5QuizCiclo extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizCiclo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizCiclo> createState() => _Juego5QuizCicloState();
}

class _Juego5QuizCicloState extends State<Juego5QuizCiclo>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué hace que el agua se evapore?',
      'answers': ['El Sol', 'La Luna', 'El Viento', 'La Tierra'],
      'correctIndex': 0
    },
    {
      'question': '¿Qué forman las gotas de agua en el cielo?',
      'answers': ['Rocas', 'Nubes', 'Pájaros', 'Estrellas'],
      'correctIndex': 1
    },
    {
      'question': '¿Cómo vuelve el agua a la tierra?',
      'answers': ['Saltando', 'Como lluvia', 'Volando', 'Caminando'],
      'correctIndex': 1
    },
    {
      'question': '¿Dónde se acumula el agua de lluvia?',
      'answers': [
        'En árboles',
        'En ríos y lagos',
        'En el cielo',
        'En volcanes'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Qué es la condensación?',
      'answers': [
        'Agua caliente',
        'Vapor que se vuelve líquido',
        'Agua congelada',
        'Lluvia de hielo'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Por qué es importante el ciclo del agua?',
      'answers': [
        'Para jugar',
        'Mantiene agua fresca en la Tierra',
        'Para las nubes',
        'No es importante'
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
            Text('Puntuación: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 1)
              Text('🔥 Racha máxima: $streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
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
                Text('⏱️ $_timeLeft s',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _timeLeft < 10 ? Colors.red : Colors.black)),
                Text('🎯 $score pts',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                if (streak > 1)
                  Text('🔥 $streak',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
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
      currentQuestionIndex++;
    });
  }
}
