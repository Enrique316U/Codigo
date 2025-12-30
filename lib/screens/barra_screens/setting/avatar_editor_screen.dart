import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AvatarEditorScreen extends StatefulWidget {
  const AvatarEditorScreen({Key? key}) : super(key: key);

  @override
  State<AvatarEditorScreen> createState() => _AvatarEditorScreenState();
}

class _AvatarEditorScreenState extends State<AvatarEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Categorías de personalización usando las imágenes de tu proyecto
  final List<String> _categories = [
    'Cuerpo',
    'Ojos',
    'Boca',
    'Ropa',
    'Accesorios'
  ];

  // Opciones usando las rutas de las imágenes de tu proyecto
  final Map<String, List<AvatarOption>> _categoryOptions = {
    'Cuerpo': [
      AvatarOption('Cuerpo 1', 'lib/assets/images/user/cuerpo/cuerpo_1.svg'),
      AvatarOption('Cuerpo 2', 'lib/assets/images/user/cuerpo/cuerpo_2.svg'),
      AvatarOption('Cuerpo 3', 'lib/assets/images/user/cuerpo/cuerpo_3.svg'),
    ],
    'Ojos': [
      AvatarOption('Ojos 1', 'lib/assets/images/user/ojos/ojos_1.svg'),
      AvatarOption('Ojos 2', 'lib/assets/images/user/ojos/ojos_2.svg'),
      AvatarOption('Ojos 3', 'lib/assets/images/user/ojos/ojos_3.svg'),
    ],
    'Boca': [
      AvatarOption('Boca 1', 'lib/assets/images/user/boca/boca_1.svg'),
      AvatarOption('Boca 2', 'lib/assets/images/user/boca/boca_2.svg'),
      AvatarOption('Boca 3', 'lib/assets/images/user/boca/boca_3.svg'),
    ],
    'Ropa': [
      AvatarOption('Ropa 1', 'lib/assets/images/user/ropa/ropa_1.svg'),
      AvatarOption('Ropa 2', 'lib/assets/images/user/ropa/ropa_2.svg'),
      AvatarOption('Ropa 3', 'lib/assets/images/user/ropa/ropa_3.svg'),
    ],
    'Accesorios': [
      AvatarOption(
          'Accesorio 1', 'lib/assets/images/user/accesorios/acc_1.svg'),
      AvatarOption(
          'Accesorio 2', 'lib/assets/images/user/accesorios/acc_2.svg'),
      AvatarOption('Ninguno', ''), // Opción sin accesorio
    ],
  };

  // Selecciones actuales
  Map<String, AvatarOption?> _currentSelections = {};

  // Para manejar la carga
  bool _isLoading = false;
  bool _hasChanges = false;

  // Cache para SVGs
  final Map<String, String> _svgCache = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadCurrentSelections();
  }

  void _loadCurrentSelections() {
    // Inicializar con las primeras opciones por defecto
    for (String category in _categories) {
      final options = _categoryOptions[category];
      if (options != null && options.isNotEmpty) {
        _currentSelections[category] = options.first;
      }
    }

    // Cargar selecciones guardadas si existen
    _loadSavedSelections();

    // Precargar SVGs en cache
    _preloadSvgAssets();
  }

  Future<void> _loadSavedSelections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool hasLoadedData = false;

      for (String category in _categories) {
        final savedPath = prefs.getString('avatar_${category.toLowerCase()}');
        if (savedPath != null) {
          final options = _categoryOptions[category];
          if (options != null) {
            final savedOption = options.firstWhere(
              (option) => option.imagePath == savedPath,
              orElse: () => options.first,
            );
            _currentSelections[category] = savedOption;
            hasLoadedData = true;
          }
        }
      }

      if (mounted && hasLoadedData) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading saved selections: $e');
    }
  }

  Future<void> _preloadSvgAssets() async {
    try {
      for (final categoryOptions in _categoryOptions.values) {
        for (final option in categoryOptions) {
          if (option.imagePath.isNotEmpty &&
              !_svgCache.containsKey(option.imagePath)) {
            final svgString = await rootBundle.loadString(option.imagePath);
            _svgCache[option.imagePath] = svgString;
          }
        }
      }
    } catch (e) {
      debugPrint('Error preloading SVG assets: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges && !_isLoading) {
          return await _showExitConfirmation(context);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F8E9),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF1F8E9),
                Color(0xFFE8F5E8),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildCustomHeader(context),
              _buildAvatarPreview(),
              _buildTabBar(),
              _buildTabBarView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (_hasChanges && !_isLoading) {
                final shouldPop = await _showExitConfirmation(context);
                if (shouldPop) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.face_retouching_natural,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Editor de Avatar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: _isLoading ? null : () => _saveAvatar(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isLoading ? Colors.grey.shade300 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                      ),
                    )
                  else
                    Icon(
                      _hasChanges ? Icons.save : Icons.check,
                      color: Colors.green[600],
                      size: 18,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    _isLoading
                        ? 'Guardando...'
                        : (_hasChanges ? 'Guardar' : 'Guardado'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isLoading ? Colors.grey[600] : Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.preview, color: Colors.green[600], size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Vista Previa del Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.palette, color: Colors.green[700], size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Personalizable',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade100.withOpacity(0.5),
                      Colors.green.shade200.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.green.shade300,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildAvatarComposite(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarComposite() {
    return Stack(
      children: [
        // Cuerpo (fondo)
        if (_currentSelections['Cuerpo']?.imagePath.isNotEmpty == true)
          Positioned.fill(
            child: SvgPicture.asset(
              _currentSelections['Cuerpo']!.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        // Ropa
        if (_currentSelections['Ropa']?.imagePath.isNotEmpty == true)
          Positioned.fill(
            child: SvgPicture.asset(
              _currentSelections['Ropa']!.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        // Ojos
        if (_currentSelections['Ojos']?.imagePath.isNotEmpty == true)
          Positioned.fill(
            child: SvgPicture.asset(
              _currentSelections['Ojos']!.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        // Boca
        if (_currentSelections['Boca']?.imagePath.isNotEmpty == true)
          Positioned.fill(
            child: SvgPicture.asset(
              _currentSelections['Boca']!.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        // Accesorios (frente)
        if (_currentSelections['Accesorios']?.imagePath.isNotEmpty == true)
          Positioned.fill(
            child: SvgPicture.asset(
              _currentSelections['Accesorios']!.imagePath,
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.green[600],
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[500]!, Colors.green[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(4),
          dividerColor: Colors.transparent,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: _categories.map((category) {
            return Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(category),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Cuerpo':
        return Icons.person;
      case 'Ojos':
        return Icons.visibility;
      case 'Boca':
        return Icons.sentiment_satisfied;
      case 'Ropa':
        return Icons.checkroom;
      case 'Accesorios':
        return Icons.watch;
      default:
        return Icons.category;
    }
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildCategoryOptions(category);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryOptions(String category) {
    final options = _categoryOptions[category] ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: Colors.green[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Opciones de $category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${options.length} opciones',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = _currentSelections[category] == option;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentSelections[category] = option;
                          _hasChanges = true;
                        });

                        // Haptic feedback
                        HapticFeedback.selectionClick();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    Colors.green.shade200,
                                    Colors.green.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey.shade100,
                                    Colors.grey.shade200,
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? Colors.green.shade400
                                : Colors.grey.shade300,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Mostrar vista previa de la opción
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: option.imagePath.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.not_interested,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : _buildOptimizedSvg(option.imagePath),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              option.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.green[800]
                                    : Colors.grey[700],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green[600],
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAvatar(BuildContext context) async {
    if (!_hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userModel = Provider.of<UserModel>(context, listen: false);

      // Crear JSON con las selecciones del avatar
      Map<String, String> avatarData = {};
      for (String category in _categories) {
        final selection = _currentSelections[category];
        if (selection != null) {
          avatarData[category.toLowerCase()] = selection.imagePath;
          await prefs.setString(
              'avatar_${category.toLowerCase()}', selection.imagePath);
        }
      }

      // Generar un SVG compuesto (para futuras mejoras)
      String compositeSvg = await _generateCompositeSvg();

      // Actualizar el UserModel con los datos del avatar
      userModel.updateAvatarData(
        jsonEncode(avatarData),
        compositeSvg,
      );

      // Mostrar mensaje de éxito con animación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Avatar personalizado guardado correctamente',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Ver',
              textColor: Colors.white,
              onPressed: () {
                // Aquí podrías navegar a una pantalla de vista previa
              },
            ),
          ),
        );

        // Regresar con animación suave
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context)
              .pop(true); // Devolver true para indicar que se guardó
        }
      }
    } catch (e) {
      debugPrint('Error saving avatar: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Error al guardar avatar: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

// Clase para representar una opción de avatar
class AvatarOption {
  final String name;
  final String imagePath;

  AvatarOption(this.name, this.imagePath);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarOption &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          imagePath == other.imagePath;

  @override
  int get hashCode => name.hashCode ^ imagePath.hashCode;
}

// Métodos auxiliares agregados
extension _AvatarEditorScreenExtension on _AvatarEditorScreenState {
  Widget _buildOptimizedSvg(String assetPath) {
    return FutureBuilder<String>(
      future: _getSvgFromCache(assetPath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(
            snapshot.data!,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image,
                color: Colors.grey.shade400,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.error,
              color: Colors.red.shade400,
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
          ),
        );
      },
    );
  }

  Future<String> _getSvgFromCache(String assetPath) async {
    if (_svgCache.containsKey(assetPath)) {
      return _svgCache[assetPath]!;
    }

    try {
      final svgString = await rootBundle.loadString(assetPath);
      _svgCache[assetPath] = svgString;
      return svgString;
    } catch (e) {
      debugPrint('Error loading SVG: $assetPath - $e');
      rethrow;
    }
  }

  Future<String> _generateCompositeSvg() async {
    // Generar un SVG compuesto básico para futuras mejoras
    StringBuffer svgBuffer = StringBuffer();
    svgBuffer.write(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">');

    // Agregar cada parte del avatar en orden
    List<String> layerOrder = ['Cuerpo', 'Ropa', 'Ojos', 'Boca', 'Accesorios'];

    for (String category in layerOrder) {
      final selection = _currentSelections[category];
      if (selection != null && selection.imagePath.isNotEmpty) {
        try {
          String svgContent = await _getSvgFromCache(selection.imagePath);
          // Extraer el contenido del SVG (simplificado)
          RegExp regExp = RegExp(r'<svg[^>]*>(.*?)</svg>', dotAll: true);
          Match? match = regExp.firstMatch(svgContent);
          if (match != null) {
            svgBuffer.write('<g class="$category">');
            svgBuffer.write(match.group(1) ?? '');
            svgBuffer.write('</g>');
          }
        } catch (e) {
          debugPrint('Error processing SVG for $category: $e');
        }
      }
    }

    svgBuffer.write('</svg>');
    return svgBuffer.toString();
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[600]),
                  const SizedBox(width: 12),
                  const Text('Cambios sin guardar'),
                ],
              ),
              content: const Text(
                'Tienes cambios sin guardar en tu avatar. ¿Estás seguro de que quieres salir?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Salir sin guardar',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                    await _saveAvatar(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar y salir',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
