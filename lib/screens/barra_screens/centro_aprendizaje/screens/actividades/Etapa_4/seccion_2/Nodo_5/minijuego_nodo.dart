// ETAPA 4 - SECCIÓN 2 - NODO 5: LA TIERRA Y LA VIDA (SUELOS Y FOTOSÍNTESIS)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo5Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo5Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo5Screen> createState() => _MinijuegoNodo5ScreenState();
}

class _MinijuegoNodo5ScreenState extends State<MinijuegoNodo5Screen> {
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
        return Juego1CapasSuelo(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2Fotosintesis(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3Erosion(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4PartesPlanta(
            color: widget.color, onGameComplete: _onGameComplete);
      case 4:
        return Juego5QuizNaturaleza(
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
              Icon(Icons.eco, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Guardián de la Tierra!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Excelente! Conoces los secretos de la naturaleza.',
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

// JUEGO 1: CAPAS DEL SUELO
class Juego1CapasSuelo extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1CapasSuelo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1CapasSuelo> createState() => _Juego1CapasSueloState();
}

class _Juego1CapasSueloState extends State<Juego1CapasSuelo> {
  int _score = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final Map<String, bool> placedLayers = {
    'Humus': false,
    'Arcilla': false,
    'Roca Madre': false,
  };

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
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    int layersPlaced = placedLayers.values.where((v) => v).length;
    _score = (layersPlaced * 33).clamp(0, 100);
    widget.onGameComplete(_score);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool allPlaced = !placedLayers.containsValue(false);

    if (allPlaced) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.5, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child:
                      const Icon(Icons.layers, size: 100, color: Colors.brown),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('¡Suelo Formado!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Tiempo restante: $_timeLeft s',
                style: const TextStyle(fontSize: 18, color: Colors.blue)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                widget.onGameComplete(100);
              },
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
              const Text('Ordena las capas',
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
          child: Row(
            children: [
              // Zona de construcción
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLayerTarget('Humus', Colors.black87),
                    _buildLayerTarget('Arcilla', Colors.brown),
                    _buildLayerTarget('Roca Madre', Colors.grey),
                  ],
                ),
              ),
              // Piezas
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: placedLayers.entries
                      .where((e) => !e.value)
                      .map((e) => Draggable<String>(
                            data: e.key,
                            feedback: Material(
                              child: Container(
                                width: 150,
                                height: 80,
                                color: _getColor(e.key),
                                alignment: Alignment.center,
                                child: Text(e.key,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                            child: Container(
                              width: 150,
                              height: 80,
                              color: _getColor(e.key),
                              alignment: Alignment.center,
                              child: Text(e.key,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColor(String layer) {
    switch (layer) {
      case 'Humus':
        return Colors.black87;
      case 'Arcilla':
        return Colors.brown;
      case 'Roca Madre':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  Widget _buildLayerTarget(String layerName, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 200,
          height: 100,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: placedLayers[layerName]! ? color : Colors.grey[200],
          ),
          alignment: Alignment.center,
          child: Text(
            placedLayers[layerName]! ? layerName : 'Arrastra aquí',
            style: TextStyle(
              color: placedLayers[layerName]! ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      onWillAccept: (data) => data == layerName,
      onAccept: (data) {
        setState(() {
          placedLayers[layerName] = true;
          HapticFeedback.mediumImpact();
        });
      },
    );
  }
}

// JUEGO 2: FOTOSÍNTESIS
class Juego2Fotosintesis extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2Fotosintesis(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2Fotosintesis> createState() => _Juego2FotosintesisState();
}

class _Juego2FotosintesisState extends State<Juego2Fotosintesis> {
  int _score = 0;
  int _timeLeft = 30;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<String> inputs = ['Sol', 'Agua', 'CO2'];
  final List<String> outputs = ['Oxígeno', 'Glucosa'];
  final List<String> collected = [];

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
    if (collected.length >= 5) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Fotosíntesis Completa!',
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
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Elementos: ${collected.length}/5',
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
        ),
        const Text('Alimenta a la planta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.local_florist, size: 200, color: Colors.green),
              // Inputs (Arriba)
              Positioned(
                top: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: inputs
                      .where((i) => !collected.contains(i))
                      .map((i) => _buildDraggable(i))
                      .toList(),
                ),
              ),
              // Outputs (Abajo - aparecen después)
              if (collected.length >= 3)
                Positioned(
                  bottom: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: outputs
                        .where((o) => !collected.contains(o))
                        .map((o) => _buildDraggable(o))
                        .toList(),
                  ),
                ),
              // Target
              DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: candidateData.isNotEmpty
                              ? Colors.green
                              : Colors.transparent,
                          width: 3),
                    ),
                  );
                },
                onAccept: (data) {
                  setState(() {
                    collected.add(data);
                    _streak++;
                    _score += 18 + (_streak >= 3 ? 7 : 0);
                    HapticFeedback.mediumImpact();
                  });
                  if (collected.length >= 5) {
                    _endGame();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDraggable(String item) {
    return Draggable<String>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Chip(
          label: Text(item),
          backgroundColor: Colors.orangeAccent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chip(
          label: Text(item),
          backgroundColor: Colors.orangeAccent,
        ),
      ),
    );
  }
}

// JUEGO 3: EROSIÓN
class Juego3Erosion extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3Erosion(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3Erosion> createState() => _Juego3ErosionState();
}

class _Juego3ErosionState extends State<Juego3Erosion> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Viento fuerte', 'causesErosion': true, 'icon': '💨'},
    {'name': 'Plantar árboles', 'causesErosion': false, 'icon': '🌳'},
    {'name': 'Lluvia ácida', 'causesErosion': true, 'icon': '🌧️'},
    {'name': 'Deforestación', 'causesErosion': true, 'icon': '🪓'},
    {'name': 'Terrazas cultivo', 'causesErosion': false, 'icon': '🌾'},
    {'name': 'Muros contención', 'causesErosion': false, 'icon': '🧱'},
    {'name': 'Pastoreo excesivo', 'causesErosion': true, 'icon': '🐄'},
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
            const Text('¡Análisis Completo!',
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
              Text('Situación ${_currentItem + 1}/${_items.length}',
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
        const Text('¿Causa erosión o protege el suelo?',
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
                    data: _items[_currentItem]['causesErosion'],
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
                          colors: [
                            Colors.green.shade100,
                            Colors.brown.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
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
            _buildZone('Protege', '🛡️', false, Colors.green),
            _buildZone('Erosiona', '⚠️', true, Colors.orange),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildZone(
      String label, String icon, bool causesErosion, Color color) {
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
        bool correct = data == causesErosion;
        setState(() {
          if (correct) {
            _streak++;
            _score += 14 + (_streak >= 3 ? 6 : 0);
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
      },
    );
  }
}

// JUEGO 4: PARTES DE LA PLANTA
class Juego4PartesPlanta extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4PartesPlanta(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4PartesPlanta> createState() => _Juego4PartesPlantaState();
}

class _Juego4PartesPlantaState extends State<Juego4PartesPlanta> {
  int _score = 0;
  int _timeLeft = 20;
  Timer? _timer;
  final Random _random = Random();

  final Map<String, bool> placedParts = {
    'Raíz': false,
    'Tallo': false,
    'Hoja': false,
    'Flor': false,
  };

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
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    int partsPlaced = placedParts.values.where((v) => v).length;
    _score = (partsPlaced * 25).clamp(0, 100);
    widget.onGameComplete(_score);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool allPlaced = !placedParts.containsValue(false);

    if (allPlaced) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Planta Completa!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Tiempo restante: $_timeLeft s',
                style: const TextStyle(fontSize: 18, color: Colors.blue)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                widget.onGameComplete(100);
              },
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
              const Text('Identifica las partes',
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
          child: Row(
            children: [
              // Planta
              Expanded(
                flex: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.local_florist,
                        size: 300, color: Colors.green),
                    // Targets posicionados (aproximados)
                    Positioned(
                        top: 20, child: _buildTarget('Flor')), // Flor arriba
                    Positioned(
                        top: 100,
                        right: 20,
                        child: _buildTarget('Hoja')), // Hoja lado
                    Positioned(
                        top: 150, child: _buildTarget('Tallo')), // Tallo centro
                    Positioned(
                        bottom: 20, child: _buildTarget('Raíz')), // Raíz abajo
                  ],
                ),
              ),
              // Etiquetas
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: placedParts.entries
                      .where((e) => !e.value)
                      .map((e) => Draggable<String>(
                            data: e.key,
                            feedback: Material(
                              child: Chip(
                                  label: Text(e.key),
                                  backgroundColor: Colors.greenAccent),
                            ),
                            child: Chip(
                                label: Text(e.key),
                                backgroundColor: Colors.greenAccent),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTarget(String part) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: placedParts[part]!
                ? Colors.green
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green),
          ),
          alignment: Alignment.center,
          child: Text(
            placedParts[part]! ? part : '?',
            style: TextStyle(
                color: placedParts[part]! ? Colors.white : Colors.black),
          ),
        );
      },
      onWillAccept: (data) => data == part,
      onAccept: (data) {
        setState(() {
          placedParts[part] = true;
          HapticFeedback.mediumImpact();
        });
      },
    );
  }
}

// JUEGO 5: QUIZ NATURALEZA
class Juego5QuizNaturaleza extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5QuizNaturaleza(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego5QuizNaturaleza> createState() => _Juego5QuizNaturalezaState();
}

class _Juego5QuizNaturalezaState extends State<Juego5QuizNaturaleza> {
  int _score = 0;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _timeLeft = 10;
  Timer? _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué gas absorben las plantas?',
      'answers': ['Oxígeno', 'Dióxido de Carbono', 'Nitrógeno', 'Helio'],
      'correctIndex': 1,
      'explanation':
          'Las plantas absorben CO2 del aire durante la fotosíntesis y liberan oxígeno.'
    },
    {
      'question': '¿Cuál es la capa más fértil del suelo?',
      'answers': ['Roca madre', 'Arcilla', 'Humus', 'Arena'],
      'correctIndex': 2,
      'explanation':
          'El humus es la capa superior rica en materia orgánica donde crecen mejor las plantas.'
    },
    {
      'question': '¿Qué necesitan las plantas para vivir?',
      'answers': ['Solo agua', 'Solo sol', 'Agua, sol y aire', 'Pizza'],
      'correctIndex': 2,
      'explanation':
          'Las plantas necesitan agua, luz solar y aire (CO2) para realizar la fotosíntesis y vivir.'
    },
    {
      'question': '¿Qué produce la fotosíntesis?',
      'answers': ['Solo oxígeno', 'Oxígeno y glucosa', 'Solo agua', 'CO2'],
      'correctIndex': 1,
      'explanation':
          'La fotosíntesis produce oxígeno (que liberan) y glucosa (que usan como alimento).'
    },
    {
      'question': '¿Qué previene la erosión del suelo?',
      'answers': [
        'Talar árboles',
        'Plantar vegetación',
        'Dejar tierra desnuda',
        'Quemar pasto'
      ],
      'correctIndex': 1,
      'explanation':
          'Las raíces de las plantas sujetan el suelo y evitan que sea arrastrado por viento o lluvia.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 10;
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
                colors: [Colors.green.shade100, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green, width: 2),
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
                      color: bgColor ?? Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAnswer == index
                            ? Colors.green
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
