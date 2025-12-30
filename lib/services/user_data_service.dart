import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Servicio para gestionar los datos del usuario en Firebase Realtime Database
/// Maneja la sincronización completa del progreso del usuario
class UserDataService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtener el ID del usuario actual
  String? get currentUserId => _auth.currentUser?.uid;

  /// Referencia al nodo del usuario actual
  DatabaseReference? get _userRef {
    final uid = currentUserId;
    if (uid == null) return null;
    return _database.child('users').child(uid);
  }

  // ==================== PERFIL ====================

  /// Crear o actualizar el perfil del usuario
  Future<void> createOrUpdateProfile({
    required String name,
    required String email,
    String? username,
    String? profileImage,
    String? avatarJson,
    String? avatarSvg,
    bool? useCustomAvatar,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    // Generar avatar aleatorio si no se proporciona uno
    String? finalAvatarJson = avatarJson;
    bool finalUseCustomAvatar = useCustomAvatar ?? false;

    if (finalAvatarJson == null &&
        (profileImage == null || profileImage.isEmpty)) {
      finalAvatarJson = "avatar${Random().nextInt(30) + 1}";
      finalUseCustomAvatar = true;
    }

    final profileData = {
      'uid': currentUserId,
      'displayName': name, // Usar displayName según documentación
      'name': name, // Mantener name por compatibilidad
      'email': email,
      'username': username ?? email.split('@')[0],
      'profileImage': profileImage ?? '',
      'avatarJson': finalAvatarJson,
      'avatarSvg': avatarSvg,
      'useCustomAvatar': finalUseCustomAvatar,
      'createdAt': ServerValue.timestamp,
      'lastLogin': ServerValue.timestamp,
    };

    await userRef.child('profile').set(profileData);
    print('✅ Perfil de usuario creado/actualizado en Firebase');
  }

  /// Actualizar último inicio de sesión
  Future<void> updateLastLogin() async {
    final userRef = _userRef;
    if (userRef == null) return;

    await userRef.child('profile/lastLogin').set(ServerValue.timestamp);
  }

  /// Obtener perfil del usuario
  Future<Map<String, dynamic>?> getProfile() async {
    final userRef = _userRef;
    if (userRef == null) return null;

    final snapshot = await userRef.child('profile').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  // ==================== PROGRESO ====================

  /// Guardar progreso del usuario (nivel, experiencia, etc.)
  Future<void> saveProgress({
    required int level,
    required int experiencePoints,
    required int experienceToNextLevel,
    required double experienceProgress,
    required int consecutiveDays,
    required List<int> hoursPerDay,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final progressData = {
      'level': level,
      'experiencePoints': experiencePoints,
      'experienceToNextLevel': experienceToNextLevel,
      'experienceProgress': experienceProgress,
      'consecutiveDays': consecutiveDays,
      'hoursPerDay': hoursPerDay,
      'lastActivityDate': DateTime.now().toIso8601String().split('T')[0],
      'totalDaysUsed': consecutiveDays, // Por ahora igual, se puede mejorar
    };

    await userRef.child('progress').set(progressData);
    print('✅ Progreso guardado en Firebase');
  }

  // ==================== SOCIAL ====================

  /// Obtener todos los usuarios para la lista global
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      print('🔍 Buscando usuarios en Firebase...');
      final snapshot = await _database.child('users').get();
      if (snapshot.exists && snapshot.value != null) {
        final Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> usersList = [];

        print('🔍 Total de nodos encontrados: ${usersMap.length}');

        usersMap.forEach((key, value) {
          // Ignorar si no es un mapa válido
          if (value is! Map) return;

          final profile = value['profile'] ?? {};
          final progress = value['progress'] ?? {};
          final store = value['store'] ?? {};
          final resources = value['resources'] ?? {};
          final economy = value['economy'] ?? {};

          // Obtener nombre (compatibilidad con ambos modelos)
          final name = profile['name'] ?? profile['displayName'];
          if (name == null) {
            print('⚠️ Usuario $key ignorado: Sin nombre');
            return;
          }

          // Obtener monedas (compatibilidad con ambos modelos)
          int coins = 0;
          if (resources['coins'] != null) {
            coins = resources['coins'];
          } else if (economy['coins'] != null) {
            coins = economy['coins'];
          } else if (store['coins'] != null) {
            coins = store['coins'];
          }

          print('✅ Usuario encontrado: $name ($key)');

          usersList.add({
            'uid': key,
            'name': name,
            'username': profile['username'] ?? 'user',
            'profileImage': profile['profileImage'] ?? '',
            'avatarJson': profile['avatarJson'],
            'avatarSvg': profile['avatarSvg'],
            'useCustomAvatar': profile['useCustomAvatar'] ?? true,
            'level': progress['level'] ?? 1,
            'experienceProgress':
                (progress['experienceProgress'] ?? 0.0).toDouble(),
            'coins': coins,
          });
        });

        return usersList;
      }
    } catch (e) {
      print('Error al obtener usuarios globales: $e');
    }
    return [];
  }

  /// Obtener progreso del usuario
  Future<Map<String, dynamic>?> getProgress() async {
    final userRef = _userRef;
    if (userRef == null) return null;

    final snapshot = await userRef.child('progress').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  /// Incrementar experiencia
  Future<void> addExperience(int points) async {
    final userRef = _userRef;
    if (userRef == null) return;

    final progressSnapshot = await userRef.child('progress').get();
    if (!progressSnapshot.exists) return;

    final progress = Map<String, dynamic>.from(progressSnapshot.value as Map);
    int currentExp = progress['experiencePoints'] ?? 0;
    int expToNext = progress['experienceToNextLevel'] ?? 600;
    int level = progress['level'] ?? 1;

    currentExp += points;

    // Subir de nivel si es necesario
    while (currentExp >= expToNext) {
      level++;
      currentExp -= expToNext;
      expToNext = (expToNext * 1.5).round();
    }

    final experienceProgress = currentExp / expToNext;

    await userRef.child('progress').update({
      'experiencePoints': currentExp,
      'experienceToNextLevel': expToNext,
      'level': level,
      'experienceProgress': experienceProgress,
    });

    print('✅ Experiencia actualizada: +$points puntos');
  }

  // ==================== ECONOMÍA ====================

  /// Guardar datos de economía (monedas)
  Future<void> saveEconomy({
    required int coins,
    int? totalCoinsEarned,
    int? totalCoinsSpent,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    // Obtener totales actuales
    final resourcesSnapshot = await userRef.child('resources').get();
    int currentTotalEarned = 0;
    int currentTotalSpent = 0;

    if (resourcesSnapshot.exists) {
      final resources =
          Map<String, dynamic>.from(resourcesSnapshot.value as Map);
      currentTotalEarned = resources['totalCoinsEarned'] ?? 0;
      currentTotalSpent = resources['totalCoinsSpent'] ?? 0;
    }

    final resourcesData = {
      'coins': coins,
      'totalCoinsEarned': totalCoinsEarned ?? currentTotalEarned,
      'totalCoinsSpent': totalCoinsSpent ?? currentTotalSpent,
      'lastCoinUpdate': ServerValue.timestamp,
    };

    // Usar update para no sobrescribir otros recursos si existen
    await userRef.child('resources').update(resourcesData);
    print('✅ Economía guardada en Firebase (resources): $coins monedas');
  }

  /// Agregar monedas
  Future<void> addCoins(int amount) async {
    final userRef = _userRef;
    if (userRef == null) return;

    final resourcesSnapshot = await userRef.child('resources').get();
    int currentCoins = 0;
    int totalEarned = 0;

    if (resourcesSnapshot.exists) {
      final resources =
          Map<String, dynamic>.from(resourcesSnapshot.value as Map);
      currentCoins = resources['coins'] ?? 0;
      totalEarned = resources['totalCoinsEarned'] ?? 0;
    }

    await userRef.child('resources').update({
      'coins': currentCoins + amount,
      'totalCoinsEarned': totalEarned + amount,
      'lastCoinUpdate': ServerValue.timestamp,
    });

    print('✅ Monedas agregadas (resources): +$amount');
  }

  /// Gastar monedas
  Future<bool> spendCoins(int amount) async {
    final userRef = _userRef;
    if (userRef == null) return false;

    final resourcesSnapshot = await userRef.child('resources').get();
    int currentCoins = 0;
    int totalSpent = 0;

    if (resourcesSnapshot.exists) {
      final resources =
          Map<String, dynamic>.from(resourcesSnapshot.value as Map);
      currentCoins = resources['coins'] ?? 0;
      totalSpent = resources['totalCoinsSpent'] ?? 0;
    }

    if (currentCoins < amount) {
      print('❌ Monedas insuficientes');
      return false;
    }

    await userRef.child('resources').update({
      'coins': currentCoins - amount,
      'totalCoinsSpent': totalSpent + amount,
      'lastCoinUpdate': ServerValue.timestamp,
    });

    print('✅ Monedas gastadas (resources): -$amount');
    return true;
  }

  /// Obtener economía del usuario
  Future<Map<String, dynamic>?> getEconomy() async {
    final userRef = _userRef;
    if (userRef == null) return null;

    final snapshot = await userRef.child('resources').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  // ==================== TIENDA ====================

  /// Guardar compra en la tienda
  Future<void> savePurchase({
    required String itemId,
    required String category,
    required int price,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final purchaseData = {
      'itemId': itemId,
      'category': category,
      'purchaseDate': ServerValue.timestamp,
      'price': price,
    };

    await userRef.child('store/purchasedItems/$itemId').set(purchaseData);
    print('✅ Compra guardada en Firebase: $itemId');
  }

  /// Actualizar selección de maceta/fondo
  Future<void> updateStoreSelection({
    String? selectedPotId,
    String? selectedBackgroundId,
  }) async {
    final userRef = _userRef;
    if (userRef == null) return;

    final updates = <String, dynamic>{};
    if (selectedPotId != null) {
      updates['store/selectedPotId'] = selectedPotId;
    }
    if (selectedBackgroundId != null) {
      updates['store/selectedBackgroundId'] = selectedBackgroundId;
    }

    await userRef.update(updates);
    print('✅ Selección actualizada en Firebase');
  }

  /// Obtener datos de la tienda
  Future<Map<String, dynamic>?> getStoreData() async {
    final userRef = _userRef;
    if (userRef == null) return null;

    final snapshot = await userRef.child('store').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  // ==================== LOGROS ====================

  /// Desbloquear logro
  Future<void> unlockAchievement(String achievementId, String category) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final achievementData = {
      'id': achievementId,
      'unlockedAt': ServerValue.timestamp,
    };

    await userRef
        .child('achievements/$category/$achievementId')
        .set(achievementData);

    // Actualizar resumen
    await _updateAchievementsSummary();

    print('✅ Logro desbloqueado: $achievementId ($category)');
  }

  /// Actualizar resumen de logros
  Future<void> _updateAchievementsSummary() async {
    final userRef = _userRef;
    if (userRef == null) return;

    final achievementsSnapshot = await userRef.child('achievements').get();
    if (!achievementsSnapshot.exists) return;

    final achievements =
        Map<String, dynamic>.from(achievementsSnapshot.value as Map);

    int totalMedals = 0;
    int totalPlants = 0;
    int totalCreatures = 0;

    if (achievements.containsKey('medals')) {
      totalMedals = (achievements['medals'] as Map).length;
    }
    if (achievements.containsKey('plants')) {
      totalPlants = (achievements['plants'] as Map).length;
    }
    if (achievements.containsKey('creatures')) {
      totalCreatures = (achievements['creatures'] as Map).length;
    }

    await userRef.child('achievements/summary').set({
      'totalMedals': totalMedals,
      'totalPlants': totalPlants,
      'totalCreatures': totalCreatures,
      'lastAchievementUnlocked': ServerValue.timestamp,
    });
  }

  /// Obtener logros
  Future<Map<String, dynamic>?> getAchievements() async {
    final userRef = _userRef;
    if (userRef == null) return null;

    final snapshot = await userRef.child('achievements').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  // ==================== CONFIGURACIONES ====================

  /// Guardar configuraciones
  Future<void> saveSettings({
    required bool notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? soundEnabled,
    String? language,
    String? theme,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    final settingsData = {
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications ?? true,
      'pushNotifications': pushNotifications ?? true,
      'soundEnabled': soundEnabled ?? true,
      'language': language ?? 'es',
      'theme': theme ?? 'light',
    };

    await userRef.child('settings').set(settingsData);
    print('✅ Configuraciones guardadas en Firebase');
  }

  /// Obtener configuraciones
  Future<Map<String, dynamic>?> getSettings() async {
    final userRef = _userRef;
    if (userRef == null) return null;

    final snapshot = await userRef.child('settings').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  // ==================== SINCRONIZACIÓN COMPLETA ====================

  /// Cargar todos los datos del usuario desde Firebase
  Future<Map<String, dynamic>?> loadAllUserData() async {
    final userRef = _userRef;
    if (userRef == null) {
      print('❌ Usuario no autenticado');
      return null;
    }

    print('🔄 Cargando datos del usuario desde Firebase...');

    final snapshot = await userRef.get();
    if (!snapshot.exists) {
      print('⚠️ No hay datos guardados para este usuario');
      return null;
    }

    final userData = Map<String, dynamic>.from(snapshot.value as Map);
    print('✅ Datos del usuario cargados desde Firebase');

    return userData;
  }

  /// Guardar todos los datos del usuario en Firebase
  Future<void> saveAllUserData({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> progress,
    required Map<String, dynamic> resources,
    required Map<String, dynamic> store,
    required Map<String, dynamic> achievements,
    required Map<String, dynamic> settings,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    print('💾 Guardando todos los datos del usuario en Firebase...');

    final userData = {
      'profile': profile,
      'progress': progress,
      'resources': resources,
      'store': store,
      'achievements': achievements,
      'settings': settings,
    };

    await userRef.set(userData);
    print('✅ Todos los datos guardados en Firebase');
  }

  /// Verificar si el usuario ya existe en la base de datos
  Future<bool> userExists() async {
    final userRef = _userRef;
    if (userRef == null) return false;

    final snapshot = await userRef.get();
    return snapshot.exists;
  }

  /// Inicializar datos por defecto para nuevo usuario
  Future<void> initializeNewUser({
    required String name,
    required String email,
  }) async {
    final userRef = _userRef;
    if (userRef == null) throw Exception('Usuario no autenticado');

    print('🆕 Inicializando nuevo usuario en Firebase...');

    final userData = {
      'profile': {
        'uid': currentUserId,
        'displayName': name, // Usar displayName según documentación
        'name': name, // Mantener name por compatibilidad
        'email': email,
        'username': email.split('@')[0],
        'profileImage': '',
        'useCustomAvatar': true,
        'avatarJson': "avatar${Random().nextInt(30) + 1}",
        'createdAt': ServerValue.timestamp,
        'lastLogin': ServerValue.timestamp,
      },
      'progress': {
        'level': 1,
        'experiencePoints': 0,
        'experienceToNextLevel': 600,
        'experienceProgress': 0.0,
        'consecutiveDays': 0,
        'hoursPerDay': [],
        'totalDaysUsed': 0,
        'lastActivityDate': DateTime.now().toIso8601String().split('T')[0],
      },
      'resources': {
        'coins': 100000, // Monedas iniciales
        'totalCoinsEarned': 100000,
        'totalCoinsSpent': 0,
        'lastCoinUpdate': ServerValue.timestamp,
      },
      'store': {
        'selectedPotId': 'maceta_01',
        'selectedBackgroundId': 'fondo_misti',
        'purchasedItems': {
          'maceta_01': {
            'itemId': 'maceta_01',
            'category': 'Macetas',
            'purchaseDate': ServerValue.timestamp,
            'price': 0,
          },
          'fondo_misti': {
            'itemId': 'fondo_misti',
            'category': 'Fondos',
            'purchaseDate': ServerValue.timestamp,
            'price': 0,
          },
        },
      },
      'achievements': {
        'medals': {},
        'plants': {},
        'creatures': {},
        'summary': {
          'totalMedals': 0,
          'totalPlants': 0,
          'totalCreatures': 0,
        },
      },
      'settings': {
        'notificationsEnabled': true,
        'emailNotifications': true,
        'pushNotifications': true,
        'soundEnabled': true,
        'language': 'es',
        'theme': 'light',
      },
      'social': {
        'friends': {},
        'friendRequests': {
          'sent': {},
          'received': {},
        },
      },
      'statistics': {
        'totalTimeInApp': 0,
        'plantsMonitored': 0,
        'dataPointsCollected': 0,
        'alertsReceived': 0,
        'alertsResolved': 0,
        'perfectDays': 0,
        'longestStreak': 0,
        'firstUseDate': DateTime.now().toIso8601String(),
      },
    };

    await userRef.set(userData);
    print('✅ Nuevo usuario inicializado en Firebase');
  }

  /// Eliminar todos los datos del usuario (útil para testing o eliminación de cuenta)
  Future<void> deleteUserData() async {
    final userRef = _userRef;
    if (userRef == null) return;

    await userRef.remove();
    print('🗑️ Datos del usuario eliminados de Firebase');
  }

  // ==================== STREAM EN TIEMPO REAL ====================

  /// Escuchar cambios en tiempo real del perfil
  Stream<Map<String, dynamic>?> watchProfile() {
    final userRef = _userRef;
    if (userRef == null) return Stream.value(null);

    return userRef.child('profile').onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }

  /// Escuchar cambios en tiempo real del progreso
  Stream<Map<String, dynamic>?> watchProgress() {
    final userRef = _userRef;
    if (userRef == null) return Stream.value(null);

    return userRef.child('progress').onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }

  /// Escuchar cambios en tiempo real de la economía
  Stream<Map<String, dynamic>?> watchEconomy() {
    final userRef = _userRef;
    if (userRef == null) return Stream.value(null);

    return userRef.child('resources').onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }
}
