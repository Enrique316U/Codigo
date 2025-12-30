import "package:firebase_database/firebase_database.dart";
import "dart:math";

class FirebaseService {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref("/devices");

  // Obtener datos de todos los dispositivos
  Future<Map<String, dynamic>> getAllDevices() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      throw Exception("No data available");
    }
  }

  // Obtener datos de un dispositivo específico
  Future<Map<String, dynamic>> getDeviceData(String deviceId) async {
    final snapshot = await _databaseRef.child(deviceId).get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      throw Exception("Device not found: $deviceId");
    }
  }

  // Obtener el dispositivo más cercano basado en coordenadas GPS
  Future<Map<String, dynamic>> getNearestDevice(
      double userLat, double userLng) async {
    final devicesSnapshot = await _databaseRef.get();

    if (!devicesSnapshot.exists) {
      throw Exception("No hay dispositivos disponibles");
    }

    final devices = Map<String, dynamic>.from(devicesSnapshot.value as Map);
    String? nearestDeviceId;
    double minDistance = double.infinity;
    Map<String, dynamic>? nearestDeviceData;
    List<Map<String, dynamic>> devicesWithLocation = [];

    print('🔍 Buscando entre ${devices.length} dispositivos...');

    devices.forEach((deviceId, deviceData) {
      final deviceMap = Map<String, dynamic>.from(deviceData as Map);

      // Verificar si es un dispositivo EVA (EVA_01 a EVA_11)
      if (!deviceId.toString().startsWith('EVA_')) {
        return; // Saltar dispositivos que no sean EVA
      }

      // Buscar coordenadas GPS en la estructura actual
      double? deviceLat, deviceLng;

      // Método 1: Buscar en history (estructura actual)
      if (deviceMap.containsKey('history')) {
        final historyRaw = deviceMap['history'];
        final history =
            historyRaw is Map ? Map<String, dynamic>.from(historyRaw) : null;

        if (history != null && history.isNotEmpty) {
          // Obtener la entrada más reciente del historial
          final dates = history.keys.toList()..sort((a, b) => b.compareTo(a));
          final latestDate = dates.first;
          final dayDataRaw = history[latestDate];
          final dayData =
              dayDataRaw is Map ? Map<String, dynamic>.from(dayDataRaw) : null;

          if (dayData != null && dayData.isNotEmpty) {
            final times = dayData.keys.toList()..sort((a, b) => b.compareTo(a));
            final latestTime = times.first;
            final timeDataRaw = dayData[latestTime];
            final timeData = timeDataRaw is Map
                ? Map<String, dynamic>.from(timeDataRaw)
                : null;

            if (timeData != null &&
                timeData.containsKey('sensors') &&
                timeData['sensors'] is Map &&
                (timeData['sensors'] as Map).containsKey('gps')) {
              final gpsRaw = timeData['sensors']['gps'];
              final gps =
                  gpsRaw is Map ? Map<String, dynamic>.from(gpsRaw) : null;

              if (gps != null &&
                  gps.containsKey('latitude') &&
                  gps.containsKey('longitude')) {
                deviceLat = (gps['latitude'] as num).toDouble();
                deviceLng = (gps['longitude'] as num).toDouble();
              }
            }
          }
        }
      }

      // Método 2: Buscar en device_info (estructura alternativa)
      if (deviceLat == null && deviceMap.containsKey('device_info')) {
        final deviceInfoRaw = deviceMap['device_info'];
        final deviceInfo = deviceInfoRaw is Map
            ? Map<String, dynamic>.from(deviceInfoRaw)
            : null;

        if (deviceInfo != null && deviceInfo.containsKey('coordinates')) {
          final coordsRaw = deviceInfo['coordinates'];
          final coords =
              coordsRaw is Map ? Map<String, dynamic>.from(coordsRaw) : null;

          if (coords != null &&
              coords.containsKey('latitude') &&
              coords.containsKey('longitude')) {
            deviceLat = (coords['latitude'] as num).toDouble();
            deviceLng = (coords['longitude'] as num).toDouble();
          }
        }
      }

      // Si encontramos coordenadas, calcular distancia
      if (deviceLat != null && deviceLng != null) {
        final distance =
            _calculateDistance(userLat, userLng, deviceLat, deviceLng);

        devicesWithLocation.add({
          'deviceId': deviceId,
          'distance': distance,
          'latitude': deviceLat,
          'longitude': deviceLng,
          'data': deviceMap,
        });

        print(
            '📍 $deviceId: ${distance.toInt()}m (${deviceLat.toStringAsFixed(6)}, ${deviceLng.toStringAsFixed(6)})');

        if (distance < minDistance) {
          minDistance = distance;
          nearestDeviceId = deviceId;
          nearestDeviceData = deviceMap;
        }
      } else {
        print('⚠️  $deviceId: Sin coordenadas GPS');
      }
    });

    print(
        '📊 Dispositivos con ubicación encontrados: ${devicesWithLocation.length}');

    if (nearestDeviceId == null || nearestDeviceData == null) {
      // Fallback: usar EVA_01 si no hay coordenadas GPS
      if (devices.containsKey('EVA_01')) {
        print('🔄 Fallback: Usando EVA_01 (sin GPS)');
        return {
          'deviceId': 'EVA_01',
          'distance': 0.0,
          'data': devices['EVA_01'],
          'fallback': true,
        };
      }
      throw Exception("No se encontraron dispositivos EVA con coordenadas GPS");
    }

    print(
        '🎯 Dispositivo más cercano: $nearestDeviceId (${minDistance.toInt()}m)');

    return {
      'deviceId': nearestDeviceId,
      'distance': minDistance,
      'data': nearestDeviceData,
      'allDevicesWithLocation': devicesWithLocation,
    };
  }

  // Calcular distancia entre dos puntos GPS usando la fórmula de Haversine
  double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371000; // Radio de la Tierra en metros

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Obtener datos en tiempo real de un dispositivo específico
  Stream<Map<String, dynamic>> getDeviceRealTimeStream(String deviceId) {
    return _databaseRef.child(deviceId).onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      } else {
        throw Exception("Device not found: $deviceId");
      }
    });
  }

  // Método de compatibilidad con el código anterior
  Future<Map<String, dynamic>> getSensorData() async {
    // Intentar obtener datos del primer dispositivo disponible
    final devices = await getAllDevices();
    if (devices.isNotEmpty) {
      final firstDeviceId = devices.keys.first;
      return getDeviceData(firstDeviceId);
    } else {
      throw Exception("No devices available");
    }
  }
}
