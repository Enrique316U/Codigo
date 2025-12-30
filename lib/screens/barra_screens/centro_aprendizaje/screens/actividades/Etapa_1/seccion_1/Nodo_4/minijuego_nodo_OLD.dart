// ETAPA 1 - SECCIÓN 1 - NODO 4: LOS ANIMALES
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
        return Juego1SonidosSelva(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 1));
      case 2:
        return Juego2DondeVivo(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 2));
      case 3:
        return Juego3MamasBebes(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 3));
      case 4:
        return Juego4AlimentandoAmigos(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 4));
      case 5:
        return Juego5HuellasMisteriosas(
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
            '🐾 LOS ANIMALES',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Descubre los secretos de los animales',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildGameCard(1, '🦁 Sonidos de la Selva', '¿Quién hace ese ruido?',
              Icons.volume_up, Colors.orange),
          _buildGameCard(2, '🏠 ¿Dónde Vivo?', 'Cada uno en su casa',
              Icons.home, Colors.blue),
          _buildGameCard(3, '👶 Mamás y Bebés', 'Une a la familia',
              Icons.family_restroom, Colors.pink),
          _buildGameCard(4, '🥕 Alimentando Amigos', '¿Qué comen?',
              Icons.restaurant, Colors.green),
          _buildGameCard(5, '👣 Huellas Misteriosas', 'Sigue el rastro',
              Icons.pets, Colors.brown),
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

// JUEGO 1: SONIDOS DE LA SELVA (Simple Quiz Placeholder)
class Juego1SonidosSelva extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1SonidosSelva(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.volume_up, size: 100, color: Colors.orange),
          const SizedBox(height: 20),
          const Text(
            '¡Sonidos de la Selva!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has adivinado el rugido del león!',
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

// JUEGO 2: ¿DÓNDE VIVO?
class Juego2DondeVivo extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2DondeVivo(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2DondeVivo> createState() => _Juego2DondeVivoState();
}

class _Juego2DondeVivoState extends State<Juego2DondeVivo> {
  int score = 0;
  int currentItem = 0;

  final List<Map<String, String>> animals = [
    {'emoji': '🐟', 'name': 'Pez', 'habitat': 'Agua'},
    {'emoji': '🦅', 'name': 'Águila', 'habitat': 'Aire'},
    {'emoji': '🦁', 'name': 'León', 'habitat': 'Tierra'},
    {'emoji': '🐬', 'name': 'Delfín', 'habitat': 'Agua'},
  ];

  @override
  Widget build(BuildContext context) {
    if (currentItem >= animals.length) {
      return Center(
        child: ElevatedButton(
          onPressed: () => widget.onGameComplete(score),
          child: Text('¡Hábitats Completos! ($score pts)'),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('¿Dónde vive este animal?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Center(
            child: Draggable<String>(
              data: animals[currentItem]['habitat'],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildHabitat('Agua', Icons.water, Colors.blue),
            _buildHabitat('Tierra', Icons.landscape, Colors.brown),
            _buildHabitat('Aire', Icons.cloud, Colors.lightBlue),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHabitat(String name, IconData icon, Color color) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 100,
          width: 100,
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
              Icon(icon, size: 40, color: color),
              Text(name,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (data == name) {
            score += 25;
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

// JUEGO 3: MAMÁS Y BEBÉS (Simple Match Placeholder)
class Juego3MamasBebes extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3MamasBebes(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.family_restroom, size: 100, color: Colors.pink),
          const SizedBox(height: 20),
          const Text(
            '¡Mamás y Bebés!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has unido al pollito con la gallina!',
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

// JUEGO 4: ALIMENTANDO AMIGOS (Simple Drag Placeholder)
class Juego4AlimentandoAmigos extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4AlimentandoAmigos(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant, size: 100, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            '¡Hora de Comer!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has dado zanahorias al conejo!',
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

// JUEGO 5: HUELLAS MISTERIOSAS (Simple Quiz Placeholder)
class Juego5HuellasMisteriosas extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5HuellasMisteriosas(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, size: 100, color: Colors.brown),
          const SizedBox(height: 20),
          const Text(
            '¡Huellas Misteriosas!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has seguido el rastro del oso!',
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
