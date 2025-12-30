import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:green_cloud/models/achievements_model.dart';

class MedalDetailScreen extends StatelessWidget {
  final String medalId;

  const MedalDetailScreen({Key? key, required this.medalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsModel>(builder: (context, model, child) {
      // Obtener la medalla seleccionada
      final medal = model.allMedals.firstWhere((m) => m.id == medalId);
      final isUnlocked = model.isMedalUnlocked(medalId);

      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(medal.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.pink[300],
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Parte superior con la imagen de la medalla
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.pink[50],
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isUnlocked
                            ? (medal.imagePath != null
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: SvgPicture.asset(
                                      medal.imagePath!,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Icon(medal.iconData ?? Icons.emoji_events,
                                    size: 80, color: Colors.black))
                            : Icon(Icons.lock_outline,
                                size: 60, color: Colors.grey[600]),
                      ),
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
                      color: Colors.pink,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),

                    const SizedBox(height: 20),

                    // Descripción
                    Text(
                      medal.description,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(),

                    // Texto adicional
                    Text(
                      isUnlocked
                          ? 'Para conseguir esta campaña debes haber completado las actividades requeridas.'
                          : 'Para desbloquear esta medalla, debes cumplir los requisitos.',
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
                        color: Colors.pink[100],
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
