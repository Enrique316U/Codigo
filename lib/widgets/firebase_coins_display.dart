import 'package:flutter/material.dart';
import 'package:green_cloud/services/firebase_game_data_service.dart';

/// Widget que muestra las monedas del usuario en tiempo real desde Firebase
class FirebaseCoinsDisplay extends StatelessWidget {
  final FirebaseGameDataService _gameDataService = FirebaseGameDataService();
  final double iconSize;
  final TextStyle? textStyle;
  final Color? iconColor;

  FirebaseCoinsDisplay({
    Key? key,
    this.iconSize = 18,
    this.textStyle,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _gameDataService.listenToCoins(),
      builder: (context, snapshot) {
        // Mostrar valor por defecto mientras carga
        final coins = snapshot.data ?? 0;

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
                Icons.monetization_on,
                color: iconColor ?? Colors.amber[700],
                size: iconSize,
              ),
              const SizedBox(width: 4),
              Text(
                '$coins',
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
