import 'package:flutter/material.dart';
import '../../../../models/plant.dart';
import 'package:firebase_database/firebase_database.dart';
import '../chat/chat_ai_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../widgets/animated_clouds.dart';
import 'package:provider/provider.dart';
import '../../../../models/store_model.dart';
import '../../../../data/firebase_service.dart';
import '../../../../services/location_service.dart';

class HomeScreens extends StatefulWidget {
  static const String routeName = "/home";
  final Plant plant;
  const HomeScreens({super.key, required this.plant});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens>
    with TickerProviderStateMixin {
  int hearts = 3; // Número de corazones disponibles
  AnimationController? _droneAnimationController;
  Animation<double>? _droneAnimation;

  // Servicios para Firebase y ubicación
  final FirebaseService _firebaseService = FirebaseService();
  final LocationService _locationService = LocationService();

  // Variables para la planta más cercana
  String? _nearestDeviceId;
  Map<String, dynamic>? _nearestDeviceData;
  double? _distanceToNearestDevice;
  bool _isLoadingNearestDevice = true;
  String? _locationError;

  @override
  void initState() {
    super.initState();

    // Inicializar animación del dron
    _droneAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _droneAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _droneAnimationController!,
      curve: Curves.easeInOut,
    ));

    // Iniciar animación repetitiva
    _droneAnimationController?.repeat(reverse: true);

    // Buscar la planta más cercana
    _findNearestDevice();
  }

  Future<void> _findNearestDevice() async {
    try {
      setState(() {
        _isLoadingNearestDevice = true;
        _locationError = null;
      });

      // Obtener ubicación actual del usuario
      final userLocation = await _locationService.getCurrentLocation();

      // Buscar el dispositivo más cercano
      final nearestResult = await _firebaseService.getNearestDevice(
        userLocation['latitude']!,
        userLocation['longitude']!,
      );

      setState(() {
        _nearestDeviceId = nearestResult['deviceId'];
        _nearestDeviceData = nearestResult['data'];
        _distanceToNearestDevice = nearestResult['distance'];
        _isLoadingNearestDevice = false;
      });
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isLoadingNearestDevice = false;
      });

      // Si hay error, usar el primer dispositivo disponible como fallback
      try {
        final devices = await _firebaseService.getAllDevices();
        if (devices.isNotEmpty) {
          final firstDeviceId = devices.keys.first;
          // Asegurarse de que el valor sea un Map<String, dynamic>
          final deviceData = devices[firstDeviceId];
          final Map<String, dynamic> safeDeviceData =
              deviceData is Map ? Map<String, dynamic>.from(deviceData) : {};

          setState(() {
            _nearestDeviceId = firstDeviceId;
            _nearestDeviceData = safeDeviceData;
            _distanceToNearestDevice = null; // Sin distancia conocida
          });
        }
      } catch (fallbackError) {
        print('Error en fallback: $fallbackError');
      }
    }
  }

  // Mostrar lista de todos los dispositivos disponibles
  void _showDevicesListDialog() async {
    try {
      final userLocation = await _locationService.getCurrentLocation();
      final nearestResult = await _firebaseService.getNearestDevice(
        userLocation['latitude']!,
        userLocation['longitude']!,
      );

      final allDevices = nearestResult['allDevicesWithLocation']
              as List<Map<String, dynamic>>? ??
          [];

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.eco, color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Dispositivos EVA Disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  // Lista de dispositivos
                  Flexible(
                    child: allDevices.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(Icons.location_off,
                                    size: 48, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'No se encontraron dispositivos con ubicación GPS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: allDevices.length,
                            itemBuilder: (context, index) {
                              final device = allDevices[index];
                              final isNearest =
                                  device['deviceId'] == _nearestDeviceId;

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isNearest
                                      ? Colors.green.shade50
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isNearest
                                      ? Border.all(
                                          color: Colors.green.shade300,
                                          width: 2)
                                      : null,
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isNearest
                                          ? Colors.green.shade100
                                          : Colors.blue.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isNearest ? Icons.star : Icons.eco,
                                      color: isNearest
                                          ? Colors.green.shade600
                                          : Colors.blue.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        device['deviceId'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isNearest
                                              ? Colors.green.shade700
                                              : Colors.black87,
                                        ),
                                      ),
                                      if (isNearest) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'MÁS CERCANO',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  subtitle: Text(
                                    '${device['distance'] < 1000 ? '${device['distance'].toInt()}m' : '${(device['distance'] / 1000).toStringAsFixed(1)}km'} - '
                                    '${device['latitude'].toStringAsFixed(4)}, ${device['longitude'].toStringAsFixed(4)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: isNearest
                                        ? null
                                        : () {
                                            setState(() {
                                              _nearestDeviceId =
                                                  device['deviceId'];
                                              _nearestDeviceData =
                                                  device['data'];
                                              _distanceToNearestDevice =
                                                  device['distance'];
                                            });
                                            Navigator.pop(context);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isNearest
                                          ? Colors.grey.shade300
                                          : Colors.blue.shade500,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(60, 30),
                                    ),
                                    child: Text(
                                      isNearest ? 'ACTUAL' : 'USAR',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Total: ${allDevices.length} dispositivos con GPS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar dispositivos: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  @override
  void dispose() {
    _droneAnimationController?.dispose();
    super.dispose();
  }

  void _showAdvertisementDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón X para cerrar
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Imagen de publicidad
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'lib/assets/animations/publicidad.jpg',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.8,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text(
                              'Imagen no disponible',
                              style: TextStyle(color: Colors.grey),
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
      },
    );
  }

  void _showHeartsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const Text(
                  "CORAZONES",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 72, 175, 80),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.favorite,
                        color: index < hearts ? Colors.red : Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes agregar la lógica para ver más detalles
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "VER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes agregar la lógica para ver más detalles
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "VER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final textSize = screenSize.width * 0.07; // 10% del ancho de pantalla

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Fila superior: Ícono a la izquierda, porcentaje a la derecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: textSize * 0.6, // Tamaño del ícono proporcional al texto
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Descripción abajo de todo
          Text(
            label,
            style: TextStyle(
              fontSize: textSize * 0.3, // 30% del tamaño principal
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Si aún está cargando la planta más cercana, mostrar indicador
    if (_isLoadingNearestDevice) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Buscando la planta más cercana...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Si hay error de ubicación, mostrar mensaje
    if (_locationError != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 64,
                color: Colors.orange.shade600,
              ),
              const SizedBox(height: 16),
              Text(
                'No se pudo obtener tu ubicación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _nearestDeviceId != null
                      ? 'Mostrando la primera planta disponible'
                      : 'Error: $_locationError',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _findNearestDevice,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // Si no hay dispositivo seleccionado, mostrar mensaje
    if (_nearestDeviceId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.eco_outlined,
                size: 64,
                color: Colors.green.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No se encontraron plantas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _findNearestDevice,
                child: const Text('Buscar plantas'),
              ),
            ],
          ),
        ),
      );
    }

    // Crear referencia al dispositivo más cercano
    final DatabaseReference _databaseRef =
        FirebaseDatabase.instance.ref("devices/$_nearestDeviceId");

    return Scaffold(
      body: StreamBuilder<DatabaseEvent>(
        stream: _databaseRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData &&
              snapshot.data!.snapshot.value != null) {
            final rawData = snapshot.data!.snapshot.value;
            final deviceData = Map<String, dynamic>.from(rawData as Map);

            // Extraer datos de sensores de la estructura más reciente del historial
            Map<String, dynamic> data = {};
            if (deviceData.containsKey('history')) {
              final historyRaw = deviceData['history'];
              final history = historyRaw is Map
                  ? Map<String, dynamic>.from(historyRaw)
                  : null;

              if (history != null && history.isNotEmpty) {
                final dates = history.keys.toList()
                  ..sort((a, b) => b.compareTo(a));
                final latestDate = dates.first;
                final dayDataRaw = history[latestDate];
                final dayData = dayDataRaw is Map
                    ? Map<String, dynamic>.from(dayDataRaw)
                    : null;

                if (dayData != null && dayData.isNotEmpty) {
                  final times = dayData.keys.toList()
                    ..sort((a, b) => b.compareTo(a));
                  final latestTime = times.first;
                  final timeDataRaw = dayData[latestTime];
                  final timeData = timeDataRaw is Map
                      ? Map<String, dynamic>.from(timeDataRaw)
                      : null;

                  if (timeData != null && timeData.containsKey('sensors')) {
                    final sensorsRaw = timeData['sensors'];
                    final sensors = sensorsRaw is Map
                        ? Map<String, dynamic>.from(sensorsRaw)
                        : null;
                    if (sensors != null) {
                      // Mapear los datos de sensores al formato esperado por la UI
                      data = {
                        'temperature': sensors['temperature'] ?? 0,
                        'soilMoisture': sensors['soil_moisture'] ?? 0,
                        'humidity': sensors['humidity'] ?? 0,
                        'lightLevel': sensors['light_level'] ?? 0,
                      };
                    }
                  }
                }
              }
            }

            // Si no hay datos en history, usar valores por defecto
            if (data.isEmpty) {
              data = {
                'temperature': 25.0,
                'soilMoisture': 50.0,
                'humidity': 60.0,
                'lightLevel': 1,
              };
            }

            return Consumer<StoreModel>(
              builder: (context, storeModel, child) {
                return Stack(
                  children: [
                    // Fondo con imagen SVG dinámico - toca para cambiar
                    GestureDetector(
                      onTap: () {
                        if (storeModel.isInitialized) {
                          _showBackgroundSelectionDialog(context, storeModel);
                        }
                      },
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            storeModel.isInitialized
                                ? storeModel.getSelectedBackgroundSvgPath()
                                : 'lib/assets/images/fondos/fondo_misti.svg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholderBuilder: (context) => Container(
                              color: Colors.green.shade100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ),
                          ),
                          // Indicador sutil de que se puede cambiar el fondo
                          if (storeModel.isInitialized)
                            Positioned(
                              top: 100,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.landscape,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Nubes animadas
                    const AnimatedClouds(),

                    // Contenido principal
                    SafeArea(
                      child: Column(
                        children: [
                          // Barra superior con iconos
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                // Información de la planta más cercana
                                if (_nearestDeviceId != null)
                                  GestureDetector(
                                    onTap: _showDevicesListDialog,
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 8.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.95),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Indicador de estado
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade500,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.eco,
                                            color: Colors.green.shade600,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _nearestDeviceId!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                          if (_distanceToNearestDevice !=
                                              null) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.near_me,
                                                    color: Colors.blue.shade600,
                                                    size: 12,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    _distanceToNearestDevice! <
                                                            1000
                                                        ? '${_distanceToNearestDevice!.toInt()}m'
                                                        : '${(_distanceToNearestDevice! / 1000).toStringAsFixed(1)}km',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blue.shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          const SizedBox(width: 8),
                                          // Indicador de que es clickeable
                                          Icon(
                                            Icons.expand_more,
                                            color: Colors.grey.shade600,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: _findNearestDevice,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.refresh,
                                                color: Colors.grey.shade600,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                // Primera fila: Chat y Corazón (a la misma altura)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Botón de chat
                                    IconButton(
                                      icon: const Icon(
                                        Icons.chat_bubble_outline,
                                        size: 60.0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ChatAIScreen(),
                                          ),
                                        );
                                      },
                                      color: Colors.white,
                                      iconSize: 66.0,
                                    ),
                                    // Botón de corazones (a la altura del chat)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 60.0,
                                      ),
                                      onPressed: _showHeartsDialog,
                                      iconSize: 66.0,
                                    ),
                                  ],
                                ),
                                // Segunda fila: Solo el dron (a la izquierda)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 20.0),
                                      child: GestureDetector(
                                        onTap: _showAdvertisementDialog,
                                        child: _droneAnimation != null
                                            ? AnimatedBuilder(
                                                animation: _droneAnimation!,
                                                builder: (context, child) {
                                                  return Transform.translate(
                                                    offset: Offset(0,
                                                        _droneAnimation!.value),
                                                    child: SvgPicture.asset(
                                                      'lib/assets/animations/dron_investigacion_usmp.svg',
                                                      width:
                                                          120, // Doble de tamaño: 60 → 120
                                                      height:
                                                          120, // Doble de tamaño: 60 → 120
                                                      // Removido: color: Colors.white (mantiene colores originales)
                                                    ),
                                                  );
                                                },
                                              )
                                            : SvgPicture.asset(
                                                'lib/assets/animations/dron_investigacion_usmp.svg',
                                                width: 120,
                                                height: 120,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Spacer(flex: 1),

                          // Reorganizamos el layout para mejor integración
                          Expanded(
                            flex: 5,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                // Mesa SVG (en el fondo)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: SvgPicture.asset(
                                    'lib/assets/images/mesas/mesa_marron.svg',
                                    width: size.width,
                                    height: size.height * 0.2,
                                    fit: BoxFit.cover,
                                    placeholderBuilder: (context) => Container(
                                      width: size.width,
                                      height: size.height * 0.3,
                                      color: Colors.brown.shade200,
                                      child: Center(
                                        child: Text(
                                          'Mesa',
                                          style: TextStyle(
                                            color: Colors.brown.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Libros SVG
                                Positioned(
                                  bottom: size.height * 0.15,
                                  right: size.width * 0.15,
                                  child: SvgPicture.asset(
                                    'lib/assets/images/libros/libros.svg',
                                    height: size.height * 0.20,
                                    width: size.width * 0.25,
                                    fit: BoxFit.contain,
                                    placeholderBuilder: (context) => Container(
                                      width: size.width * 0.2,
                                      height: size.height * 0.15,
                                      color: Colors.blue.shade200,
                                      child: Center(
                                        child: Icon(
                                          Icons.menu_book,
                                          color: Colors.blue.shade600,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Maceta (primero - base) - Usando Consumer para obtener la maceta seleccionada
                                Positioned(
                                  bottom: size.height * 0.30,
                                  left: size.width * 0.54 -
                                      (size.width * 0.45) /
                                          2, // Centrado horizontalmente
                                  child: Consumer<StoreModel>(
                                    builder: (context, storeModel, child) {
                                      // Mostrar maceta por defecto si no está inicializado
                                      if (!storeModel.isInitialized) {
                                        return SvgPicture.asset(
                                          'lib/assets/images/pots/maceta_01.svg',
                                          width: size.width * 0.5,
                                          height: size.height * 0.5,
                                          fit: BoxFit.contain,
                                        );
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          _showPotSelectionDialog(
                                              context, storeModel);
                                        },
                                        child: Stack(
                                          children: [
                                            SvgPicture.asset(
                                              storeModel.selectedPotImage,
                                              width: size.width *
                                                  0.2, // 35% del ancho de pantalla para mejor visibilidad
                                              height: size.height *
                                                  0.2, // 30% de la altura de pantalla
                                              fit: BoxFit.contain,
                                              placeholderBuilder: (context) =>
                                                  Container(
                                                width: size.width * 0.05,
                                                height: size.height * 0.05,
                                                color: Colors.brown,
                                                child: const Center(
                                                  child: Text('Maceta',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                            // Icono de configuración para cambiar maceta
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.swap_horiz,
                                                  size: 16,
                                                  color: Colors.green.shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Planta (después - encima de la maceta)
                                Positioned(
                                  bottom: size.height * 0.47,
                                  left: size.width * 0.5 -
                                      (size.width * 0.5) /
                                          2, // Centrado horizontalmente
                                  child: SvgPicture.asset(
                                    'lib/assets/images/plants/floracion.svg',
                                    width: size.width *
                                        0.3, // 30% del ancho de pantalla
                                    height: size.height *
                                        0.35, // 35% de la altura de pantalla
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                // Panel de información deslizante
                                DraggableScrollableSheet(
                                  initialChildSize:
                                      0.08, // Tamaño inicial (8% - oculto al inicio)
                                  minChildSize:
                                      0.08, // Tamaño mínimo (8% - casi oculto)
                                  maxChildSize:
                                      0.6, // Tamaño máximo (60% de la pantalla)
                                  snap:
                                      true, // Hacer que se ajuste a posiciones específicas
                                  snapSizes: const [
                                    0.08,
                                    0.15,
                                    0.6
                                  ], // Posiciones de ajuste
                                  builder: (context, scrollController) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: const Offset(0, -8),
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          children: [
                                            // Handle para arrastrar
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              width: 40,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius:
                                                    BorderRadius.circular(2.5),
                                              ),
                                            ),

                                            // Contenido cuando está minimizado
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Viguiera Procumbens",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF2E7D32),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.water_drop,
                                                          color:
                                                              data['soilMoisture'] <
                                                                      20
                                                                  ? Colors.red
                                                                      .shade400
                                                                  : Colors.blue
                                                                      .shade400,
                                                          size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                          "${(data['soilMoisture'] * 1.0).toInt()}%"),
                                                      const SizedBox(width: 12),
                                                      Icon(
                                                          Icons
                                                              .thermostat_rounded,
                                                          color: Colors
                                                              .green.shade400,
                                                          size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                          "${data['temperature'].toInt()}°C"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Contenido expandido
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  // Alerta si es necesaria
                                                  if (data['soilMoisture'] < 20)
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 16),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFFFEBEE),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .warning_rounded,
                                                            color: Colors
                                                                .red.shade600,
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Expanded(
                                                            child: Text(
                                                              "¡Por favor, riega la planta!",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                  // Grid de sensores
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: _buildSensorCard(
                                                          icon:
                                                              Icons.water_drop,
                                                          value:
                                                              "${(data['soilMoisture'] * 1.0).toInt()}%",
                                                          label: "Water tank",
                                                          color:
                                                              data['soilMoisture'] <
                                                                      20
                                                                  ? Colors.red
                                                                      .shade400
                                                                  : Colors.blue
                                                                      .shade400,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: _buildSensorCard(
                                                          icon: Icons
                                                              .wb_sunny_rounded,
                                                          value:
                                                              "${((data['lightLevel'] / 4000) * 100).toInt()}%",
                                                          label: "Light",
                                                          color: Colors
                                                              .orange.shade400,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: _buildSensorCard(
                                                          icon: Icons
                                                              .thermostat_rounded,
                                                          value:
                                                              "${data['temperature'].toInt()}°C",
                                                          label: "Temper.",
                                                          color: Colors
                                                              .green.shade400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 16),

                                                  // Humedad ambiental (más destacada)
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade200,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Ícono (izquierda)
                                                        Icon(
                                                          Icons.opacity_rounded,
                                                          color: Colors
                                                              .blue.shade400,
                                                          size: 24,
                                                        ),

                                                        // Porcentaje (centro)
                                                        Text(
                                                          "${data['humidity'].toInt()}%",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF1976D2),
                                                          ),
                                                        ),

                                                        // Texto "Humedad Ambiental" (derecha)
                                                        Text(
                                                          "Humedad Ambiental",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }

  // Método para mostrar el diálogo de selección de macetas
  void _showPotSelectionDialog(BuildContext context, StoreModel storeModel) {
    final ownedPots = storeModel.getOwnedPots();
    print('🏺 Abriendo selector: ${ownedPots.length} macetas');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Seleccionar Maceta",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 72, 175, 80),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Grid de macetas
                Container(
                  height: 300,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: storeModel.getOwnedPots().length,
                    itemBuilder: (context, index) {
                      final pot = storeModel.getOwnedPots()[index];
                      final isSelected = pot.id == storeModel.selectedPotId;

                      return GestureDetector(
                        onTap: () {
                          print('🎯 Seleccionando: ${pot.name}');
                          storeModel.selectPot(pot.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Maceta "${pot.name}" seleccionada'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Colors.green.shade50
                                : Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Imagen de la maceta
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    pot.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // Nombre de la maceta
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    pot.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.green.shade700
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // Indicador de selección
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Botón para ir a la tienda
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Cambiar a la pestaña de la tienda (índice 1 según BottomNavBar)
                    // Necesitamos acceder al BottomNavBar parent para cambiar la pestaña
                    final bottomNavBarState = context
                        .findAncestorStateOfType<State<StatefulWidget>>();
                    if (bottomNavBarState != null &&
                        bottomNavBarState.mounted) {
                      // Buscar el método _onItemTapped en el estado padre
                      try {
                        (bottomNavBarState as dynamic)._onItemTapped(1);
                      } catch (e) {
                        // Fallback: mostrar mensaje
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Ve a la tienda para comprar más macetas'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Comprar más macetas",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método para mostrar el diálogo de selección de fondos
  void _showBackgroundSelectionDialog(
      BuildContext context, StoreModel storeModel) {
    final ownedBackgrounds = storeModel.getOwnedBackgrounds();
    print('🖼️ Abriendo selector: ${ownedBackgrounds.length} fondos');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Seleccionar Fondo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 72, 175, 80),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Grid de fondos
                Container(
                  height: 300,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2, // Más ancho para los fondos
                    ),
                    itemCount: storeModel.getOwnedBackgrounds().length,
                    itemBuilder: (context, index) {
                      final background =
                          storeModel.getOwnedBackgrounds()[index];
                      final isSelected =
                          background.id == storeModel.selectedBackgroundId;

                      return GestureDetector(
                        onTap: () {
                          print('🎯 Seleccionando: ${background.name}');
                          storeModel.selectBackground(background.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Fondo "${background.name}" seleccionado'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Colors.green.shade50
                                : Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Vista previa del fondo
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SvgPicture.asset(
                                      'lib/assets/images/fondos/${background.id}.svg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      placeholderBuilder: (context) =>
                                          Container(
                                        color: Colors.grey.shade300,
                                        child: Icon(
                                          Icons.landscape,
                                          color: Colors.grey.shade600,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Nombre del fondo
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    background.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.green.shade700
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // Indicador de selección
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Botón para ir a la tienda
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Cambiar a la pestaña de la tienda (índice 1 según BottomNavBar)
                    final bottomNavBarState = context
                        .findAncestorStateOfType<State<StatefulWidget>>();
                    if (bottomNavBarState != null &&
                        bottomNavBarState.mounted) {
                      try {
                        (bottomNavBarState as dynamic)._onItemTapped(1);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Ve a la tienda para comprar más fondos'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Comprar más fondos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
