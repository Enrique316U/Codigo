import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/image_memory_manager.dart';

/// Overlay de debug para mostrar estadísticas de memoria
/// Solo se muestra en modo debug
class MemoryDebugOverlay extends StatefulWidget {
  final Widget child;

  const MemoryDebugOverlay({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MemoryDebugOverlay> createState() => _MemoryDebugOverlayState();
}

class _MemoryDebugOverlayState extends State<MemoryDebugOverlay> {
  bool _showStats = false;
  final _memoryManager = ImageMemoryManager();

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        // Botón flotante para alternar estadísticas
        Positioned(
          top: 50,
          left: 10,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showStats = !_showStats;
              });
              if (_showStats) {
                _memoryManager.debugPrintStats();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _showStats ? Icons.memory : Icons.memory_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        // Panel de estadísticas
        if (_showStats)
          Positioned(
            top: 90,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Memoria Imágenes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatRow('Caché:',
                      '${_memoryManager.getMemoryStats().cachedImages}/${_memoryManager.getMemoryStats().maxCacheSize}'),
                  _buildStatRow('Memoria:',
                      _memoryManager.getMemoryStats().formattedMemory),
                  _buildStatRow('Uso:',
                      '${_memoryManager.getMemoryStats().cacheUsagePercent.toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
