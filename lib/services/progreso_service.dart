import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_cloud/services/firebase_game_data_service.dart';

class ProgresoService {
  static const String _keyPrefix = 'progreso_';
  static const String _keyPuntuacionTotal = 'puntuacion_total';

  // Singleton
  static final ProgresoService _instance = ProgresoService._internal();
  factory ProgresoService() => _instance;
  ProgresoService._internal();

  final FirebaseGameDataService _firebaseService = FirebaseGameDataService();

  // Marcar actividad como completada
  Future<void> marcarActividadCompletada(
      int etapa, int seccion, int actividad, int puntuacion) async {
    print(
        '🎮 Marcando actividad completada: Etapa ${etapa + 1}, Sección ${seccion + 1}, Nodo ${actividad + 1}');

    try {
      // Calcular estrellas basado en puntuación
      int stars = _calculateStars(puntuacion);

      // Guardar en Firebase
      await _firebaseService.completeNode(
        etapa: etapa + 1, // Firebase usa 1-indexed
        seccion: seccion + 1,
        node: actividad + 1,
        stars: stars,
        score: puntuacion,
      );

      // Calcular recompensa de monedas (20 monedas por estrella)
      int coinsReward = stars * 20;
      await _firebaseService.addCoins(coinsReward);
      print('💰 Monedas ganadas: $coinsReward');

      // También guardar localmente (para compatibilidad con código existente)
      final prefs = await SharedPreferences.getInstance();
      String key =
          '${_keyPrefix}etapa_${etapa}_seccion_${seccion}_actividad_$actividad';
      await prefs.setBool(key, true);
      await prefs.setInt('${key}_puntuacion', puntuacion);

      // Actualizar puntuación total local
      int puntuacionActual = prefs.getInt(_keyPuntuacionTotal) ?? 0;
      await prefs.setInt(_keyPuntuacionTotal, puntuacionActual + puntuacion);

      // Verificar si se debe desbloquear siguiente nodo
      await _verificarDesbloqueoNodos(etapa, seccion);

      print('✅ Actividad completada y guardada en Firebase');
    } catch (e) {
      print('❌ Error al guardar actividad en Firebase: $e');
      // Continuar con guardado local aunque falle Firebase
      final prefs = await SharedPreferences.getInstance();
      String key =
          '${_keyPrefix}etapa_${etapa}_seccion_${seccion}_actividad_$actividad';
      await prefs.setBool(key, true);
      await prefs.setInt('${key}_puntuacion', puntuacion);
    }
  }

  // Calcular estrellas según puntuación
  int _calculateStars(int score) {
    if (score >= 90) return 3;
    if (score >= 70) return 2;
    if (score >= 50) return 1;
    return 0;
  }

  // Verificar si una actividad está completada
  Future<bool> esActividadCompletada(
      int etapa, int seccion, int actividad) async {
    final prefs = await SharedPreferences.getInstance();
    String key =
        '${_keyPrefix}etapa_${etapa}_seccion_${seccion}_actividad_$actividad';
    bool completada = prefs.getBool(key) ?? false;

    // DEBUG: Mostrar qué se está buscando
    if (etapa == 2 && seccion == 1 && actividad >= 0 && actividad <= 4) {
      print('🔍 DEBUG: Buscando "$key" = $completada');
    }

    // MIGRACIÓN BIDIRECCIONAL para Etapa 3, Sección "Agua, Aire y Suelo"
    // El problema: algunos datos se guardaron en seccion=1, otros en seccion=2
    // Solución: buscar en ambas ubicaciones
    if (!completada && etapa == 2) {
      String keyAlterna = '';

      if (seccion == 1) {
        // Si buscan en seccion=1, también buscar en seccion=2
        keyAlterna =
            '${_keyPrefix}etapa_${etapa}_seccion_2_actividad_$actividad';
      } else if (seccion == 2) {
        // Si buscan en seccion=2, también buscar en seccion=1
        keyAlterna =
            '${_keyPrefix}etapa_${etapa}_seccion_1_actividad_$actividad';
      }

      if (keyAlterna.isNotEmpty) {
        bool completadaAlterna = prefs.getBool(keyAlterna) ?? false;

        // DEBUG: Mostrar qué se encontró en la ubicación alterna
        if (etapa == 2 && seccion == 1 && actividad >= 0 && actividad <= 4) {
          print(
              '🔍 DEBUG: También buscando "$keyAlterna" = $completadaAlterna');
        }

        if (completadaAlterna) {
          print(
              '🔄 MIGRANDO progreso: Etapa $etapa, Sección ${seccion == 1 ? '2→1' : '1→2'}, Actividad $actividad');
          // Copiar el progreso a ambas ubicaciones para consistencia
          await prefs.setBool(key, true);
          return true;
        }
      }
    }

    return completada;
  }

  // Verificar si un nodo (sección) está desbloqueado
  Future<bool> esNodoDesbloqueado(int etapa, int seccion) async {
    final prefs = await SharedPreferences.getInstance();

    // El primer nodo siempre está desbloqueado
    if (seccion == 0) return true;

    String key =
        '${_keyPrefix}nodo_desbloqueado_etapa_${etapa}_seccion_$seccion';
    bool desbloqueado = prefs.getBool(key) ?? false;

    // MIGRACIÓN BIDIRECCIONAL para Etapa 3, Sección "Agua, Aire y Suelo"
    if (!desbloqueado && etapa == 2) {
      String keyAlterna = '';

      if (seccion == 1) {
        // Si buscan en seccion=1, también buscar en seccion=2
        keyAlterna = '${_keyPrefix}nodo_desbloqueado_etapa_${etapa}_seccion_2';
      } else if (seccion == 2) {
        // Si buscan en seccion=2, también buscar en seccion=1
        keyAlterna = '${_keyPrefix}nodo_desbloqueado_etapa_${etapa}_seccion_1';
      }

      if (keyAlterna.isNotEmpty) {
        bool desbloqueadoAlterno = prefs.getBool(keyAlterna) ?? false;

        if (desbloqueadoAlterno) {
          print(
              '🔄 MIGRANDO desbloqueo nodo: Etapa $etapa, Sección ${seccion == 1 ? '2→1' : '1→2'}');
          // Copiar el estado de desbloqueo a ambas ubicaciones
          await prefs.setBool(key, true);
          return true;
        }
      }
    }

    return desbloqueado;
  } // Método para forzar desbloqueo de nodo (para testing/debug)

  Future<void> forzarDesbloqueoNodo(int etapa, int seccion) async {
    final prefs = await SharedPreferences.getInstance();
    String key =
        '${_keyPrefix}nodo_desbloqueado_etapa_${etapa}_seccion_$seccion';
    await prefs.setBool(key, true);
    print('⚡ FORZADO: Nodo etapa $etapa, sección $seccion desbloqueado');

    // También desbloquear en Firebase
    try {
      await _firebaseService.unlockSeccion(
        etapa: etapa + 1,
        seccion: seccion + 1,
      );
    } catch (e) {
      print('⚠️ Error al desbloquear en Firebase: $e');
    }
  }

  // Verificar y desbloquear nodos basado en progreso
  Future<void> _verificarDesbloqueoNodos(int etapa, int seccion) async {
    final prefs = await SharedPreferences.getInstance();

    print('🔓 VERIFICANDO DESBLOQUEO:');
    print('  - Etapa: $etapa, Sección: $seccion');

    // Verificar si todas las actividades de la sección actual están completadas
    bool todasCompletadas = await _todasActividadesCompletadas(etapa, seccion);
    print(
        '  - Todas actividades completadas en sección $seccion: $todasCompletadas');

    if (todasCompletadas) {
      try {
        // Desbloquear siguiente nodo (sección)
        int siguienteSeccion = seccion + 1;
        int maxSeccionesEtapa = _getNumeroSeccionesPorEtapa(etapa);

        if (siguienteSeccion < maxSeccionesEtapa) {
          // Desbloquear siguiente sección en la misma etapa
          String key =
              '${_keyPrefix}nodo_desbloqueado_etapa_${etapa}_seccion_$siguienteSeccion';
          print('  - Desbloqueando sección $siguienteSeccion con key: $key');
          await prefs.setBool(key, true);

          // Desbloquear en Firebase (Firebase usa 1-indexed)
          await _firebaseService.unlockSeccion(
            etapa: etapa + 1,
            seccion: siguienteSeccion + 1,
          );

          print('  ✅ Sección $siguienteSeccion desbloqueada');
        } else {
          // Es la última sección de la etapa, desbloquear primera sección de siguiente etapa
          int siguienteEtapa = etapa + 1;
          if (siguienteEtapa <= 5) {
            // Solo hasta etapa 6 (índice 5)
            String keyEtapaSiguiente =
                '${_keyPrefix}nodo_desbloqueado_etapa_${siguienteEtapa}_seccion_0';
            print(
                '  - Desbloqueando etapa ${siguienteEtapa}, sección 0 con key: $keyEtapaSiguiente');
            await prefs.setBool(keyEtapaSiguiente, true);

            // Desbloquear en Firebase (Firebase usa 1-indexed)
            await _firebaseService.unlockEtapa(siguienteEtapa + 1);
            await _firebaseService.unlockSeccion(
              etapa: siguienteEtapa + 1,
              seccion: 1,
            );
            print('  ✅ Etapa ${siguienteEtapa}, sección 0 desbloqueada');
          } else {
            print('  🎉 ¡Todas las etapas completadas! ¡Felicitaciones!');
          }
        }
      } catch (e) {
        print('⚠️ Error al desbloquear en Firebase: $e');
        // Continuar con desbloqueo local
      }
    } else {
      print(
          '  ❌ No todas las actividades están completadas - no se desbloquea nada');
    }
    print('🔓 FIN VERIFICACIÓN DESBLOQUEO\n');
  }

  // Verificar si todas las actividades de una sección están completadas
  Future<bool> _todasActividadesCompletadas(int etapa, int seccion) async {
    int totalActividades = _getNumeroActividadesPorSeccion(etapa, seccion);

    print(
        '  - Verificando $totalActividades actividades en etapa $etapa, sección $seccion');

    for (int actividad = 0; actividad < totalActividades; actividad++) {
      bool completada = await esActividadCompletada(etapa, seccion, actividad);
      print('    Actividad $actividad: $completada');
      if (!completada) {
        print('  ❌ Actividad $actividad no completada - faltan actividades');
        return false;
      }
    }
    print('  ✅ Todas las $totalActividades actividades están completadas');
    return true;
  }

  // Obtener el número correcto de actividades por etapa y sección
  int _getNumeroActividadesPorSeccion(int etapa, int seccion) {
    // Estructura real del proyecto:
    switch (etapa) {
      case 0: // Etapa 1
        return seccion == 0 ? 4 : 4; // Sección 1: 4, Sección 2: 4
      case 1: // Etapa 2
        return seccion == 0 ? 4 : 3; // Sección 1: 4, Sección 2: 3
      case 2: // Etapa 3
        return seccion == 0 ? 4 : 5; // Sección 1: 4, Sección 2: 5
      case 3: // Etapa 4
        return seccion == 0 ? 3 : 2; // Sección 1: 3, Sección 2: 2
      case 4: // Etapa 5
        return seccion == 0 ? 4 : 3; // Sección 1: 4, Sección 2: 3
      case 5: // Etapa 6
        return 3; // Ambas secciones tienen 3 actividades
      default:
        return 4; // Por defecto
    }
  }

  // Obtener el número de secciones por etapa
  int _getNumeroSeccionesPorEtapa(int etapa) {
    switch (etapa) {
      case 0: // Etapa 1
      case 1: // Etapa 2
      case 2: // Etapa 3
      case 3: // Etapa 4
      case 4: // Etapa 5
      case 5: // Etapa 6
        return 2; // Todas las etapas tienen 2 secciones
      default:
        return 2; // Por defecto
    }
  }

  // Obtener progreso de una sección (porcentaje)
  Future<double> getProgresoSeccion(int etapa, int seccion) async {
    int completadas = 0;
    int total = _getNumeroActividadesPorSeccion(etapa, seccion);

    for (int actividad = 0; actividad < total; actividad++) {
      bool completada = await esActividadCompletada(etapa, seccion, actividad);
      if (completada) completadas++;
    }

    return completadas / total;
  }

  // Obtener puntuación de una actividad específica
  Future<int> getPuntuacionActividad(
      int etapa, int seccion, int actividad) async {
    final prefs = await SharedPreferences.getInstance();
    String key =
        '${_keyPrefix}etapa_${etapa}_seccion_${seccion}_actividad_${actividad}_puntuacion';
    int puntuacion = prefs.getInt(key) ?? 0;

    // MIGRACIÓN BIDIRECCIONAL para Etapa 3, Sección "Agua, Aire y Suelo"
    if (puntuacion == 0 && etapa == 2) {
      String keyAlterna = '';

      if (seccion == 1) {
        // Si buscan en seccion=1, también buscar en seccion=2
        keyAlterna =
            '${_keyPrefix}etapa_${etapa}_seccion_2_actividad_${actividad}_puntuacion';
      } else if (seccion == 2) {
        // Si buscan en seccion=2, también buscar en seccion=1
        keyAlterna =
            '${_keyPrefix}etapa_${etapa}_seccion_1_actividad_${actividad}_puntuacion';
      }

      if (keyAlterna.isNotEmpty) {
        int puntuacionAlterna = prefs.getInt(keyAlterna) ?? 0;

        if (puntuacionAlterna > 0) {
          print(
              '🔄 MIGRANDO puntuación: Etapa $etapa, Sección ${seccion == 1 ? '2→1' : '1→2'}, Actividad $actividad: $puntuacionAlterna pts');
          // Copiar la puntuación a ambas ubicaciones
          await prefs.setInt(key, puntuacionAlterna);
          return puntuacionAlterna;
        }
      }
    }

    return puntuacion;
  }

  // Obtener puntuación total del usuario
  Future<int> getPuntuacionTotal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPuntuacionTotal) ?? 0;
  }

  // Obtener resumen de progreso de una etapa
  Future<Map<String, dynamic>> getResumenEtapa(int etapa) async {
    int seccionesCompletadas = 0;
    int totalSecciones = 2; // Cada etapa tiene 2 secciones
    int puntuacionEtapa = 0;

    for (int seccion = 0; seccion < totalSecciones; seccion++) {
      bool todasCompletadas =
          await _todasActividadesCompletadas(etapa, seccion);
      if (todasCompletadas) seccionesCompletadas++;

      // Sumar puntuaciones de todas las actividades de la sección
      for (int actividad = 0; actividad < 4; actividad++) {
        puntuacionEtapa +=
            await getPuntuacionActividad(etapa, seccion, actividad);
      }
    }

    return {
      'seccionesCompletadas': seccionesCompletadas,
      'totalSecciones': totalSecciones,
      'progreso': seccionesCompletadas / totalSecciones,
      'puntuacion': puntuacionEtapa,
    };
  }

  // Resetear progreso (para testing o reiniciar)
  Future<void> resetearProgreso() async {
    final prefs = await SharedPreferences.getInstance();

    // Obtener todas las claves que empiecen con nuestro prefijo
    Set<String> keys = prefs.getKeys();
    List<String> keysToRemove =
        keys.where((key) => key.startsWith(_keyPrefix)).toList();

    for (String key in keysToRemove) {
      await prefs.remove(key);
    }

    await prefs.remove(_keyPuntuacionTotal);
  }

  // Inicializar progreso por primera vez
  Future<void> inicializarProgreso() async {
    final prefs = await SharedPreferences.getInstance();

    // Verificar si ya está inicializado
    bool inicializado = prefs.getBool('progreso_inicializado') ?? false;

    if (!inicializado) {
      // Desbloquear el primer nodo de la primera etapa
      String primerNodo = '${_keyPrefix}nodo_desbloqueado_etapa_0_seccion_0';
      await prefs.setBool(primerNodo, true);
      await prefs.setBool('progreso_inicializado', true);
    }
  }

  // Obtener lista de actividades disponibles para una sección
  Future<List<Map<String, dynamic>>> getActividadesDisponibles(
      int etapa, int seccion) async {
    List<Map<String, dynamic>> actividades = [];

    for (int actividad = 0; actividad < 4; actividad++) {
      bool completada = await esActividadCompletada(etapa, seccion, actividad);
      int puntuacion = await getPuntuacionActividad(etapa, seccion, actividad);

      // Una actividad está disponible si:
      // 1. Es la primera actividad (índice 0), O
      // 2. La actividad anterior está completada
      bool disponible = actividad == 0 ||
          await esActividadCompletada(etapa, seccion, actividad - 1);

      actividades.add({
        'indice': actividad,
        'completada': completada,
        'disponible': disponible,
        'puntuacion': puntuacion,
        'bloqueada': !disponible,
      });
    }

    return actividades;
  }

  // Método de DEBUG para ver el estado completo del progreso
  Future<void> imprimirEstadoProgreso() async {
    final prefs = await SharedPreferences.getInstance();

    print('=== ESTADO COMPLETO DEL PROGRESO ===');

    // Mostrar todas las claves relacionadas con progreso
    Set<String> keys = prefs.getKeys();
    List<String> progresoKeys = keys
        .where((key) => key.startsWith(_keyPrefix) || key.contains('progreso'))
        .toList();

    for (String key in progresoKeys) {
      dynamic value = prefs.get(key);
      print('$key: $value');
    }

    print('\n=== ACTIVIDADES POR ETAPA Y SECCIÓN ===');

    // Mostrar estado de actividades para Etapa 0
    for (int seccion = 0; seccion < 2; seccion++) {
      print('\nETAPA 0, SECCIÓN $seccion:');
      print('  - Nodo desbloqueado: ${await esNodoDesbloqueado(0, seccion)}');
      print(
          '  - Todas actividades completadas: ${await _todasActividadesCompletadas(0, seccion)}');

      for (int actividad = 0; actividad < 4; actividad++) {
        bool completada = await esActividadCompletada(0, seccion, actividad);
        int puntuacion = await getPuntuacionActividad(0, seccion, actividad);
        String key =
            '${_keyPrefix}etapa_0_seccion_${seccion}_actividad_$actividad';
        bool keyExists = prefs.containsKey(key);
        print(
            '    Actividad $actividad: completada=$completada, puntuación=$puntuacion, key_exists=$keyExists, key=$key');
      }
    }

    print('\n=== RESUMEN DE DESBLOQUEOS ===');
    for (int seccion = 0; seccion < 2; seccion++) {
      bool desbloqueado = await esNodoDesbloqueado(0, seccion);
      String keyDesbloqueo =
          '${_keyPrefix}nodo_desbloqueado_etapa_0_seccion_$seccion';
      bool keyExistsDesbloqueo = prefs.containsKey(keyDesbloqueo);
      print(
          'Nodo $seccion: desbloqueado=$desbloqueado, key_exists=$keyExistsDesbloqueo, key=$keyDesbloqueo');
    }

    print('\n===================================');
  }
}
