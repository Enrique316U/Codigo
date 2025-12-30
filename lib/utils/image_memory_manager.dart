import 'dart:async';
import 'package:flutter/foundation.dart';

/// Gestor de memoria para optimizar el uso de imágenes SVG
class ImageMemoryManager {
  static final ImageMemoryManager _instance = ImageMemoryManager._internal();
  factory ImageMemoryManager() => _instance;
  ImageMemoryManager._internal();

  // Límites de memoria
  static const int _maxCacheSize = 15; // Máximo 15 SVGs en memoria
  static const int _targetCacheSize = 10; // Objetivo después de limpieza
  static const Duration _cleanupInterval = Duration(minutes: 2);

  // Cache y estadísticas
  final Map<String, CachedImageInfo> _imageCache = {};
  Timer? _cleanupTimer;
  int _totalMemoryUsage = 0;

  /// Inicializar el gestor de memoria
  void initialize() {
    _startPeriodicCleanup();
    if (kDebugMode) {
      print('🧠 ImageMemoryManager inicializado');
    }
  }

  /// Registrar uso de una imagen
  void registerImageUsage(String path, {int estimatedSize = 100}) {
    final now = DateTime.now();

    if (_imageCache.containsKey(path)) {
      _imageCache[path]!.lastUsed = now;
      _imageCache[path]!.usageCount++;
    } else {
      _imageCache[path] = CachedImageInfo(
        path: path,
        lastUsed: now,
        usageCount: 1,
        estimatedSizeKB: estimatedSize,
      );
      _totalMemoryUsage += estimatedSize;
    }

    // Limpiar si excedemos el límite
    if (_imageCache.length > _maxCacheSize) {
      _performMemoryCleanup();
    }
  }

  /// Realizar limpieza de memoria
  void _performMemoryCleanup() {
    if (_imageCache.length <= _targetCacheSize) return;

    if (kDebugMode) {
      print(
          '🧹 Iniciando limpieza de memoria: ${_imageCache.length} elementos');
    }

    // Ordenar por última vez usado y frecuencia de uso
    final sortedEntries = _imageCache.entries.toList()
      ..sort((a, b) {
        // Prioridad: frecuencia de uso > tiempo desde último uso
        final usageCompare = b.value.usageCount.compareTo(a.value.usageCount);
        if (usageCompare != 0) return usageCompare;

        return b.value.lastUsed.compareTo(a.value.lastUsed);
      });

    // Remover los elementos menos usados
    for (int i = _targetCacheSize; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      _totalMemoryUsage -= entry.value.estimatedSizeKB;
      _imageCache.remove(entry.key);
    }

    if (kDebugMode) {
      print('✅ Limpieza completada: ${_imageCache.length} elementos restantes');
      print('📊 Memoria estimada: ${_totalMemoryUsage}KB');
    }
  }

  /// Iniciar limpieza periódica
  void _startPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) {
      _performPeriodicCleanup();
    });
  }

  /// Limpieza periódica (más conservadora)
  void _performPeriodicCleanup() {
    final now = DateTime.now();
    final expiredThreshold = now.subtract(const Duration(minutes: 5));

    // Remover solo elementos muy antiguos y poco usados
    final toRemove = <String>[];

    _imageCache.forEach((key, info) {
      if (info.lastUsed.isBefore(expiredThreshold) && info.usageCount <= 2) {
        toRemove.add(key);
      }
    });

    for (final key in toRemove) {
      final info = _imageCache.remove(key);
      if (info != null) {
        _totalMemoryUsage -= info.estimatedSizeKB;
      }
    }

    if (toRemove.isNotEmpty && kDebugMode) {
      print(
          '🕐 Limpieza periódica: ${toRemove.length} elementos expirados removidos');
    }
  }

  /// Limpiar toda la caché
  void clearCache() {
    _imageCache.clear();
    _totalMemoryUsage = 0;
    if (kDebugMode) {
      print('🧹 Caché de imágenes completamente limpiada');
    }
  }

  /// Obtener estadísticas de memoria
  MemoryStats getMemoryStats() {
    return MemoryStats(
      cachedImages: _imageCache.length,
      estimatedMemoryKB: _totalMemoryUsage,
      maxCacheSize: _maxCacheSize,
    );
  }

  /// Verificar si una imagen está en caché
  bool isImageCached(String path) {
    return _imageCache.containsKey(path);
  }

  /// Liberar recursos al cerrar la app
  void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    clearCache();
  }

  /// Método para debug - mostrar estado actual
  void debugPrintStats() {
    if (!kDebugMode) return;

    print('\n📊 === ESTADÍSTICAS DE MEMORIA ===');
    print('🖼️ Imágenes en caché: ${_imageCache.length}/$_maxCacheSize');
    print('💾 Memoria estimada: ${_totalMemoryUsage}KB');
    print('📈 Top 5 imágenes más usadas:');

    final sorted = _imageCache.entries.toList()
      ..sort((a, b) => b.value.usageCount.compareTo(a.value.usageCount));

    for (int i = 0; i < 5 && i < sorted.length; i++) {
      final entry = sorted[i];
      final name = entry.key.split('/').last;
      print('  ${i + 1}. $name - ${entry.value.usageCount} usos');
    }
    print('📊 === FIN ESTADÍSTICAS ===\n');
  }
}

/// Información de una imagen en caché
class CachedImageInfo {
  final String path;
  DateTime lastUsed;
  int usageCount;
  final int estimatedSizeKB;

  CachedImageInfo({
    required this.path,
    required this.lastUsed,
    required this.usageCount,
    required this.estimatedSizeKB,
  });
}

/// Estadísticas de memoria
class MemoryStats {
  final int cachedImages;
  final int estimatedMemoryKB;
  final int maxCacheSize;

  MemoryStats({
    required this.cachedImages,
    required this.estimatedMemoryKB,
    required this.maxCacheSize,
  });

  double get cacheUsagePercent => (cachedImages / maxCacheSize) * 100;
  String get formattedMemory => '${estimatedMemoryKB}KB';
}
