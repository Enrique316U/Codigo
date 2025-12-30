// ETAPA 5 - SECCIÓN 1 - NODO 3: MEZCLAS Y SOLUCIONES - VERSIÓN DINÁMICA
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
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
        return Juego1ClasificarMezclas(
            color: widget.color, onGameComplete: _onGameComplete);
      case 1:
        return Juego2SepararMezclas(
            color: widget.color, onGameComplete: _onGameComplete);
      case 2:
        return Juego3SolutoSolvente(
            color: widget.color, onGameComplete: _onGameComplete);
      case 3:
        return Juego4QuizMezclas(
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
              Icon(Icons.science, size: 100, color: widget.color),
              const SizedBox(height: 20),
              const Text(
                '¡Químico Experto!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntuación Final: $_totalScore',
                style: TextStyle(fontSize: 20, color: widget.color),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Excelente! Sabes diferenciar y separar mezclas como un profesional.',
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

// JUEGO 1: CLASIFICAR MEZCLAS (HOMOGÉNEAS VS HETEROGÉNEAS)
class Juego1ClasificarMezclas extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego1ClasificarMezclas(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego1ClasificarMezclas> createState() =>
      _Juego1ClasificarMezclasState();
}

class _Juego1ClasificarMezclasState extends State<Juego1ClasificarMezclas> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 20;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {'name': 'Agua con Sal', 'type': 'Homogénea', 'icon': '🧂💧'},
    {'name': 'Ensalada', 'type': 'Heterogénea', 'icon': '🥗'},
    {'name': 'Aire', 'type': 'Homogénea', 'icon': '💨'},
    {'name': 'Agua y Aceite', 'type': 'Heterogénea', 'icon': '🛢️💧'},
    {'name': 'Pizza', 'type': 'Heterogénea', 'icon': '🍕'},
    {'name': 'Té', 'type': 'Homogénea', 'icon': '🍵'},
    {'name': 'Leche', 'type': 'Homogénea', 'icon': '🥛'},
    {'name': 'Cereal con Leche', 'type': 'Heterogénea', 'icon': '🥣'},
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

  void _handleAnswer(String type) {
    bool correct = type == _items[_currentItem]['type'];
    setState(() {
      if (correct) {
        _streak++;
        _score += 12 + (_streak >= 3 ? 5 : 0);
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
    return Column(
      children: [
        // Header con timer y progreso
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.3),
                widget.color.withOpacity(0.1)
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Clasificar Mezclas',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('${_currentItem + 1}/${_items.length}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer,
                          color: _timeLeft < 10 ? Colors.red : widget.color),
                      const SizedBox(width: 5),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _timeLeft.toDouble()),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) => Text(
                          '${value.toInt()}s',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _timeLeft < 10 ? Colors.red : widget.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      Text('$_score pts',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Streak indicator
        if (_streak >= 3)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.orange.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.deepOrange),
                Text(' ¡Racha x$_streak! +5 pts bonus',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        const SizedBox(height: 20),
        // Elemento actual con animación
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, scale, child) => Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_items[_currentItem]['icon'],
                        style: const TextStyle(fontSize: 100)),
                    const SizedBox(height: 20),
                    Text(_items[_currentItem]['name'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),
                    const Text('¿Qué tipo de mezcla es?',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Botones de respuesta
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildButton(
                  'Homogénea', 'No se distinguen sus componentes', Colors.blue),
              const SizedBox(height: 15),
              _buildButton('Heterogénea', 'Se distinguen sus componentes',
                  Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String type, String description, Color color) {
    return InkWell(
      onTap: () => _handleAnswer(type),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Text(
              type,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// JUEGO 2: SEPARAR MEZCLAS
class Juego2SepararMezclas extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego2SepararMezclas(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego2SepararMezclas> createState() => _Juego2SepararMezclasState();
}

class _Juego2SepararMezclasState extends State<Juego2SepararMezclas> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 25;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();

  final List<Map<String, dynamic>> _items = [
    {
      'mixture': 'Arena y Hierro',
      'method': 'Imantación',
      'icon': '🧲',
      'desc': 'Usar un imán'
    },
    {
      'mixture': 'Agua y Pasta',
      'method': 'Filtración',
      'icon': '🕸️',
      'desc': 'Usar un colador'
    },
    {
      'mixture': 'Agua y Sal',
      'method': 'Evaporación',
      'icon': '☀️',
      'desc': 'Calentar el agua'
    },
    {
      'mixture': 'Agua y Aceite',
      'method': 'Decantación',
      'icon': '🧪',
      'desc': 'Dejar reposar y separar'
    },
    {
      'mixture': 'Arena y Gravilla',
      'method': 'Filtración',
      'icon': '🕸️',
      'desc': 'Usar un tamiz'
    },
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
    return Column(
      children: [
        // Header con estadísticas
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.3),
                widget.color.withOpacity(0.1)
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Métodos de Separación',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${_currentItem + 1}/${_items.length}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer,
                          color: _timeLeft < 10 ? Colors.red : widget.color),
                      Text(' ${_timeLeft}s',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  _timeLeft < 10 ? Colors.red : widget.color)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' $_score pts',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_streak >= 3)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.purple.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.purple),
                Text(' ¡Racha perfecta x$_streak!',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        const SizedBox(height: 20),
        // Pregunta con animación
        TweenAnimationBuilder<double>(
          key: ValueKey(_currentItem),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Text('¿Cómo separarías?',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text(_items[_currentItem]['mixture'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Grid de opciones
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(20),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.1,
            children: [
              _buildOption('Imantación', '🧲'),
              _buildOption('Filtración', '🕸️'),
              _buildOption('Evaporación', '☀️'),
              _buildOption('Decantación', '🧪'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(String method, String icon) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) => Transform.scale(
        scale: scale,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () => _checkAnswer(method),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.2),
                    widget.color.withOpacity(0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                border:
                    Border.all(color: widget.color.withOpacity(0.5), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 10),
                  Text(method,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.color),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkAnswer(String method) {
    bool correct = method == _items[_currentItem]['method'];
    setState(() {
      if (correct) {
        _streak++;
        _score += 20 + (_streak >= 3 ? 8 : 0);
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('¡Correcto! ${_items[_currentItem]['desc']}'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        _streak = 0;
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 10),
                Text('Incorrecto. Usa: ${_items[_currentItem]['method']}'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      _currentItem++;
      if (_currentItem >= _items.length) {
        _endGame();
      }
    });
  }
}

// JUEGO 3: SOLUTO Y SOLVENTE
class Juego3SolutoSolvente extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego3SolutoSolvente(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego3SolutoSolvente> createState() => _Juego3SolutoSolventeState();
}

class _Juego3SolutoSolventeState extends State<Juego3SolutoSolvente> {
  int _score = 0;
  int _currentItem = 0;
  int _timeLeft = 20;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();
  bool _showExplanation = true;

  final List<Map<String, dynamic>> _items = [
    {
      'solution': 'Agua con Azúcar',
      'soluto': 'Azúcar',
      'solvente': 'Agua',
      'icon': '🍬💧'
    },
    {
      'solution': 'Agua Salada',
      'soluto': 'Sal',
      'solvente': 'Agua',
      'icon': '🧂💧'
    },
    {'solution': 'Café', 'soluto': 'Café', 'solvente': 'Agua', 'icon': '☕'},
    {
      'solution': 'Limonada',
      'soluto': 'Azúcar/Limón',
      'solvente': 'Agua',
      'icon': '🍋💧'
    },
    {
      'solution': 'Aire',
      'soluto': 'Oxígeno',
      'solvente': 'Nitrógeno',
      'icon': '💨'
    },
  ];

  @override
  void initState() {
    super.initState();
    _items.shuffle(_random);
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

  void _handleAnswer(String type) {
    bool correct = (type == 'Soluto' &&
            _items[_currentItem]['soluto'] != 'Agua' &&
            _items[_currentItem]['soluto'] != 'Nitrógeno') ||
        (type == 'Solvente' &&
            (_items[_currentItem]['solvente'] == 'Agua' ||
                _items[_currentItem]['solvente'] == 'Nitrógeno'));

    setState(() {
      if (correct) {
        _streak++;
        _score += 18 + (_streak >= 3 ? 7 : 0);
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
    if (_showExplanation) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.science, size: 80, color: widget.color),
              const SizedBox(height: 20),
              const Text('Conceptos Clave:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildConceptCard('Soluto', 'Lo que se disuelve (menor cantidad)',
                  'Ej: Sal, Azúcar, Café', Colors.orange),
              const SizedBox(height: 15),
              _buildConceptCard('Solvente', 'Lo que disuelve (mayor cantidad)',
                  'Ej: Agua (el más común)', Colors.blue),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showExplanation = false;
                    _startTimer();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('¡Comenzar el Desafío!',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.3),
                widget.color.withOpacity(0.1)
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Soluto y Solvente',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${_currentItem + 1}/${_items.length}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer,
                          color: _timeLeft < 8 ? Colors.red : widget.color),
                      Text(' ${_timeLeft}s',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  _timeLeft < 8 ? Colors.red : widget.color)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' $_score pts',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_streak >= 3)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.cyan.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.science, color: Colors.cyan),
                Text(' ¡Químico experto! Racha x$_streak',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        const SizedBox(height: 30),
        // Elemento actual
        Expanded(
          child: Center(
            child: TweenAnimationBuilder<double>(
              key: ValueKey(_currentItem),
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 350),
              builder: (context, scale, child) => Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_items[_currentItem]['icon'],
                        style: const TextStyle(fontSize: 100)),
                    const SizedBox(height: 20),
                    Text(_items[_currentItem]['solution'],
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text('Soluto: ${_items[_currentItem]['soluto']}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.orange)),
                          const SizedBox(height: 8),
                          Text('Solvente: ${_items[_currentItem]['solvente']}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.blue)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('¿Cuál está en mayor cantidad?',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Botones de respuesta
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildAnswerButton(
                  'Solvente', '(Disuelve, mayor cantidad)', Colors.blue),
              const SizedBox(height: 15),
              _buildAnswerButton(
                  'Soluto', '(Se disuelve, menor cantidad)', Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConceptCard(
      String title, String desc, String example, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(desc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(example,
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String type, String description, Color color) {
    return InkWell(
      onTap: () => _handleAnswer(type),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Text(
              type,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// JUEGO 4: QUIZ MEZCLAS
class Juego4QuizMezclas extends StatefulWidget {
  final Color color;
  final Function(int) onGameComplete;

  const Juego4QuizMezclas(
      {super.key, required this.color, required this.onGameComplete});

  @override
  State<Juego4QuizMezclas> createState() => _Juego4QuizMezclasState();
}

class _Juego4QuizMezclasState extends State<Juego4QuizMezclas> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  int _timeLeft = 30;
  int _streak = 0;
  Timer? _timer;
  final Random _random = Random();
  String? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Qué es una solución?',
      'answers': [
        'Una mezcla heterogénea',
        'Una mezcla homogénea',
        'Un elemento puro',
        'Una roca'
      ],
      'correctIndex': 1,
      'icon': '🧪'
    },
    {
      'question': 'En agua salada, la sal es el...',
      'answers': ['Solvente', 'Soluto', 'Líquido', 'Gas'],
      'correctIndex': 1,
      'icon': '🧂'
    },
    {
      'question': '¿Cuál NO es una mezcla?',
      'answers': ['Aire', 'Agua de mar', 'Oro puro', 'Sopa'],
      'correctIndex': 2,
      'icon': '💎'
    },
    {
      'question': '¿Cómo se separa agua y aceite?',
      'answers': ['Imantación', 'Decantación', 'Filtración', 'Evaporación'],
      'correctIndex': 1,
      'icon': '🛢️'
    },
    {
      'question': '¿Qué método usa un imán?',
      'answers': ['Filtración', 'Imantación', 'Evaporación', 'Decantación'],
      'correctIndex': 1,
      'icon': '🧲'
    },
  ];

  @override
  void initState() {
    super.initState();
    _questions.shuffle(_random);
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
    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        // Header con estadísticas
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.3),
                widget.color.withOpacity(0.1)
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quiz de Mezclas',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                      'Pregunta ${_currentQuestionIndex + 1}/${_questions.length}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer,
                          color: _timeLeft < 10 ? Colors.red : widget.color),
                      Text(' ${_timeLeft}s',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  _timeLeft < 10 ? Colors.red : widget.color)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' $_score pts',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_streak >= 3)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.green.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.green),
                Text(' ¡Imparable! Racha x$_streak',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        const SizedBox(height: 30),
        // Pregunta con animación
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  key: ValueKey(_currentQuestionIndex),
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Column(
                        children: [
                          Text(question['icon'],
                              style: const TextStyle(fontSize: 70)),
                          const SizedBox(height: 20),
                          Text(
                            question['question'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Opciones de respuesta
                ...List.generate(question['answers'].length, (index) {
                  Color buttonColor = widget.color;
                  if (_answered &&
                      _selectedAnswer == question['answers'][index]) {
                    buttonColor = index == question['correctIndex']
                        ? Colors.green
                        : Colors.red;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(50 * (1 - value), 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _answered ? null : () => _checkAnswer(index),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(18),
                                backgroundColor: buttonColor.withOpacity(0.9),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    buttonColor.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                question['answers'][index],
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
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
    bool correct = index == _questions[_currentQuestionIndex]['correctIndex'];
    setState(() {
      _answered = true;
      _selectedAnswer = _questions[_currentQuestionIndex]['answers'][index];
    });

    if (correct) {
      _streak++;
      _score += 20 + (_streak >= 3 ? 10 : 0);
      HapticFeedback.mediumImpact();
    } else {
      _streak = 0;
      HapticFeedback.heavyImpact();
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
          _selectedAnswer = null;
        });

        if (_currentQuestionIndex >= _questions.length) {
          _endGame();
        }
      }
    });
  }
}
