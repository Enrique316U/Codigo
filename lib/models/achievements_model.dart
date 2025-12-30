import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_cloud/services/progreso_service.dart';

class AchievementsModel extends ChangeNotifier {
  // Listas para guardar los logros conseguidos
  final List<String> _unlockedMedals = [];
  final List<String> _unlockedPlants = [];
  final List<String> _unlockedCreatures = [];

  // Datos de todas las medallas disponibles
  final List<Achievement> allMedals = [
    // Logros de Etapas (Coherentes con el progreso del juego)
    Achievement(
      id: 'etapa_1_complete',
      name: 'Etapa 1 Completada',
      description:
          'Has completado todos los nodos de Fundamentos del Mundo Natural',
      iconData: Icons.star,
      category: 'medals',
      imagePath: 'lib/assets/images/etapas/etapa1.svg',
    ),
    Achievement(
      id: 'etapa_2_complete',
      name: 'Etapa 2 Completada',
      description:
          'Has completado todos los nodos de Interacciones en la Naturaleza',
      iconData: Icons.star,
      category: 'medals',
      imagePath: 'lib/assets/images/etapas/etapa2.svg',
    ),
    Achievement(
      id: 'etapa_3_complete',
      name: 'Etapa 3 Completada',
      description: 'Has completado todos los nodos de Ecosistema Acuático',
      iconData: Icons.star,
      category: 'medals',
      imagePath: 'lib/assets/images/etapas/etapa3.svg',
    ),
    Achievement(
      id: 'etapa_4_complete',
      name: 'Etapa 4 Completada',
      description: 'Has completado todos los nodos de Región Andina',
      iconData: Icons.star,
      category: 'medals',
      imagePath: 'lib/assets/images/etapas/etapa4.svg',
    ),
    Achievement(
      id: 'etapa_5_complete',
      name: 'Etapa 5 Completada',
      description: 'Has completado todos los nodos de Desiertos y Humedales',
      iconData: Icons.star,
      category: 'medals',
      imagePath: 'lib/assets/images/etapas/etapa5.svg',
    ),
    Achievement(
      id: 'etapa_6_complete',
      name: 'Etapa 6 Completada',
      description: 'Has completado todos los nodos de Ecosistema Global',
      iconData: Icons.star,
      category: 'medals',
      imagePath: 'lib/assets/images/etapas/etapa6.svg',
    ),
  ];

  // Datos de todas las plantas disponibles
  final List<Achievement> allPlants = [
    Achievement(
      id: 'first_plant',
      name: 'Primera Planta',
      description: 'Suculenta: Planta fácil de cuidar',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'medicinal_plant',
      name: 'Planta Medicinal',
      description: 'Aloe Vera: Planta con propiedades curativas',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'fruit_plant',
      name: 'Planta Frutal',
      description: 'Fresa: Cultiva tu primera fruta',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'aromatic_plant',
      name: 'Planta Aromática',
      description: 'Lavanda: Planta con aroma relajante',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'ornamental_plant',
      name: 'Planta Ornamental',
      description: 'Rosa: La flor más popular del mundo',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'aquatic_plant',
      name: 'Planta Acuática',
      description: 'Nenúfar: Planta que vive en el agua',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'bonsai_plant',
      name: 'Bonsái',
      description: 'Bonsái: El arte de la miniatura',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'cactus_plant',
      name: 'Cactus',
      description: 'Cactus: Adaptado a ambientes secos',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'shadow_plant',
      name: 'Planta de Sombra',
      description: 'Helecho: Crece bien en lugares con poca luz',
      iconData: Icons.eco,
      category: 'plants',
    ),
    Achievement(
      id: 'climbing_plant',
      name: 'Planta Trepadora',
      description: 'Hiedra: Crece verticalmente sobre superficies',
      iconData: Icons.eco,
      category: 'plants',
    ),
  ];

  // Datos de todas las criaturas disponibles
  final List<Achievement> allCreatures = [
    Achievement(
      id: 'hummingbird',
      name: 'Colibrí',
      description: 'Ave pequeña que se alimenta de néctar',
      iconData: Icons.pets,
      category: 'creatures',
      imagePath: 'assets/criaturas/colibri.png',
    ),
    Achievement(
      id: 'frog',
      name: 'Rana',
      description: 'Anfibio que vive cerca del agua',
      iconData: Icons.pets,
      category: 'creatures',
      imagePath: 'assets/criaturas/rana.png',
    ),
    Achievement(
      id: 'butterfly',
      name: 'Mariposa',
      description: 'Insecto con coloridas alas',
      iconData: Icons.pets,
      category: 'creatures',
    ),
    Achievement(
      id: 'bee',
      name: 'Abeja',
      description: 'Insecto polinizador esencial',
      iconData: Icons.pets,
      category: 'creatures',
    ),
    Achievement(
      id: 'beetle',
      name: 'Escarabajo',
      description: 'Insecto con caparazón duro',
      iconData: Icons.pets,
      category: 'creatures',
    ),
    Achievement(
      id: 'lizard',
      name: 'Lagartija',
      description: 'Reptil de pequeño tamaño',
      iconData: Icons.pets,
      category: 'creatures',
    ),
    Achievement(
      id: 'snail',
      name: 'Caracol',
      description: 'Molusco de movimiento lento',
      iconData: Icons.pets,
      category: 'creatures',
    ),
    Achievement(
      id: 'squirrel',
      name: 'Ardilla',
      description: 'Roedor que vive en los árboles',
      iconData: Icons.pets,
      category: 'creatures',
    ),
    Achievement(
      id: 'owl',
      name: 'Búho',
      description: 'Ave nocturna silenciosa',
      iconData: Icons.pets,
      category: 'creatures',
    ),
    Achievement(
      id: 'fox',
      name: 'Zorro',
      description: 'Mamífero astuto de la familia de los cánidos',
      iconData: Icons.pets,
      category: 'creatures',
    ),
  ];

  AchievementsModel() {
    // Inicializar con algunos logros desbloqueados para demostración
    _unlockedMedals.addAll(['first_level', 'five_plants', 'one_creature']);
    _unlockedPlants.addAll([
      'first_plant',
      'medicinal_plant',
      'fruit_plant',
      'aromatic_plant',
      'ornamental_plant'
    ]);
    _unlockedCreatures.addAll(['hummingbird', 'frog']);

    loadData();
  }

  // Getters para obtener los logros desbloqueados
  List<String> get unlockedMedals => _unlockedMedals;
  List<String> get unlockedPlants => _unlockedPlants;
  List<String> get unlockedCreatures => _unlockedCreatures;

  // Métodos para verificar si un logro está desbloqueado
  bool isMedalUnlocked(String id) {
    return _unlockedMedals.contains(id);
  }

  bool isPlantUnlocked(String id) {
    return _unlockedPlants.contains(id);
  }

  bool isCreatureUnlocked(String id) {
    return _unlockedCreatures.contains(id);
  }

  // Método inteligente para desbloquear cualquier tipo de logro
  void unlockAnyAchievement(String id) {
    // Verificar si es medalla
    if (allMedals.any((m) => m.id == id)) {
      unlockAchievement(id, 'medals');
      return;
    }

    // Verificar si es planta
    if (allPlants.any((p) => p.id == id)) {
      unlockAchievement(id, 'plants');
      return;
    }

    // Verificar si es criatura
    if (allCreatures.any((c) => c.id == id)) {
      unlockAchievement(id, 'creatures');
      return;
    }

    // Si no se encuentra, asumir que es medalla por defecto (comportamiento legacy)
    unlockAchievement(id, 'medals');
  }

  // Método para desbloquear un logro
  void unlockAchievement(String id, String category) {
    switch (category) {
      case 'medals':
        if (!_unlockedMedals.contains(id)) {
          _unlockedMedals.add(id);
          notifyListeners();
          saveData();
        }
        break;
      case 'plants':
        if (!_unlockedPlants.contains(id)) {
          _unlockedPlants.add(id);
          notifyListeners();
          saveData();
        }
        break;
      case 'creatures':
        if (!_unlockedCreatures.contains(id)) {
          _unlockedCreatures.add(id);
          notifyListeners();
          saveData();
        }
        break;
    }
  }

  // Métodos para obtener información de progreso
  String getMedalsProgress() {
    return '${_unlockedMedals.length}/${allMedals.length}';
  }

  String getPlantsProgress() {
    return '${_unlockedPlants.length}/${allPlants.length}';
  }

  String getCreaturesProgress() {
    return '${_unlockedCreatures.length}/${allCreatures.length}';
  }

  double getMedalsProgressValue() {
    return _unlockedMedals.length / allMedals.length;
  }

  double getPlantsProgressValue() {
    return _unlockedPlants.length / allPlants.length;
  }

  double getCreaturesProgressValue() {
    return _unlockedCreatures.length / allCreatures.length;
  }

  // Guardar datos en SharedPreferences
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('unlockedMedals', _unlockedMedals);
    await prefs.setStringList('unlockedPlants', _unlockedPlants);
    await prefs.setStringList('unlockedCreatures', _unlockedCreatures);
  }

  // Cargar datos de SharedPreferences
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final medals = prefs.getStringList('unlockedMedals');
    final plants = prefs.getStringList('unlockedPlants');
    final creatures = prefs.getStringList('unlockedCreatures');

    if (medals != null) {
      _unlockedMedals.clear();
      // Solo cargar medallas que existen en la lista actual (filtrar legacy)
      for (String id in medals) {
        if (allMedals.any((m) => m.id == id)) {
          _unlockedMedals.add(id);
        }
      }
    }

    if (plants != null) {
      _unlockedPlants.clear();
      _unlockedPlants.addAll(plants);
    }

    if (creatures != null) {
      _unlockedCreatures.clear();
      _unlockedCreatures.addAll(creatures);
    }

    // Verificar logros de etapas
    await checkAndUnlockStageAchievements();

    notifyListeners();
  }

  // Métodos para cargar desde Firebase
  void loadFromFirebase({
    Map<String, dynamic>? medals,
    Map<String, dynamic>? plants,
    Map<String, dynamic>? creatures,
  }) {
    print('📥 Cargando logros desde Firebase...');

    if (medals != null) {
      _unlockedMedals.clear();
      // Solo cargar medallas que existen en la lista actual (filtrar legacy)
      for (String id in medals.keys) {
        if (allMedals.any((m) => m.id == id)) {
          _unlockedMedals.add(id);
        }
      }
      print('🏅 Medallas cargadas: ${_unlockedMedals.length}');
    }

    if (plants != null) {
      _unlockedPlants.clear();
      _unlockedPlants.addAll(plants.keys);
      print('🌱 Plantas cargadas: ${_unlockedPlants.length}');
    }

    if (creatures != null) {
      _unlockedCreatures.clear();
      _unlockedCreatures.addAll(creatures.keys);
      print('🐸 Criaturas cargadas: ${_unlockedCreatures.length}');
    }

    notifyListeners();
    saveData(); // Guardar en SharedPreferences también
    print('✅ Logros cargados desde Firebase');

    // Verificar si hay nuevos logros por desbloquear basados en el progreso
    checkAndUnlockStageAchievements();
  }

  // Verificar y desbloquear logros de etapas
  Future<void> checkAndUnlockStageAchievements() async {
    final progresoService = ProgresoService();

    // Etapa 1: Seccion 2 (1), Nodo 8 (Index 3)
    if (await progresoService.esActividadCompletada(0, 1, 3)) {
      unlockAchievement('etapa_1_complete', 'medals');
    }

    // Etapa 2: Seccion 2 (1), Nodo 7 (Index 2)
    if (await progresoService.esActividadCompletada(1, 1, 2)) {
      unlockAchievement('etapa_2_complete', 'medals');
    }

    // Etapa 3: Seccion 2 (1), Nodo 9 (Index 4)
    if (await progresoService.esActividadCompletada(2, 1, 4)) {
      unlockAchievement('etapa_3_complete', 'medals');
    }

    // Etapa 4: Seccion 2 (1), Nodo 6 (Index 1)
    if (await progresoService.esActividadCompletada(3, 1, 1)) {
      unlockAchievement('etapa_4_complete', 'medals');
    }

    // Etapa 5: Seccion 2 (1), Nodo 7 (Index 2)
    if (await progresoService.esActividadCompletada(4, 1, 2)) {
      unlockAchievement('etapa_5_complete', 'medals');
    }

    // Etapa 6: Seccion 2 (1), Nodo 6 (Index 2)
    if (await progresoService.esActividadCompletada(5, 1, 2)) {
      unlockAchievement('etapa_6_complete', 'medals');
    }
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData iconData;
  final String category;
  final String? imagePath;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconData,
    required this.category,
    this.imagePath,
  });
}
