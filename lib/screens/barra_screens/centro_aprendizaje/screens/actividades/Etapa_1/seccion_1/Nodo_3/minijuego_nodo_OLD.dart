// ETAPA 1 - SECCIÓN 1 - NODO 3: OBJETOS Y MATERIALES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo3Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo3Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo3Screen> createState() => _MinijuegoNodo3ScreenState();
}

class _MinijuegoNodo3ScreenState extends State<MinijuegoNodo3Screen> {
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
          content: Text('¡Felicidades! Eres un experto en materiales 🏆'),
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
        return Juego1MaderaPlasticoMetal(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 1));
      case 2:
        return Juego2DuroBlando(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 2));
      case 3:
        return Juego3FlotaHunde(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 3));
      case 4:
        return Juego4TransparenteOpaco(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 4));
      case 5:
        return Juego5Constructor(
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
            '🧱 OBJETOS Y MATERIALES',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Descubre de qué están hechas las cosas',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildGameCard(1, '🪵 Madera, Plástico o Metal',
              'Clasifica materiales', Icons.category, Colors.brown),
          _buildGameCard(2, '🪨 ¿Duro o Blando?', 'Toca y siente',
              Icons.touch_app, Colors.grey),
          _buildGameCard(3, '⛵ ¿Flota o se Hunde?', 'Experimento en agua',
              Icons.water, Colors.blue),
          _buildGameCard(4, '🪟 ¿Transparente u Opaco?', 'Mira a través',
              Icons.visibility, Colors.cyan),
          _buildGameCard(5, '🏗️ Pequeño Constructor',
              'Usa el material correcto', Icons.construction, Colors.orange),
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

// JUEGO 1: MADERA, PLÁSTICO O METAL
class Juego1MaderaPlasticoMetal extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1MaderaPlasticoMetal(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.category, size: 100, color: Colors.brown),
          const SizedBox(height: 20),
          const Text(
            '¡Madera, Plástico o Metal!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has separado los juguetes de plástico!',
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

// JUEGO 2: DURO O BLANDO
class Juego2DuroBlando extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2DuroBlando(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.touch_app, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            '¡Duro o Blando!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has tocado una almohada suave!',
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

// JUEGO 3: FLOTA O SE HUNDE
class Juego3FlotaHunde extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3FlotaHunde(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.water, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            '¡Flota o se Hunde!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has puesto un barco en el agua!',
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

// JUEGO 4: TRANSPARENTE U OPACO
class Juego4TransparenteOpaco extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4TransparenteOpaco(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.visibility, size: 100, color: Colors.cyan),
          const SizedBox(height: 20),
          const Text(
            '¡Transparente u Opaco!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has mirado a través de un vidrio!',
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

// JUEGO 5: PEQUEÑO CONSTRUCTOR
class Juego5Constructor extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5Constructor(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 100, color: Colors.orange),
          const SizedBox(height: 20),
          const Text(
            '¡Pequeño Constructor!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has construido una casa de madera!',
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
