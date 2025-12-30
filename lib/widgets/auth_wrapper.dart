import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../screens/login/login_screen.dart';
import '../widgets/BottomNavBar.dart';
import '../screens/onboarding/01_splash_screen.dart';
import '../services/firebase_game_data_service.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../models/store_model.dart';
import '../models/achievements_model.dart';
import '../models/user_game_data.dart';

/// Widget que gestiona el estado de autenticación
/// Firebase mantiene automáticamente la sesión persistente
/// Solo pide login al abrir la app por primera vez
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final FirebaseGameDataService _gameDataService = FirebaseGameDataService();
  final AuthService _authService = AuthService();
  String? _initializedUserId;
  Future<void>? _initializationFuture;

  /// Inicializar datos del usuario desde Firebase
  Future<void> _initializeUserData(
    String userId,
    UserModel userModel,
    StoreModel storeModel,
    AchievementsModel achievementsModel,
  ) async {
    // Si ya está inicializado para este usuario, no hacer nada
    if (_initializedUserId == userId) {
      print('✅ Usuario ya inicializado: $userId');
      return;
    }

    print('🚀 Inicializando datos de usuario: $userId');

    try {
      // 1. Verificar si el usuario tiene datos guardados
      final hasData = await _gameDataService.userDataExists();

      UserGameData userData;

      if (!hasData) {
        // 2a. Si es nuevo usuario, crear datos por defecto
        print('🆕 Nuevo usuario detectado, creando datos iniciales...');

        final username = await _authService.getCurrentUsername() ?? 'usuario';

        userData = await _gameDataService.createNewUser(
          username: username,
          displayName: username,
        );
      } else {
        // 2b. Si ya existe, cargar datos
        print('📥 Cargando datos existentes...');
        userData = await _gameDataService.loadUserData() ??
            UserGameData.createDefault(
              uid: userId,
              username: 'usuario',
              displayName: 'Usuario',
            );
      }

      // 3. Sincronizar con los modelos locales (Provider)
      _syncWithLocalModels(userData, userModel, storeModel, achievementsModel);

      _initializedUserId = userId;
      print('✅ Usuario inicializado completamente: $userId');
    } catch (e) {
      print('❌ Error al inicializar usuario: $e');
      // Crear datos por defecto si falla la carga
      final defaultData = UserGameData.createDefault(
        uid: userId,
        username: 'usuario',
        displayName: 'Usuario',
      );
      _syncWithLocalModels(
          defaultData, userModel, storeModel, achievementsModel);
    }
  }

  /// Sincronizar datos de Firebase con los modelos locales (Provider)
  void _syncWithLocalModels(
    UserGameData userData,
    UserModel userModel,
    StoreModel storeModel,
    AchievementsModel achievementsModel,
  ) {
    print('🔄 Sincronizando datos con modelos locales...');

    // 1. Sincronizar UserModel
    userModel.loadFromFirebase(
      name: userData.displayName,
      username: userData.username,
      email: userData.email,
      profileImage: userData.profileImage,
      avatarJson: userData.avatarJson,
      avatarSvg: userData.avatarSvg,
      useCustomAvatar: userData.useCustomAvatar,
      level: userData.level,
      experienceProgress: userData.experienceProgress,
      experiencePoints: userData.experiencePoints,
      experienceToNextLevel: userData.experienceToNextLevel,
      notificationsEnabled: userData.notificationsEnabled,
      consecutiveDays: userData.consecutiveDays,
      hoursPerDay: userData.hoursPerDay,
    );

    // 2. Sincronizar StoreModel (Monedas)
    storeModel.setCoins(userData.coins);

    // 3. Sincronizar AchievementsModel (Logros)
    if (userData.unlockedAchievements.isNotEmpty) {
      for (final achievementId in userData.unlockedAchievements) {
        // Usar el nuevo método inteligente que detecta la categoría
        achievementsModel.unlockAnyAchievement(achievementId);
      }
    }

    print('✅ Sincronización completada');
  }

  @override
  Widget build(BuildContext context) {
    // Firebase mantiene la sesión automáticamente
    // authStateChanges() escucha cambios en el estado de autenticación
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('🔍 Estado de autenticación: ${snapshot.connectionState}');

        // Mostrar splash mientras se verifica el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('⏳ Verificando sesión persistente...');
          return const SplashScreen();
        }

        // Si hay usuario autenticado (sesión activa)
        if (snapshot.hasData) {
          final user = snapshot.data!;
          print('✅ Usuario autenticado: ${user.uid}');

          // Crear el Future solo una vez por usuario
          if (_initializedUserId != user.uid) {
            _initializationFuture = _initializeUserData(
              user.uid,
              Provider.of<UserModel>(context, listen: false),
              Provider.of<StoreModel>(context, listen: false),
              Provider.of<AchievementsModel>(context, listen: false),
            );
          }

          return FutureBuilder(
            future: _initializationFuture,
            builder: (context, initSnapshot) {
              if (initSnapshot.connectionState == ConnectionState.waiting) {
                print('⏳ Cargando datos del usuario...');
                return const SplashScreen();
              }

              if (initSnapshot.hasError) {
                print('❌ Error al cargar datos: ${initSnapshot.error}');
                // Aún así permitir acceso para evitar bloqueos
              }

              print('🎉 Mostrando pantalla principal');
              return const BottomNavBar();
            },
          );
        }

        // Si no hay usuario, mostrar login antiguo
        // Firebase solo llega aquí si realmente no hay sesión activa
        print('🔓 No hay usuario autenticado - Mostrar login antiguo');
        _initializedUserId = null;
        _initializationFuture = null;
        return LoginScreen();
      },
    );
  }
}
