import 'package:flutter/material.dart';

class PlantEncyclopediaModel {
  static final List<EncyclopediaPlant> allPlants = [
    EncyclopediaPlant(
      id: 'sunflower',
      name: 'Girasol',
      scientificName: 'Helianthus annuus',
      type: 'Planta Solar',
      rarity: PlantRarity.common,
      sunCost: 50,
      rechargeTime: 7.5,
      damage: 0,
      health: 300,
      range: 0,
      description:
          'Produce energía solar para cultivar más plantas. Es fundamental para cualquier jardín defensivo.',
      characteristics: [
        'Gira siguiendo la dirección del sol',
        'Produce 25 unidades de sol cada 24 segundos',
        'Es una de las plantas más básicas pero esenciales',
        'Tiene pétalos amarillos brillantes',
      ],
      habitat: 'Campos abiertos y jardines soleados',
      discoveredBy: 'Los antiguos pueblos americanos',
      funFact: '¡Un solo girasol puede producir hasta 2000 semillas!',
      iconPath: 'lib/assets/images/plants/sunflower.png',
      isUnlocked: true,
    ),
    EncyclopediaPlant(
      id: 'peashooter',
      name: 'Lanza Guisantes',
      scientificName: 'Pisum sativum defensivus',
      type: 'Planta Ofensiva',
      rarity: PlantRarity.common,
      sunCost: 100,
      rechargeTime: 7.5,
      damage: 20,
      health: 300,
      range: 'Todo el carril',
      description:
          'Tu primera línea de defensa. Dispara guisantes a una velocidad constante.',
      characteristics: [
        'Dispara guisantes cada 1.5 segundos',
        'Excelente planta inicial para principiantes',
        'Color verde brillante',
        'Tiene una expresión determinada',
      ],
      habitat: 'Jardines templados y huertos',
      discoveredBy: 'Jardineros defensivos experimentales',
      funFact: 'Sus guisantes pueden viajar a 30 metros por segundo.',
      iconPath: 'lib/assets/images/plants/peashooter.png',
      isUnlocked: true,
    ),
    EncyclopediaPlant(
      id: 'wall_nut',
      name: 'Nuez',
      scientificName: 'Juglans defensiva',
      type: 'Planta Defensiva',
      rarity: PlantRarity.common,
      sunCost: 50,
      rechargeTime: 30.0,
      damage: 0,
      health: 4000,
      range: 0,
      description:
          'Una barrera natural resistente que protege a otras plantas del ataque enemigo.',
      characteristics: [
        'Muy alta resistencia al daño',
        'No produce ataques ofensivos',
        'Tiene una cáscara extremadamente dura',
        'Cambia de apariencia según el daño recibido',
      ],
      habitat: 'Bosques de nogales y jardines rocosos',
      discoveredBy: 'Ingenieros de fortificaciones naturales',
      funFact:
          'Su cáscara es tan dura que puede resistir hasta 40 ataques normales.',
      iconPath: 'lib/assets/images/plants/wall_nut.png',
      isUnlocked: true,
    ),
    EncyclopediaPlant(
      id: 'cherry_bomb',
      name: 'Bomba Cereza',
      scientificName: 'Prunus explosiva',
      type: 'Planta Explosiva',
      rarity: PlantRarity.rare,
      sunCost: 150,
      rechargeTime: 50.0,
      damage: 1800,
      health: 300,
      range: 'Área 3x3',
      description:
          'Explota inmediatamente después de plantarse, causando daño masivo en área.',
      characteristics: [
        'Daño explosivo instantáneo',
        'Afecta a múltiples enemigos',
        'Se consume al usarse',
        'Tiene dos cerezas gemelas',
      ],
      habitat: 'Huertos especializados en explosivos',
      discoveredBy: 'Alquimistas botánicos',
      funFact:
          'Las dos cerezas trabajan en perfecta sincronización para crear la explosión.',
      iconPath: 'lib/assets/images/plants/cherry_bomb.png',
      isUnlocked: false,
    ),
    EncyclopediaPlant(
      id: 'potato_mine',
      name: 'Papa Mina',
      scientificName: 'Solanum explosive',
      type: 'Planta Trampa',
      rarity: PlantRarity.uncommon,
      sunCost: 25,
      rechargeTime: 30.0,
      damage: 1800,
      health: 300,
      range: 'Contacto directo',
      description:
          'Se entierra y espera pacientemente hasta que un enemigo pase por encima para explotar.',
      characteristics: [
        'Invisible para los enemigos',
        'Requiere tiempo de preparación',
        'Exploción única y poderosa',
        'Expresión traviesa característica',
      ],
      habitat: 'Campos subterráneos y jardines minerales',
      discoveredBy: 'Mineros botánicos especializados',
      funFact:
          'Puede permanecer enterrada hasta 5 minutos esperando el momento perfecto.',
      iconPath: 'lib/assets/images/plants/potato_mine.png',
      isUnlocked: false,
    ),
    EncyclopediaPlant(
      id: 'snow_pea',
      name: 'Guisante Helado',
      scientificName: 'Pisum frigidus',
      type: 'Planta de Hielo',
      rarity: PlantRarity.uncommon,
      sunCost: 175,
      rechargeTime: 7.5,
      damage: 20,
      health: 300,
      range: 'Todo el carril',
      description:
          'Dispara guisantes congelados que ralentizan a los enemigos además de dañarlos.',
      characteristics: [
        'Efecto de ralentización por frío',
        'Color azul cristalino',
        'Reduce velocidad enemiga a la mitad',
        'Resistente a bajas temperaturas',
      ],
      habitat: 'Regiones árticas y jardines fríos',
      discoveredBy: 'Exploradores de climas extremos',
      funFact:
          'Sus guisantes mantienen una temperatura de -10°C constantemente.',
      iconPath: 'lib/assets/images/plants/snow_pea.png',
      isUnlocked: false,
    ),
    EncyclopediaPlant(
      id: 'chomper',
      name: 'Devorador',
      scientificName: 'Dionaea gigantea',
      type: 'Planta Carnívora',
      rarity: PlantRarity.rare,
      sunCost: 150,
      rechargeTime: 7.5,
      damage: 'Instantáneo',
      health: 300,
      range: 'Contacto directo',
      description:
          'Una planta carnívora gigante que puede devorar enemigos enteros de un solo bocado.',
      characteristics: [
        'Elimina enemigos instantáneamente',
        'Requiere tiempo de digestión',
        'Mandíbulas poderosas',
        'Color verde oscuro intimidante',
      ],
      habitat: 'Pantanos carnívoros y selvas densas',
      discoveredBy: 'Biólogos especializados en plantas carnívoras',
      funFact: 'Puede digerir un enemigo completo en exactamente 42 segundos.',
      iconPath: 'lib/assets/images/plants/chomper.png',
      isUnlocked: false,
    ),
    EncyclopediaPlant(
      id: 'repeater',
      name: 'Repetidor',
      scientificName: 'Pisum rapidus',
      type: 'Planta Ofensiva Avanzada',
      rarity: PlantRarity.uncommon,
      sunCost: 200,
      rechargeTime: 7.5,
      damage: 40,
      health: 300,
      range: 'Todo el carril',
      description:
          'Una versión mejorada del Lanza Guisantes que dispara dos guisantes por cada disparo.',
      characteristics: [
        'Doble potencia de fuego',
        'Dos cabezas sincronizadas',
        'Mayor consumo energético',
        'Color verde más intenso',
      ],
      habitat: 'Laboratorios de mejoramiento genético',
      discoveredBy: 'Ingenieros genéticos vegetales',
      funFact:
          'Sus dos cabezas pueden calcular trayectorias independientes simultáneamente.',
      iconPath: 'lib/assets/images/plants/repeater.png',
      isUnlocked: false,
    ),
    EncyclopediaPlant(
      id: 'squash',
      name: 'Calabaza Aplastadora',
      scientificName: 'Cucurbita smashicus',
      type: 'Planta de Impacto',
      rarity: PlantRarity.rare,
      sunCost: 50,
      rechargeTime: 30.0,
      damage: 1800,
      health: 300,
      range: '3 casillas adelante',
      description:
          'Detecta enemigos cercanos y salta para aplastarlos con su peso masivo.',
      characteristics: [
        'Ataque de salto devastador',
        'Detección automática de enemigos',
        'Se consume al atacar',
        'Expresión seria y determinada',
      ],
      habitat: 'Granjas de calabazas gigantes',
      discoveredBy: 'Atletas botánicos especializados',
      funFact: 'Puede saltar hasta 3 metros de altura antes de impactar.',
      iconPath: 'lib/assets/images/plants/squash.png',
      isUnlocked: false,
    ),
    EncyclopediaPlant(
      id: 'threepeater',
      name: 'Triple Lanzador',
      scientificName: 'Pisum triplicus',
      type: 'Planta Multi-Carril',
      rarity: PlantRarity.epic,
      sunCost: 325,
      rechargeTime: 7.5,
      damage: 60,
      health: 300,
      range: '3 carriles simultáneos',
      description:
          'La evolución definitiva del lanzador, dispara en tres carriles a la vez.',
      characteristics: [
        'Cobertura de tres carriles',
        'Tres cabezas independientes',
        'Alta eficiencia táctica',
        'Diseño simétrico perfecto',
      ],
      habitat: 'Campos de entrenamiento avanzado',
      discoveredBy: 'Estrategas militares botánicos',
      funFact: 'Cada cabeza tiene su propia personalidad y estilo de disparo.',
      iconPath: 'lib/assets/images/plants/threepeater.png',
      isUnlocked: false,
    ),
  ];

  static EncyclopediaPlant getPlantById(String id) {
    return allPlants.firstWhere((plant) => plant.id == id);
  }

  static List<EncyclopediaPlant> getUnlockedPlants() {
    return allPlants.where((plant) => plant.isUnlocked).toList();
  }

  static List<EncyclopediaPlant> getLockedPlants() {
    return allPlants.where((plant) => !plant.isUnlocked).toList();
  }

  static void unlockPlant(String id) {
    final plantIndex = allPlants.indexWhere((plant) => plant.id == id);
    if (plantIndex != -1) {
      allPlants[plantIndex].isUnlocked = true;
    }
  }
}

class EncyclopediaPlant {
  final String id;
  final String name;
  final String scientificName;
  final String type;
  final PlantRarity rarity;
  final int sunCost;
  final double rechargeTime;
  final dynamic damage; // Puede ser int, String ("Instantáneo"), etc.
  final int health;
  final dynamic range; // Puede ser int, String, etc.
  final String description;
  final List<String> characteristics;
  final String habitat;
  final String discoveredBy;
  final String funFact;
  final String iconPath;
  bool isUnlocked;

  EncyclopediaPlant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.rarity,
    required this.sunCost,
    required this.rechargeTime,
    required this.damage,
    required this.health,
    required this.range,
    required this.description,
    required this.characteristics,
    required this.habitat,
    required this.discoveredBy,
    required this.funFact,
    required this.iconPath,
    this.isUnlocked = false,
  });

  Color get rarityColor {
    switch (rarity) {
      case PlantRarity.common:
        return Colors.grey[600]!;
      case PlantRarity.uncommon:
        return Colors.green[600]!;
      case PlantRarity.rare:
        return Colors.blue[600]!;
      case PlantRarity.epic:
        return Colors.purple[600]!;
      case PlantRarity.legendary:
        return Colors.orange[600]!;
    }
  }

  String get rarityName {
    switch (rarity) {
      case PlantRarity.common:
        return 'Común';
      case PlantRarity.uncommon:
        return 'Poco Común';
      case PlantRarity.rare:
        return 'Rara';
      case PlantRarity.epic:
        return 'Épica';
      case PlantRarity.legendary:
        return 'Legendaria';
    }
  }
}

enum PlantRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}
