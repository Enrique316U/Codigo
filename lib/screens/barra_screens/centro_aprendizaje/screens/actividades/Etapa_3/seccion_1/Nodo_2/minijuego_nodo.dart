// ETAPA 3 - SECCIÓN 1 - NODO 2: Insectos y arácnidos en el ecosistema
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
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
        return Juego1CicloMariposa(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2CadenaAlimentaria(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3DietaAnimal(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4CicloRana(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizVida(
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
              Icon(Icons.emoji_nature, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Experto en Vida!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
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

// JUEGO 1: CICLO DE VIDA DE LA MARIPOSA
class Juego1CicloMariposa extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego1CicloMariposa(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1CicloMariposa> createState() => _Juego1CicloMariposaState();
}

class _Juego1CicloMariposaState extends State<Juego1CicloMariposa>
    with SingleTickerProviderStateMixin {
  final List<String> correctOrder = ['🥚', '🐛', '🧶', '🦋'];
  final List<String> labels = ['Huevo', 'Oruga', 'Capullo', 'Mariposa'];
  List<String> currentOrder = ['🦋', '🥚', '🧶', '🐛'];

  int streak = 0;
  int score = 0;
  Timer? _timer;
  int _timeLeft = 45;
  late AnimationController _scaleController;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    currentOrder.shuffle();
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
    if (_timeLeft == 0 || completed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bug_report,
                size: 80, color: completed ? Colors.green : Colors.grey),
            const SizedBox(height: 20),
            Text(
              completed ? '¡Ciclo Completo!' : '¡Tiempo agotado!',
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
                child: Text(
                  'Ordena el ciclo de vida de la mariposa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
          child: ReorderableListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (int i = 0; i < currentOrder.length; i++)
                AnimatedContainer(
                  key: ValueKey(currentOrder[i]),
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Text(currentOrder[i],
                          style: const TextStyle(fontSize: 40)),
                      title: Text(_getLabel(currentOrder[i])),
                      trailing: const Icon(Icons.drag_handle),
                    ),
                  ),
                ),
            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final String item = currentOrder.removeAt(oldIndex);
                currentOrder.insert(newIndex, item);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _checkOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Verificar Orden',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  String _getLabel(String emoji) {
    int index = correctOrder.indexOf(emoji);
    if (index != -1) return labels[index];
    return '';
  }

  void _checkOrder() {
    bool isCorrect = true;
    for (int i = 0; i < correctOrder.length; i++) {
      if (currentOrder[i] != correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      int points = 100 + (streak * 10);
      setState(() {
        score += points;
        streak++;
        completed = true;
      });
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      setState(() {
        streak = 0;
      });
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Inténtalo de nuevo! El orden no es correcto.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// JUEGO 2: CADENA ALIMENTARIA
class Juego2CadenaAlimentaria extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego2CadenaAlimentaria(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2CadenaAlimentaria> createState() =>
      _Juego2CadenaAlimentariaState();
}

class _Juego2CadenaAlimentariaState extends State<Juego2CadenaAlimentaria>
    with SingleTickerProviderStateMixin {
  final List<String> correctOrder = ['☀️', '🌱', '🐛', '🐦'];
  final List<String> labels = ['Sol', 'Planta', 'Oruga', 'Pájaro'];
  List<String> currentOrder = ['🐛', '☀️', '🐦', '🌱'];

  int streak = 0;
  int score = 0;
  Timer? _timer;
  int _timeLeft = 45;
  late AnimationController _scaleController;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    currentOrder.shuffle();
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
    if (_timeLeft == 0 || completed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.energy_savings_leaf,
                size: 80, color: completed ? Colors.green : Colors.grey),
            const SizedBox(height: 20),
            Text(
              completed ? '¡Cadena Completa!' : '¡Tiempo agotado!',
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
                child: Text(
                  '¿Quién come a quién?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
          child: ReorderableListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (int i = 0; i < currentOrder.length; i++)
                AnimatedContainer(
                  key: ValueKey(currentOrder[i]),
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Text(currentOrder[i],
                          style: const TextStyle(fontSize: 40)),
                      title: Text(_getLabel(currentOrder[i])),
                      trailing: const Icon(Icons.drag_handle),
                    ),
                  ),
                ),
            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final String item = currentOrder.removeAt(oldIndex);
                currentOrder.insert(newIndex, item);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _checkOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Verificar Cadena',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  String _getLabel(String emoji) {
    int index = correctOrder.indexOf(emoji);
    if (index != -1) return labels[index];
    return '';
  }

  void _checkOrder() {
    bool isCorrect = true;
    for (int i = 0; i < correctOrder.length; i++) {
      if (currentOrder[i] != correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      int points = 100 + (streak * 10);
      setState(() {
        score += points;
        streak++;
        completed = true;
      });
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      setState(() {
        streak = 0;
      });
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('¡Ups! Recuerda: Sol -> Planta -> Herbívoro -> Carnívoro'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// JUEGO 3: DIETA ANIMAL
class Juego3DietaAnimal extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego3DietaAnimal(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3DietaAnimal> createState() => _Juego3DietaAnimalState();
}

class _Juego3DietaAnimalState extends State<Juego3DietaAnimal>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentItem = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 50;
  late AnimationController _scaleController;

  List<Map<String, String>> animals = [
    {'emoji': '🦁', 'name': 'León', 'type': 'Carnívoro'},
    {'emoji': '🐄', 'name': 'Vaca', 'type': 'Herbívoro'},
    {'emoji': '🐻', 'name': 'Oso', 'type': 'Omnívoro'},
    {'emoji': '🦈', 'name': 'Tiburón', 'type': 'Carnívoro'},
    {'emoji': '🦒', 'name': 'Jirafa', 'type': 'Herbívoro'},
    {'emoji': '🐷', 'name': 'Cerdo', 'type': 'Omnívoro'},
    {'emoji': '🐺', 'name': 'Lobo', 'type': 'Carnívoro'},
    {'emoji': '🐰', 'name': 'Conejo', 'type': 'Herbívoro'},
  ];

  @override
  void initState() {
    super.initState();
    animals.shuffle();
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
    if (_timeLeft == 0 || currentItem >= animals.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets,
                size: 80,
                color:
                    currentItem >= animals.length ? Colors.green : Colors.grey),
            const SizedBox(height: 20),
            Text(
              currentItem >= animals.length
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
                child: Text('¿Qué come este animal?',
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
              scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                CurvedAnimation(
                    parent: _scaleController, curve: Curves.easeInOut),
              ),
              child: Draggable<String>(
                data: animals[currentItem]['type'],
                feedback: Material(
                  color: Colors.transparent,
                  child: Text(animals[currentItem]['emoji']!,
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
                    Text(animals[currentItem]['emoji']!,
                        style: const TextStyle(fontSize: 80)),
                    Text(animals[currentItem]['name']!,
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
            _buildZone('Herbívoro', '🌿', Colors.green),
            _buildZone('Carnívoro', '🥩', Colors.red),
            _buildZone('Omnívoro', '🍽️', Colors.orange),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String name, String icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 120,
          width: 100,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: candidateData.isNotEmpty ? color : Colors.transparent,
                width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),
              Text(name,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        bool correct = data == name;

        setState(() {
          if (correct) {
            int points = 20 + (streak * 5);
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

// JUEGO 4: CICLO DE LA RANA
class Juego4CicloRana extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego4CicloRana(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4CicloRana> createState() => _Juego4CicloRanaState();
}

class _Juego4CicloRanaState extends State<Juego4CicloRana>
    with SingleTickerProviderStateMixin {
  final List<String> correctOrder = ['🥚', '🐸(bebé)', '🐸(joven)', '🐸'];
  final List<String> labels = [
    'Huevos',
    'Renacuajo',
    'Rana Joven',
    'Rana Adulta'
  ];
  List<String> currentOrder = ['🐸(joven)', '🐸', '🥚', '🐸(bebé)'];

  int streak = 0;
  int score = 0;
  Timer? _timer;
  int _timeLeft = 45;
  late AnimationController _scaleController;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    currentOrder.shuffle();
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
    if (_timeLeft == 0 || completed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.waves,
                size: 80, color: completed ? Colors.green : Colors.grey),
            const SizedBox(height: 20),
            Text(
              completed ? '¡Ciclo Completo!' : '¡Tiempo agotado!',
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
                child: Text(
                  'Ordena el ciclo de vida de la rana',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
          child: ReorderableListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (int i = 0; i < currentOrder.length; i++)
                AnimatedContainer(
                  key: ValueKey(currentOrder[i]),
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Text(
                        currentOrder[i].contains('bebé')
                            ? '🐟'
                            : currentOrder[i].contains('joven')
                                ? '🐸'
                                : currentOrder[i],
                        style: const TextStyle(fontSize: 40),
                      ),
                      title: Text(_getLabel(currentOrder[i])),
                      trailing: const Icon(Icons.drag_handle),
                    ),
                  ),
                ),
            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final String item = currentOrder.removeAt(oldIndex);
                currentOrder.insert(newIndex, item);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _checkOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Verificar Ciclo',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  String _getLabel(String key) {
    int index = correctOrder.indexOf(key);
    if (index != -1) return labels[index];
    return '';
  }

  void _checkOrder() {
    bool isCorrect = true;
    for (int i = 0; i < correctOrder.length; i++) {
      if (currentOrder[i] != correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      int points = 100 + (streak * 10);
      setState(() {
        score += points;
        streak++;
        completed = true;
      });
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      setState(() {
        streak = 0;
      });
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Inténtalo de nuevo!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// JUEGO 5: QUIZ DE LA VIDA
class Juego5QuizVida extends StatefulWidget {
  final Color color;
  final Function(int, int) onGameComplete;

  const Juego5QuizVida(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizVida> createState() => _Juego5QuizVidaState();
}

class _Juego5QuizVidaState extends State<Juego5QuizVida>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentQuestionIndex = 0;
  int streak = 0;
  Timer? _timer;
  int _timeLeft = 60;
  late AnimationController _scaleController;

  List<Map<String, dynamic>> questions = [
    {
      'question': '¿Qué necesitan las plantas para vivir?',
      'answers': ['Solo agua', 'Sol, agua y aire', 'Solo sol', 'Nada'],
      'correctIndex': 1
    },
    {
      'question': '¿Cómo nacen los mamíferos?',
      'answers': [
        'De huevos',
        'Del vientre de la madre',
        'De semillas',
        'Del agua'
      ],
      'correctIndex': 1
    },
    {
      'question': '¿Qué es un animal omnívoro?',
      'answers': [
        'Come solo carne',
        'Come solo plantas',
        'Come de todo',
        'No come'
      ],
      'correctIndex': 2
    },
    {
      'question': '¿Qué animal pone huevos?',
      'answers': ['Perro', 'Gato', 'Tortuga', 'Caballo'],
      'correctIndex': 2
    },
    {
      'question': '¿Qué hacen las abejas?',
      'answers': [
        'Polinizan flores',
        'Solo pican',
        'Destruyen plantas',
        'Nada importante'
      ],
      'correctIndex': 0
    },
    {
      'question': '¿Dónde viven los peces?',
      'answers': ['En árboles', 'En el agua', 'En el aire', 'Bajo tierra'],
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
            Icon(Icons.quiz,
                size: 80,
                color: currentQuestionIndex >= questions.length
                    ? Colors.green
                    : Colors.grey),
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

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color:
              _timeLeft < 10 ? Colors.red.withOpacity(0.2) : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Pregunta ${currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
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
      int points = 30 + (streak * 5);
      setState(() {
        score += points;
        streak++;
      });
      _scaleController.forward().then((_) => _scaleController.reverse());
      HapticFeedback.mediumImpact();
    } else {
      setState(() {
        streak = 0;
      });
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentQuestionIndex++;
    });
  }
}
