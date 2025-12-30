// ETAPA 5 - SECCIÓN 1 - NODO 4: FUERZA, MOVIMIENTO Y FRICCIÓN
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo4Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo4Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo4Screen> createState() => _MinijuegoNodo4ScreenState();
}

class _MinijuegoNodo4ScreenState extends State<MinijuegoNodo4Screen> {
  int _currentGame = 0;
  int _totalScore = 0;
  final int _maxGames = 4;

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
        return Juego1EmpujarJalar(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Friccion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3MaquinasSimples(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4QuizFuerza(
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
              Icon(Icons.fitness_center, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Maestro del Movimiento!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Increíble! Entiendes cómo funcionan las fuerzas y el movimiento.',
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

// JUEGO 1: EMPUJAR O JALAR
class Juego1EmpujarJalar extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1EmpujarJalar(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1EmpujarJalar> createState() => _Juego1EmpujarJalarState();
}

class _Juego1EmpujarJalarState extends State<Juego1EmpujarJalar> {
  int score = 0;
  int currentItem = 0;

  final List<Map<String, dynamic>> items = [
    {'name': 'Abrir cajón', 'type': 'Jalar', 'icon': '🗄️'},
    {'name': 'Patear balón', 'type': 'Empujar', 'icon': '⚽'},
    {'name': 'Remolcar auto', 'type': 'Jalar', 'icon': '🚗'},
    {'name': 'Tocar timbre', 'type': 'Empujar', 'icon': '🔔'},
    {'name': 'Subir cierre', 'type': 'Jalar', 'icon': '🤐'},
    {'name': 'Escribir', 'type': 'Empujar', 'icon': '✏️'},
  ];

  @override
  Widget build(BuildContext context) {
    if (currentItem >= items.length) {
      return Center(
        child: ElevatedButton(
          onPressed: () => widget.onGameComplete(score),
          child: Text('¡Fuerzas Identificadas! ($score pts)'),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿Empujar o Jalar?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: items[currentItem]['type'],
              feedback: Material(
                color: Colors.transparent,
                child: Text(items[currentItem]['icon'],
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
                  Text(items[currentItem]['icon'],
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
            _buildZone('Empujar', Colors.blue),
            _buildZone('Jalar', Colors.orange),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(String type, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: candidateData.isNotEmpty ? color : Colors.transparent,
                width: 3),
          ),
          child: Center(
            child: Text(type,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 24)),
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == type) {
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

// JUEGO 2: FRICCIÓN
class Juego2Friccion extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Friccion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Friccion> createState() => _Juego2FriccionState();
}

class _Juego2FriccionState extends State<Juego2Friccion> {
  double sliderValue = 0.5;
  bool carMoving = false;
  double carPosition = 0;
  String surface = 'Pasto';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Experimenta con la Fricción',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hielo (Poca)'),
              Expanded(
                child: Slider(
                  value: sliderValue,
                  onChanged: carMoving
                      ? null
                      : (v) {
                          setState(() {
                            sliderValue = v;
                            if (v < 0.33)
                              surface = 'Hielo';
                            else if (v < 0.66)
                              surface = 'Madera';
                            else
                              surface = 'Alfombra';
                          });
                        },
                ),
              ),
              const Text('Alfombra (Mucha)'),
            ],
          ),
        ),
        Text('Superficie: $surface',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Expanded(
          child: Stack(
            children: [
              // Pista
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  color: _getSurfaceColor(),
                ),
              ),
              // Coche
              AnimatedPositioned(
                duration: Duration(milliseconds: _getDuration()),
                curve: Curves.easeOut,
                left: carPosition,
                bottom: 100,
                child: const Icon(Icons.directions_car,
                    size: 80, color: Colors.red),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: carMoving
                ? null
                : () {
                    setState(() {
                      carMoving = true;
                      // Distancia basada en fricción (inversa)
                      // Menos fricción (0.0) -> Más distancia (300)
                      // Más fricción (1.0) -> Menos distancia (50)
                      carPosition = 50 + (1.0 - sliderValue) * 250;
                    });
                    Future.delayed(Duration(milliseconds: _getDuration() + 500),
                        () {
                      widget.onGameComplete(100); // Completar tras un intento
                    });
                  },
            child: const Text('¡Lanzar Coche!'),
          ),
        ),
      ],
    );
  }

  Color _getSurfaceColor() {
    if (sliderValue < 0.33) return Colors.lightBlueAccent.withOpacity(0.5);
    if (sliderValue < 0.66) return Colors.brown.withOpacity(0.5);
    return Colors.green.withOpacity(0.5);
  }

  int _getDuration() {
    // Más fricción -> Se detiene más rápido (duración menor de animación)
    return 1000 + ((1.0 - sliderValue) * 2000).toInt();
  }
}

// JUEGO 3: MÁQUINAS SIMPLES
class Juego3MaquinasSimples extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3MaquinasSimples(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3MaquinasSimples> createState() => _Juego3MaquinasSimplesState();
}

class _Juego3MaquinasSimplesState extends State<Juego3MaquinasSimples> {
  int score = 0;
  int currentItem = 0;

  final List<Map<String, dynamic>> items = [
    {'name': 'Rampa', 'type': 'Plano Inclinado', 'icon': '📐'},
    {'name': 'Sube y baja', 'type': 'Palanca', 'icon': '⚖️'},
    {'name': 'Pozo', 'type': 'Polea', 'icon': '🏗️'},
    {'name': 'Hacha', 'type': 'Cuña', 'icon': '🪓'},
  ];

  @override
  Widget build(BuildContext context) {
    if (currentItem >= items.length) {
      return Center(
        child: ElevatedButton(
          onPressed: () => widget.onGameComplete(score),
          child: Text('¡Máquinas Identificadas! ($score pts)'),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿Qué máquina simple es?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(items[currentItem]['icon'],
                    style: const TextStyle(fontSize: 100)),
                Text(items[currentItem]['name'],
                    style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _buildButton('Plano Inclinado'),
            _buildButton('Palanca'),
            _buildButton('Polea'),
            _buildButton('Cuña'),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildButton(String type) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(type),
      child: Text(type),
    );
  }

  void _checkAnswer(String type) {
    if (type == items[currentItem]['type']) {
      score += 25;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentItem++;
    });
  }
}

// JUEGO 4: QUIZ FUERZA
class Juego4QuizFuerza extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4QuizFuerza(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4QuizFuerza> createState() => _Juego4QuizFuerzaState();
}

class _Juego4QuizFuerzaState extends State<Juego4QuizFuerza> {
  int score = 0;
  int currentQuestionIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'La fuerza que detiene los objetos se llama...',
      'answers': ['Gravedad', 'Fricción', 'Magnetismo', 'Electricidad'],
      'correctIndex': 1
    },
    {
      'question': 'Para mover algo pesado es mejor usar...',
      'answers': ['Una rampa', 'Pegamento', 'Agua', 'Nada'],
      'correctIndex': 0
    },
    {
      'question': 'La fuerza que nos mantiene en el suelo es...',
      'answers': ['Fricción', 'Gravedad', 'Viento', 'Magia'],
      'correctIndex': 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (currentQuestionIndex >= questions.length) {
      return Center(
        child: ElevatedButton(
          onPressed: () => widget.onGameComplete(score),
          child: Text('¡Quiz Completado! ($score pts)'),
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
      score += 30;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    setState(() {
      currentQuestionIndex++;
    });
  }
}
