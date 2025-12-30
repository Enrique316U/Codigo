import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_cloud/services/user_data_service.dart';

class UserModel extends ChangeNotifier {
  String _name = 'Enrique Miguel Paco Cusi';
  String _username = 'enriquempc';
  String _email = 'enrique.miguel@ejemplo.com';
  String _password = '********';
  String _profileImage = '';
  String? _avatarJson =
      "avatar${Random().nextInt(30) + 1}"; // Default random avatar
  String? _avatarSvg; // SVG del avatar personalizado
  bool _useCustomAvatar = true; // Default to true to avoid missing asset crash
  int _level = 2;
  double _experienceProgress = 0.4; // Progreso entre 0.0 y 1.0
  int _experiencePoints = 240;
  int _experienceToNextLevel = 600;
  bool _notificationsEnabled = true;
  List<Friend> _friends = [];
  List<GlobalUser> _globalUsers = [];

  // Estadísticas
  int _consecutiveDays = 1;
  List<int> _hoursPerDay = [0, 0, 0, 0, 0, 0, 0]; // Últimos 7 días
  DateTime? _lastLoginDate;

  UserModel() {
    _loadData();
    _initializeDemoData();
  }

  // Getters
  String get name => _name;
  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get profileImage => _profileImage;
  String? get avatarJson => _avatarJson;
  String? get avatarSvg => _avatarSvg;
  bool get useCustomAvatar => _useCustomAvatar;
  int get level => _level;
  double get experienceProgress => _experienceProgress;
  int get experiencePoints => _experiencePoints;
  int get experienceToNextLevel => _experienceToNextLevel;
  bool get notificationsEnabled => _notificationsEnabled;
  List<Friend> get friends => _friends;
  List<GlobalUser> get globalUsers => _globalUsers;
  int get consecutiveDays => _consecutiveDays;
  List<int> get hoursPerDay => _hoursPerDay;

  // Método para verificar y actualizar la racha diaria
  void _checkDailyStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastLoginDate == null) {
      // Primera vez
      _lastLoginDate = today;
      _consecutiveDays = 1;
      _saveData();
      return;
    }

    final lastLogin = DateTime(
        _lastLoginDate!.year, _lastLoginDate!.month, _lastLoginDate!.day);
    final difference = today.difference(lastLogin).inDays;

    if (difference == 0) {
      // Ya se logueó hoy, no hacer nada
      return;
    } else if (difference == 1) {
      // Se logueó ayer, aumentar racha
      _consecutiveDays++;
      // Actualizar horas: mover todo a la izquierda y poner 0 en hoy
      _shiftHours();
    } else {
      // Perdió la racha
      _consecutiveDays = 1;
      // Resetear o ajustar horas según los días perdidos
      for (int i = 0; i < difference; i++) {
        _shiftHours();
      }
    }

    _lastLoginDate = today;
    notifyListeners();
    _saveData();
  }

  void _shiftHours() {
    if (_hoursPerDay.isNotEmpty) {
      _hoursPerDay.removeAt(0);
      _hoursPerDay.add(0);
    } else {
      _hoursPerDay = [0, 0, 0, 0, 0, 0, 0];
    }
  }

  // Método para registrar tiempo de uso (simulado o real)
  // Se puede llamar periódicamente o al cerrar sesión
  void addSessionTime(int minutes) {
    if (_hoursPerDay.isEmpty) {
      _hoursPerDay = [0, 0, 0, 0, 0, 0, 0];
    }

    // Guardamos minutos directamente para mayor precisión
    _hoursPerDay[_hoursPerDay.length - 1] += minutes;

    notifyListeners();
    _saveData();
  }

  // Setters
  set name(String value) {
    _name = value;
    notifyListeners();
    _saveData();
  }

  set username(String value) {
    _username = value;
    notifyListeners();
    _saveData();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
    _saveData();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
    _saveData();
  }

  set notificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
    _saveData();
  }

  // Métodos para manejar avatar personalizado
  void updateAvatarData(String avatarJson, String avatarSvg) {
    _avatarJson = avatarJson;
    _avatarSvg = avatarSvg;
    _useCustomAvatar = true;
    notifyListeners();
    _saveData();
  }

  void setUseCustomAvatar(bool value) {
    _useCustomAvatar = value;
    notifyListeners();
    _saveData();
  }

  void clearCustomAvatar() {
    _avatarJson = null;
    _avatarSvg = null;
    _useCustomAvatar = false;
    notifyListeners();
    _saveData();
  }

  // Método para buscar usuarios
  List<GlobalUser> searchUsers(String query) {
    if (query.isEmpty) {
      return _globalUsers;
    }

    return _globalUsers.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.username.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Método para añadir experiencia
  void addExperience(int points) {
    _experiencePoints += points;

    // Comprobar si subimos de nivel
    if (_experiencePoints >= _experienceToNextLevel) {
      _level++;
      _experiencePoints -= _experienceToNextLevel;
      _experienceToNextLevel =
          (_experienceToNextLevel * 1.5).round(); // Aumentar dificultad
    }

    // Actualizar barra de progreso
    _experienceProgress = _experiencePoints / _experienceToNextLevel;

    notifyListeners();
    _saveData();
  }

  // Método para registrar un día más de uso
  void addConsecutiveDay() {
    _consecutiveDays++;
    notifyListeners();
    _saveData();
  }

  // Método para registrar horas de uso hoy
  void registerHoursToday(int hours) {
    if (_hoursPerDay.length >= 5) {
      _hoursPerDay.removeAt(0);
    }
    _hoursPerDay.add(hours);
    notifyListeners();
    _saveData();
  }

  // Métodos para actualizar desde Firebase (sin guardar localmente)
  void loadFromFirebase({
    String? name,
    String? username,
    String? email,
    String? profileImage,
    String? avatarJson,
    String? avatarSvg,
    bool? useCustomAvatar,
    int? level,
    double? experienceProgress,
    int? experiencePoints,
    int? experienceToNextLevel,
    bool? notificationsEnabled,
    int? consecutiveDays,
    List<int>? hoursPerDay,
  }) {
    if (name != null) _name = name;
    if (username != null) _username = username;
    if (email != null) _email = email;
    if (profileImage != null) _profileImage = profileImage;
    if (avatarJson != null) _avatarJson = avatarJson;
    if (avatarSvg != null) _avatarSvg = avatarSvg;
    if (useCustomAvatar != null) _useCustomAvatar = useCustomAvatar;
    if (level != null) _level = level;
    if (experienceProgress != null) _experienceProgress = experienceProgress;
    if (experiencePoints != null) _experiencePoints = experiencePoints;
    if (experienceToNextLevel != null)
      _experienceToNextLevel = experienceToNextLevel;
    if (notificationsEnabled != null)
      _notificationsEnabled = notificationsEnabled;
    if (consecutiveDays != null) _consecutiveDays = consecutiveDays;
    if (hoursPerDay != null) _hoursPerDay = hoursPerDay;

    // Verificar racha después de cargar datos remotos
    _checkDailyStreak();

    notifyListeners();
  }

  // Cargar usuarios globales reales desde Firebase
  Future<void> loadGlobalUsers() async {
    try {
      print('🌍 Cargando usuarios globales desde Firebase...');
      final userDataService = UserDataService();
      final usersData = await userDataService.getAllUsers();
      final currentUserId = userDataService.currentUserId;

      print('🌍 Usuarios encontrados: ${usersData.length}');

      // Limpiar lista actual para evitar duplicados o datos viejos
      _globalUsers = [];

      if (usersData.isNotEmpty) {
        // Mapear todos los usuarios, incluido el actual
        _globalUsers = usersData.map((data) {
          return GlobalUser(
            name: data['name'],
            username: data['username'],
            level: data['level'],
            experienceProgress: data['experienceProgress'],
            profileImage: data['profileImage'],
            coins: data['coins'],
            isFriend: false, // Por defecto
            avatarJson: data['avatarJson'],
            avatarSvg: data['avatarSvg'],
            useCustomAvatar: data['useCustomAvatar'] ?? false,
          );
        }).toList();

        // Ordenar por nivel descendente
        _globalUsers.sort((a, b) => b.level.compareTo(a.level));

        print('🌍 Usuarios globales procesados: ${_globalUsers.length}');

        // Actualizar lista de amigos (por ahora vacía o simulada con los top 3)
        // Si queremos simular amigos con usuarios reales:
        if (_globalUsers.length >= 3) {
          _friends = _globalUsers
              .take(3)
              .map((u) => Friend(
                    name: u.name,
                    username: u.username,
                    level: u.level,
                    experienceProgress: u.experienceProgress,
                    profileImage: u.profileImage,
                    coins: u.coins,
                    avatarJson: u.avatarJson,
                    avatarSvg: u.avatarSvg,
                    useCustomAvatar: u.useCustomAvatar,
                  ))
              .toList();
        } else {
          _friends = [];
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error cargando usuarios globales: $e');
    }
  }

  // Actualizar monedas sin notificar (usado por sincronización)
  void setCoinsFromFirebase(int coins) {
    // Este método será usado por StoreModel
  }

  // Inicializar datos demo
  void _initializeDemoData() {
    // Añadir amigos de ejemplo
    if (_friends.isEmpty) {
      _friends = [
        Friend(
          name: 'Leopoldo Castillo',
          username: 'leopoldoc',
          level: 3,
          experienceProgress: 0.6,
          profileImage: 'assets/friend.png',
          coins: 78,
        ),
        Friend(
          name: 'Ana Gómez',
          username: 'anagomez',
          level: 4,
          experienceProgress: 0.3,
          profileImage: 'assets/friend2.png',
          coins: 120,
        ),
        Friend(
          name: 'Carlos Mendoza',
          username: 'carlosmendoza',
          level: 2,
          experienceProgress: 0.9,
          profileImage: 'assets/friend3.png',
          coins: 65,
        ),
      ];
    }

    // Añadir usuarios globales de ejemplo
    // COMENTADO: Ya no usamos datos de ejemplo, solo usuarios reales de Firebase
    /*
    if (_globalUsers.isEmpty) {
      _globalUsers = [
        GlobalUser(
          name: 'Leopoldo Castillo',
          username: 'leopoldoc',
          level: 3,
          experienceProgress: 0.6,
          profileImage: 'assets/friend.png',
          coins: 78,
          isFriend: true,
        ),
        // ... otros usuarios demo ...
      ];
    }
    */

    notifyListeners();
  }

  // Guardar datos en SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _name);
    await prefs.setString('user_username', _username);
    await prefs.setString('user_email', _email);
    await prefs.setString('user_password', _password);
    await prefs.setString('user_profileImage', _profileImage);
    if (_avatarJson != null)
      await prefs.setString('user_avatarJson', _avatarJson!);
    if (_avatarSvg != null)
      await prefs.setString('user_avatarSvg', _avatarSvg!);
    await prefs.setBool('user_useCustomAvatar', _useCustomAvatar);
    await prefs.setInt('user_level', _level);
    await prefs.setDouble('user_experienceProgress', _experienceProgress);
    await prefs.setInt('user_experiencePoints', _experiencePoints);
    await prefs.setInt('user_experienceToNextLevel', _experienceToNextLevel);
    await prefs.setBool('user_notificationsEnabled', _notificationsEnabled);
    await prefs.setInt('user_consecutiveDays', _consecutiveDays);
    await prefs.setString('user_hoursPerDay', jsonEncode(_hoursPerDay));
    if (_lastLoginDate != null) {
      await prefs.setString(
          'user_lastLoginDate', _lastLoginDate!.toIso8601String());
    }

    // Guardar amigos
    final List<String> friendsJson =
        _friends.map((friend) => jsonEncode(friend.toJson())).toList();
    await prefs.setStringList('user_friends', friendsJson);

    // Guardar usuarios globales
    final List<String> globalUsersJson =
        _globalUsers.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('user_globalUsers', globalUsersJson);
  }

  // Cargar datos desde SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _name = prefs.getString('user_name') ?? _name;
      _username = prefs.getString('user_username') ?? _username;
      _email = prefs.getString('user_email') ?? _email;
      _password = prefs.getString('user_password') ?? _password;
      _profileImage = prefs.getString('user_profileImage') ?? _profileImage;
      _avatarJson = prefs.getString('user_avatarJson');
      _avatarSvg = prefs.getString('user_avatarSvg');
      _useCustomAvatar =
          prefs.getBool('user_useCustomAvatar') ?? _useCustomAvatar;

      // Si no hay avatar configurado, generar uno aleatorio por defecto
      if (_avatarJson == null && !_useCustomAvatar && (_profileImage.isEmpty)) {
        _avatarJson = "avatar${Random().nextInt(30) + 1}";
        _useCustomAvatar = true;
        // Guardar la configuración inicial
        await prefs.setString('user_avatarJson', _avatarJson!);
        await prefs.setBool('user_useCustomAvatar', true);
      }

      _level = prefs.getInt('user_level') ?? _level;
      _experienceProgress =
          prefs.getDouble('user_experienceProgress') ?? _experienceProgress;
      _experiencePoints =
          prefs.getInt('user_experiencePoints') ?? _experiencePoints;
      _experienceToNextLevel =
          prefs.getInt('user_experienceToNextLevel') ?? _experienceToNextLevel;
      _notificationsEnabled =
          prefs.getBool('user_notificationsEnabled') ?? _notificationsEnabled;
      _consecutiveDays =
          prefs.getInt('user_consecutiveDays') ?? _consecutiveDays;

      final String? lastLoginStr = prefs.getString('user_lastLoginDate');
      if (lastLoginStr != null) {
        _lastLoginDate = DateTime.parse(lastLoginStr);
      }

      final String? hoursPerDayJson = prefs.getString('user_hoursPerDay');
      if (hoursPerDayJson != null) {
        _hoursPerDay = List<int>.from(jsonDecode(hoursPerDayJson));
      }

      // Cargar amigos
      final List<String>? friendsJson = prefs.getStringList('user_friends');
      if (friendsJson != null && friendsJson.isNotEmpty) {
        _friends = friendsJson
            .map((json) => Friend.fromJson(jsonDecode(json)))
            .toList();
      }

      // Cargar usuarios globales
      final List<String>? globalUsersJson =
          prefs.getStringList('user_globalUsers');
      if (globalUsersJson != null && globalUsersJson.isNotEmpty) {
        _globalUsers = globalUsersJson
            .map((json) => GlobalUser.fromJson(jsonDecode(json)))
            .toList();
      }

      // Verificar racha después de cargar datos
      _checkDailyStreak();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      notifyListeners();
    }
  }
}

class Friend {
  final String name;
  final String username;
  final int level;
  final double experienceProgress;
  final String profileImage;
  final int coins;
  final String? avatarJson;
  final String? avatarSvg;
  final bool useCustomAvatar;

  Friend({
    required this.name,
    required this.username,
    required this.level,
    required this.experienceProgress,
    required this.profileImage,
    required this.coins,
    this.avatarJson,
    this.avatarSvg,
    this.useCustomAvatar = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'level': level,
      'experienceProgress': experienceProgress,
      'profileImage': profileImage,
      'coins': coins,
      'avatarJson': avatarJson,
      'avatarSvg': avatarSvg,
      'useCustomAvatar': useCustomAvatar,
    };
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['name'],
      username: json['username'],
      level: json['level'],
      experienceProgress: json['experienceProgress'],
      profileImage: json['profileImage'],
      coins: json['coins'],
      avatarJson: json['avatarJson'],
      avatarSvg: json['avatarSvg'],
      useCustomAvatar: json['useCustomAvatar'] ?? false,
    );
  }
}

class GlobalUser {
  final String name;
  final String username;
  final int level;
  final double experienceProgress;
  final String profileImage;
  final int coins;
  final bool isFriend;
  final String? avatarJson;
  final String? avatarSvg;
  final bool useCustomAvatar;

  GlobalUser({
    required this.name,
    required this.username,
    required this.level,
    required this.experienceProgress,
    required this.profileImage,
    required this.coins,
    required this.isFriend,
    this.avatarJson,
    this.avatarSvg,
    this.useCustomAvatar = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'level': level,
      'experienceProgress': experienceProgress,
      'profileImage': profileImage,
      'coins': coins,
      'isFriend': isFriend,
      'avatarJson': avatarJson,
      'avatarSvg': avatarSvg,
      'useCustomAvatar': useCustomAvatar,
    };
  }

  factory GlobalUser.fromJson(Map<String, dynamic> json) {
    return GlobalUser(
      name: json['name'],
      username: json['username'],
      level: json['level'],
      experienceProgress: json['experienceProgress'],
      profileImage: json['profileImage'],
      coins: json['coins'],
      isFriend: json['isFriend'],
      avatarJson: json['avatarJson'],
      avatarSvg: json['avatarSvg'],
      useCustomAvatar: json['useCustomAvatar'] ?? false,
    );
  }
}
