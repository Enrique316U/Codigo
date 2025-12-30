// ETAPA 1 - SECCIÓN 2 - NODO 6: LOS SENTIDOS
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
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
          content: Text('¡Felicidades! Has descubierto tus 5 sentidos 🏆'),
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
        return Juego1OjosLince(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 1));
      case 2:
        return Juego2OidosAtentos(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 2));
      case 3:
        return Juego3NarizCuriosa(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 3));
      case 4:
        return Juego4LenguaSabrosa(
            color: widget.color,
            onGameComplete: (score) => _completeGame(score, 4));
      case 5:
        return Juego5ManosSensibles(
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
            '👃 LOS 5 SENTIDOS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Descubre el mundo con tus sentidos',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildGameCard(1, '👀 Ojos de Lince', 'Sentido de la Vista',
              Icons.visibility, Colors.blue),
          _buildGameCard(2, '👂 Oídos Atentos', 'Sentido del Oído',
              Icons.hearing, Colors.orange),
          _buildGameCard(3, '👃 Nariz Curiosa', 'Sentido del Olfato',
              Icons.face, Colors.green),
          _buildGameCard(4, '👅 Lengua Sabrosa', 'Sentido del Gusto',
              Icons.restaurant_menu, Colors.red),
          _buildGameCard(5, '✋ Manos Sensibles', 'Sentido del Tacto',
              Icons.pan_tool, Colors.brown),
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

// JUEGO 1: OJOS DE LINCE
class Juego1OjosLince extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1OjosLince(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.visibility, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            '¡Ojos de Lince!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has encontrado el objeto escondido!',
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

// JUEGO 2: OÍDOS ATENTOS
class Juego2OidosAtentos extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2OidosAtentos(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hearing, size: 100, color: Colors.orange),
          const SizedBox(height: 20),
          const Text(
            '¡Oídos Atentos!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has adivinado el sonido!',
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

// JUEGO 3: NARIZ CURIOSA
class Juego3NarizCuriosa extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3NarizCuriosa(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.face, size: 100, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            '¡Nariz Curiosa!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has olido una flor!',
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

// JUEGO 4: LENGUA SABROSA
class Juego4LenguaSabrosa extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4LenguaSabrosa(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu, size: 100, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            '¡Lengua Sabrosa!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has probado un limón ácido!',
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

// JUEGO 5: MANOS SENSIBLES
class Juego5ManosSensibles extends StatelessWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego5ManosSensibles(
      {super.key, required this.color, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pan_tool, size: 100, color: Colors.brown),
          const SizedBox(height: 20),
          const Text(
            '¡Manos Sensibles!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Este minijuego está en construcción.\n¡Imagina que has tocado algo suave!',
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
