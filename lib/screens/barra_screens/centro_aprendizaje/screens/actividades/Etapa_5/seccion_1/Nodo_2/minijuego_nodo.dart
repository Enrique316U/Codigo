// ETAPA 5 - SECCIÓN 1 - NODO 2: PROPIEDADES DE LA LUZ Y EL SONIDO (VERSIÓN DINÁMICA)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo2Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo2Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo2Screen> createState() => _MinijuegoNodo2ScreenState();
}

class _MinijuegoNodo2ScreenState extends State<MinijuegoNodo2Screen> {
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
        return Juego1MaterialesLuz(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2FuentesSonido(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Reflexion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4TonoSonido(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizLuzSonido(
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
              Icon(Icons.light_mode, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Maestro de la Física!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Brillante! Entiendes la luz y el sonido a la perfección.',
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

// JUEGO 1: MEMORIA DE MATERIALES - Memoriza qué materiales dejan pasar la luz
class Juego1MaterialesLuz extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1MaterialesLuz(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1MaterialesLuz> createState() => _Juego1MaterialesLuzState();
}

class _Juego1MaterialesLuzState extends State<Juego1MaterialesLuz> {
  int _score = 0;
  int _currentItem = 0;
  int _showTime = 3;
  bool _showing = true;
  bool _isTransitioning = false; // Nuevo: estado de transición
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Vidrio', 'type': 'Transparente', 'icon': '🪟'},
    {'name': 'Madera', 'type': 'Opaco', 'icon': '🚪'},
    {'name': 'Papel cebolla', 'type': 'Translúcido', 'icon': '📄'},
    {'name': 'Ladrillo', 'type': 'Opaco', 'icon': '🧱'},
    {'name': 'Agua limpia', 'type': 'Transparente', 'icon': '💧'},
    {'name': 'Cortina blanca', 'type': 'Translúcido', 'icon': '🪟'},
    {'name': 'Pared', 'type': 'Opaco', 'icon': '🧱'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
    _startShowTimer();
  }

  void _startShowTimer() {
    if (!mounted) return;
    _timer?.cancel();
    setState(() {
      _showing = true;
      _showTime = 3;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_showTime > 0) {
        if (mounted) setState(() => _showTime--);
      } else {
        if (mounted) setState(() => _showing = false);
        timer.cancel();
      }
    });
  }

  void _handleAnswer(String type) {
    if (!mounted || _isTransitioning) return;

    _timer?.cancel(); // Cancelar timer actual

    bool correct = type == _items[_currentItem]['type'];

    int earnedPoints = 0;
    if (correct) {
      earnedPoints = 15 + (_showTime * 2); // Bonus por rapidez
    }

    setState(() {
      _score += earnedPoints;
      _currentItem++;
      _isTransitioning = true; // Bloquear interacciones durante transición
    });

    if (_currentItem >= _items.length) {
      // Completar juego inmediatamente cuando se terminan todos los items
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          widget.onGameComplete(_score.clamp(0, 100));
        }
      });
      return;
    }

    // Esperar un momento antes de mostrar el siguiente item
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _isTransitioning = false;
        });
        _startShowTimer();
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
    if (_currentItem >= _items.length) {
      // Asegurar que se llama onGameComplete si aún no se ha llamado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onGameComplete(_score.clamp(0, 100));
        }
      });
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Memoria Completada!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntuación: $_score pts',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text('Cargando siguiente nivel...',
                style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    }

    // Mostrar pantalla de transición
    if (_isTransitioning) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Preparando siguiente material...',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Material ${_currentItem + 1} de ${_items.length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        if (_showing) ...[
          const Text('¡Memoriza!',
              style: TextStyle(fontSize: 18, color: Colors.blue)),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            duration: Duration(seconds: _showTime),
            tween: Tween(begin: 1.0, end: 0.0),
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_items[_currentItem]['icon'],
                            style: const TextStyle(fontSize: 70)),
                        const SizedBox(height: 10),
                        Text(_items[_currentItem]['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Text('$_showTime',
                      style: TextStyle(
                          fontSize: 80,
                          color: Colors.blue.withOpacity(0.3),
                          fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ] else ...[
          const Text('¿A qué categoría pertenece?',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_items[_currentItem]['icon'],
                    style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 10),
                Text(_items[_currentItem]['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: [
              _buildButton('Transparente', '🪟', Colors.blue),
              _buildButton('Translúcido', '📄', Colors.orange),
              _buildButton('Opaco', '🧱', Colors.brown),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildButton(String type, String icon, Color color) {
    return ElevatedButton(
      onPressed: () => _handleAnswer(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('$icon $type',
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

// JUEGO 2: FUENTES DE SONIDO
class Juego2FuentesSonido extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2FuentesSonido(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2FuentesSonido> createState() => _Juego2FuentesSonidoState();
}

class _Juego2FuentesSonidoState extends State<Juego2FuentesSonido> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 20;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Pájaro', 'natural': true, 'icon': '🐦'},
    {'name': 'Coche', 'natural': false, 'icon': '🚗'},
    {'name': 'Trueno', 'natural': true, 'icon': '⛈️'},
    {'name': 'Teléfono', 'natural': false, 'icon': '📱'},
    {'name': 'Río', 'natural': true, 'icon': '🌊'},
    {'name': 'Viento', 'natural': true, 'icon': '💨'},
    {'name': 'Sirena', 'natural': false, 'icon': '🚨'},
    {'name': 'Gato', 'natural': true, 'icon': '🐱'},
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

  void _handleDecision(bool isNatural) {
    bool correct = isNatural == _items[_currentItem]['natural'];
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
            const Text('¡Todos los sonidos identificados!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Sonido ${_currentItem + 1}/${_items.length}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    colors: [Colors.blue.shade100, Colors.purple.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                child: Column(
                  children: [
                    Text(_items[_currentItem]['icon'],
                        style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 15),
                    Text(_items[_currentItem]['name'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 50),
        const Text('¿Natural o Artificial?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton('Natural', '🌳', Colors.green, true),
            const SizedBox(width: 30),
            _buildButton('Artificial', '🏭', Colors.grey, false),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String label, String icon, Color color, bool isNatural) {
    return ElevatedButton(
      onPressed: () => _handleDecision(isNatural),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// JUEGO 3: REFLEXIÓN DE LA LUZ
class Juego3Reflexion extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Reflexion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Reflexion> createState() => _Juego3ReflexionState();
}

class _Juego3ReflexionState extends State<Juego3Reflexion> {
  int _score = 0;
  int _targetsTapped = 0;
  final int _totalTargets = 10;
  int _timeLeft = 15;
  Offset? _targetPosition;
  Timer? _timer;
  Timer? _targetTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _spawnTarget();
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

  void _spawnTarget() {
    double x = 50 + _random.nextDouble() * 250;
    double y = 50 + _random.nextDouble() * 350;
    setState(() => _targetPosition = Offset(x, y));

    _targetTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_targetPosition != null && _targetsTapped < _totalTargets) {
        _spawnTarget();
      }
    });
  }

  void _handleTap() {
    setState(() {
      _targetsTapped++;
      _score += 10;
      _targetPosition = null;
    });
    HapticFeedback.mediumImpact();

    if (_targetsTapped < _totalTargets) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _spawnTarget();
      });
    } else {
      _endGame();
    }
  }

  void _endGame() {
    _timer?.cancel();
    _targetTimer?.cancel();
    widget.onGameComplete(_score.clamp(0, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _targetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow.shade50, Colors.orange.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Tocados: $_targetsTapped/$_totalTargets',
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
            const SizedBox(height: 20),
            const Text('¡Toca los destellos de luz!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Expanded(
              child: Stack(
                children: [
                  if (_targetPosition != null)
                    Positioned(
                      left: _targetPosition!.dx,
                      top: _targetPosition!.dy,
                      child: GestureDetector(
                        onTap: _handleTap,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 500),
                          tween: Tween(begin: 0.5, end: 1.5),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.yellow,
                                      Colors.orange.withOpacity(0.3)
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.yellow.withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5),
                                  ],
                                ),
                                child: const Icon(Icons.light_mode,
                                    size: 30, color: Colors.white),
                              ),
                            );
                          },
                          onEnd: () => setState(() {}),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text('Puntuación: $_score pts',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}

// JUEGO 4: TONO DEL SONIDO
class Juego4TonoSonido extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4TonoSonido(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4TonoSonido> createState() => _Juego4TonoSonidoState();
}

class _Juego4TonoSonidoState extends State<Juego4TonoSonido> {
  int _score = 0;
  int _currentItem = 0;
  int _streak = 0;
  String? _feedback;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Pajarito', 'pitch': 'Agudo', 'icon': '🐦'},
    {'name': 'León', 'pitch': 'Grave', 'icon': '🦁'},
    {'name': 'Silbato', 'pitch': 'Agudo', 'icon': '🚨'},
    {'name': 'Tambor grande', 'pitch': 'Grave', 'icon': '🥁'},
    {'name': 'Violín', 'pitch': 'Agudo', 'icon': '🎻'},
    {'name': 'Trueno', 'pitch': 'Grave', 'icon': '⚡'},
    {'name': 'Flauta', 'pitch': 'Agudo', 'icon': '🎶'},
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
  }

  void _checkAnswer(String answer) {
    bool correct = answer == _items[_currentItem]['pitch'];
    setState(() {
      if (correct) {
        _streak++;
        _score += 14 + (_streak >= 3 ? 6 : 0);
        _feedback = '¡Correcto!';
        HapticFeedback.mediumImpact();
      } else {
        _streak = 0;
        _feedback = 'Era ${_items[_currentItem]['pitch']}';
        HapticFeedback.heavyImpact();
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _currentItem++;
        _feedback = null;
      });
      if (_currentItem >= _items.length) {
        widget.onGameComplete(_score.clamp(0, 100));
      }
    });
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Sonido ${_currentItem + 1}/${_items.length}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_streak >= 3)
              Text('Racha: $_streak 🔥',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 30),
        const Text('¿Es Agudo o Grave?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.8, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple, width: 3),
                ),
                child: Column(
                  children: [
                    Text(_items[_currentItem]['icon'],
                        style: const TextStyle(fontSize: 90)),
                    const SizedBox(height: 15),
                    Text(_items[_currentItem]['name'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        if (_feedback != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _feedback == '¡Correcto!' ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_feedback!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton('Grave', '🔽', Colors.blue.shade700),
              const SizedBox(width: 30),
              _buildButton('Agudo', '🔼', Colors.pink.shade400),
            ],
          ),
      ],
    );
  }

  Widget _buildButton(String type, String icon, Color color) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(type,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// JUEGO 5: QUIZ LUZ Y SONIDO
class Juego5QuizLuzSonido extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizLuzSonido(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizLuzSonido> createState() => _Juego5QuizLuzSonidoState();
}

class _Juego5QuizLuzSonidoState extends State<Juego5QuizLuzSonido> {
  int _score = 0;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _timeLeft = 8;
  Timer? _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué viaja más rápido?',
      'answers': ['El sonido', 'La luz', 'Un avión', 'Un guepardo'],
      'correctIndex': 1,
      'explanation':
          'La luz viaja a 300,000 km/s, mientras el sonido solo a 340 m/s en el aire.'
    },
    {
      'question': '¿Qué objeto refleja mejor la luz?',
      'answers': ['Madera', 'Espejo', 'Tela negra', 'Papel'],
      'correctIndex': 1,
      'explanation':
          'Los espejos tienen superficie lisa y reflectante que devuelven casi toda la luz.'
    },
    {
      'question': 'El sonido necesita ___ para viajar.',
      'answers': ['Vacío', 'Un medio (aire/agua)', 'Silencio', 'Luz'],
      'correctIndex': 1,
      'explanation':
          'El sonido son ondas que necesitan materia (aire, agua, etc.) para propagarse.'
    },
    {
      'question': '¿Qué material es translúcido?',
      'answers': ['Madera', 'Papel cebolla', 'Vidrio claro', 'Ladrillo'],
      'correctIndex': 1,
      'explanation':
          'Translúcido deja pasar algo de luz pero no permite ver claramente a través.'
    },
    {
      'question': '¿Qué animal produce sonido agudo?',
      'answers': ['León', 'Elefante', 'Pajarito', 'Oso'],
      'correctIndex': 2,
      'explanation':
          'Los sonidos agudos tienen frecuencia alta. Los pájaros pequeños cantan en tonos altos.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 8;
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
