import 'dart:math';

import 'dart:math';

/// Modelo completo de datos del juego del usuario
/// Contiene toda la información del progreso, inventario, logros, etc.
class UserGameData {
  // ==================== PERFIL ====================
  String uid;
  String username;
  String displayName;
  String? email;
  String? profileImage;
  String? avatarJson;
  String? avatarSvg;
  bool useCustomAvatar;
  DateTime createdAt;
  DateTime lastLogin;

  // ==================== PROGRESO GENERAL ====================
  int level;
  int experiencePoints;
  int experienceToNextLevel;
  double experienceProgress;

  // ==================== MONEDAS Y RECURSOS ====================
  int coins; // Monedas del juego
  int hearts; // Corazones/vidas
  int maxHearts; // Máximo de corazones
  DateTime? lastHeartRegenTime; // Última vez que se regeneró un corazón
  int gems; // Gemas premium (opcional)

  // ==================== RACHA ====================
  int consecutiveDays; // Días consecutivos de uso
  DateTime? lastActivityDate; // Última actividad registrada
  List<String> activityDates; // Historial de fechas de actividad
  int totalDaysUsed; // Total de días que ha usado la app
  List<int> hoursPerDay; // Horas de uso por día (últimos 7 días)

  // ==================== PROGRESO DEL MAPA ====================
  Map<String, EtapaProgress> etapasProgress; // Progreso por etapa (1-6)
  int currentEtapa; // Etapa actual en la que está
  int totalActivitiesCompleted; // Total de actividades completadas
  int totalStarsEarned; // Total de estrellas ganadas

  // ==================== TIENDA ====================
  List<String> purchasedItems; // IDs de items comprados
  List<String> equippedItems; // IDs de items equipados
  List<String> unlockedCategories; // Categorías desbloqueadas

  // ==================== LOGROS ====================
  List<String> unlockedAchievements; // IDs de logros desbloqueados
  Map<String, int>
      achievementsProgress; // Progreso de logros (ej: "complete_10_activities": 5)
  DateTime? lastAchievementUnlocked;

  // ==================== ESTADÍSTICAS ====================
  Map<String, int> stats; // Estadísticas generales del usuario
  int totalTimePlayedMinutes; // Tiempo total jugado en minutos
  int perfectScoresCount; // Cantidad de puntajes perfectos
  int activitiesRetried; // Actividades reintentadas

  // ==================== CONFIGURACIÓN ====================
  bool soundEnabled;
  bool musicEnabled;
  bool notificationsEnabled;
  String language; // 'es' o 'en'

  // ==================== TUTORIAL ====================
  bool tutorialCompleted;
  List<String> tutorialsShown; // Tutoriales que ya se mostraron

  UserGameData({
    required this.uid,
    required this.username,
    required this.displayName,
    this.email,
    this.profileImage,
    this.avatarJson,
    this.avatarSvg,
    this.useCustomAvatar = false,
    DateTime? createdAt,
    DateTime? lastLogin,
    this.level = 1,
    this.experiencePoints = 0,
    this.experienceToNextLevel = 100,
    this.experienceProgress = 0.0,
    this.coins = 0,
    this.hearts = 5,
    this.maxHearts = 5,
    this.lastHeartRegenTime,
    this.gems = 0,
    this.consecutiveDays = 0,
    this.lastActivityDate,
    List<String>? activityDates,
    this.totalDaysUsed = 0,
    List<int>? hoursPerDay,
    Map<String, EtapaProgress>? etapasProgress,
    this.currentEtapa = 1,
    this.totalActivitiesCompleted = 0,
    this.totalStarsEarned = 0,
    List<String>? purchasedItems,
    List<String>? equippedItems,
    List<String>? unlockedCategories,
    List<String>? unlockedAchievements,
    Map<String, int>? achievementsProgress,
    this.lastAchievementUnlocked,
    Map<String, int>? stats,
    this.totalTimePlayedMinutes = 0,
    this.perfectScoresCount = 0,
    this.activitiesRetried = 0,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.notificationsEnabled = true,
    this.language = 'es',
    this.tutorialCompleted = false,
    List<String>? tutorialsShown,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastLogin = lastLogin ?? DateTime.now(),
        activityDates = activityDates ?? [],
        hoursPerDay = hoursPerDay ?? [0, 0, 0, 0, 0, 0, 0],
        etapasProgress = etapasProgress ??
            {
              '1': EtapaProgress(etapaNumber: 1),
              '2': EtapaProgress(etapaNumber: 2),
              '3': EtapaProgress(etapaNumber: 3),
              '4': EtapaProgress(etapaNumber: 4),
              '5': EtapaProgress(etapaNumber: 5),
              '6': EtapaProgress(etapaNumber: 6),
            },
        purchasedItems = purchasedItems ?? [],
        equippedItems = equippedItems ?? [],
        unlockedCategories = unlockedCategories ?? [],
        unlockedAchievements = unlockedAchievements ?? [],
        achievementsProgress = achievementsProgress ?? {},
        stats = stats ?? {},
        tutorialsShown = tutorialsShown ?? [];

  // Convertir a JSON para Firebase
  Map<String, dynamic> toJson() {
    return {
      'profile': {
        'uid': uid,
        'username': username,
        'displayName': displayName,
        'email': email,
        'profileImage': profileImage,
        'avatarJson': avatarJson,
        'avatarSvg': avatarSvg,
        'useCustomAvatar': useCustomAvatar,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'lastLogin': lastLogin.millisecondsSinceEpoch,
      },
      'progress': {
        'level': level,
        'experiencePoints': experiencePoints,
        'experienceToNextLevel': experienceToNextLevel,
        'experienceProgress': experienceProgress,
      },
      'resources': {
        'coins': coins,
        'hearts': hearts,
        'maxHearts': maxHearts,
        'lastHeartRegenTime': lastHeartRegenTime?.millisecondsSinceEpoch,
        'gems': gems,
      },
      'streak': {
        'consecutiveDays': consecutiveDays,
        'lastActivityDate': lastActivityDate?.toIso8601String(),
        'activityDates': activityDates,
        'totalDaysUsed': totalDaysUsed,
        'hoursPerDay': hoursPerDay,
      },
      'mapProgress': {
        'etapas':
            etapasProgress.map((key, value) => MapEntry(key, value.toJson())),
        'currentEtapa': currentEtapa,
        'totalActivitiesCompleted': totalActivitiesCompleted,
        'totalStarsEarned': totalStarsEarned,
      },
      'store': {
        'purchasedItems': purchasedItems,
        'equippedItems': equippedItems,
        'unlockedCategories': unlockedCategories,
      },
      'achievements': {
        'unlockedAchievements': unlockedAchievements,
        'achievementsProgress': achievementsProgress,
        'lastAchievementUnlocked':
            lastAchievementUnlocked?.millisecondsSinceEpoch,
      },
      'statistics': {
        'stats': stats,
        'totalTimePlayedMinutes': totalTimePlayedMinutes,
        'perfectScoresCount': perfectScoresCount,
        'activitiesRetried': activitiesRetried,
      },
      'settings': {
        'soundEnabled': soundEnabled,
        'musicEnabled': musicEnabled,
        'notificationsEnabled': notificationsEnabled,
        'language': language,
      },
      'tutorial': {
        'tutorialCompleted': tutorialCompleted,
        'tutorialsShown': tutorialsShown,
      },
    };
  }

  // Crear desde JSON de Firebase
  factory UserGameData.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] != null
        ? Map<String, dynamic>.from(json['profile'] as Map)
        : <String, dynamic>{};
    final progress = json['progress'] != null
        ? Map<String, dynamic>.from(json['progress'] as Map)
        : <String, dynamic>{};
    final resources = json['resources'] != null
        ? Map<String, dynamic>.from(json['resources'] as Map)
        : <String, dynamic>{};
    final streak = json['streak'] != null
        ? Map<String, dynamic>.from(json['streak'] as Map)
        : <String, dynamic>{};
    final mapProgress = json['mapProgress'] != null
        ? Map<String, dynamic>.from(json['mapProgress'] as Map)
        : <String, dynamic>{};
    final store = json['store'] != null
        ? Map<String, dynamic>.from(json['store'] as Map)
        : <String, dynamic>{};
    final achievements = json['achievements'] != null
        ? Map<String, dynamic>.from(json['achievements'] as Map)
        : <String, dynamic>{};
    final statistics = json['statistics'] != null
        ? Map<String, dynamic>.from(json['statistics'] as Map)
        : <String, dynamic>{};
    final settings = json['settings'] != null
        ? Map<String, dynamic>.from(json['settings'] as Map)
        : <String, dynamic>{};
    final tutorial = json['tutorial'] != null
        ? Map<String, dynamic>.from(json['tutorial'] as Map)
        : <String, dynamic>{};

    return UserGameData(
      uid: profile['uid'] as String? ?? '',
      username: profile['username'] as String? ?? '',
      displayName: profile['displayName'] as String? ?? '',
      email: profile['email'] as String?,
      profileImage: profile['profileImage'] as String?,
      avatarJson: profile['avatarJson'] as String?,
      avatarSvg: profile['avatarSvg'] as String?,
      useCustomAvatar: profile['useCustomAvatar'] as bool? ?? false,
      createdAt: profile['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(profile['createdAt'] as int)
          : DateTime.now(),
      lastLogin: profile['lastLogin'] != null
          ? DateTime.fromMillisecondsSinceEpoch(profile['lastLogin'] as int)
          : DateTime.now(),
      level: progress['level'] as int? ?? 1,
      experiencePoints: progress['experiencePoints'] as int? ?? 0,
      experienceToNextLevel: progress['experienceToNextLevel'] as int? ?? 100,
      experienceProgress:
          (progress['experienceProgress'] as num?)?.toDouble() ?? 0.0,
      coins: resources['coins'] as int? ?? 0,
      hearts: resources['hearts'] as int? ?? 5,
      maxHearts: resources['maxHearts'] as int? ?? 5,
      lastHeartRegenTime: resources['lastHeartRegenTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              resources['lastHeartRegenTime'] as int)
          : null,
      gems: resources['gems'] as int? ?? 0,
      consecutiveDays: streak['consecutiveDays'] as int? ?? 0,
      lastActivityDate: streak['lastActivityDate'] != null
          ? DateTime.parse(streak['lastActivityDate'] as String)
          : null,
      activityDates:
          (streak['activityDates'] as List<dynamic>?)?.cast<String>() ?? [],
      totalDaysUsed: streak['totalDaysUsed'] as int? ?? 0,
      hoursPerDay: (streak['hoursPerDay'] as List<dynamic>?)?.cast<int>() ??
          [0, 0, 0, 0, 0, 0, 0],
      etapasProgress: _parseEtapasProgress(mapProgress['etapas']),
      currentEtapa: mapProgress['currentEtapa'] as int? ?? 1,
      totalActivitiesCompleted:
          mapProgress['totalActivitiesCompleted'] as int? ?? 0,
      totalStarsEarned: mapProgress['totalStarsEarned'] as int? ?? 0,
      purchasedItems:
          (store['purchasedItems'] as List<dynamic>?)?.cast<String>() ?? [],
      equippedItems:
          (store['equippedItems'] as List<dynamic>?)?.cast<String>() ?? [],
      unlockedCategories:
          (store['unlockedCategories'] as List<dynamic>?)?.cast<String>() ?? [],
      unlockedAchievements:
          (achievements['unlockedAchievements'] as List<dynamic>?)
                  ?.cast<String>() ??
              [],
      achievementsProgress: achievements['achievementsProgress'] is Map
          ? (achievements['achievementsProgress'] as Map).map(
              (key, value) => MapEntry(key.toString(), value as int),
            )
          : {},
      lastAchievementUnlocked: achievements['lastAchievementUnlocked'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              achievements['lastAchievementUnlocked'] as int)
          : null,
      stats: statistics['stats'] is Map
          ? (statistics['stats'] as Map).map(
              (key, value) => MapEntry(key.toString(), value as int),
            )
          : {},
      totalTimePlayedMinutes: statistics['totalTimePlayedMinutes'] as int? ?? 0,
      perfectScoresCount: statistics['perfectScoresCount'] as int? ?? 0,
      activitiesRetried: statistics['activitiesRetried'] as int? ?? 0,
      soundEnabled: settings['soundEnabled'] as bool? ?? true,
      musicEnabled: settings['musicEnabled'] as bool? ?? true,
      notificationsEnabled: settings['notificationsEnabled'] as bool? ?? true,
      language: settings['language'] as String? ?? 'es',
      tutorialCompleted: tutorial['tutorialCompleted'] as bool? ?? false,
      tutorialsShown:
          (tutorial['tutorialsShown'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  static Map<String, EtapaProgress> _parseEtapasProgress(dynamic etapasData) {
    if (etapasData == null) {
      return {
        '1': EtapaProgress(etapaNumber: 1),
        '2': EtapaProgress(etapaNumber: 2),
        '3': EtapaProgress(etapaNumber: 3),
        '4': EtapaProgress(etapaNumber: 4),
        '5': EtapaProgress(etapaNumber: 5),
        '6': EtapaProgress(etapaNumber: 6),
      };
    }

    if (etapasData is List) {
      final map = <String, EtapaProgress>{};
      for (var item in etapasData) {
        if (item != null) {
          try {
            final itemMap = Map<String, dynamic>.from(item as Map);
            final etapa = EtapaProgress.fromJson(itemMap);
            map[etapa.etapaNumber.toString()] = etapa;
          } catch (e) {
            print('Error parsing etapa from list: $e');
          }
        }
      }
      return map;
    }

    try {
      final map = Map<String, dynamic>.from(etapasData as Map);
      return map.map((key, value) => MapEntry(
            key,
            EtapaProgress.fromJson(Map<String, dynamic>.from(value as Map)),
          ));
    } catch (e) {
      print('Error parsing etapas map: $e');
      return {};
    }
  }

  // Crear datos por defecto para un nuevo usuario
  factory UserGameData.createDefault({
    required String uid,
    required String username,
    required String displayName,
    String? email,
  }) {
    // Generar avatar aleatorio por defecto
    final randomAvatarId = "avatar${Random().nextInt(30) + 1}";

    return UserGameData(
      uid: uid,
      username: username,
      displayName: displayName,
      email: email,
      coins: 100, // Monedas iniciales de bienvenida
      hearts: 5, // Corazones completos
      gems: 0,
      avatarJson: randomAvatarId,
      useCustomAvatar: true, // Usar avatar personalizado por defecto
      profileImage: '', // Fallback
    );
  }

  // Copiar con modificaciones
  UserGameData copyWith({
    String? uid,
    String? username,
    String? displayName,
    String? email,
    String? profileImage,
    String? avatarJson,
    String? avatarSvg,
    bool? useCustomAvatar,
    DateTime? createdAt,
    DateTime? lastLogin,
    int? level,
    int? experiencePoints,
    int? experienceToNextLevel,
    double? experienceProgress,
    int? coins,
    int? hearts,
    int? maxHearts,
    DateTime? lastHeartRegenTime,
    int? gems,
    int? consecutiveDays,
    DateTime? lastActivityDate,
    List<String>? activityDates,
    int? totalDaysUsed,
    List<int>? hoursPerDay,
    Map<String, EtapaProgress>? etapasProgress,
    int? currentEtapa,
    int? totalActivitiesCompleted,
    int? totalStarsEarned,
    List<String>? purchasedItems,
    List<String>? equippedItems,
    List<String>? unlockedCategories,
    List<String>? unlockedAchievements,
    Map<String, int>? achievementsProgress,
    DateTime? lastAchievementUnlocked,
    Map<String, int>? stats,
    int? totalTimePlayedMinutes,
    int? perfectScoresCount,
    int? activitiesRetried,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? notificationsEnabled,
    String? language,
    bool? tutorialCompleted,
    List<String>? tutorialsShown,
  }) {
    return UserGameData(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      avatarJson: avatarJson ?? this.avatarJson,
      avatarSvg: avatarSvg ?? this.avatarSvg,
      useCustomAvatar: useCustomAvatar ?? this.useCustomAvatar,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      experienceToNextLevel:
          experienceToNextLevel ?? this.experienceToNextLevel,
      experienceProgress: experienceProgress ?? this.experienceProgress,
      coins: coins ?? this.coins,
      hearts: hearts ?? this.hearts,
      maxHearts: maxHearts ?? this.maxHearts,
      lastHeartRegenTime: lastHeartRegenTime ?? this.lastHeartRegenTime,
      gems: gems ?? this.gems,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      activityDates: activityDates ?? this.activityDates,
      totalDaysUsed: totalDaysUsed ?? this.totalDaysUsed,
      hoursPerDay: hoursPerDay ?? this.hoursPerDay,
      etapasProgress: etapasProgress ?? this.etapasProgress,
      currentEtapa: currentEtapa ?? this.currentEtapa,
      totalActivitiesCompleted:
          totalActivitiesCompleted ?? this.totalActivitiesCompleted,
      totalStarsEarned: totalStarsEarned ?? this.totalStarsEarned,
      purchasedItems: purchasedItems ?? this.purchasedItems,
      equippedItems: equippedItems ?? this.equippedItems,
      unlockedCategories: unlockedCategories ?? this.unlockedCategories,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      achievementsProgress: achievementsProgress ?? this.achievementsProgress,
      lastAchievementUnlocked:
          lastAchievementUnlocked ?? this.lastAchievementUnlocked,
      stats: stats ?? this.stats,
      totalTimePlayedMinutes:
          totalTimePlayedMinutes ?? this.totalTimePlayedMinutes,
      perfectScoresCount: perfectScoresCount ?? this.perfectScoresCount,
      activitiesRetried: activitiesRetried ?? this.activitiesRetried,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      tutorialsShown: tutorialsShown ?? this.tutorialsShown,
    );
  }
}

/// Progreso de una etapa específica (1º a 6º Básico)
class EtapaProgress {
  int etapaNumber;
  bool isUnlocked;
  Map<String, SeccionProgress> seccionesProgress; // Secciones de la etapa
  int totalNodesCompleted;
  int totalStars;

  EtapaProgress({
    required this.etapaNumber,
    this.isUnlocked = false,
    Map<String, SeccionProgress>? seccionesProgress,
    this.totalNodesCompleted = 0,
    this.totalStars = 0,
  }) : seccionesProgress =
            seccionesProgress ?? _initializeSecciones(etapaNumber);

  static Map<String, SeccionProgress> _initializeSecciones(int etapa) {
    // Cada etapa tiene 2 secciones
    return {
      '1': SeccionProgress(seccionNumber: 1, etapaNumber: etapa),
      '2': SeccionProgress(seccionNumber: 2, etapaNumber: etapa),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'etapaNumber': etapaNumber,
      'isUnlocked': isUnlocked,
      'secciones':
          seccionesProgress.map((key, value) => MapEntry(key, value.toJson())),
      'totalNodesCompleted': totalNodesCompleted,
      'totalStars': totalStars,
    };
  }

  factory EtapaProgress.fromJson(Map<String, dynamic> json) {
    return EtapaProgress(
      etapaNumber: json['etapaNumber'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      seccionesProgress: _parseSeccionesProgress(json['secciones']),
      totalNodesCompleted: json['totalNodesCompleted'] as int? ?? 0,
      totalStars: json['totalStars'] as int? ?? 0,
    );
  }

  static Map<String, SeccionProgress> _parseSeccionesProgress(
      dynamic seccionesData) {
    if (seccionesData == null) {
      return {
        '1': SeccionProgress(seccionNumber: 1, etapaNumber: 1),
        '2': SeccionProgress(seccionNumber: 2, etapaNumber: 1),
      };
    }

    if (seccionesData is List) {
      final map = <String, SeccionProgress>{};
      for (var item in seccionesData) {
        if (item != null) {
          try {
            final itemMap = Map<String, dynamic>.from(item as Map);
            final seccion = SeccionProgress.fromJson(itemMap);
            map[seccion.seccionNumber.toString()] = seccion;
          } catch (e) {
            print('Error parsing seccion from list: $e');
          }
        }
      }
      return map;
    }

    try {
      final map = Map<String, dynamic>.from(seccionesData as Map);
      return map.map((key, value) => MapEntry(
            key,
            SeccionProgress.fromJson(Map<String, dynamic>.from(value as Map)),
          ));
    } catch (e) {
      print('Error parsing secciones map: $e');
      return {};
    }
  }
}

/// Progreso de una sección dentro de una etapa
class SeccionProgress {
  int seccionNumber;
  int etapaNumber;
  bool isUnlocked;
  Map<String, NodeProgress> nodesProgress; // Nodos/actividades de la sección
  int totalNodesCompleted;
  int totalStars;

  SeccionProgress({
    required this.seccionNumber,
    required this.etapaNumber,
    this.isUnlocked = false,
    Map<String, NodeProgress>? nodesProgress,
    this.totalNodesCompleted = 0,
    this.totalStars = 0,
  }) : nodesProgress =
            nodesProgress ?? _initializeNodes(etapaNumber, seccionNumber);

  static Map<String, NodeProgress> _initializeNodes(int etapa, int seccion) {
    // Número de nodos varía por etapa/sección
    final nodeCount = _getNodeCount(etapa, seccion);
    final Map<String, NodeProgress> nodes = {};

    for (int i = 1; i <= nodeCount; i++) {
      nodes['$i'] = NodeProgress(
        nodeNumber: i,
        seccionNumber: seccion,
        etapaNumber: etapa,
      );
    }

    return nodes;
  }

  static int _getNodeCount(int etapa, int seccion) {
    // Define cuántos nodos tiene cada sección
    // Puedes ajustar estos números según tu estructura real
    return 7; // Por defecto 7 nodos por sección
  }

  Map<String, dynamic> toJson() {
    return {
      'seccionNumber': seccionNumber,
      'etapaNumber': etapaNumber,
      'isUnlocked': isUnlocked,
      'nodes': nodesProgress.map((key, value) => MapEntry(key, value.toJson())),
      'totalNodesCompleted': totalNodesCompleted,
      'totalStars': totalStars,
    };
  }

  factory SeccionProgress.fromJson(Map<String, dynamic> json) {
    return SeccionProgress(
      seccionNumber: json['seccionNumber'] as int,
      etapaNumber: json['etapaNumber'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      nodesProgress: _parseNodesProgress(json['nodes']),
      totalNodesCompleted: json['totalNodesCompleted'] as int? ?? 0,
      totalStars: json['totalStars'] as int? ?? 0,
    );
  }

  static Map<String, NodeProgress> _parseNodesProgress(dynamic nodesData) {
    if (nodesData == null) return {};

    if (nodesData is List) {
      final map = <String, NodeProgress>{};
      for (var item in nodesData) {
        if (item != null) {
          try {
            final itemMap = Map<String, dynamic>.from(item as Map);
            final node = NodeProgress.fromJson(itemMap);
            map[node.nodeNumber.toString()] = node;
          } catch (e) {
            print('Error parsing node from list: $e');
          }
        }
      }
      return map;
    }

    try {
      final map = Map<String, dynamic>.from(nodesData as Map);
      return map.map((key, value) => MapEntry(
            key,
            NodeProgress.fromJson(Map<String, dynamic>.from(value as Map)),
          ));
    } catch (e) {
      print('Error parsing nodes map: $e');
      return {};
    }
  }
}

/// Progreso de un nodo/actividad específica
class NodeProgress {
  int nodeNumber;
  int seccionNumber;
  int etapaNumber;
  bool isCompleted;
  bool isUnlocked;
  int stars; // 0-3 estrellas
  int attempts; // Intentos realizados
  int bestScore; // Mejor puntaje obtenido
  DateTime? completedAt; // Fecha de completado
  DateTime? lastAttemptAt; // Último intento

  NodeProgress({
    required this.nodeNumber,
    required this.seccionNumber,
    required this.etapaNumber,
    this.isCompleted = false,
    this.isUnlocked = false,
    this.stars = 0,
    this.attempts = 0,
    this.bestScore = 0,
    this.completedAt,
    this.lastAttemptAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'nodeNumber': nodeNumber,
      'seccionNumber': seccionNumber,
      'etapaNumber': etapaNumber,
      'isCompleted': isCompleted,
      'isUnlocked': isUnlocked,
      'stars': stars,
      'attempts': attempts,
      'bestScore': bestScore,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'lastAttemptAt': lastAttemptAt?.millisecondsSinceEpoch,
    };
  }

  factory NodeProgress.fromJson(Map<String, dynamic> json) {
    return NodeProgress(
      nodeNumber: json['nodeNumber'] as int,
      seccionNumber: json['seccionNumber'] as int,
      etapaNumber: json['etapaNumber'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      stars: json['stars'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
      bestScore: json['bestScore'] as int? ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'] as int)
          : null,
      lastAttemptAt: json['lastAttemptAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastAttemptAt'] as int)
          : null,
    );
  }
}
