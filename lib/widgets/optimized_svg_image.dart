import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/image_memory_manager.dart';

/// Widget optimizado para cargar imágenes SVG con lazy loading y caché
class OptimizedSvgImage extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final bool enableCache;
  final bool lazyLoad;

  const OptimizedSvgImage({
    Key? key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.placeholder,
    this.enableCache = true,
    this.lazyLoad = true,
  }) : super(key: key);

  @override
  State<OptimizedSvgImage> createState() => _OptimizedSvgImageState();
}

class _OptimizedSvgImageState extends State<OptimizedSvgImage>
    with AutomaticKeepAliveClientMixin {
  bool _isVisible = false;
  bool _isLoaded = false;

  // Caché estático para SVGs ya cargados
  static final Map<String, SvgPicture> _svgCache = {};
  static const int _maxCacheSize = 15; // Máximo 15 SVGs en caché

  // Instancia del gestor de memoria
  final _memoryManager = ImageMemoryManager();

  @override
  bool get wantKeepAlive => widget.enableCache && _isLoaded;

  @override
  void initState() {
    super.initState();
    if (!widget.lazyLoad) {
      _loadImage();
    }
  }

  @override
  void dispose() {
    // Limpiar caché si hay demasiados elementos
    if (_svgCache.length > _maxCacheSize) {
      _cleanCache();
    }
    super.dispose();
  }

  void _cleanCache() {
    // Mantener solo los últimos 10 elementos
    if (_svgCache.length > 10) {
      final keys = _svgCache.keys.toList();
      final keysToRemove = keys.take(_svgCache.length - 10);
      for (final key in keysToRemove) {
        _svgCache.remove(key);
      }
    }
  }

  void _loadImage() {
    if (_isLoaded) return;

    setState(() {
      _isVisible = true;
    });

    // Cargar después del siguiente frame para no bloquear la UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  Widget _buildPlaceholder() {
    return widget.placeholder ??
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.landscape_outlined,
                  color: Colors.grey.shade400,
                  size: (widget.width ?? 50) * 0.3,
                ),
                const SizedBox(height: 4),
                Text(
                  'Cargando...',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildSvgImage() {
    // Registrar uso en el gestor de memoria
    _memoryManager.registerImageUsage(widget.assetPath,
        estimatedSize: _estimateImageSize());

    // Verificar caché primero
    if (widget.enableCache && _svgCache.containsKey(widget.assetPath)) {
      return _svgCache[widget.assetPath]!;
    }

    // Crear nueva instancia con configuración optimizada
    final svgWidget = SvgPicture.asset(
      widget.assetPath,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      color: widget.color,
      allowDrawingOutsideViewBox: false,
      // Configuraciones de rendimiento
      excludeFromSemantics: true,
      clipBehavior: Clip.hardEdge,
      // Optimización adicional para SVGs grandes
      matchTextDirection: false,
      // Manejo de errores mejorado
      placeholderBuilder: (context) => _buildPlaceholder(),
    );

    // Guardar en caché si está habilitado y no excedemos el límite
    if (widget.enableCache && _svgCache.length < _maxCacheSize) {
      _svgCache[widget.assetPath] = svgWidget;
    } else if (_svgCache.length >= _maxCacheSize) {
      _cleanCache();
      _svgCache[widget.assetPath] = svgWidget;
    }

    return svgWidget;
  }

  /// Estimar el tamaño de la imagen basado en dimensiones
  int _estimateImageSize() {
    // Manejar valores infinitos o nulos
    double width = widget.width ?? 200;
    double height = widget.height ?? 200;

    // Si alguna dimensión es infinita, usar valores por defecto
    if (!width.isFinite) width = 200;
    if (!height.isFinite) height = 200;

    // Estimación aproximada: 0.5KB por cada 1000 píxeles cuadrados
    final area = width * height;
    if (!area.isFinite) return 150; // Valor por defecto seguro

    return (area / 2000).round().clamp(50, 500);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.lazyLoad) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // Auto-activar la carga si el widget está siendo construido
          if (!_isVisible && constraints.biggest != Size.zero) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_isVisible) {
                _loadImage();
              }
            });
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isLoaded ? _buildSvgImage() : _buildPlaceholder(),
          );
        },
      );
    }

    return _buildSvgImage();
  }
}

/// Detector de visibilidad simplificado para lazy loading
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;
  final Key key;

  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  bool _hasNotified = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (!_hasNotified) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _checkVisibility();
            }
          });
        }
        return false;
      },
      child: widget.child,
    );
  }

  void _checkVisibility() {
    if (_hasNotified) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenSize = MediaQuery.of(context).size;

      // Calcular si el widget está visible
      final isVisible = position.dx < screenSize.width &&
          position.dy < screenSize.height &&
          position.dx + size.width > 0 &&
          position.dy + size.height > 0;

      if (isVisible) {
        _hasNotified = true;
        widget.onVisibilityChanged(VisibilityInfo(visibleFraction: 0.5));
      }
    }
  }
}

class VisibilityInfo {
  final double visibleFraction;
  VisibilityInfo({required this.visibleFraction});
}
