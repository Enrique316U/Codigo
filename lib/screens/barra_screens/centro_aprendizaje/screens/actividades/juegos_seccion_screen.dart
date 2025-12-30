import 'package:flutter/material.dart';

class JuegosSeccionScreen extends StatelessWidget {
  final String seccionTitle;
  final int actividadIndex;
  final String actividadNombre;

  const JuegosSeccionScreen({
    Key? key,
    required this.seccionTitle,
    required this.actividadIndex,
    required this.actividadNombre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulamos diferentes tipos de actividades según el índice
    final List<Widget> actividadContent = [
      _buildIntroduccionActividad(),
      _buildQuizActividad(),
      _buildInteractivaActividad(),
      _buildQuizActividad(),
      _buildRetoActividad(),
      _buildMiniJuegoActividad(),
      _buildEvaluacionActividad(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(actividadNombre),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: actividadContent[actividadIndex % actividadContent.length],
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.green.withOpacity(0.1),
      child: Column(
        children: [
          Text(
            seccionTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Actividad ${actividadIndex + 1} de 7',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (actividadIndex + 1) / 7,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroduccionActividad() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¡Bienvenido a esta Actividad!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoBox(
            'En esta actividad aprenderás conceptos fundamentales sobre el tema de esta sección. Esto te ayudará a comprender mejor las siguientes actividades.',
          ),
          const SizedBox(height: 15),
          const Text(
            'Contenido:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildContentItem('1. Introducción al tema'),
          _buildContentItem('2. Conceptos clave'),
          _buildContentItem('3. Ejemplos prácticos'),
          _buildContentItem('4. Resumen'),
          const SizedBox(height: 20),
          Image.asset(
            'assets/placeholder_image.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.green[100],
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.green,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Duración estimada: 15 minutos',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizActividad() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quiz de Conocimiento',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Responde las siguientes preguntas para poner a prueba tus conocimientos:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          _buildQuizQuestion(
            'Pregunta 1: ¿Cuál de las siguientes acciones es más efectiva para reducir la huella de carbono?',
            [
              'Usar bolsas de plástico',
              'Utilizar transporte público',
              'Dejar luces encendidas',
              'Consumir alimentos importados'
            ],
            1,
          ),
          const Divider(height: 30),
          _buildQuizQuestion(
            'Pregunta 2: ¿Qué recurso natural es considerado como renovable?',
            ['Petróleo', 'Gas natural', 'Energía solar', 'Carbón'],
            2,
          ),
          const Divider(height: 30),
          _buildQuizQuestion(
            'Pregunta 3: ¿Cuál es el principal gas de efecto invernadero?',
            ['Oxígeno', 'Hidrógeno', 'Nitrógeno', 'Dióxido de carbono'],
            3,
          ),
        ],
      ),
    );
  }

  Widget _buildInteractivaActividad() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividad Interactiva',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoBox(
            'En esta actividad aprenderás mediante la práctica. Sigue las instrucciones y completa cada paso.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instrucciones:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildStep(
                    '1. Observa el diagrama de clasificación de residuos'),
                _buildStep(
                    '2. Arrastra cada residuo a su contenedor correspondiente'),
                _buildStep(
                    '3. Verifica tus respuestas para obtener retroalimentación'),
                _buildStep(
                    '4. Completa la actividad con al menos un 80% de aciertos'),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                    ),
                    child: const Center(
                      child: Text(
                        'Área de arrastrar y soltar\n(Simulación)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetoActividad() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reto Práctico',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoBox(
            'Este reto te invita a aplicar lo aprendido en tu vida cotidiana. Complétalo en los próximos días y registra tus resultados.',
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.green.withOpacity(0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Tu Reto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Reducir tu consumo de plásticos de un solo uso durante 7 días',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '• Evita bolsas plásticas utilizando bolsas reutilizables\n'
                    '• Usa botellas de agua reutilizables\n'
                    '• Evita cubiertos plásticos desechables\n'
                    '• Rechaza pajitas/popotes de plástico\n'
                    '• Compra alimentos con menos empaques',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Registra cada día y anota cuántos plásticos evitaste usar',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Área para registro diario\n(Simulación)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniJuegoActividad() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.videogame_asset,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 20),
          const Text(
            'Mini-Juego',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green),
            ),
            child: const Column(
              children: [
                Text(
                  'Aprende mientras juegas con esta actividad interactiva.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Duración: 5-10 minutos',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'INICIAR JUEGO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluacionActividad() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evaluación Final',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.amber),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Esta evaluación permitirá medir tu comprensión de los temas estudiados en esta sección.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEvaluacionItem(
                    'Pregunta 1 de 5',
                    'Explica con tus propias palabras qué es el desarrollo sostenible y por qué es importante.',
                    TextInputType.multiline,
                  ),
                  const SizedBox(height: 25),
                  _buildEvaluacionItem(
                    'Pregunta 2 de 5',
                    '¿Cuáles son los tres pilares fundamentales del desarrollo sostenible?',
                    TextInputType.text,
                  ),
                  const SizedBox(height: 25),
                  _buildEvaluacionItem(
                    'Pregunta 3 de 5',
                    'Menciona tres acciones que puedas implementar en tu vida diaria para contribuir al desarrollo sostenible.',
                    TextInputType.multiline,
                  ),
                  const SizedBox(height: 25),
                  _buildEvaluacionItem(
                    'Pregunta 4 de 5',
                    '¿Qué objetivos de desarrollo sostenible (ODS) te parecen más relevantes y por qué?',
                    TextInputType.multiline,
                  ),
                  const SizedBox(height: 25),
                  _buildEvaluacionItem(
                    'Pregunta 5 de 5',
                    'Reflexiona sobre los hábitos en tu comunidad que podrían mejorarse para ser más sostenibles.',
                    TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluacionItem(
      String numero, String pregunta, TextInputType inputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          numero,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          pregunta,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: inputType,
          maxLines: inputType == TextInputType.multiline ? 4 : 1,
          decoration: InputDecoration(
            hintText: 'Escribe tu respuesta aquí...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: const Text('Volver'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simulación de completar la actividad
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Actividad completada con éxito!'),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizQuestion(
      String question, List<String> options, int correctIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ...List.generate(
          options.length,
          (index) => _buildQuizOption(options[index], index, correctIndex),
        ),
      ],
    );
  }

  Widget _buildQuizOption(String text, int index, int correctIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: RadioListTile<int>(
          title: Text(text),
          value: index,
          groupValue:
              null, // En una app real, esto sería una variable de estado
          onChanged: (value) {
            // En una app real, aquí se manejaría la selección
          },
          activeColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[300]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.green[700]),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
