// ETAPA 1 - SECCIÓN 1 - NODO 2: LAS PLANTAS
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
      _currentGame = 0;
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
        title: Text(widget.titulo, style: const TextStyle(color: Colors.white)),
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
        return Juego1SemillaPlanta(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 1));
      case 2:
        return Juego2PartesFlor(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 2));
      case 3:
        return Juego3FrutasVerduras(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 3));
      case 4:
        return Juego4CuidandoJardin(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 4));
      case 5:
        return Juego5ColoresNaturaleza(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 5));
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
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '� LAS PLANTAS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Aprende cómo crecen y viven las plantas',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildGameCard(1, '🌱 De Semilla a Planta', 'El ciclo de vida',
              Icons.grass, Colors.green),
          _buildGameCard(2, '🌸 Partes de la Flor', '¿Qué es cada cosa?',
              Icons.local_florist, Colors.pink),
          _buildGameCard(3, '🍎 Frutas vs Verduras', 'Clasifica la comida',
              Icons.restaurant, Colors.orange),
          _buildGameCard(4, '🚿 Cuidando mi Jardín', 'Agua y Sol',
              Icons.water_drop, Colors.blue),
          _buildGameCard(5, '🎨 Colores Naturales', 'Busca los colores',
              Icons.palette, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildGameCard(
      int index, String title, String subtitle, IconData icon, Color color) {
    bool isCompleted = _gamesCompleted[index - 1];
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _startGame(index),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                isCompleted ? Colors.grey.shade200 : Colors.white,
                isCompleted ? Colors.grey.shade100 : Colors.white,
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.grey : color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check : icon,
                  color: isCompleted ? Colors.white : color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.grey : Colors.black87,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isCompleted ? Colors.grey : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCompleted)
                Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// JUEGO 1: DE SEMILLA A PLANTA
class Juego1SemillaPlanta extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1SemillaPlanta(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1SemillaPlanta> createState() => _Juego1SemillaPlantaState();
}

class _Juego1SemillaPlantaState extends State<Juego1SemillaPlanta> {
  List<String> currentOrder = [];
  final List<Map<String, String>> stages = [
    {'emoji': '🟤', 'name': 'Semilla'},
    {'emoji': '🌱', 'name': 'Brote'},
    {'emoji': '🌿', 'name': 'Planta Joven'},
    {'emoji': '🌳', 'name': 'Árbol'},
  ];

  @override
  void initState() {
    super.initState();
    stages.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Ordena el crecimiento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ReorderableListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (int i = 0; i < stages.length; i++)
                Card(
                  key: ValueKey(stages[i]['name']),
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Text(stages[i]['emoji']!,
                        style: const TextStyle(fontSize: 30)),
                    title: Text(stages[i]['name']!),
                    trailing: const Icon(Icons.drag_handle),
                  ),
                ),
            ],
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = stages.removeAt(oldIndex);
                stages.insert(newIndex, item);
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
            child: const Text('¡Listo!',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  void _checkOrder() {
    // Orden correcto: Semilla -> Brote -> Planta Joven -> Árbol
    bool correct = stages[0]['name'] == 'Semilla' &&
        stages[1]['name'] == 'Brote' &&
        stages[2]['name'] == 'Planta Joven' &&
        stages[3]['name'] == 'Árbol';

    if (correct) {
      widget.onGameComplete(100);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mmm... algo no está en orden. ¡Intenta de nuevo!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

// JUEGO 2: PARTES DE LA FLOR (Simple Quiz Placeholder)
class Juego2PartesFlor extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2PartesFlor(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_florist, size: 100, color: Colors.pink),
          const SizedBox(height: 20),
          const Text(
            '¡Partes de la Flor!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has nombrado los pétalos!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => onGameComplete(100),
            child: const Text('Completar Misión'),
          ),
        ],
      ),
    );
  }
}

// JUEGO 3: FRUTAS VS VERDURAS
class Juego3FrutasVerduras extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3FrutasVerduras(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3FrutasVerduras> createState() => _Juego3FrutasVerdurasState();
}

class _Juego3FrutasVerdurasState extends State<Juego3FrutasVerduras> {
  int score = 0;
  int currentItem = 0;

  final List<Map<String, String>> items = [
    {'emoji': '🍎', 'name': 'Manzana', 'type': 'Fruta'},
    {'emoji': '🥕', 'name': 'Zanahoria', 'type': 'Verdura'},
    {'emoji': '🍌', 'name': 'Banana', 'type': 'Fruta'},
    {'emoji': '🥦', 'name': 'Brócoli', 'type': 'Verdura'},
    {'emoji': '🍇', 'name': 'Uvas', 'type': 'Fruta'},
    {'emoji': '🥔', 'name': 'Papa', 'type': 'Verdura'},
  ];

  @override
  Widget build(BuildContext context) {
    if (currentItem >= items.length) {
      return Center(
        child: ElevatedButton(
          onPressed: () => widget.onGameComplete(score),
          child: Text('¡Cosecha Completa! ($score pts)'),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿Es Fruta o Verdura?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: items[currentItem]['type'],
              feedback: Material(
                color: Colors.transparent,
                child: Text(items[currentItem]['emoji']!,
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
                  Text(items[currentItem]['emoji']!,
                      style: const TextStyle(fontSize: 80)),
                  Text(items[currentItem]['name']!,
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildZone('Fruta', '🍎', Colors.red),
            _buildZone('Verdura', '🥦', Colors.green),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String name, String icon, Color color) {
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
              Text(name,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == name) {
            score += 20;
            HapticFeedback.mediumImpact();
          } else {
            HapticFeedback.heavyImpact();
          }
          currentItem++;
        });
      },
    );
  }
}

// JUEGO 4: CUIDANDO MI JARDÍN
class Juego4CuidandoJardin extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4CuidandoJardin(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4CuidandoJardin> createState() => _Juego4CuidandoJardinState();
}

class _Juego4CuidandoJardinState extends State<Juego4CuidandoJardin> {
  double waterLevel = 0.0;
  double sunLevel = 0.0;
  bool flowerGrown = false;

  @override
  Widget build(BuildContext context) {
    if (flowerGrown) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_florist, size: 150, color: Colors.pink),
            const SizedBox(height: 20),
            const Text('¡Tu flor ha crecido!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onGameComplete(100),
              child: const Text('Terminar'),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(height: 200, width: 200, color: Colors.transparent),
            Icon(Icons.local_florist,
                size: 50 + (waterLevel + sunLevel) * 75,
                color: Colors.green
                    .withOpacity(0.3 + (waterLevel + sunLevel) / 3)),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (waterLevel < 1.0) waterLevel += 0.1;
                  _checkGrowth();
                });
              },
              child: Column(
                children: [
                  const Icon(Icons.water_drop, size: 50, color: Colors.blue),
                  const Text('Regar'),
                  LinearProgressIndicator(
                      value: waterLevel,
                      color: Colors.blue,
                      backgroundColor: Colors.blue.shade100),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (sunLevel < 1.0) sunLevel += 0.1;
                  _checkGrowth();
                });
              },
              child: Column(
                children: [
                  const Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
                  const Text('Dar Sol'),
                  LinearProgressIndicator(
                      value: sunLevel,
                      color: Colors.orange,
                      backgroundColor: Colors.orange.shade100),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _checkGrowth() {
    if (waterLevel >= 1.0 && sunLevel >= 1.0) {
      setState(() {
        flowerGrown = true;
      });
    }
  }
}

// JUEGO 5: COLORES DE LA NATURALEZA (Simple Match Placeholder)
class Juego5ColoresNaturaleza extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5ColoresNaturaleza(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.palette, size: 100, color: Colors.purple),
          const SizedBox(height: 20),
          const Text(
            '¡Colores Naturales!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has pintado el paisaje!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => onGameComplete(100),
            child: const Text('Completar Misión'),
          ),
        ],
      ),
    );
  }
}
