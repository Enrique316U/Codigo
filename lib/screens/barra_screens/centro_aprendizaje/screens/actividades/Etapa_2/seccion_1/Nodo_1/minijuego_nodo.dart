// ETAPA 2 - SECCIÓN 1 - NODO 1: LAS PLANTAS Y SUS FUNCIONES
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
  int _currentGame = 0; // 0: Menu, 1-5: Games
  int _totalScore = 0;
  List<bool> _gamesCompleted = [false, false, false, false, false];

  void _startGame(int gameIndex) {
    setState(() {
      _currentGame = gameIndex;
    });
  }

  void _completeGame(int score, int gameIndex) {
    setState(() {
      _totalScore += score;
      _gamesCompleted[gameIndex - 1] = true;
      _currentGame = 0; // Return to menu
    });

    if (_gamesCompleted.every((completed) => completed)) {
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    await ProgresoService().marcarActividadCompletada(
        widget.etapa, widget.seccion, widget.actividad, _totalScore);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Felicidades! Has completado todo el nodo 🏆'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LAS PLANTAS Y SUS FUNCIONES",
            style: TextStyle(color: Colors.white)),
        backgroundColor: widget.color,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_totalScore',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentGame) {
      case 1:
        return Juego1FuncionesPartes(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 1));
      case 2:
        return Juego2NecesidadesPlanta(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 2));
      case 3:
        return Juego3CicloVida(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 3));
      case 4:
        return Juego4ClasificacionComestibles(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 4));
      case 5:
        return Juego5QuizPlantas(
            color: widget.color,
            onGameCompleted: (score) => _completeGame(score, 5));
      default:
        return _buildMenu();
    }
  }

  Widget _buildMenu() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [widget.color.withOpacity(0.1), Colors.white],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  '🌿',
                  style: TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 10),
                const Text(
                  '¡Aprende sobre las Plantas!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _buildGameCardEmoji(
            1,
            '🌱 Funciones de las Partes',
            'Une cada parte con su función',
            '🌱',
            const Color(0xFF66BB6A),
          ),
          _buildGameCardEmoji(
            2,
            '💧 Necesidades de la Planta',
            '¿Qué necesita para crecer?',
            '💧',
            const Color(0xFF42A5F5),
          ),
          _buildGameCardEmoji(
            3,
            '🌸 Ciclo de Vida',
            'Ordena las etapas de crecimiento',
            '🌸',
            const Color(0xFFEC407A),
          ),
          _buildGameCardEmoji(
            4,
            '🍎 Partes Comestibles',
            '¿Qué parte de la planta comemos?',
            '🍎',
            const Color(0xFFFF7043),
          ),
          _buildGameCardEmoji(
            5,
            '📚 Quiz de Plantas',
            'Demuestra todo lo que aprendiste',
            '🏆',
            const Color(0xFFFFCA28),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCardEmoji(int index, String title, String description,
      String emoji, Color cardColor) {
    bool isCompleted = _gamesCompleted[index - 1];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [Colors.green, Colors.green[700]!]
              : [cardColor, cardColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _startGame(index),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    isCompleted ? '✅' : emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
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

// JUEGO 1: Funciones de las Partes (Drag and Drop)
class Juego1FuncionesPartes extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego1FuncionesPartes(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego1FuncionesPartes> createState() => _Juego1FuncionesPartesState();
}

class _Juego1FuncionesPartesState extends State<Juego1FuncionesPartes> {
  final Map<String, String> _matches = {
    'Raíz': 'Absorbe agua',
    'Tallo': 'Sostiene la planta',
    'Hoja': 'Fabrica alimento',
    'Flor': 'Reproducción',
  };
  final Map<String, bool> _matched = {};
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Inténtalo de nuevo! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [widget.color, widget.color.withOpacity(0.7)]),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Text('🌱', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Partes de la Planta',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Une cada parte con su función',
                style: TextStyle(
                    fontSize: 16, color: Colors.white.withOpacity(0.9)),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(_formatTime(_seconds),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('⭐ $_score / 80 puntos',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 10),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                      color: _feedbackColor?.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: _feedbackColor?.withOpacity(0.5) ??
                                Colors.transparent,
                            blurRadius: 8,
                            spreadRadius: 2)
                      ]),
                  child: Text(_lastFeedback!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _matches.keys.map((part) {
                  return Draggable<String>(
                    data: part,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(part,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    childWhenDragging: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(part,
                          style: const TextStyle(color: Colors.transparent)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _matched.containsKey(part)
                            ? Colors.green
                            : widget.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(part,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  );
                }).toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _matches.values.map((func) {
                  return DragTarget<String>(
                    onAccept: (receivedPart) {
                      if (_matches[receivedPart] == func) {
                        setState(() {
                          _matched[receivedPart] = true;
                          _score += 20;
                        });
                        _showFeedback(true);
                        HapticFeedback.mediumImpact();
                        if (_matched.length == _matches.length) {
                          _timer?.cancel();
                          Future.delayed(const Duration(seconds: 1), () {
                            widget.onGameCompleted(_score);
                          });
                        }
                      } else {
                        _showFeedback(false);
                        HapticFeedback.vibrate();
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      bool isMatched = _matched.entries
                          .any((e) => e.value && _matches[e.key] == func);
                      return Container(
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMatched ? Colors.green[100] : Colors.white,
                          border: Border.all(
                              color: isMatched ? Colors.green : Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            func,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isMatched ? Colors.green : Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// JUEGO 2: Necesidades de la Planta (Selection)
class Juego2NecesidadesPlanta extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego2NecesidadesPlanta(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego2NecesidadesPlanta> createState() =>
      _Juego2NecesidadesPlantaState();
}

class _Juego2NecesidadesPlantaState extends State<Juego2NecesidadesPlanta> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Agua', 'icon': Icons.water_drop, 'needed': true},
    {'name': 'Sol', 'icon': Icons.wb_sunny, 'needed': true},
    {'name': 'Caramelos', 'icon': Icons.cake, 'needed': false},
    {'name': 'Aire', 'icon': Icons.air, 'needed': true},
    {'name': 'Juguetes', 'icon': Icons.toys, 'needed': false},
    {'name': 'Tierra', 'icon': Icons.landscape, 'needed': true},
  ];
  final Set<int> _selected = {};
  int _seconds = 0;
  Timer? _timer;
  Map<int, bool?> _itemFeedback = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _checkAnswers() {
    int correct = 0;
    int wrong = 0;

    // Actualizar feedback visual para cada ítem
    setState(() {
      for (int i = 0; i < _items.length; i++) {
        if (_selected.contains(i)) {
          if (_items[i]['needed']) {
            _itemFeedback[i] = true; // Verde - correcto
            correct++;
          } else {
            _itemFeedback[i] = false; // Rojo - incorrecto
            wrong++;
          }
        } else {
          if (_items[i]['needed']) {
            _itemFeedback[i] = false; // Rojo - faltó seleccionar
            wrong++;
          } else {
            _itemFeedback[i] = true; // Verde - correcto no seleccionar
          }
        }
      }
    });

    if (correct == 4 && wrong == 0) {
      HapticFeedback.mediumImpact();
      _timer?.cancel();
      Future.delayed(Duration(milliseconds: 1000), () {
        widget.onGameCompleted(100);
      });
    } else {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Revisa! $correct correctas, $wrong incorrectas'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      // Limpiar feedback y selección después de 2 segundos
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _itemFeedback.clear();
            _selected.clear();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF42A5F5),
              Color(0xFF42A5F5).withOpacity(0.7)
            ]),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Text('💧', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Necesidades de la Planta',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Selecciona lo que las plantas necesitan',
                style: TextStyle(
                    fontSize: 16, color: Colors.white.withOpacity(0.9)),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(_formatTime(_seconds),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('⭐ ${_selected.length}/4 seleccionados',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              bool isSelected = _selected.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selected.remove(index);
                      _itemFeedback.remove(index);
                    } else {
                      _selected.add(index);
                    }
                  });
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _itemFeedback[index] == true
                        ? Colors.green.withOpacity(0.3)
                        : _itemFeedback[index] == false
                            ? Colors.red.withOpacity(0.3)
                            : isSelected
                                ? Color(0xFF42A5F5).withOpacity(0.2)
                                : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _itemFeedback[index] == true
                            ? Colors.green
                            : _itemFeedback[index] == false
                                ? Colors.red
                                : isSelected
                                    ? Color(0xFF42A5F5)
                                    : Colors.grey,
                        width: isSelected ? 3 : 2),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: Color(0xFF42A5F5).withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2)
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _items[index]['icon'],
                        size: 48,
                        color: isSelected ? Colors.white : widget.color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _items[index]['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _checkAnswers,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Verificar',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

// JUEGO 3: Ciclo de Vida (Ordering)
class Juego3CicloVida extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego3CicloVida(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego3CicloVida> createState() => _Juego3CicloVidaState();
}

class _Juego3CicloVidaState extends State<Juego3CicloVida> {
  List<String> _stages = ['Semilla', 'Brote', 'Planta Joven', 'Planta Adulta'];
  List<String> _currentOrder = [];
  int _seconds = 0;
  Timer? _timer;
  Map<int, bool?> _feedback = {};

  @override
  void initState() {
    super.initState();
    _currentOrder = List.from(_stages)..shuffle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _checkOrder() {
    setState(() {
      for (int i = 0; i < _stages.length; i++) {
        _feedback[i] = _currentOrder[i] == _stages[i];
      }
    });

    bool correct = _feedback.values.every((v) => v == true);

    if (correct) {
      HapticFeedback.mediumImpact();
      _timer?.cancel();
      Future.delayed(Duration(milliseconds: 1000), () {
        widget.onGameCompleted(100);
      });
    } else {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Algunas etapas no están en orden correcto'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _feedback.clear();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text(
                '🌸',
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(height: 8),
              Text(
                'Ciclo de Vida',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Arrastra para ordenar el ciclo de vida',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: ReorderableListView(
            padding: const EdgeInsets.all(16),
            children: _currentOrder
                .asMap()
                .entries
                .map((entry) {
                  int idx = entry.key;
                  String stage = entry.value;
                  bool? feedbackState = _feedback[idx];
                  return Card(
                    key: ValueKey(stage),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: feedbackState == true
                        ? Colors.green.withOpacity(0.2)
                        : feedbackState == false
                            ? Colors.red.withOpacity(0.2)
                            : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: feedbackState == true
                            ? Colors.green
                            : feedbackState == false
                                ? Colors.red
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.drag_handle, color: widget.color),
                      title: Text(stage, style: const TextStyle(fontSize: 18)),
                      trailing: Icon(
                        stage == 'Semilla'
                            ? Icons.grain
                            : stage == 'Brote'
                                ? Icons.grass
                                : stage == 'Planta Joven'
                                    ? Icons.local_florist
                                    : Icons.nature,
                        color: widget.color,
                      ),
                    ),
                  );
                })
                .toList()
                .toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = _currentOrder.removeAt(oldIndex);
                _currentOrder.insert(newIndex, item);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _checkOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Verificar Orden',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

// JUEGO 4: Clasificación Comestibles (Quiz style)
class Juego4ClasificacionComestibles extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego4ClasificacionComestibles(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego4ClasificacionComestibles> createState() =>
      _Juego4ClasificacionComestiblesState();
}

class _Juego4ClasificacionComestiblesState
    extends State<Juego4ClasificacionComestibles> {
  int _index = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;
  final List<Map<String, dynamic>> _questions = [
    {
      'food': 'Zanahoria',
      'options': ['Raíz', 'Hoja', 'Fruto'],
      'correct': 0
    },
    {
      'food': 'Lechuga',
      'options': ['Tallo', 'Hoja', 'Raíz'],
      'correct': 1
    },
    {
      'food': 'Manzana',
      'options': ['Flor', 'Hoja', 'Fruto'],
      'correct': 2
    },
    {
      'food': 'Apio',
      'options': ['Tallo', 'Fruto', 'Raíz'],
      'correct': 0
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  void _answer(int optionIndex) {
    bool isCorrect = optionIndex == _questions[_index]['correct'];

    if (isCorrect) {
      _score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }

    _showFeedback(isCorrect);

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        if (_index < _questions.length - 1) {
          setState(() {
            _index++;
          });
        } else {
          _timer?.cancel();
          widget.onGameCompleted(_score);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text('🍎', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Partes Comestibles',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pregunta ${_index + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Text(
                  '¿Qué parte de la planta es?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _questions[_index]['food'],
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(3, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _answer(i),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.color,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                _questions[_index]['options'][i],
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// JUEGO 5: Quiz Final
class Juego5QuizPlantas extends StatefulWidget {
  final Color color;
  final Function(int) onGameCompleted;

  const Juego5QuizPlantas(
      {super.key, required this.color, required this.onGameCompleted});

  @override
  State<Juego5QuizPlantas> createState() => _Juego5QuizPlantasState();
}

class _Juego5QuizPlantasState extends State<Juego5QuizPlantas> {
  int _questionIndex = 0;
  int _score = 0;
  int _seconds = 0;
  Timer? _timer;
  String? _lastFeedback;
  Color? _feedbackColor;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFeedback(bool isCorrect) {
    setState(() {
      _lastFeedback = isCorrect ? '¡Correcto! ✓' : '¡Incorrecto! ✗';
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _lastFeedback = null;
        });
      }
    });
  }

  final List<Map<String, Object>> _questions = [
    {
      'question': '¿Qué necesitan las plantas para fabricar su alimento?',
      'answers': [
        {'text': 'Solo agua', 'score': 0},
        {'text': 'Sol, agua y aire', 'score': 20},
        {'text': 'Juguetes', 'score': 0},
      ],
    },
    {
      'question': '¿Por dónde absorbe el agua la planta?',
      'answers': [
        {'text': 'Por las hojas', 'score': 0},
        {'text': 'Por la flor', 'score': 0},
        {'text': 'Por la raíz', 'score': 20},
      ],
    },
    {
      'question': '¿Qué parte se convierte en fruto?',
      'answers': [
        {'text': 'La flor', 'score': 20},
        {'text': 'El tallo', 'score': 0},
        {'text': 'La hoja', 'score': 0},
      ],
    },
    {
      'question': '¿Qué nos dan las plantas para respirar?',
      'answers': [
        {'text': 'Dióxido de carbono', 'score': 0},
        {'text': 'Oxígeno', 'score': 20},
        {'text': 'Humo', 'score': 0},
      ],
    },
    {
      'question': '¿Cómo se llama el proceso de fabricar alimento?',
      'answers': [
        {'text': 'Fotosíntesis', 'score': 20},
        {'text': 'Digestión', 'score': 0},
        {'text': 'Respiración', 'score': 0},
      ],
    },
  ];

  void _answerQuestion(int score) {
    bool isCorrect = score > 0;

    if (isCorrect) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }

    _showFeedback(isCorrect);
    setState(() {
      _score += score;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _questionIndex++;
        });

        if (_questionIndex >= _questions.length) {
          _timer?.cancel();
          widget.onGameCompleted(_score);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questionIndex >= _questions.length) return Container();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text('🏆', style: TextStyle(fontSize: 50)),
              SizedBox(height: 8),
              Text(
                'Quiz de Plantas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_seconds),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $_score / 100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_lastFeedback != null) ...[
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _feedbackColor?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _feedbackColor!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    _lastFeedback!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
                  'Pregunta ${_questionIndex + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Text(
                  _questions[_questionIndex]['question'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                ...(_questions[_questionIndex]['answers']
                        as List<Map<String, Object>>)
                    .map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            _answerQuestion(answer['score'] as int),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          answer['text'] as String,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
