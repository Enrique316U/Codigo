import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:green_cloud/services/progreso_service.dart';

// Widget de Temporizador Reutilizable
class GameTimer extends StatelessWidget {
  final int timeLeft;
  final int totalTime;

  const GameTimer({
    Key? key,
    required this.timeLeft,
    required this.totalTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = timeLeft / totalTime;
    Color color = progress > 0.5
        ? Colors.green
        : progress > 0.2
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: color),
          SizedBox(width: 10),
          Text(
            '$timeLeft s',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 15),
          Container(
            width: 100,
            height: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MinijuegoNodo1Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo1Screen({
    Key? key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  }) : super(key: key);

  @override
  _MinijuegoNodo1ScreenState createState() => _MinijuegoNodo1ScreenState();
}

class _MinijuegoNodo1ScreenState extends State<MinijuegoNodo1Screen> {
  int _currentLevel = 0;
  int _score = 0;
  final int _totalLevels = 7;

  void _nextLevel(int scoreToAdd) {
    setState(() {
      _score += scoreToAdd;
      if (_currentLevel < _totalLevels - 1) {
        _currentLevel++;
      } else {
        _showVictoryDialog();
      }
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            SizedBox(height: 20),
            Text('Has completado todos los desafíos de Seres Vivos.'),
            Text('Puntaje Final: $_score',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Guardar progreso
              await ProgresoService().marcarActividadCompletada(
                  widget.etapa, widget.seccion, widget.actividad, _score);

              if (mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true); // Retorna true al cerrar
              }
            },
            child: Text('Terminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightGreen[300]!, Colors.green[700]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Nivel ${_currentLevel + 1}/$_totalLevels',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Puntos: $_score',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildCurrentLevel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLevel() {
    switch (_currentLevel) {
      case 0:
        return Juego1Clasificacion(onCompleted: _nextLevel);
      case 1:
        return Juego2PuzzleEcosistema(onCompleted: _nextLevel);
      case 2:
        return Juego3CicloVida(onCompleted: _nextLevel);
      case 3:
        return Juego4Memoria(onCompleted: _nextLevel);
      case 4:
        return Juego5Alimentacion(onCompleted: _nextLevel);
      case 5:
        return Juego6Habitat(onCompleted: _nextLevel);
      case 6:
        return Juego7Quiz(onCompleted: _nextLevel);
      default:
        return Center(child: Text('Error de nivel'));
    }
  }
}

// --- JUEGO 1: Clasificación Seres Vivos vs Inertes (MEJORADO) ---
class Juego1Clasificacion extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego1Clasificacion({required this.onCompleted});

  @override
  _Juego1ClasificacionState createState() => _Juego1ClasificacionState();
}

class _Juego1ClasificacionState extends State<Juego1Clasificacion> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Perro', 'icon': Icons.pets, 'type': 'vivo'},
    {'name': 'Roca', 'icon': Icons.landscape, 'type': 'inerte'},
    {'name': 'Árbol', 'icon': Icons.park, 'type': 'vivo'},
    {'name': 'Auto', 'icon': Icons.directions_car, 'type': 'inerte'},
    {'name': 'Flor', 'icon': Icons.local_florist, 'type': 'vivo'},
    {'name': 'Mesa', 'icon': Icons.table_restaurant, 'type': 'inerte'},
    {'name': 'Pájaro', 'icon': Icons.flutter_dash, 'type': 'vivo'}, // Extra
    {
      'name': 'Teléfono',
      'icon': Icons.phone_android,
      'type': 'inerte'
    }, // Extra
  ];

  late List<Map<String, dynamic>> _currentItems;
  int _score = 0;
  int _timeLeft = 45; // Tiempo límite
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentItems = List.from(_items)..shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(_score);
        }
      });
    });
  }

  void _handleGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('¡Tiempo Agotado!'),
        content: Text('Inténtalo de nuevo para ser más rápido.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _timeLeft = 45;
                _score = 0;
                _currentItems = List.from(_items)..shuffle();
                _startTimer();
              });
            },
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 45),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Arrastra al contenedor correcto',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTarget('Seres Vivos', 'vivo', Colors.green[100]!),
              _buildTarget('Objetos Inertes', 'inerte', Colors.grey[300]!),
            ],
          ),
        ),
        Container(
          height: 120,
          padding: EdgeInsets.all(10),
          child: _currentItems.isEmpty
              ? Center(
                  child: Text('¡Bien hecho!',
                      style: TextStyle(color: Colors.white, fontSize: 24)))
              : Draggable<Map<String, dynamic>>(
                  data: _currentItems.first,
                  feedback: _buildDraggableItem(_currentItems.first, true),
                  childWhenDragging: Container(width: 80, height: 80),
                  child: _buildDraggableItem(_currentItems.first, false),
                ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDraggableItem(Map<String, dynamic> item, bool isDragging) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: isDragging
              ? [BoxShadow(blurRadius: 10, color: Colors.black26)]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item['icon'], size: 40, color: Colors.blue),
            Text(item['name'], style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildTarget(String title, String type, Color color) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 150,
          height: 250,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type == 'vivo' ? Icons.favorite : Icons.block,
                  size: 50, color: Colors.black54),
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        if (data['type'] == type) {
          setState(() {
            _score += 10;
            _currentItems.removeAt(0);
            HapticFeedback.lightImpact();
          });
          if (_currentItems.isEmpty) {
            _timer?.cancel();
            widget.onCompleted(_score + _timeLeft * 2); // Bonus por tiempo
          }
        } else {
          setState(() {
            _timeLeft = max(0, _timeLeft - 5); // Penalización de tiempo
            HapticFeedback.heavyImpact();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('¡Incorrecto! -5 segundos'),
                backgroundColor: Colors.red,
                duration: Duration(milliseconds: 500)),
          );
        }
      },
    );
  }
}

// --- JUEGO 2: Puzzle Ecosistema (MEJORADO - 8-Puzzle) ---
class Juego2PuzzleEcosistema extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego2PuzzleEcosistema({required this.onCompleted});

  @override
  _Juego2PuzzleEcosistemaState createState() => _Juego2PuzzleEcosistemaState();
}

class _Juego2PuzzleEcosistemaState extends State<Juego2PuzzleEcosistema> {
  // 0 representa el espacio vacío
  List<int> _puzzlePieces = [1, 2, 3, 4, 5, 6, 7, 8, 0];
  int _timeLeft = 120; // Más tiempo para un puzzle real
  Timer? _timer;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _shufflePuzzle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  void _shufflePuzzle() {
    // Algoritmo de mezcla simple: realizar movimientos aleatorios válidos
    // Esto garantiza que el puzzle siempre sea resoluble
    Random rng = Random();
    int emptyIndex = 8; // Posición inicial del 0

    // Realizar 100 movimientos aleatorios
    for (int i = 0; i < 100; i++) {
      List<int> neighbors = [];
      int row = emptyIndex ~/ 3;
      int col = emptyIndex % 3;

      if (row > 0) neighbors.add(emptyIndex - 3); // Arriba
      if (row < 2) neighbors.add(emptyIndex + 3); // Abajo
      if (col > 0) neighbors.add(emptyIndex - 1); // Izquierda
      if (col < 2) neighbors.add(emptyIndex + 1); // Derecha

      int targetIndex = neighbors[rng.nextInt(neighbors.length)];

      // Intercambiar
      int temp = _puzzlePieces[emptyIndex];
      _puzzlePieces[emptyIndex] = _puzzlePieces[targetIndex];
      _puzzlePieces[targetIndex] = temp;

      emptyIndex = targetIndex;
    }

    // Asegurarse de que no esté resuelto al inicio
    if (_checkWin()) {
      _shufflePuzzle();
    }

    setState(() {
      _moves = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _checkWin() {
    List<int> target = [1, 2, 3, 4, 5, 6, 7, 8, 0];
    for (int i = 0; i < _puzzlePieces.length; i++) {
      if (_puzzlePieces[i] != target[i]) return false;
    }
    return true;
  }

  void _movePiece(int index) {
    int emptyIndex = _puzzlePieces.indexOf(0);

    // Verificar si el movimiento es válido (adyacente al vacío)
    int row = index ~/ 3;
    int col = index % 3;
    int emptyRow = emptyIndex ~/ 3;
    int emptyCol = emptyIndex % 3;

    bool isAdjacent = (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);

    if (isAdjacent) {
      setState(() {
        // Intercambiar
        _puzzlePieces[emptyIndex] = _puzzlePieces[index];
        _puzzlePieces[index] = 0;
        _moves++;
        HapticFeedback.selectionClick();

        if (_checkWin()) {
          _timer?.cancel();
          HapticFeedback.heavyImpact();
          widget.onCompleted(100 + _timeLeft + (50 - _moves).clamp(0, 50));
        }
      });
    } else {
      HapticFeedback.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 120),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Ordena los números del 1 al 8',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Desliza las piezas al espacio vacío',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                'Movimientos: $_moves',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.brown[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int number = _puzzlePieces[index];
                  if (number == 0) {
                    return Container(color: Colors.transparent);
                  }

                  // Color basado en si está en su posición correcta (opcional, ayuda visual)
                  bool isCorrect = number == index + 1;

                  return GestureDetector(
                    onTap: () => _movePiece(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isCorrect ? Colors.green[400] : Colors.amber[100],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          )
                        ],
                        border: Border.all(
                          color: Colors.brown[600]!,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ElevatedButton.icon(
            onPressed: () {
              _timer?.cancel();
              _shufflePuzzle();
              _timeLeft = 120;
              _startTimer();
            },
            icon: Icon(Icons.refresh),
            label: Text('Reiniciar Puzzle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// --- JUEGO 3: Ciclo de Vida (MEJORADO) ---
class Juego3CicloVida extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego3CicloVida({required this.onCompleted});

  @override
  _Juego3CicloVidaState createState() => _Juego3CicloVidaState();
}

class _Juego3CicloVidaState extends State<Juego3CicloVida> {
  List<String> _stages = [
    'Semilla',
    'Brote',
    'Planta Joven',
    'Planta Adulta',
    'Flor/Fruto'
  ];
  late List<String> _currentOrder;
  int _timeLeft = 40;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentOrder = List.from(_stages)..shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkOrder() {
    bool correct = true;
    for (int i = 0; i < _stages.length; i++) {
      if (_currentOrder[i] != _stages[i]) {
        correct = false;
        break;
      }
    }
    if (correct) {
      _timer?.cancel();
      widget.onCompleted(100 + _timeLeft);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Orden incorrecto, sigue intentando'),
            backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 40),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ordena el ciclo de vida de la planta',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        Expanded(
          child: ReorderableListView(
            padding: EdgeInsets.symmetric(horizontal: 40),
            children: _currentOrder
                .map((item) => Card(
                      key: ValueKey(item),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.grass, color: Colors.green),
                        title: Text(item,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.drag_handle),
                      ),
                    ))
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
        ElevatedButton(
          onPressed: _checkOrder,
          child: Text('Verificar Orden'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: Colors.white,
            foregroundColor: Colors.green,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

// --- JUEGO 4: Memoria (MEJORADO) ---
class Juego4Memoria extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego4Memoria({required this.onCompleted});

  @override
  _Juego4MemoriaState createState() => _Juego4MemoriaState();
}

class _Juego4MemoriaState extends State<Juego4Memoria> {
  final List<IconData> _icons = [
    Icons.pets,
    Icons.pets,
    Icons.local_florist,
    Icons.local_florist,
    Icons.wb_sunny,
    Icons.wb_sunny,
    Icons.water_drop,
    Icons.water_drop,
    Icons.grass,
    Icons.grass,
    Icons.bug_report,
    Icons.bug_report,
  ];

  late List<bool> _flipped;
  late List<bool> _matched;
  int? _firstFlippedIndex;
  bool _isProcessing = false;
  int _timeLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _icons.shuffle();
    _flipped = List.filled(_icons.length, false);
    _matched = List.filled(_icons.length, false);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onCardTap(int index) {
    if (_isProcessing || _flipped[index] || _matched[index]) return;

    setState(() {
      _flipped[index] = true;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      _isProcessing = true;
      if (_icons[_firstFlippedIndex!] == _icons[index]) {
        _matched[_firstFlippedIndex!] = true;
        _matched[index] = true;
        _firstFlippedIndex = null;
        _isProcessing = false;
        if (_matched.every((element) => element)) {
          _timer?.cancel();
          widget.onCompleted(150 + _timeLeft);
        }
      } else {
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            _flipped[_firstFlippedIndex!] = false;
            _flipped[index] = false;
            _firstFlippedIndex = null;
            _isProcessing = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 60),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _icons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onCardTap(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _flipped[index] || _matched[index]
                        ? Colors.white
                        : Colors.green[700],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4)
                    ],
                  ),
                  child: Center(
                    child: _flipped[index] || _matched[index]
                        ? Icon(_icons[index], size: 40, color: Colors.green)
                        : Icon(Icons.question_mark,
                            color: Colors.white54, size: 40),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- JUEGO 5: Alimentación (MEJORADO) ---
class Juego5Alimentacion extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego5Alimentacion({required this.onCompleted});

  @override
  _Juego5AlimentacionState createState() => _Juego5AlimentacionState();
}

class _Juego5AlimentacionState extends State<Juego5Alimentacion> {
  final List<Map<String, dynamic>> _animals = [
    {'name': 'León', 'type': 'carnivoro', 'icon': Icons.pets},
    {'name': 'Vaca', 'type': 'herbivoro', 'icon': Icons.grass},
    {'name': 'Oso', 'type': 'omnivoro', 'icon': Icons.emoji_nature},
    {'name': 'Tigre', 'type': 'carnivoro', 'icon': Icons.pets},
    {'name': 'Conejo', 'type': 'herbivoro', 'icon': Icons.cruelty_free},
  ];

  late List<Map<String, dynamic>> _currentAnimals;
  int _timeLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentAnimals = List.from(_animals)..shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
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
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 45),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Clasifica según su alimentación',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTarget('Carnívoro', 'carnivoro', Colors.red[200]!),
              _buildTarget('Herbívoro', 'herbivoro', Colors.green[200]!),
              _buildTarget('Omnívoro', 'omnivoro', Colors.orange[200]!),
            ],
          ),
        ),
        Container(
          height: 100,
          child: _currentAnimals.isEmpty
              ? Center(
                  child: Text('¡Completado!',
                      style: TextStyle(color: Colors.white)))
              : Draggable<Map<String, dynamic>>(
                  data: _currentAnimals.first,
                  feedback: Icon(_currentAnimals.first['icon'],
                      size: 50, color: Colors.white),
                  childWhenDragging: Container(),
                  child: Column(
                    children: [
                      Icon(_currentAnimals.first['icon'],
                          size: 50, color: Colors.white),
                      Text(_currentAnimals.first['name'],
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTarget(String label, String type, Color color) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white),
          ),
          child: Center(
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold))),
        );
      },
      onAccept: (data) {
        if (data['type'] == type) {
          setState(() {
            _currentAnimals.removeAt(0);
            if (_currentAnimals.isEmpty) {
              _timer?.cancel();
              widget.onCompleted(100 + _timeLeft);
            }
          });
        } else {
          setState(() {
            _timeLeft = max(0, _timeLeft - 5);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Incorrecto -5s'),
              duration: Duration(milliseconds: 500)));
        }
      },
    );
  }
}

// --- JUEGO 6: Hábitat (MEJORADO) ---
class Juego6Habitat extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego6Habitat({required this.onCompleted});

  @override
  _Juego6HabitatState createState() => _Juego6HabitatState();
}

class _Juego6HabitatState extends State<Juego6Habitat> {
  final List<Map<String, dynamic>> _animals = [
    {'name': 'Pez', 'habitat': 'agua', 'icon': Icons.water},
    {'name': 'Pájaro', 'habitat': 'aire', 'icon': Icons.air},
    {'name': 'Topo', 'habitat': 'tierra', 'icon': Icons.landscape},
    {'name': 'Ballena', 'habitat': 'agua', 'icon': Icons.water},
    {'name': 'Águila', 'habitat': 'aire', 'icon': Icons.air},
  ];

  late List<Map<String, dynamic>> _currentAnimals;
  int _timeLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentAnimals = List.from(_animals)..shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
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
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 45),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Asigna el hábitat correcto',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTarget('Agua', 'agua', Colors.blue[300]!),
              _buildTarget('Tierra', 'tierra', Colors.brown[300]!),
              _buildTarget('Aire', 'aire', Colors.lightBlue[100]!),
            ],
          ),
        ),
        Container(
          height: 100,
          child: _currentAnimals.isEmpty
              ? Center(
                  child: Text('¡Completado!',
                      style: TextStyle(color: Colors.white)))
              : Draggable<Map<String, dynamic>>(
                  data: _currentAnimals.first,
                  feedback: Icon(_currentAnimals.first['icon'],
                      size: 50, color: Colors.white),
                  childWhenDragging: Container(),
                  child: Column(
                    children: [
                      Icon(_currentAnimals.first['icon'],
                          size: 50, color: Colors.white),
                      Text(_currentAnimals.first['name'],
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTarget(String label, String habitat, Color color) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: double.infinity,
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white),
          ),
          child: Center(
              child: Text(label,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        );
      },
      onAccept: (data) {
        if (data['habitat'] == habitat) {
          setState(() {
            _currentAnimals.removeAt(0);
            if (_currentAnimals.isEmpty) {
              _timer?.cancel();
              widget.onCompleted(100 + _timeLeft);
            }
          });
        } else {
          setState(() {
            _timeLeft = max(0, _timeLeft - 5);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Incorrecto -5s'),
              duration: Duration(milliseconds: 500)));
        }
      },
    );
  }
}

// --- JUEGO 7: Quiz Final (MEJORADO) ---
class Juego7Quiz extends StatefulWidget {
  final Function(int) onCompleted;
  const Juego7Quiz({required this.onCompleted});

  @override
  _Juego7QuizState createState() => _Juego7QuizState();
}

class _Juego7QuizState extends State<Juego7Quiz> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué necesitan las plantas para vivir?',
      'answers': ['Solo agua', 'Agua, sol y aire', 'Solo sol'],
      'correct': 1
    },
    {
      'question': '¿Cuál es un ser vivo?',
      'answers': ['Una piedra', 'Un gato', 'Una silla'],
      'correct': 1
    },
    {
      'question': '¿Qué animal vive en el agua?',
      'answers': ['Perro', 'Pez', 'Gato'],
      'correct': 1
    },
  ];

  int _currentQuestion = 0;
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          widget.onCompleted(50);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _answerQuestion(int index) {
    if (index == _questions[_currentQuestion]['correct']) {
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _timeLeft += 10; // Bonus de tiempo
        });
      } else {
        _timer?.cancel();
        widget.onCompleted(200 + _timeLeft);
      }
    } else {
      setState(() {
        _timeLeft = max(0, _timeLeft - 10); // Penalización fuerte
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Incorrecto -10s'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimer(timeLeft: _timeLeft, totalTime: 60),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _questions[_currentQuestion]['question'],
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                ...List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _answerQuestion(index),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          _questions[_currentQuestion]['answers'][index],
                          style: TextStyle(fontSize: 18),
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
}
