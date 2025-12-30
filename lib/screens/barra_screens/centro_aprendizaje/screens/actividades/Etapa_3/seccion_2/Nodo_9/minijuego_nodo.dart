import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo9Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo9Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo9Screen> createState() => _MinijuegoNodo9ScreenState();
}

class _MinijuegoNodo9ScreenState extends State<MinijuegoNodo9Screen> {
  int _currentGame = 0;
  int _totalScore = 0;
  int _streak = 0;
  int _maxStreak = 0;
  final int _maxGames = 5;

  void _onGameComplete(int score, int streak) {
    setState(() {
      _totalScore += score;
      _streak = streak;
      if (streak > _maxStreak) _maxStreak = streak;
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
          if (_streak > 1)
            Text(
              '🔥 x$_streak',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
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
        return Juego1CapasSuelo(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Compostaje(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3VidaSuelo(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4Erosion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizSuelo(
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
              Icon(Icons.terrain, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Experto en Suelos!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Excelente! Ahora sabes cómo cuidar el suelo y por qué es tan importante.',
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

// JUEGO 1: CAPAS DEL SUELO (MEJORADO CON VISUALES)
class Juego1CapasSuelo extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1CapasSuelo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1CapasSuelo> createState() => _Juego1CapasSueloState();
}

class _Juego1CapasSueloState extends State<Juego1CapasSuelo>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> layers = [
    {
      'name': 'Hojas y Plantas',
      'icon': '🍂',
      'description': 'Capa superior con hojas',
      'height': 60.0,
      'number': 1
    },
    {
      'name': 'Tierra Fértil',
      'icon': '🌾',
      'description': 'Donde crecen las plantas',
      'height': 80.0,
      'number': 2
    },
    {
      'name': 'Tierra con Piedras',
      'icon': '⛰️',
      'description': 'Mezcla de tierra y rocas',
      'height': 70.0,
      'number': 3
    },
    {
      'name': 'Rocas Grandes',
      'icon': '🪨',
      'description': 'Capa de roca sólida',
      'height': 60.0,
      'number': 4
    },
  ];

  List<Map<String, dynamic>> currentOrder = [];
  bool completed = false;
  int score = 0;
  int streak = 0;
  int attempts = 0;
  Timer? _timer;
  int _timeLeft = 90;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    currentOrder = List.from(layers)..shuffle();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          if (!completed) {
            widget.onGameComplete(score, streak);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || completed) {
      _timer?.cancel();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(completed ? '🎉' : '⏰', style: const TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
                completed
                    ? '¡Capas Perfectamente Ordenadas!'
                    : '¡Tiempo Terminado!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Puntos: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            const Text(
                '💡 Las capas del suelo se forman\na lo largo de muchos años',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
              style: ElevatedButton.styleFrom(backgroundColor: widget.color),
              child: const Text('Continuar',
                  style: TextStyle(color: Colors.white)),
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
            gradient: LinearGradient(
              colors: _timeLeft < 10
                  ? [Colors.red, Colors.orange]
                  : [widget.color, widget.color.withOpacity(0.7)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 $score pts',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              if (streak > 1)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('🔥 x$streak',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.brown[50],
          child: Column(
            children: [
              const Text('🏔️ Ordena el suelo de ARRIBA hacia ABAJO 🏔️',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Pista: Las hojas van arriba (1), las rocas abajo (4)',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              // Vista previa visual del suelo
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.brown),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.lightBlue[100],
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wb_sunny, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('☁️  Superficie  ☁️',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: currentOrder.isEmpty
                            ? const Center(
                                child: Text('Arrastra capas aquí',
                                    style: TextStyle(color: Colors.grey)))
                            : ListView.builder(
                                reverse: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: currentOrder.length,
                                itemBuilder: (context, index) {
                                  final layer = currentOrder[index];
                                  return Container(
                                    height: layer['height'],
                                    decoration: BoxDecoration(
                                      color: _getColorForLayer(layer['name']),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${layer['icon']} ${layer['name']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.grey[800],
                        child: const Center(
                          child: Text('⬇️ Profundidad ⬇️',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Lista reordenable
              Expanded(
                flex: 3,
                child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    for (int i = 0; i < currentOrder.length; i++)
                      Card(
                        key: ValueKey(currentOrder[i]['name']),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        elevation: 4,
                        color: _getColorForLayer(currentOrder[i]['name']),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text('${currentOrder[i]['number']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(currentOrder[i]['icon'],
                                  style: const TextStyle(fontSize: 30)),
                            ],
                          ),
                          title: Text(currentOrder[i]['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(currentOrder[i]['description'],
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          trailing: const Icon(Icons.drag_indicator,
                              color: Colors.white),
                        ),
                      ),
                  ],
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = currentOrder.removeAt(oldIndex);
                      currentOrder.insert(newIndex, item);
                    });
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _checkOrder,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Verificar Orden',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForLayer(String layer) {
    switch (layer) {
      case 'Hojas y Plantas':
        return const Color(0xFF2C1810);
      case 'Tierra Fértil':
        return const Color(0xFF8B4513);
      case 'Tierra con Piedras':
        return const Color(0xFFCD853F);
      case 'Rocas Grandes':
        return const Color(0xFF808080);
      default:
        return Colors.brown;
    }
  }

  void _checkOrder() {
    List<String> correctOrder = [
      'Hojas y Plantas',
      'Tierra Fértil',
      'Tierra con Piedras',
      'Rocas Grandes'
    ];

    bool isCorrect = true;
    for (int i = 0; i < currentOrder.length; i++) {
      if (currentOrder[i]['name'] != correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      setState(() {
        completed = true;
        score = 120;
        streak++;
      });
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) widget.onGameComplete(score, streak);
      });
    } else {
      _shakeController.forward(from: 0);
      attempts++;
      setState(() {
        score = 0;
        // No se pierde la racha en los primeros 2 intentos
        if (attempts > 2) {
          streak = 0;
        }
      });

      String hint = '';
      if (attempts == 1) {
        hint = 'Recuerda: 1️⃣ Hojas arriba → 4️⃣ Rocas abajo';
      } else if (attempts == 2) {
        hint = 'Pista: Ordénalas por los números (1, 2, 3, 4)';
      } else {
        hint = 'Última pista: 🍂(1) → 🌾(2) → ⛰️(3) → 🪨(4)';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(hint),
              ),
            ],
          ),
          backgroundColor: attempts > 2 ? Colors.red[700] : Colors.orange[700],
          duration: const Duration(seconds: 4),
        ),
      );
      HapticFeedback.heavyImpact();
    }
  }
}

// JUEGO 2: COMPOSTAJE
class Juego2Compostaje extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2Compostaje(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Compostaje> createState() => _Juego2CompostajeState();
}

class _Juego2CompostajeState extends State<Juego2Compostaje> {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 45;

  List<Map<String, dynamic>> items = [
    {'emoji': '🍎', 'name': 'Manzana', 'compost': true},
    {'emoji': '🥤', 'name': 'Plástico', 'compost': false},
    {'emoji': '🍂', 'name': 'Hojas', 'compost': true},
    {'emoji': '🔋', 'name': 'Pila', 'compost': false},
    {'emoji': '🍌', 'name': 'Cáscara', 'compost': true},
    {'emoji': '🥚', 'name': 'Huevo', 'compost': true},
  ];

  @override
  void initState() {
    super.initState();
    items.shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || currentItem >= items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text('Puntos: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
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
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 $score',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿Sirve para compost?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: items[currentItem]['compost'].toString(),
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
            _buildZone('Basura', '🗑️', false, Colors.grey),
            _buildZone('Compost', '🌱', true, Colors.green),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(
      String label, String icon, bool isCompostZone, Color color) {
    return DragTarget<String>(
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
        bool isCompostItem = data == 'true';
        bool correct = isCompostItem == isCompostZone;

        setState(() {
          if (correct) {
            int points = 20 + (streak * 5).toInt();
            score += points;
            streak++;
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

// JUEGO 3: VIDA EN EL SUELO
class Juego3VidaSuelo extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3VidaSuelo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3VidaSuelo> createState() => _Juego3VidaSueloState();
}

class _Juego3VidaSueloState extends State<Juego3VidaSuelo> {
  int found = 0;
  List<bool> isFound = List.filled(6, false);
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 40;

  final List<Map<String, dynamic>> creatures = [
    {'emoji': '🪱', 'top': 100.0, 'left': 50.0},
    {'emoji': '🐜', 'top': 200.0, 'left': 250.0},
    {'emoji': '🐞', 'top': 300.0, 'left': 100.0},
    {'emoji': '🕷️', 'top': 150.0, 'left': 200.0},
    {'emoji': '🐛', 'top': 250.0, 'left': 50.0},
    {'emoji': '🦗', 'top': 180.0, 'left': 120.0},
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || found >= 6) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🪱', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
                'Puntos: ${(found >= 6) ? 100 + (streak * 5).toInt() : found * 15}',
                style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(
                  (found >= 6) ? 100 + (streak * 5).toInt() : found * 15,
                  streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Container(color: Colors.brown[300]),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: _timeLeft < 10 ? Colors.red : widget.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('⏱️ $_timeLeft s',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('🎯 ${found * 15}',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                if (streak > 1)
                  Text('🔥 x$streak',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        ),
        const Center(
          child: Text('¡Encuentra los habitantes del suelo!',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        ...List.generate(creatures.length, (index) {
          return Positioned(
            top: creatures[index]['top'],
            left: creatures[index]['left'],
            child: GestureDetector(
              onTap: () {
                if (!isFound[index]) {
                  setState(() {
                    isFound[index] = true;
                    found++;
                    streak++;
                    HapticFeedback.mediumImpact();
                  });
                }
              },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isFound[index] ? 1.0 : 0.1, // Casi invisible al inicio
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isFound[index] ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(creatures[index]['emoji'],
                      style: const TextStyle(fontSize: 40)),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// JUEGO 4: EROSIÓN
class Juego4Erosion extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4Erosion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Erosion> createState() => _Juego4ErosionState();
}

class _Juego4ErosionState extends State<Juego4Erosion> {
  int trees = 0;
  double erosionLevel = 1.0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 35;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == 0 || erosionLevel <= 0.1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Suelo Protegido!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('🌳🌳🌳', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 20),
            Text(
                'Puntos: ${(erosionLevel <= 0.1) ? 100 + (streak * 5).toInt() : trees * 10}',
                style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(
                  (erosionLevel <= 0.1)
                      ? 100 + (streak * 5).toInt()
                      : trees * 10,
                  streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 ${trees * 10}',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('¡Planta árboles para detener la erosión!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.color)),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                trees++;
                erosionLevel = (erosionLevel - 0.1).clamp(0.0, 1.0);
                streak++;
                HapticFeedback.mediumImpact();
              });
            },
            child: Container(
              width: double.infinity,
              color: Color.lerp(
                  Colors.green[800], Colors.brown[200], erosionLevel),
              child: Stack(
                children: [
                  // Grietas de erosión que desaparecen
                  if (erosionLevel > 0.5)
                    const Center(
                        child: Text('🏜️', style: TextStyle(fontSize: 150))),

                  // Árboles que aparecen
                  Wrap(
                    children: List.generate(trees, (index) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('🌳', style: TextStyle(fontSize: 40)),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: LinearProgressIndicator(
            value: 1.0 - erosionLevel,
            backgroundColor: Colors.red[100],
            color: Colors.green,
            minHeight: 20,
          ),
        ),
      ],
    );
  }
}

// JUEGO 5: QUIZ DE SUELO
class Juego5QuizSuelo extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizSuelo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizSuelo> createState() => _Juego5QuizSueloState();
}

class _Juego5QuizSueloState extends State<Juego5QuizSuelo> {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué capa del suelo tiene más nutrientes?',
      'answers': ['Roca Madre', 'Humus', 'Arena', 'Arcilla'],
      'correctIndex': 1
    },
    {
      'question': '¿Quiénes ayudan a airear el suelo?',
      'answers': ['Las lombrices', 'Las piedras', 'El plástico', 'El viento'],
      'correctIndex': 0
    },
    {
      'question': '¿Qué protege al suelo de la erosión?',
      'answers': [
        'El sol fuerte',
        'La lluvia ácida',
        'Las raíces de plantas',
        'El viento'
      ],
      'correctIndex': 2
    },
    {
      'question': '¿Qué se puede hacer con restos de comida?',
      'answers': ['Quemarlos', 'Tirarlos', 'Hacer compost', 'Enterrarlos'],
      'correctIndex': 2
    },
    {
      'question': '¿Dónde viven las lombrices?',
      'answers': ['En el aire', 'En el agua', 'En el suelo', 'En las nubes'],
      'correctIndex': 2
    },
    {
      'question': '¿Qué ayuda a que el suelo sea fértil?',
      'answers': ['La basura', 'El humus', 'El plástico', 'El cemento'],
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
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
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
            const Text('🌱', style: TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text('Puntos: $score', style: const TextStyle(fontSize: 20)),
            if (streak > 0)
              Text('Racha: 🔥 x$streak',
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(score, streak),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _timeLeft < 10 ? Colors.red : widget.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱️ $_timeLeft s',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('🎯 $score',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              if (streak > 1)
                Text('🔥 x$streak',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  question['question'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
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
          ),
        ),
      ],
    );
  }

  void _checkAnswer(int index) {
    if (index == questions[currentQuestionIndex]['correctIndex']) {
      int points = 30 + (streak * 5).toInt();
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
