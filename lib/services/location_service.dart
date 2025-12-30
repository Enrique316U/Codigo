import 'package:geolocator/geolocator.dart';
import 'dart:math' as dart_math;

class LocationService {
  // Verificar si los permisos de ubicación están habilitados
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          'Los servicios de ubicación están deshabilitados. Por favor, actívalos en la configuración.');
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación están permanentemente denegados. Ve a la configuración de la aplicación para habilitarlos.');
    }

    return true;
  }

  // Obtener la posición actual del usuario
  Future<Position> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      throw Exception('No se pudo obtener permisos de ubicación');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      // Fallback con menor precisión si falla
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 15),
        );
      } catch (e) {
        throw Exception('No se pudo obtener la ubicación: $e');
      }
    }
  }

  // Obtener la posición actual con manejo de errores mejorado
  Future<Map<String, double>> getCurrentLocation() async {
    try {
      print('🌍 Obteniendo ubicación GPS...');
      final position = await getCurrentPosition();

      print(
          '📍 Ubicación obtenida: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}');
      print('🎯 Precisión: ${position.accuracy.toInt()}m');

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'timestamp': position.timestamp?.millisecondsSinceEpoch.toDouble() ?? 0,
      };
    } catch (e) {
      print('❌ Error GPS: $e');

      // Fallback con ubicación simulada para desarrollo/pruebas
      print('🔄 Usando ubicación por defecto (-16.424046, -71.521697)');
      return {
        'latitude': -16.424046,
        'longitude': -71.521697,
        'accuracy': 1000.0, // Baja precisión para indicar que es simulada
        'timestamp': DateTime.now().millisecondsSinceEpoch.toDouble(),
      };
    }
  }

  // Calcular distancia entre dos puntos (en metros)
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Obtener stream de posición en tiempo real
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Actualizar cada 10 metros
      ),
    );
  }

  // Verificar si los servicios de ubicación están disponibles
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Abrir configuración de ubicación
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // Obtener la última ubicación conocida
  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      print('No se pudo obtener la última ubicación conocida: $e');
      return null;
    }
  }
}
