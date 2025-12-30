import 'package:flutter/material.dart';
import 'package:green_cloud/services/firebase_game_data_service.dart';

/// Widget que muestra los corazones del usuario en tiempo real desde Firebase
class FirebaseHeartsDisplay extends StatelessWidget {
  final FirebaseGameDataService _gameDataService = FirebaseGameDataService();
  final double iconSize;
  final TextStyle? textStyle;
  final Color? iconColor;

  FirebaseHeartsDisplay({
    Key? key,
    this.iconSize = 18,
    this.textStyle,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _gameDataService.listenToHearts(),
      builder: (context, snapshot) {
        // Mostrar valor por defecto mientras carga
        final hearts = snapshot.data ?? 3;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: iconColor ?? Colors.red[600],
                size: iconSize,
              ),
              const SizedBox(width: 4),
              Text(
                '$hearts',
                style: textStyle ??
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
