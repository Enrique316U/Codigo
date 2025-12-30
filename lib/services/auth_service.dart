import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

/// Servicio de autenticación con Firebase
/// Ahora usa username + password en lugar de email
/// Mantiene la sesión persistente automáticamente con Firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Stream para escuchar cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Verificar si el usuario está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  // Obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ==================== REGISTRO CON USERNAME ====================

  /// Registra un nuevo usuario usando username y password
  /// Internamente crea un email falso (username@greencloud.local)
  /// Verifica que el username no esté en uso
  Future<UserCredential?> registerWithUsername({
    required String username,
    required String password,
    required String displayName,
  }) async {
    try {
      // 1. Validar que el username no exista
      final usernameExists = await checkUsernameExists(username);
      if (usernameExists) {
        throw FirebaseAuthException(
          code: 'username-already-in-use',
          message: 'Este nombre de usuario ya está en uso',
        );
      }

      // 2. Validar formato del username
      if (!_isValidUsername(username)) {
        throw FirebaseAuthException(
          code: 'invalid-username',
          message:
              'El nombre de usuario solo puede contener letras, números y guiones bajos (3-20 caracteres)',
        );
      }

      // 3. Crear email interno (no visible para el usuario)
      final internalEmail = '$username@greencloud.local';

      // 4. Crear usuario en Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: internalEmail,
        password: password,
      );

      // 5. Actualizar el displayName del usuario
      await userCredential.user?.updateDisplayName(displayName);

      // 6. Guardar el username en la base de datos
      await _saveUsernameMapping(username, userCredential.user!.uid);

      // 7. Guardar localmente para recuperación rápida
      await _secureStorage.write(key: 'username', value: username);
      await _secureStorage.write(key: 'uid', value: userCredential.user!.uid);

      print('✅ Usuario registrado: $username');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ Error en registro: ${e.code}');
      rethrow;
    } catch (e) {
      print('❌ Error inesperado en registro: $e');
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Error inesperado al registrar usuario',
      );
    }
  }

  // ==================== LOGIN CON USERNAME ====================

  /// Inicia sesión con username y password
  Future<UserCredential?> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Obtener el UID asociado al username
      final uid = await _getUidFromUsername(username);
      if (uid == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No existe una cuenta con este nombre de usuario',
        );
      }

      // 2. Crear email interno
      final internalEmail = '$username@greencloud.local';

      // 3. Iniciar sesión con Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: internalEmail,
        password: password,
      );

      // 4. Guardar localmente para recuperación rápida
      await _secureStorage.write(key: 'username', value: username);
      await _secureStorage.write(key: 'uid', value: userCredential.user!.uid);

      print('✅ Sesión iniciada: $username');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ Error en login: ${e.code}');
      rethrow;
    } catch (e) {
      print('❌ Error inesperado en login: $e');
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Error inesperado al iniciar sesión',
      );
    }
  }

  // ==================== CERRAR SESIÓN ====================

  /// Cierra la sesión del usuario
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _secureStorage.deleteAll(); // Limpiar datos locales
      print('✅ Sesión cerrada');
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
    }
  }

  // ==================== UTILIDADES ====================

  /// Verificar si un username ya existe
  Future<bool> checkUsernameExists(String username) async {
    try {
      final snapshot = await _database
          .child('usernames')
          .child(username.toLowerCase())
          .get()
          .timeout(const Duration(seconds: 5));
      return snapshot.exists;
    } catch (e) {
      print('❌ Error al verificar username: $e');
      return false;
    }
  }

  /// Obtener UID desde username
  Future<String?> _getUidFromUsername(String username) async {
    try {
      final snapshot = await _database
          .child('usernames')
          .child(username.toLowerCase())
          .get();

      if (snapshot.exists) {
        return snapshot.value as String?;
      }
      return null;
    } catch (e) {
      print('❌ Error al obtener UID: $e');
      return null;
    }
  }

  /// Guardar mapeo username -> UID
  Future<void> _saveUsernameMapping(String username, String uid) async {
    try {
      await _database.child('usernames').child(username.toLowerCase()).set(uid);
    } catch (e) {
      print('❌ Error al guardar username: $e');
    }
  }

  /// Validar formato del username
  bool _isValidUsername(String username) {
    // Solo letras, números y guiones bajos, entre 3 y 20 caracteres
    final regex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return regex.hasMatch(username);
  }

  /// Obtener username guardado localmente
  Future<String?> getSavedUsername() async {
    try {
      return await _secureStorage.read(key: 'username');
    } catch (e) {
      return null;
    }
  }

  /// Obtener username del usuario actual desde Firebase
  Future<String?> getCurrentUsername() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      // Buscar en el mapeo de usernames
      final snapshot = await _database.child('usernames').get();
      if (snapshot.exists) {
        final usernamesMap = Map<String, dynamic>.from(snapshot.value as Map);

        // Buscar el username que corresponde al UID actual
        for (var entry in usernamesMap.entries) {
          if (entry.value == user.uid) {
            return entry.key;
          }
        }
      }

      // Si no se encuentra, intentar obtener del almacenamiento local
      return await getSavedUsername();
    } catch (e) {
      print('❌ Error al obtener username actual: $e');
      return await getSavedUsername();
    }
  }

  // ==================== MÉTODOS DE LOGIN ANTIGUO (COMPATIBILIDAD) ====================

  /// Login con email y password (usado por login_screen.dart antiguo)
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      print('📧 Intentando login con email: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Login con email exitoso');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ Error en login con email: ${e.code}');
      rethrow;
    }
  }

  /// Registro con email y password (usado por register_screen.dart antiguo)
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      print('📧 Creando cuenta con email: $email');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Cuenta creada exitosamente');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ Error al crear cuenta: ${e.code}');
      rethrow;
    }
  }

  /// Login con Google (requiere google_sign_in package)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔍 Login con Google no está configurado');
      throw FirebaseAuthException(
        code: 'not-configured',
        message:
            'El login con Google no está configurado. Usa email y contraseña.',
      );
    } catch (e) {
      print('❌ Error en login con Google: $e');
      rethrow;
    }
  }

  /// Login con Facebook (requiere flutter_facebook_auth package)
  Future<UserCredential?> signInWithFacebook() async {
    try {
      print('📘 Login con Facebook no está configurado');
      throw FirebaseAuthException(
        code: 'not-configured',
        message:
            'El login con Facebook no está configurado. Usa email y contraseña.',
      );
    } catch (e) {
      print('❌ Error en login con Facebook: $e');
      rethrow;
    }
  }

  /// Enviar email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      print('📧 Enviando email de recuperación a: $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Email de recuperación enviado');
    } on FirebaseAuthException catch (e) {
      print('❌ Error al enviar email de recuperación: ${e.code}');
      rethrow;
    }
  }

  // ==================== MENSAJES DE ERROR ====================

  /// Obtener mensaje de error amigable
  String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este correo electrónico';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'username-already-in-use':
          return 'Este nombre de usuario ya está en uso';
        case 'email-already-in-use':
          return 'Este nombre de usuario ya está en uso';
        case 'weak-password':
          return 'La contraseña debe tener al menos 6 caracteres';
        case 'invalid-email':
          return 'El correo electrónico no es válido';
        case 'invalid-username':
          return 'El nombre de usuario no es válido';
        case 'too-many-requests':
          return 'Demasiados intentos fallidos. Intenta más tarde';
        case 'network-request-failed':
          return 'Error de conexión. Verifica tu internet';
        case 'invalid-credential':
          return 'Las credenciales son inválidas';
        case 'not-configured':
          return 'Esta opción de login no está disponible';
        default:
          return error.message ?? 'Error de autenticación desconocido';
      }
    }
    return 'Error inesperado: $error';
  }
}
