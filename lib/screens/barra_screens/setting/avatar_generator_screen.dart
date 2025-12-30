import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/services.dart';

/// Editor simplificado que solo genera avatares automáticamente con Avatar Plus
class AvatarGeneratorScreen extends StatefulWidget {
  const AvatarGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<AvatarGeneratorScreen> createState() => _AvatarGeneratorScreenState();
}

class _AvatarGeneratorScreenState extends State<AvatarGeneratorScreen>
    with SingleTickerProviderStateMixin {
  // Estados para Avatar Plus
  String _selectedAvatarId = "avatar1";
  final List<String> _availableAvatarIds = [
    "avatar1",
    "avatar2",
    "avatar3",
    "avatar4",
    "avatar5",
    "avatar6",
    "avatar7",
    "avatar8",
    "avatar9",
    "avatar10",
    "avatar11",
    "avatar12",
    "avatar13",
    "avatar14",
    "avatar15",
    "avatar16",
    "avatar17",
    "avatar18",
    "avatar19",
    "avatar20",
    "avatar21",
    "avatar22",
    "avatar23",
    "avatar24",
    "avatar25",
    "avatar26",
    "avatar27",
    "avatar28",
    "avatar29",
    "avatar30"
  ];

  // Estados generales
  bool _isLoading = false;
  bool _hasChanges = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadAvatarPlusSelection();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAvatarPlusSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAvatarId = prefs.getString('avatar_plus_id');
      if (savedAvatarId != null &&
          _availableAvatarIds.contains(savedAvatarId)) {
        setState(() {
          _selectedAvatarId = savedAvatarId;
        });
      }
    } catch (e) {
      debugPrint('Error loading Avatar Plus selection: $e');
    }
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
              colors: [Color(0xFFF1F8E9), Color(0xFFE8F5E8)],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildCustomHeader(context),
                _buildAvatarPreview(),
                _buildAvatarGrid(),
              ],
            ),
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
          colors: [Colors.purple[600]!, Colors.purple[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
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
                if (shouldPop) Navigator.of(context).pop();
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
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Generador de Avatar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black26)
                ],
              ),
            ),
          ),
          Row(
            children: [
              // Botón aleatorio
              GestureDetector(
                onTap: _generateRandomAvatar,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.shuffle, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              // Botón guardar
              GestureDetector(
                onTap: _isLoading ? null : () => _saveAvatar(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purple[600]!),
                          ),
                        )
                      else
                        Icon(
                          _hasChanges ? Icons.save : Icons.check,
                          color: Colors.purple[600],
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
                          color: _isLoading
                              ? Colors.grey[600]
                              : Colors.purple[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            color: Colors.purple.withOpacity(0.1),
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
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.preview, color: Colors.purple[600], size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Vista Previa del Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome,
                          color: Colors.orange[700], size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Generado con IA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
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
              child: Hero(
                tag: 'avatar_preview',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade100.withOpacity(0.5),
                        Colors.purple.shade200.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: Colors.purple.shade300, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AvatarPlus(_selectedAvatarId,
                          height: 104, width: 104),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header del selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[50]!, Colors.purple[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child:
                        Icon(Icons.face, color: Colors.purple[600], size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecciona tu Avatar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Elige entre ${_availableAvatarIds.length} avatares únicos generados automáticamente',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.purple[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contador de selección
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple[600],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '#${_availableAvatarIds.indexOf(_selectedAvatarId) + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Grid de avatares
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _availableAvatarIds.length,
                  itemBuilder: (context, index) {
                    final avatarId = _availableAvatarIds[index];
                    final isSelected = _selectedAvatarId == avatarId;

                    return GestureDetector(
                      onTap: () => _selectAvatar(avatarId),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    Colors.purple.shade200,
                                    Colors.purple.shade300
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey.shade100,
                                    Colors.grey.shade200
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? Colors.purple.shade400
                                : Colors.grey.shade300,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.3),
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
                        child: Stack(
                          children: [
                            // Avatar
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    AvatarPlus(avatarId, height: 60, width: 60),
                              ),
                            ),
                            // Indicador de selección
                            if (isSelected)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.purple[600],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check,
                                      color: Colors.white, size: 12),
                                ),
                              ),
                            // Número del avatar
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.purple[600]
                                      : Colors.grey[600],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }

  void _selectAvatar(String avatarId) {
    setState(() {
      _selectedAvatarId = avatarId;
      _hasChanges = true;
    });
    HapticFeedback.selectionClick();
  }

  void _generateRandomAvatar() {
    final random = (_availableAvatarIds..shuffle()).first;
    setState(() {
      _selectedAvatarId = random;
      _hasChanges = true;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _saveAvatar(BuildContext context) async {
    if (!_hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userModel = Provider.of<UserModel>(context, listen: false);

      // Guardar Avatar Plus
      await prefs.setString('avatar_plus_id', _selectedAvatarId);
      await prefs.setString('current_avatar_type', 'plus');

      // Actualizar UserModel
      userModel.updateAvatarData(_selectedAvatarId, '');
      userModel.setUseCustomAvatar(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Avatar #${_availableAvatarIds.indexOf(_selectedAvatarId) + 1} guardado correctamente',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.purple[600],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: '¡Genial!',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.of(context).pop(true);
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
                    child: Text('Error al guardar avatar: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[600]),
                  const SizedBox(width: 12),
                  const Text('Cambios sin guardar'),
                ],
              ),
              content: const Text(
                'Tienes un avatar seleccionado sin guardar. ¿Estás seguro de que quieres salir?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Salir sin guardar',
                    style: TextStyle(
                        color: Colors.red[600], fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                    await _saveAvatar(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Guardar y salir',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
