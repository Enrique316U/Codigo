import 'package:flutter/material.dart';

class Plant {
  final String name;
  final String image;
  final double waterPercentage;
  final double temperature;
  final double humidity;
  final Color backgroundColor;
  final double lightIntensity;

  Plant({
    required this.name,
    required this.image,
    required this.waterPercentage,
    required this.temperature,
    required this.humidity,
    required this.backgroundColor,
    required this.lightIntensity,
  });
}
