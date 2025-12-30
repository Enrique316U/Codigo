// ETAPA 4 - SECCIÓN 2 - NODO 6: CUIDADO DEL PLANETA Y EL COSMOS
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
        return Juego1Reciclaje(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2FasesLuna(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Limpieza(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4Habitos(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizFinal(
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
              Icon(Icons.public, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Héroe del Planeta!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Has completado la Etapa 4! Eres un experto en ciencias.',
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

// JUEGO 1: RECICLAJE
class Juego1Reciclaje extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1Reciclaje(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1Reciclaje> createState() => _Juego1ReciclajeState();
}

class _Juego1ReciclajeState extends State<Juego1Reciclaje> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 30;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Botella', 'type': 'Plástico', 'icon': '🥤', 'color': Colors.blue},
    {'name': 'Periódico', 'type': 'Papel', 'icon': '📰', 'color': Colors.grey},
    {
      'name': 'Manzana',
      'type': 'Orgánico',
      'icon': '🍎',
      'color': Colors.green
    },
    {'name': 'Lata', 'type': 'Metal', 'icon': '🥫', 'color': Colors.yellow},
    {'name': 'Caja', 'type': 'Papel', 'icon': '📦', 'color': Colors.grey},
    {'name': 'Bolsa', 'type': 'Plástico', 'icon': '🛍️', 'color': Colors.blue},
    {
      'name': 'Cáscara',
      'type': 'Orgánico',
      'icon': '🍌',
      'color': Colors.green
    },
    {'name': 'Alambre', 'type': 'Metal', 'icon': '🔗', 'color': Colors.yellow},
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
            const Text('¡Reciclaje Completado!',
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
              if (_streak >= 3)
                Text('Racha: $_streak 🔥',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Text('Clasifica la basura',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
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
                          colors: [Colors.blue.shade100, Colors.green.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue, width: 3),
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
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildBin('Plástico', Colors.blue),
            _buildBin('Papel', Colors.grey),
            _buildBin('Orgánico', Colors.green),
            _buildBin('Metal', Colors.yellow),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBin(String type, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: candidateData.isNotEmpty
                    ? Colors.white
                    : Colors.transparent,
                width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete_outline, color: Colors.white, size: 40),
              Text(type,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == type) {
            _streak++;
            _score += 12 + (_streak >= 3 ? 5 : 0);
            HapticFeedback.mediumImpact();
          } else {
            _streak = 0;
            HapticFeedback.heavyImpact();
          }
          _currentItem++;
        });
      },
    );
  }
}

// JUEGO 2: FASES DE LA LUNA
class Juego2FasesLuna extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2FasesLuna(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2FasesLuna> createState() => _Juego2FasesLunaState();
}

class _Juego2FasesLunaState extends State<Juego2FasesLuna> {
  final List<String> correctOrder = [
    'Luna Nueva',
    'Cuarto Creciente',
    'Luna Llena',
    'Cuarto Menguante'
  ];
  List<String> currentOrder = [];
  int _timeLeft = 40;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentOrder = List.from(correctOrder)..shuffle();
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
    widget.onGameComplete(0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect = true;
    for (int i = 0; i < correctOrder.length; i++) {
      if (currentOrder[i] != correctOrder[i]) isCorrect = false;
    }

    if (isCorrect) {
      _timer?.cancel();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.nightlight_round, size: 100, color: Colors.yellow),
            const SizedBox(height: 20),
            const Text('¡Ciclo Lunar Correcto!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Tiempo restante: $_timeLeft s',
                style: const TextStyle(fontSize: 18, color: Colors.blue)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(100),
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
              const Text('Ordena las fases de la Luna',
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
          child: ReorderableListView(
            children: [
              for (final item in currentOrder)
                ListTile(
                  key: ValueKey(item),
                  title: Text(item),
                  leading: _getMoonIcon(item),
                  tileColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = currentOrder.removeAt(oldIndex);
                currentOrder.insert(newIndex, item);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _getMoonIcon(String phase) {
    switch (phase) {
      case 'Luna Nueva':
        return const Icon(Icons.circle_outlined, color: Colors.black);
      case 'Cuarto Creciente':
        return const Icon(Icons.nightlight_round, color: Colors.grey);
      case 'Luna Llena':
        return const Icon(Icons.circle, color: Colors.yellow);
      case 'Cuarto Menguante':
        return Transform.flip(
            flipX: true,
            child: const Icon(Icons.nightlight_round, color: Colors.grey));
      default:
        return const Icon(Icons.help);
    }
  }
}

// JUEGO 3: LIMPIEZA
class Juego3Limpieza extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Limpieza(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Limpieza> createState() => _Juego3LimpiezaState();
}

class _Juego3LimpiezaState extends State<Juego3Limpieza> {
  List<Offset> trashPositions = [];
  int _cleanedCount = 0;
  int _score = 0;
  final int _totalTrash = 12;
  int _timeLeft = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _totalTrash; i++) {
      trashPositions.add(Offset(
        (i * 30.0) % 300 + 20,
        (i * 50.0) % 400 + 50,
      ));
    }
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
    if (_cleanedCount >= _totalTrash) {
      _timer?.cancel();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cleaning_services, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text('¡Playa Limpia!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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

    return Stack(
      children: [
        // Fondo
        Container(color: Colors.lightBlue[100]),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(color: Colors.amber[100])), // Arena
        // Encabezado
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Limpiados: $_cleanedCount/$_totalTrash',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
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
        const Center(
            child: Text('¡Toca la basura para limpiar!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        // Basura
        ...trashPositions.asMap().entries.map((entry) {
          if (entry.value == Offset.zero) return const SizedBox();
          return Positioned(
            left: entry.value.dx,
            top: entry.value.dy,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        trashPositions[entry.key] = Offset.zero;
                        _cleanedCount++;
                        _score += 8;
                        HapticFeedback.mediumImpact();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.delete,
                          color: Colors.white, size: 36),
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ],
    );
  }
}

// JUEGO 4: HÁBITOS
class Juego4Habitos extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4Habitos(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4Habitos> createState() => _Juego4HabitosState();
}

class _Juego4HabitosState extends State<Juego4Habitos> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Cerrar el grifo', 'good': true, 'icon': '🚰'},
    {'name': 'Tirar basura al río', 'good': false, 'icon': '🚮'},
    {'name': 'Apagar luces', 'good': true, 'icon': '💡'},
    {'name': 'Usar bolsas de tela', 'good': true, 'icon': '🛍️'},
    {'name': 'Dejar TV encendida', 'good': false, 'icon': '📺'},
    {'name': 'Reciclar papel', 'good': true, 'icon': '📄'},
    {'name': 'Malgastar agua', 'good': false, 'icon': '💧'},
    {'name': 'Usar bicicleta', 'good': true, 'icon': '🚴'},
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
      _timer?.cancel();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Evaluación Completa!',
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
              if (_streak >= 3)
                Text('Racha: $_streak 🔥',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Text('¿Es un buen hábito?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Draggable<bool>(
                    data: _items[_currentItem]['good'],
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
                          colors: [Colors.green.shade100, Colors.blue.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
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
            _buildZone('Malo', '👎', false, Colors.red),
            _buildZone('Bueno', '👍', true, Colors.green),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String label, String icon, bool isGood, Color color) {
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
          if (data == isGood) {
            _streak++;
            _score += 12 + (_streak >= 3 ? 5 : 0);
            HapticFeedback.mediumImpact();
          } else {
            _streak = 0;
            HapticFeedback.heavyImpact();
          }
          _currentItem++;
        });
      },
    );
  }
}

// JUEGO 5: QUIZ FINAL
class Juego5QuizFinal extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizFinal(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizFinal> createState() => _Juego5QuizFinalState();
}

class _Juego5QuizFinalState extends State<Juego5QuizFinal> {
  int _score = 0;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _timeLeft = 10;
  Timer? _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuánto tarda la Luna en dar la vuelta a la Tierra?',
      'answers': ['28 días', '365 días', '24 horas', '1 semana'],
      'correctIndex': 0,
      'explanation':
          'La Luna tarda aproximadamente 28 días en completar una órbita alrededor de la Tierra.'
    },
    {
      'question': '¿Qué color de contenedor es para el papel?',
      'answers': ['Verde', 'Amarillo', 'Azul', 'Gris/Azul'],
      'correctIndex': 2,
      'explanation': 'El contenedor azul es para papel y cartón.'
    },
    {
      'question': '¿Qué es reciclar?',
      'answers': [
        'Tirar todo junto',
        'Reusar materiales',
        'Quemar basura',
        'Comprar más'
      ],
      'correctIndex': 1,
      'explanation':
          'Reciclar es transformar materiales usados en nuevos productos.'
    },
    {
      'question': '¿Cuál es un buen hábito ecológico?',
      'answers': [
        'Dejar luces encendidas',
        'Malgastar agua',
        'Usar bicicleta',
        'Tirar basura al suelo'
      ],
      'correctIndex': 2,
      'explanation':
          'Usar bicicleta reduce la contaminación y cuida el medio ambiente.'
    },
    {
      'question': '¿Por qué debemos cuidar el planeta?',
      'answers': [
        'Es nuestro hogar',
        'No importa',
        'Solo por diversión',
        'Para gastar más'
      ],
      'correctIndex': 0,
      'explanation':
          'El planeta es nuestro hogar y debemos protegerlo para las futuras generaciones.'
    },
  ];

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
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (!_answered) {
      setState(() {
        _answered = true;
        _selectedAnswer = -1;
      });
      _timer?.cancel();
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(seconds: 2), _nextQuestion);
    }
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestion++;
      _answered = false;
      _selectedAnswer = null;
      _timeLeft = 10;
    });
    if (_currentQuestion < _questions.length) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion >= _questions.length) {
      _timer?.cancel();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('¡Quiz Completado!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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

    final question = _questions[_currentQuestion];
    final correctIndex = question['correctIndex'] as int;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pregunta ${_currentQuestion + 1}/${_questions.length}',
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
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade100, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
            if (_answered) {
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
                  onPressed: _answered ? null : () => _checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor:
                        buttonColor ?? widget.color.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: buttonColor,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: Text(
                    question['answers'][index],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }),
          if (_answered) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedAnswer == correctIndex
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    _selectedAnswer == correctIndex
                        ? '¡Correcto! +20 pts'
                        : _selectedAnswer == -1
                            ? '¡Tiempo agotado!'
                            : '¡Incorrecto!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _selectedAnswer == correctIndex
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
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

  void _checkAnswer(int index) {
    _timer?.cancel();
    setState(() {
      _answered = true;
      _selectedAnswer = index;
      if (index == _questions[_currentQuestion]['correctIndex']) {
        _score += 20;
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    });
    Future.delayed(const Duration(seconds: 3), _nextQuestion);
  }
}
