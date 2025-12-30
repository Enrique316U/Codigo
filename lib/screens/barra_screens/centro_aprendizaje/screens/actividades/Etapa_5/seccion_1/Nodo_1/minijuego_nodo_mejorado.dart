// ETAPA 5 - SECCIÓN 1 - NODO 1: SISTEMAS DEL CUERPO HUMANO - VERSIÓN MEJORADA
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
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

class _MinijuegoNodo1ScreenState extends State<MinijuegoNodo1Screen>
    with TickerProviderStateMixin {
  int _currentGame = 0;
  int _totalScore = 0;
  int _combo = 0;
  final int _maxGames = 5;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onGameComplete(int score) {
    setState(() {
      _combo++;
      int bonusScore = score + (_combo * 10); // Bonus por combo
      _totalScore += bonusScore;
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
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.color.withOpacity(0.1),
              Colors.white,
              widget.color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildProgressHeader(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _buildCurrentGame(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.2),
            widget.color.withOpacity(0.1)
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars, color: widget.color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Nivel ${_currentGame + 1}/$_maxGames',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ),
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '$_totalScore pts',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_combo > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.whatshot, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'COMBO x$_combo 🔥',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentGame() {
    switch (_currentGame) {
      case 0:
        return Juego1Circulatorio(
            key: ValueKey(_currentGame),
            color: widget.color,
            onGameComplete: _onGameComplete);
      case 1:
        return Juego2Nervioso(
            key: ValueKey(_currentGame),
            color: widget.color,
            onGameComplete: _onGameComplete);
      case 2:
        return Juego3Digestivo(
            key: ValueKey(_currentGame),
            color: widget.color,
            onGameComplete: _onGameComplete);
      case 3:
        return Juego4Respiratorio(
            key: ValueKey(_currentGame),
            color: widget.color,
            onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizRapido(
            key: ValueKey(_currentGame),
            color: widget.color,
            onGameComplete: _onGameComplete);
      default:
        return const Center(child: Text('¡Juego Terminado!'));
    }
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(0.3),
              Colors.white,
              widget.color.withOpacity(0.2),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Transform.rotate(
                        angle: value * 2 * math.pi,
                        child: Icon(
                          Icons.accessibility_new,
                          size: 100 * value,
                          color: widget.color,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  '🏆 ¡Experto en Anatomía! 🏆',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Puntuación Final',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$_totalScore',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '¡Increíble! Conoces muy bien cómo funciona tu cuerpo. 🎉',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text(
                    'Volver al Mapa',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// JUEGO 1: SISTEMA CIRCULATORIO - Latidos del Corazón (Timing Game)
class Juego1Circulatorio extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1Circulatorio({
    super.key,
    required this.color,
    required this.onGameComplete,
  });

  @override
  State<Juego1Circulatorio> createState() => _Juego1CirculatorioState();
}

class _Juego1CirculatorioState extends State<Juego1Circulatorio>
    with SingleTickerProviderStateMixin {
  int _score = 0;
  int _taps = 0;
  final int _targetTaps = 10;
  bool _isGameActive = false;
  late AnimationController _heartBeatController;
  late Animation<double> _heartBeatAnimation;
  Timer? _gameTimer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _heartBeatController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _heartBeatAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _heartBeatController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _heartBeatController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isGameActive = true;
      _taps = 0;
      _score = 0;
      _timeLeft = 15;
    });
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0 || _taps >= _targetTaps) {
          _endGame();
        }
      });
    });
  }

  void _tapHeart() {
    if (!_isGameActive) return;

    setState(() {
      _taps++;
      _score += 10;
    });

    _heartBeatController.forward(from: 0);

    if (_taps >= _targetTaps) {
      _endGame();
    }
  }

  void _endGame() {
    _gameTimer?.cancel();
    setState(() => _isGameActive = false);

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onGameComplete(_score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.favorite, size: 40, color: Colors.red),
                const SizedBox(height: 10),
                const Text(
                  '❤️ Sistema Circulatorio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isGameActive
                      ? '¡Haz latir el corazón al ritmo correcto!'
                      : '¡Presiona el corazón 10 veces en 15 segundos!',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (_isGameActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.pink],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Tiempo: $_timeLeft s',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _tapHeart,
            child: AnimatedBuilder(
              animation: _heartBeatAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isGameActive ? _heartBeatAnimation.value : 1.0,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.red.shade300,
                          Colors.red,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          if (_isGameActive)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Latidos: $_taps / $_targetTaps',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _taps / _targetTaps,
                      minHeight: 15,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          if (!_isGameActive && _taps == 0)
            ElevatedButton.icon(
              onPressed: _startGame,
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Comenzar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// JUEGO 2: SISTEMA NERVIOSO - Reflejos (Reaction Time)
class Juego2Nervioso extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Nervioso({
    super.key,
    required this.color,
    required this.onGameComplete,
  });

  @override
  State<Juego2Nervioso> createState() => _Juego2NerviosoState();
}

class _Juego2NerviosoState extends State<Juego2Nervioso> {
  int _score = 0;
  int _round = 0;
  final int _maxRounds = 5;
  bool _showTarget = false;
  Timer? _targetTimer;
  final _random = math.Random();
  Offset _targetPosition = Offset.zero;
  int _reactionTime = 0;
  DateTime? _targetShowTime;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  @override
  void dispose() {
    _targetTimer?.cancel();
    super.dispose();
  }

  void _startRound() {
    if (_round >= _maxRounds) {
      widget.onGameComplete(_score);
      return;
    }

    setState(() {
      _showTarget = false;
    });

    // Espera aleatoria antes de mostrar el objetivo
    Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)), () {
      if (!mounted) return;
      setState(() {
        _showTarget = true;
        _targetShowTime = DateTime.now();
        _targetPosition = Offset(
          _random.nextDouble() * 0.7 + 0.15,
          _random.nextDouble() * 0.6 + 0.2,
        );
      });
    });
  }

  void _targetTapped() {
    if (!_showTarget) return;

    final reactionTime =
        DateTime.now().difference(_targetShowTime!).inMilliseconds;
    int points = 100 - (reactionTime ~/ 10);
    if (points < 20) points = 20;

    setState(() {
      _score += points;
      _round++;
      _showTarget = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _startRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade100,
                  Colors.purple.shade100,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on, color: Colors.amber, size: 30),
                    SizedBox(width: 10),
                    Text(
                      '⚡ Sistema Nervioso',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '¡Toca el objetivo lo más rápido que puedas!',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Ronda: ${_round + 1}/$_maxRounds',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Puntos: $_score',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_showTarget)
          Positioned(
            left: _targetPosition.dx * size.width,
            top: _targetPosition.dy * size.height,
            child: GestureDetector(
              onTap: _targetTapped,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.yellow,
                            Colors.orange,
                            Colors.red,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.touch_app,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        if (!_showTarget && _round < _maxRounds)
          const Center(
            child: Text(
              '¡Prepárate...!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black45,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// JUEGO 3: SISTEMA DIGESTIVO - Clasificar Alimentos
class Juego3Digestivo extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Digestivo({
    super.key,
    required this.color,
    required this.onGameComplete,
  });

  @override
  State<Juego3Digestivo> createState() => _Juego3DigestivoState();
}

class _Juego3DigestivoState extends State<Juego3Digestivo> {
  int _score = 0;
  final Map<String, List<String>> _categorias = {
    'Proteínas': [],
    'Carbohidratos': [],
    'Vitaminas': [],
  };

  final List<Map<String, String>> _alimentos = [
    {'nombre': '🥩 Carne', 'tipo': 'Proteínas'},
    {'nombre': '🍞 Pan', 'tipo': 'Carbohidratos'},
    {'nombre': '🥕 Zanahoria', 'tipo': 'Vitaminas'},
    {'nombre': '🥛 Leche', 'tipo': 'Proteínas'},
    {'nombre': '🍚 Arroz', 'tipo': 'Carbohidratos'},
    {'nombre': '🍎 Manzana', 'tipo': 'Vitaminas'},
    {'nombre': '🥚 Huevo', 'tipo': 'Proteínas'},
    {'nombre': '🍝 Pasta', 'tipo': 'Carbohidratos'},
    {'nombre': '🥦 Brócoli', 'tipo': 'Vitaminas'},
  ];

  late List<Map<String, String>> _alimentosDisponibles;

  @override
  void initState() {
    super.initState();
    _alimentosDisponibles = List.from(_alimentos)..shuffle();
  }

  void _verificarRespuestas() {
    int correctos = 0;
    for (var alimento in _alimentos) {
      final categoria = alimento['tipo']!;
      if (_categorias[categoria]!.contains(alimento['nombre']!)) {
        correctos++;
      }
    }

    setState(() {
      _score = (correctos / _alimentos.length * 100).round();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onGameComplete(_score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade500],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(Icons.restaurant, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  '🍽️ Sistema Digestivo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Arrastra cada alimento a su categoría nutricional',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Alimentos disponibles
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _alimentosDisponibles.map((alimento) {
              return Draggable<Map<String, String>>(
                data: alimento,
                feedback: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      alimento['nombre']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Chip(
                    label: Text(alimento['nombre']!),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                child: Chip(
                  label: Text(
                    alimento['nombre']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  backgroundColor: Colors.amber[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          // Categorías
          ..._categorias.keys.map((categoria) {
            Color categoryColor;
            IconData categoryIcon;

            if (categoria == 'Proteínas') {
              categoryColor = Colors.red;
              categoryIcon = Icons.fitness_center;
            } else if (categoria == 'Carbohidratos') {
              categoryColor = Colors.orange;
              categoryIcon = Icons.bolt;
            } else {
              categoryColor = Colors.green;
              categoryIcon = Icons.healing;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: DragTarget<Map<String, String>>(
                onAccept: (alimento) {
                  setState(() {
                    _categorias[categoria]!.add(alimento['nombre']!);
                    _alimentosDisponibles.remove(alimento);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 100),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? categoryColor.withOpacity(0.3)
                          : categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: categoryColor,
                        width: 3,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(categoryIcon, color: categoryColor, size: 30),
                            const SizedBox(width: 10),
                            Text(
                              categoria,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categorias[categoria]!.map((alimento) {
                            return Chip(
                              label: Text(alimento),
                              backgroundColor: categoryColor.withOpacity(0.3),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  _categorias[categoria]!.remove(alimento);
                                  _alimentosDisponibles.add(
                                      _alimentos.firstWhere(
                                          (a) => a['nombre'] == alimento));
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed:
                _alimentosDisponibles.isEmpty ? _verificarRespuestas : null,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text(
              'Verificar',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              disabledBackgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// JUEGO 4: SISTEMA RESPIRATORIO - Respiración (Timing)
class Juego4Respiratorio extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4Respiratorio({
    super.key,
    required this.color,
    required this.onGameComplete,
  });

  @override
  State<Juego4Respiratorio> createState() => _Juego4RespiratorioState();
}

class _Juego4RespiratorioState extends State<Juego4Respiratorio>
    with SingleTickerProviderStateMixin {
  int _score = 0;
  int _cycles = 0;
  final int _targetCycles = 5;
  bool _isInhaling = true;
  bool _isGameActive = false;
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breathAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _breathController.addStatusListener((status) {
      if (!_isGameActive) return;

      if (status == AnimationStatus.completed) {
        setState(() {
          _isInhaling = false;
        });
        _breathController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isInhaling = true;
          _cycles++;
          _score += 20;
        });

        if (_cycles >= _targetCycles) {
          _endGame();
        } else {
          _breathController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isGameActive = true;
      _cycles = 0;
      _score = 0;
      _isInhaling = true;
    });
    _breathController.forward();
  }

  void _endGame() {
    setState(() => _isGameActive = false);
    _breathController.stop();

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onGameComplete(_score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan.shade300, Colors.blue.shade400],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(Icons.air, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  '💨 Sistema Respiratorio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Sigue el ritmo de la respiración',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (_isGameActive)
            AnimatedBuilder(
              animation: _breathAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    Text(
                      _isInhaling ? '🌬️ INHALA' : '😮‍💨 EXHALA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _isInhaling ? Colors.blue : Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Transform.scale(
                      scale: _breathAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: _isInhaling
                                ? [Colors.blue.shade200, Colors.blue.shade600]
                                : [Colors.cyan.shade200, Colors.cyan.shade600],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isInhaling ? Colors.blue : Colors.cyan)
                                  .withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.air,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          if (!_isGameActive && _cycles == 0)
            Column(
              children: [
                const Icon(Icons.air, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'Sigue el ritmo de la respiración',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          const SizedBox(height: 40),
          if (_isGameActive)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                'Ciclos: $_cycles / $_targetCycles',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (!_isGameActive && _cycles == 0)
            ElevatedButton.icon(
              onPressed: _startGame,
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Comenzar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// JUEGO 5: QUIZ RÁPIDO
class Juego5QuizRapido extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizRapido({
    super.key,
    required this.color,
    required this.onGameComplete,
  });

  @override
  State<Juego5QuizRapido> createState() => _Juego5QuizRapidoState();
}

class _Juego5QuizRapidoState extends State<Juego5QuizRapido> {
  int _currentQuestion = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué órgano bombea la sangre?',
      'options': ['Corazón', 'Pulmón', 'Hígado', 'Riñón'],
      'correct': 0,
    },
    {
      'question': '¿Qué sistema controla los movimientos?',
      'options': ['Digestivo', 'Nervioso', 'Circulatorio', 'Respiratorio'],
      'correct': 1,
    },
    {
      'question': '¿Qué gas inhalamos al respirar?',
      'options': ['Carbono', 'Oxígeno', 'Nitrógeno', 'Hidrógeno'],
      'correct': 1,
    },
    {
      'question': '¿Dónde empieza la digestión?',
      'options': ['Estómago', 'Intestino', 'Boca', 'Esófago'],
      'correct': 2,
    },
    {
      'question': '¿Cuántos pulmones tenemos?',
      'options': ['1', '2', '3', '4'],
      'correct': 1,
    },
  ];

  void _selectAnswer(int selectedIndex) {
    if (_questions[_currentQuestion]['correct'] == selectedIndex) {
      setState(() => _score += 20);
    }

    if (_currentQuestion < _questions.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => _currentQuestion++);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onGameComplete(_score);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade300, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.quiz, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  '❓ Quiz del Cuerpo Humano',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Pregunta ${_currentQuestion + 1} de ${_questions.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              question['question'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ...List.generate(
            (question['options'] as List).length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _selectAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    question['options'][index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.purple.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
