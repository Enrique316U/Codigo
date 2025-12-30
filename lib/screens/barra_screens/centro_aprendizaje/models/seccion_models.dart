import 'package:flutter/material.dart';

/// Clase para almacenar la información de cada nivel.
class LevelInfo {
  final Color color; // Color del encabezado
  final String levelName; // Nombre o título del nivel
  final String content; // Contenido del nivel

  LevelInfo({
    required this.color,
    required this.levelName,
    required this.content,
  });
}

class SectionInfo {
  final Color color;
  final String title;
  final String description;
  final List<String> activities;

  SectionInfo({
    required this.color,
    required this.title,
    required this.description,
    required this.activities,
  });
}

class SectionData {
  final String titulo;
  final Color color;
  final String descripcion;
  final List<String> actividades;
  final int completadas;

  SectionData({
    required this.titulo,
    required this.color,
    required this.descripcion,
    required this.actividades,
    required this.completadas,
  });
}
