import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_game_data.dart';

/// Servicio completo para gestionar datos del juego en Firebase
/// Sincroniza automáticamente todos los cambios del usuario
class FirebaseGameDataService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtener el ID del usuario actual
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Referencia al nodo del usuario actual
  DatabaseReference? get _userRef {
    final uid = _currentUserId;
    if (uid == null) return null;
    return _database.child('users').child(uid);
  }

  // ==================== INICIALIZACIÓN ====================

  /// Crear perfil inicial para un nuevo usuario
  Future<UserGameData> createNewUser({
    required String username,
    required String displayName,
    String? email,
  }) async {
    final uid = _currentUserId;
    if (uid == null) throw Exception('Usuario no autenticado');

    // Crear datos por defecto
    final userData = UserGameData.createDefault(
      uid: uid,
      username: username,
      displayName: displayName,
      email: email,
    );

    // Desbloquear primera etapa y primeros nodos
    userData.etapasProgress['1']!.isUnlocked = true;
    userData.etapasProgress['1']!.seccionesProgress['1']!.isUnlocked = true;
    userData.etapasProgress['1']!.seccionesProgress['1']!.nodesProgress['1']!
        .isUnlocked = true;

    // Guardar en Firebase
    await _userRef!.set(userData.toJson());

    print('✅ Usuario creado en Firebase: $username');
    return userData;
  }

  /// Cargar todos los datos del usuario
  Future<UserGameData?> loadUserData() async {
    final userRef = _userRef;
    if (userRef == null) return null;

    try {
      final snapshot = await userRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return UserGameData.fromJson(data);
      }

      return null;
    } catch (e) {
      print('❌ Error al cargar datos del usuario: $e');
      return null;
    }
  }

  /// Verificar si el usuario ya tiene datos guardados
  Future<bool> userDataExists() async {
    final userRef = _userRef;
    if (userRef == null) return false;

    try {
      final snapshot = await userRef.get();
      return snapshot.exists;
    } catch (e) {
      print('❌ Error al verificar datos: $e');
      return false;
    }
  }

  // ==================== PERFIL ====================

  /// Actualizar perfil del usuario
  Future<void> updateProfile({
    String? displayName,
    String? profileImage,
    String? avatarJson,
    String? avatarSvg,
    bool? useCustomAvatar,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final updates = <String, dynamic>{};

    if (displayName != null) updates['profile/displayName'] = displayName;
    if (profileImage != null) updates['profile/profileImage'] = profileImage;
    if (avatarJson != null) updates['profile/avatarJson'] = avatarJson;
    if (avatarSvg != null) updates['profile/avatarSvg'] = avatarSvg;
    if (useCustomAvatar != null)
      updates['profile/useCustomAvatar'] = useCustomAvatar;

    updates['profile/lastLogin'] = ServerValue.timestamp;

    await userRef.update(updates);
    print('✅ Perfil actualizado');
  }

  // ==================== PROGRESO ====================

  /// Actualizar progreso general (nivel, XP)
  Future<void> updateProgress({
    int? level,
    int? experiencePoints,
    int? experienceToNextLevel,
    double? experienceProgress,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final updates = <String, dynamic>{};

    if (level != null) updates['progress/level'] = level;
    if (experiencePoints != null)
      updates['progress/experiencePoints'] = experiencePoints;
    if (experienceToNextLevel != null)
      updates['progress/experienceToNextLevel'] = experienceToNextLevel;
    if (experienceProgress != null)
      updates['progress/experienceProgress'] = experienceProgress;

    await userRef.update(updates);
    print('✅ Progreso actualizado');
  }

  // ==================== RECURSOS (MONEDAS, CORAZONES) ====================

  /// Actualizar monedas
  Future<void> updateCoins(int coins) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    await userRef.child('resources/coins').set(coins);
    print('✅ Monedas actualizadas: $coins');
  }

  /// Sumar monedas
  Future<void> addCoins(int amount) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final currentCoinsSnapshot = await userRef.child('resources/coins').get();
    final currentCoins = (currentCoinsSnapshot.value as int?) ?? 0;

    await updateCoins(currentCoins + amount);
  }

  /// Restar monedas (para compras)
  Future<bool> spendCoins(int amount) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final currentCoinsSnapshot = await userRef.child('resources/coins').get();
    final currentCoins = (currentCoinsSnapshot.value as int?) ?? 0;

    if (currentCoins >= amount) {
      await updateCoins(currentCoins - amount);
      return true;
    }

    return false;
  }

  /// Actualizar corazones
  Future<void> updateHearts(int hearts) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    await userRef.child('resources/hearts').set(hearts);
    await userRef
        .child('resources/lastHeartRegenTime')
        .set(ServerValue.timestamp);
    print('✅ Corazones actualizados: $hearts');
  }

  /// Actualizar gemas
  Future<void> updateGems(int gems) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    await userRef.child('resources/gems').set(gems);
    print('✅ Gemas actualizadas: $gems');
  }

  // ==================== RACHA ====================

  /// Actualizar racha de días consecutivos
  Future<void> updateStreak({
    required int consecutiveDays,
    required DateTime lastActivityDate,
    required List<String> activityDates,
    int? totalDaysUsed,
    List<int>? hoursPerDay,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final updates = <String, dynamic>{
      'streak/consecutiveDays': consecutiveDays,
      'streak/lastActivityDate': lastActivityDate.toIso8601String(),
      'streak/activityDates': activityDates,
    };

    if (totalDaysUsed != null) updates['streak/totalDaysUsed'] = totalDaysUsed;
    if (hoursPerDay != null) updates['streak/hoursPerDay'] = hoursPerDay;

    await userRef.update(updates);
    print('✅ Racha actualizada: $consecutiveDays días');
  }

  // ==================== PROGRESO DEL MAPA ====================

  /// Completar un nodo/actividad
  Future<void> completeNode({
    required int etapa,
    required int seccion,
    required int node,
    required int stars,
    required int score,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final nodePath = 'mapProgress/etapas/$etapa/secciones/$seccion/nodes/$node';

    final updates = <String, dynamic>{
      '$nodePath/isCompleted': true,
      '$nodePath/stars': stars,
      '$nodePath/bestScore': score,
      '$nodePath/completedAt': ServerValue.timestamp,
      '$nodePath/lastAttemptAt': ServerValue.timestamp,
    };

    // Incrementar intentos
    final attemptsSnapshot = await userRef.child('$nodePath/attempts').get();
    final currentAttempts = (attemptsSnapshot.value as int?) ?? 0;
    updates['$nodePath/attempts'] = currentAttempts + 1;

    await userRef.update(updates);

    // Actualizar contadores totales
    await _updateTotalProgress();

    print('✅ Nodo completado: Etapa $etapa, Sección $seccion, Nodo $node');
  }

  /// Desbloquear un nodo
  Future<void> unlockNode({
    required int etapa,
    required int seccion,
    required int node,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final nodePath = 'mapProgress/etapas/$etapa/secciones/$seccion/nodes/$node';
    await userRef.child('$nodePath/isUnlocked').set(true);

    print('✅ Nodo desbloqueado: Etapa $etapa, Sección $seccion, Nodo $node');
  }

  /// Desbloquear una sección
  Future<void> unlockSeccion({
    required int etapa,
    required int seccion,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final seccionPath = 'mapProgress/etapas/$etapa/secciones/$seccion';
    await userRef.child('$seccionPath/isUnlocked').set(true);

    print('✅ Sección desbloqueada: Etapa $etapa, Sección $seccion');
  }

  /// Desbloquear una etapa
  Future<void> unlockEtapa(int etapa) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final etapaPath = 'mapProgress/etapas/$etapa';
    await userRef.child('$etapaPath/isUnlocked').set(true);
    await userRef.child('mapProgress/currentEtapa').set(etapa);

    print('✅ Etapa desbloqueada: $etapa');
  }

  /// Actualizar totales de progreso
  Future<void> _updateTotalProgress() async {
    final userRef = _userRef;
    if (userRef == null) return;

    try {
      // Cargar datos completos del mapa
      final mapSnapshot = await userRef.child('mapProgress').get();
      if (!mapSnapshot.exists) return;

      final mapData = Map<String, dynamic>.from(mapSnapshot.value as Map);
      final etapas = mapData['etapas'] as Map<String, dynamic>?;

      if (etapas == null) return;

      int totalActivities = 0;
      int totalStars = 0;

      // Contar actividades y estrellas
      etapas.forEach((etapaKey, etapaValue) {
        final etapaData = Map<String, dynamic>.from(etapaValue as Map);
        final secciones = etapaData['secciones'] as Map<String, dynamic>?;

        if (secciones != null) {
          secciones.forEach((seccionKey, seccionValue) {
            final seccionData = Map<String, dynamic>.from(seccionValue as Map);
            final nodes = seccionData['nodes'] as Map<String, dynamic>?;

            if (nodes != null) {
              nodes.forEach((nodeKey, nodeValue) {
                final nodeData = Map<String, dynamic>.from(nodeValue as Map);

                if (nodeData['isCompleted'] == true) {
                  totalActivities++;
                  totalStars += (nodeData['stars'] as int?) ?? 0;
                }
              });
            }
          });
        }
      });

      // Actualizar totales
      await userRef.update({
        'mapProgress/totalActivitiesCompleted': totalActivities,
        'mapProgress/totalStarsEarned': totalStars,
      });

      print(
          '✅ Totales actualizados: $totalActivities actividades, $totalStars estrellas');
    } catch (e) {
      print('❌ Error al actualizar totales: $e');
    }
  }

  // ==================== TIENDA ====================

  /// Comprar un item
  Future<bool> purchaseItem(String itemId, int price) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    // Verificar si tiene suficientes monedas
    final canPurchase = await spendCoins(price);

    if (canPurchase) {
      // Obtener lista actual de items comprados
      final purchasedSnapshot =
          await userRef.child('store/purchasedItems').get();
      final purchased = purchasedSnapshot.exists
          ? List<String>.from(purchasedSnapshot.value as List)
          : <String>[];

      if (!purchased.contains(itemId)) {
        purchased.add(itemId);
        await userRef.child('store/purchasedItems').set(purchased);
        print('✅ Item comprado: $itemId');
      }

      return true;
    }

    return false;
  }

  /// Equipar un item
  Future<void> equipItem(String itemId) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final equippedSnapshot = await userRef.child('store/equippedItems').get();
    final equipped = equippedSnapshot.exists
        ? List<String>.from(equippedSnapshot.value as List)
        : <String>[];

    if (!equipped.contains(itemId)) {
      equipped.add(itemId);
      await userRef.child('store/equippedItems').set(equipped);
      print('✅ Item equipado: $itemId');
    }
  }

  /// Desequipar un item
  Future<void> unequipItem(String itemId) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final equippedSnapshot = await userRef.child('store/equippedItems').get();
    final equipped = equippedSnapshot.exists
        ? List<String>.from(equippedSnapshot.value as List)
        : <String>[];

    if (equipped.contains(itemId)) {
      equipped.remove(itemId);
      await userRef.child('store/equippedItems').set(equipped);
      print('✅ Item desequipado: $itemId');
    }
  }

  // ==================== LOGROS ====================

  /// Desbloquear un logro
  Future<void> unlockAchievement(String achievementId) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final unlockedSnapshot =
        await userRef.child('achievements/unlockedAchievements').get();
    final unlocked = unlockedSnapshot.exists
        ? List<String>.from(unlockedSnapshot.value as List)
        : <String>[];

    if (!unlocked.contains(achievementId)) {
      unlocked.add(achievementId);

      await userRef.update({
        'achievements/unlockedAchievements': unlocked,
        'achievements/lastAchievementUnlocked': ServerValue.timestamp,
      });

      print('✅ Logro desbloqueado: $achievementId');
    }
  }

  /// Actualizar progreso de un logro
  Future<void> updateAchievementProgress(
      String achievementId, int progress) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    await userRef
        .child('achievements/achievementsProgress/$achievementId')
        .set(progress);
    print('✅ Progreso de logro actualizado: $achievementId = $progress');
  }

  // ==================== ESTADÍSTICAS ====================

  /// Actualizar estadísticas
  Future<void> updateStatistics({
    Map<String, int>? stats,
    int? totalTimePlayedMinutes,
    int? perfectScoresCount,
    int? activitiesRetried,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final updates = <String, dynamic>{};

    if (stats != null) {
      stats.forEach((key, value) {
        updates['statistics/stats/$key'] = value;
      });
    }

    if (totalTimePlayedMinutes != null) {
      updates['statistics/totalTimePlayedMinutes'] = totalTimePlayedMinutes;
    }
    if (perfectScoresCount != null) {
      updates['statistics/perfectScoresCount'] = perfectScoresCount;
    }
    if (activitiesRetried != null) {
      updates['statistics/activitiesRetried'] = activitiesRetried;
    }

    await userRef.update(updates);
    print('✅ Estadísticas actualizadas');
  }

  // ==================== CONFIGURACIÓN ====================

  /// Actualizar configuración
  Future<void> updateSettings({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? notificationsEnabled,
    String? language,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final updates = <String, dynamic>{};

    if (soundEnabled != null) updates['settings/soundEnabled'] = soundEnabled;
    if (musicEnabled != null) updates['settings/musicEnabled'] = musicEnabled;
    if (notificationsEnabled != null)
      updates['settings/notificationsEnabled'] = notificationsEnabled;
    if (language != null) updates['settings/language'] = language;

    await userRef.update(updates);
    print('✅ Configuración actualizada');
  }

  // ==================== TUTORIALES ====================

  /// Marcar tutorial como completado
  Future<void> markTutorialCompleted() async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    await userRef.child('tutorial/tutorialCompleted').set(true);
    print('✅ Tutorial completado');
  }

  /// Agregar tutorial mostrado
  Future<void> addShownTutorial(String tutorialId) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final shownSnapshot = await userRef.child('tutorial/tutorialsShown').get();
    final shown = shownSnapshot.exists
        ? List<String>.from(shownSnapshot.value as List)
        : <String>[];

    if (!shown.contains(tutorialId)) {
      shown.add(tutorialId);
      await userRef.child('tutorial/tutorialsShown').set(shown);
      print('✅ Tutorial registrado: $tutorialId');
    }
  }

  // ==================== LISTENERS EN TIEMPO REAL ====================

  /// Escuchar cambios en monedas
  Stream<int> listenToCoins() {
    final userRef = _userRef;
    if (userRef == null) return Stream.value(0);

    return userRef.child('resources/coins').onValue.map((event) {
      if (event.snapshot.exists) {
        return event.snapshot.value as int;
      }
      return 0;
    });
  }

  /// Escuchar cambios en corazones
  Stream<int> listenToHearts() {
    final userRef = _userRef;
    if (userRef == null) return Stream.value(5);

    return userRef.child('resources/hearts').onValue.map((event) {
      if (event.snapshot.exists) {
        return event.snapshot.value as int;
      }
      return 5;
    });
  }

  /// Escuchar cambios en el progreso general
  Stream<Map<String, dynamic>> listenToProgress() {
    final userRef = _userRef;
    if (userRef == null) return Stream.value({});

    return userRef.child('progress').onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return {};
    });
  }
}
