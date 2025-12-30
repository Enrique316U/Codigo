import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/achievements_model.dart';

class CreatureDetailScreen extends StatelessWidget {
  final String creatureId;

  const CreatureDetailScreen({Key? key, required this.creatureId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsModel>(builder: (context, model, child) {
      // Obtener la criatura seleccionada
      final creature = model.allCreatures.firstWhere((c) => c.id == creatureId);
      final isUnlocked = model.isCreatureUnlocked(creatureId);

      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(creature.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.orange[300],
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Parte superior con la imagen de la criatura
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.orange[50],
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? Colors.transparent
                            : Colors.orange[100],
                        shape:
                            isUnlocked ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius:
                            isUnlocked ? BorderRadius.circular(20) : null,
                      ),
                      child: isUnlocked
                          ? creature.imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    creature.imagePath!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.pets,
                                          size: 80, color: Colors.orange[800]);
                                    },
                                  ),
                                )
                              : Icon(Icons.pets,
                                  size: 80, color: Colors.orange[800])
                          : Icon(Icons.lock_outline,
                              size: 80, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            // Parte inferior con descripción y detalles
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Barra de progreso
                    LinearProgressIndicator(
                      value: isUnlocked ? 1.0 : 0.0,
                      backgroundColor: Colors.grey[300],
                      color: Colors.orange,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),

                    const SizedBox(height: 20),

                    // Descripción
                    Text(
                      creature.description,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    // Estrellas de calificación (solo para criaturas desbloqueadas)
                    if (isUnlocked)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: 24, color: Colors.amber),
                          Icon(Icons.star, size: 24, color: Colors.amber),
                          Icon(Icons.star, size: 24, color: Colors.grey[400]),
                          Icon(Icons.star, size: 24, color: Colors.grey[400]),
                          Icon(Icons.star, size: 24, color: Colors.grey[400]),
                        ],
                      ),

                    const Spacer(),

                    // Texto adicional
                    Text(
                      isUnlocked
                          ? 'Esta criatura habita en ecosistemas cercanos a las plantas que cuidas.'
                          : 'Para atraer esta criatura a tu jardín, necesitas cumplir ciertos requisitos.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Botón de corazón
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red[400],
                          size: 28,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
