import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_cloud/services/user_data_service.dart';
import 'package:green_cloud/models/user.dart';
import 'package:green_cloud/models/store_model.dart';
import 'package:green_cloud/models/achievements_model.dart';

/// Servicio de sincronización que conecta los modelos locales con Firebase
class UserSyncService {
  final UserDataService _userDataService = UserDataService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  /// Inicializar usuario: cargar datos o crear nuevo
  Future<void> initializeUser({
    required UserModel userModel,
    required StoreModel storeModel,
    required AchievementsModel achievementsModel,
  }) async {
    if (_isSyncing) {
      print('⚠️ Ya hay una sincronización en progreso');
      return;
    }

    _isSyncing = true;
    print('🔄 === INICIANDO SINCRONIZACIÓN DE USUARIO ===');

    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ No hay usuario autenticado');
        _isSyncing = false;
        return;
      }

      // Verificar si el usuario ya existe en Firebase
      final exists = await _userDataService.userExists();

      if (!exists) {
        // NUEVO USUARIO: Inicializar en Firebase
        print('🆕 Nuevo usuario detectado, inicializando en Firebase...');
        await _initializeNewUser(
            user, userModel, storeModel, achievementsModel);
      } else {
        // USUARIO EXISTENTE: Cargar datos desde Firebase
        print('👤 Usuario existente, cargando datos desde Firebase...');
        await _loadExistingUser(userModel, storeModel, achievementsModel);
      }

      // Actualizar último inicio de sesión
      await _userDataService.updateLastLogin();

      print('✅ === SINCRONIZACIÓN COMPLETADA ===');
    } catch (e) {
      print('❌ Error en sincronización: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Inicializar nuevo usuario en Firebase
  Future<void> _initializeNewUser(
    User firebaseUser,
    UserModel userModel,
    StoreModel storeModel,
    AchievementsModel achievementsModel,
  ) async {
    // Crear datos iniciales en Firebase
    await _userDataService.initializeNewUser(
      name: firebaseUser.displayName ?? 'Usuario',
      email: firebaseUser.email ?? '',
    );

    // Actualizar modelos locales con datos por defecto
    userModel.name = firebaseUser.displayName ?? 'Usuario';
    userModel.email = firebaseUser.email ?? '';
    userModel.username = firebaseUser.email?.split('@')[0] ?? 'usuario';

    print('✅ Nuevo usuario inicializado');
  }

  /// Cargar datos de usuario existente desde Firebase
  Future<void> _loadExistingUser(
    UserModel userModel,
    StoreModel storeModel,
    AchievementsModel achievementsModel,
  ) async {
    final userData = await _userDataService.loadAllUserData();
    if (userData == null) {
      print('⚠️ No se pudieron cargar los datos del usuario');
      return;
    }

    // Cargar perfil y progreso
    if (userData.containsKey('profile') || userData.containsKey('progress')) {
      final profileRaw = userData['profile'];
      final profile =
          profileRaw is Map ? Map<String, dynamic>.from(profileRaw) : null;
      final progressRaw = userData['progress'];
      final progress =
          progressRaw is Map ? Map<String, dynamic>.from(progressRaw) : null;

      userModel.loadFromFirebase(
        name: profile?['name'] as String?,
        username: profile?['username'] as String?,
        email: profile?['email'] as String?,
        profileImage: profile?['profileImage'] as String?,
        avatarJson: profile?['avatarJson'] as String?,
        avatarSvg: profile?['avatarSvg'] as String?,
        useCustomAvatar: profile?['useCustomAvatar'] as bool?,
        level: progress?['level'] as int?,
        experiencePoints: progress?['experiencePoints'] as int?,
        experienceToNextLevel: progress?['experienceToNextLevel'] as int?,
        experienceProgress: progress?['experienceProgress'] as double?,
        consecutiveDays: progress?['consecutiveDays'] as int?,
        hoursPerDay: progress?['hoursPerDay'] != null
            ? List<int>.from(progress!['hoursPerDay'] as List)
            : null,
      );
      print('✅ Perfil y progreso cargados');
    }

    // Cargar economía y tienda
    if (userData.containsKey('economy') || userData.containsKey('store')) {
      final economyRaw = userData['economy'];
      final economy =
          economyRaw is Map ? Map<String, dynamic>.from(economyRaw) : null;
      final storeRaw = userData['store'];
      final store =
          storeRaw is Map ? Map<String, dynamic>.from(storeRaw) : null;

      storeModel.loadFromFirebase(
        coins: economy?['coins'] as int?,
        selectedPotId: store?['selectedPotId'] as String?,
        selectedBackgroundId: store?['selectedBackgroundId'] as String?,
        purchasedItems: store?['purchasedItems'] as Map<String, dynamic>?,
      );
      print('✅ Economía y tienda cargadas');
    }

    // Cargar logros
    if (userData.containsKey('achievements')) {
      final achievementsRaw = userData['achievements'];
      final achievements = achievementsRaw is Map
          ? Map<String, dynamic>.from(achievementsRaw)
          : <String, dynamic>{};

      achievementsModel.loadFromFirebase(
        medals: achievements['medals'] as Map<String, dynamic>?,
        plants: achievements['plants'] as Map<String, dynamic>?,
        creatures: achievements['creatures'] as Map<String, dynamic>?,
      );
      print('✅ Logros cargados');
    }

    // Cargar configuraciones
    if (userData.containsKey('settings')) {
      final settingsRaw = userData['settings'];
      final settings = settingsRaw is Map
          ? Map<String, dynamic>.from(settingsRaw)
          : <String, dynamic>{};
      userModel.notificationsEnabled = settings['notificationsEnabled'] ?? true;
      print('✅ Configuraciones cargadas');
    }

    print('✅ Datos cargados exitosamente desde Firebase');
  }

  /// Sincronizar perfil del usuario
  Future<void> syncProfile(UserModel userModel) async {
    try {
      await _userDataService.createOrUpdateProfile(
        name: userModel.name,
        email: userModel.email,
        username: userModel.username,
        profileImage: userModel.profileImage,
        avatarJson: userModel.avatarJson,
        avatarSvg: userModel.avatarSvg,
        useCustomAvatar: userModel.useCustomAvatar,
      );
      print('✅ Perfil sincronizado con Firebase');
    } catch (e) {
      print('❌ Error sincronizando perfil: $e');
    }
  }

  /// Sincronizar progreso del usuario
  Future<void> syncProgress(UserModel userModel) async {
    try {
      await _userDataService.saveProgress(
        level: userModel.level,
        experiencePoints: userModel.experiencePoints,
        experienceToNextLevel: userModel.experienceToNextLevel,
        experienceProgress: userModel.experienceProgress,
        consecutiveDays: userModel.consecutiveDays,
        hoursPerDay: userModel.hoursPerDay,
      );
      print('✅ Progreso sincronizado con Firebase');
    } catch (e) {
      print('❌ Error sincronizando progreso: $e');
    }
  }

  /// Sincronizar economía
  Future<void> syncEconomy(StoreModel storeModel) async {
    try {
      await _userDataService.saveEconomy(
        coins: storeModel.coins,
      );
      print('✅ Economía sincronizada con Firebase');
    } catch (e) {
      print('❌ Error sincronizando economía: $e');
    }
  }

  /// Sincronizar compra
  Future<void> syncPurchase({
    required String itemId,
    required String category,
    required int price,
  }) async {
    try {
      await _userDataService.savePurchase(
        itemId: itemId,
        category: category,
        price: price,
      );
      print('✅ Compra sincronizada con Firebase: $itemId');
    } catch (e) {
      print('❌ Error sincronizando compra: $e');
    }
  }

  /// Sincronizar selección de tienda
  Future<void> syncStoreSelection({
    String? selectedPotId,
    String? selectedBackgroundId,
  }) async {
    try {
      await _userDataService.updateStoreSelection(
        selectedPotId: selectedPotId,
        selectedBackgroundId: selectedBackgroundId,
      );
      print('✅ Selección de tienda sincronizada con Firebase');
    } catch (e) {
      print('❌ Error sincronizando selección: $e');
    }
  }

  /// Sincronizar logro desbloqueado
  Future<void> syncAchievement(String achievementId, String category) async {
    try {
      await _userDataService.unlockAchievement(achievementId, category);
      print('✅ Logro sincronizado con Firebase: $achievementId');
    } catch (e) {
      print('❌ Error sincronizando logro: $e');
    }
  }

  /// Sincronizar configuraciones
  Future<void> syncSettings(UserModel userModel) async {
    try {
      await _userDataService.saveSettings(
        notificationsEnabled: userModel.notificationsEnabled,
      );
      print('✅ Configuraciones sincronizadas con Firebase');
    } catch (e) {
      print('❌ Error sincronizando configuraciones: $e');
    }
  }

  /// Sincronización completa (manual o periódica)
  Future<void> fullSync({
    required UserModel userModel,
    required StoreModel storeModel,
    required AchievementsModel achievementsModel,
  }) async {
    if (_isSyncing) return;

    _isSyncing = true;
    print('🔄 === SINCRONIZACIÓN COMPLETA INICIADA ===');

    try {
      await Future.wait([
        syncProfile(userModel),
        syncProgress(userModel),
        syncEconomy(storeModel),
        syncSettings(userModel),
      ]);

      print('✅ === SINCRONIZACIÓN COMPLETA EXITOSA ===');
    } catch (e) {
      print('❌ Error en sincronización completa: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Cerrar sesión y limpiar datos
  Future<void> signOut() async {
    print('👋 Cerrando sesión y sincronizando datos finales...');
    // No limpiamos los datos de Firebase, solo cerramos sesión
    _isSyncing = false;
  }
}
