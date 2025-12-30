// ETAPA 1 - SECCIÓN 2 - NODO 7: EL AGUA Y SUS ESTADOS
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:green_cloud/services/progreso_service.dart';

class MinijuegoNodo7Screen extends StatefulWidget {
  final String titulo;
  final Color color;
  final int etapa;
  final int seccion;
  final int actividad;

  const MinijuegoNodo7Screen({
    super.key,
    required this.titulo,
    required this.color,
    required this.etapa,
    required this.seccion,
    required this.actividad,
  });

  @override
  State<MinijuegoNodo7Screen> createState() => _MinijuegoNodo7ScreenState();
}

class _MinijuegoNodo7ScreenState extends State<MinijuegoNodo7Screen> {
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
          content: Text('¡Felicidades! Has aprendido sobre el agua 🏆'),
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
        return Juego1SolidoLiquido(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 1));
      case 2:
        return Juego2HieloAguaVapor(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 2));
      case 3:
        return Juego3CicloAgua(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 3));
      case 4:
        return Juego4UsosAgua(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 4));
      case 5:
        return Juego5CuidandoAgua(
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
            '💧 EL AGUA Y SUS ESTADOS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Descubre cómo cambia el agua',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildGameCard(1, '🧊 ¿Sólido o Líquido?', 'Hielo y agua',
              Icons.ac_unit, Colors.cyan),
          _buildGameCard(2, '🌡️ Hielo, Agua y Vapor', 'Los tres estados',
              Icons.thermostat, Colors.red),
          _buildGameCard(3, '🔄 El Ciclo del Agua', 'Lluvia y nubes',
              Icons.loop, Colors.blue),
          _buildGameCard(4, '🚿 Usos del Agua', 'Para qué sirve', Icons.shower,
              Colors.green),
          _buildGameCard(5, '🚰 Cuidando el Agua', 'No la desperdicies',
              Icons.water_drop, Colors.teal),
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

// JUEGO 1: SÓLIDO O LÍQUIDO
class Juego1SolidoLiquido extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1SolidoLiquido(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ac_unit, size: 100, color: Colors.cyan),
          const SizedBox(height: 20),
          const Text(
            '¡Sólido o Líquido!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has tocado un cubo de hielo!',
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

// JUEGO 2: HIELO, AGUA Y VAPOR
class Juego2HieloAguaVapor extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2HieloAguaVapor(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.thermostat, size: 100, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            '¡Hielo, Agua y Vapor!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has visto hervir el agua!',
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

// JUEGO 3: CICLO DEL AGUA
class Juego3CicloAgua extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3CicloAgua(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.loop, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            '¡El Ciclo del Agua!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has visto llover!',
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

// JUEGO 4: USOS DEL AGUA
class Juego4UsosAgua extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4UsosAgua(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shower, size: 100, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            '¡Usos del Agua!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que te has lavado las manos!',
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

// JUEGO 5: CUIDANDO EL AGUA
class Juego5CuidandoAgua extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5CuidandoAgua(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.water_drop, size: 100, color: Colors.teal),
          const SizedBox(height: 20),
          const Text(
            '¡Cuidando el Agua!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has cerrado el caño!',
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
