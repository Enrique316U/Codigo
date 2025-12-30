import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xml/xml.dart';
import 'package:green_cloud/screens/barra_screens/Rank/rank.dart';
import 'package:green_cloud/screens/barra_screens/plant/home_screen.dart';
import 'package:green_cloud/screens/barra_screens/setting/profile_screen.dart';
import 'package:green_cloud/screens/barra_screens/store/store.dart';
import 'package:green_cloud/data/plants_data.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/screens/etapas/etapa_detalle_screen.dart';
import 'package:green_cloud/screens/barra_screens/centro_aprendizaje/screens/etapas/mapa_etapa_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = "/bottom_nav_bar";
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2;
  int _etapaSeleccionada = 1; // Etapa 1 por defecto (eliminamos el nullable)
  int?
      _etapaIndexParaMapa; // Variable para manejar el índice de la etapa en MapaEtapaScreen
  bool _isLoading =
      true; // Para mostrar loading mientras carga la etapa guardada

  // Variables para manejar el comportamiento del botón atrás
  DateTime? _lastBackPressed;
  static const int _exitTimeInMillis = 2000; // 2 segundos para salir

  @override
  void initState() {
    super.initState();
    _loadLastEtapa();
  }

  // Cargar la última etapa visitada desde SharedPreferences
  Future<void> _loadLastEtapa() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEtapa = prefs.getInt('ultima_etapa_visitada') ?? 1;

      // Validar que la etapa guardada esté dentro del rango permitido (1-6)
      final etapaValida = (savedEtapa >= 1 && savedEtapa <= 6) ? savedEtapa : 1;

      if (savedEtapa != etapaValida) {
        print(
            '⚠️ Etapa $savedEtapa fuera de rango, reseteando a etapa $etapaValida');
        // Guardar la etapa corregida
        await prefs.setInt('ultima_etapa_visitada', etapaValida);
      }

      print('📚 Cargando última etapa visitada: $etapaValida');

      setState(() {
        _etapaSeleccionada = etapaValida;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error cargando etapa: $e');
      setState(() {
        _etapaSeleccionada = 1; // Fallback a etapa 1
        _isLoading = false;
      });
    }
  }

  // Guardar la etapa actual en SharedPreferences
  Future<void> _saveLastEtapa(int etapa) async {
    try {
      // Validar que la etapa esté en el rango permitido (1-6)
      if (etapa < 1 || etapa > 6) {
        print('⚠️ Intento de guardar etapa $etapa fuera de rango. Ignorando.');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ultima_etapa_visitada', etapa);
      print('💾 Etapa $etapa guardada como última visitada');
    } catch (e) {
      print('❌ Error guardando etapa: $e');
    }
  }

  final List<NavItem> _navItems = [
    NavItem(
      iconPath: 'lib/assets/icons/flag.svg',
      layerToToggle: 'Vector',
    ),
    NavItem(
      iconPath: 'lib/assets/icons/tent.svg',
      layerToToggle: 'Vector',
    ),
    NavItem(
      iconPath: 'lib/assets/icons/flower.svg',
      layerToToggle: 'Vector',
    ),
    NavItem(
      iconPath: 'lib/assets/icons/plant_stack.svg',
      layerToToggle: 'Vector',
    ),
    NavItem(
      iconPath: 'lib/assets/icons/user.svg',
      layerToToggle: 'Vector',
    ),
  ];

  // Método para navegar a una etapa específica
  void navigateToEtapa(int etapa) {
    // Validar que la etapa esté en el rango permitido (1-6)
    if (etapa < 1 || etapa > 6) {
      print('⚠️ Intento de navegar a etapa $etapa fuera de rango. Ignorando.');
      return;
    }

    print('🎯 Navegando a etapa: $etapa');
    setState(() {
      _etapaSeleccionada = etapa;
      _selectedIndex = 3; // Asegurar que estamos en la sección del mapa
    });
    _saveLastEtapa(etapa); // Guardar la etapa visitada
  }

  // Método para volver al mapa de la etapa actual (NO al mapa de progreso genérico)
  void volverAlMapa() {
    setState(() {
      _etapaIndexParaMapa = null;
      // _etapaSeleccionada se mantiene, no volvemos al mapa genérico
    });
  }

  // Método para navegar a MapaEtapaScreen
  void navigateToMapaEtapa(int etapaIndex) {
    final etapaNumber = etapaIndex + 1;

    // Validar que la etapa esté en el rango permitido (1-6)
    if (etapaNumber < 1 || etapaNumber > 6) {
      print(
          '⚠️ Intento de navegar al mapa de etapa $etapaNumber fuera de rango. Ignorando.');
      return;
    }

    print('🗺️ Navegando al mapa de etapa: $etapaNumber');
    setState(() {
      _etapaIndexParaMapa = etapaIndex;
      _selectedIndex = 3; // Asegurar que estamos en la sección del mapa
    });
    _saveLastEtapa(etapaNumber); // Guardar la etapa (etapaIndex es 0-based)
  }

  // Método para volver a EtapaDetalleScreen desde MapaEtapaScreen
  void volverAEtapaDetalle() {
    setState(() {
      _etapaIndexParaMapa = null;
      // _etapaSeleccionada se mantiene para volver a las cartas
    });
  }

  // Método para actualizar la etapa cuando cambia desde EtapaDetalleScreen
  void onEtapaChanged(int nuevaEtapa) {
    // Validar que la etapa esté en el rango permitido (1-6)
    if (nuevaEtapa < 1 || nuevaEtapa > 6) {
      print(
          '⚠️ Intento de cambiar a etapa $nuevaEtapa fuera de rango. Ignorando.');
      return;
    }

    print('🔄 Actualizando etapa en BottomNavBar: $nuevaEtapa');
    setState(() {
      _etapaSeleccionada = nuevaEtapa;
    });
    _saveLastEtapa(nuevaEtapa);
  }

  List<Widget> get _widgetOptions => <Widget>[
        const LogrosScreen(),
        const TiendaScreen(),
        HomeScreens(plant: plants[0]),
        // Mostrar loading mientras carga, luego la pantalla apropiada
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _etapaIndexParaMapa != null
                ? MapaEtapaScreen(
                    etapaIndex: _etapaIndexParaMapa!,
                    onBackPressed: volverAEtapaDetalle,
                  )
                : EtapaDetalleScreen(
                    etapa: _etapaSeleccionada,
                    onBackPressed: volverAlMapa,
                    onIngresarPressed: navigateToMapaEtapa,
                    onEtapaChanged: onEtapaChanged, // Agregar el callback
                  ),
        const ProfileScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Mantenemos el estado de la etapa seleccionada para preservar la navegación
    });
  }

  // Método para manejar el comportamiento del botón atrás
  Future<bool> _onWillPop() async {
    const homeIndex = 2; // Índice de la pantalla de la planta (HomeScreens)

    // Si no está en la pantalla principal (planta), navegar a ella
    if (_selectedIndex != homeIndex) {
      setState(() {
        _selectedIndex = homeIndex;
      });
      return false; // No salir de la app
    }

    // Si está en la pantalla principal, implementar "presionar dos veces para salir"
    final DateTime now = DateTime.now();

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) >
            const Duration(milliseconds: _exitTimeInMillis)) {
      _lastBackPressed = now;

      // Mostrar mensaje de que presione atrás de nuevo para salir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Presiona atrás de nuevo para salir'),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(milliseconds: _exitTimeInMillis),
        ),
      );

      return false; // No salir todavía
    }

    // Si presionó atrás dos veces dentro del tiempo límite, salir de la app
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: const Color.fromARGB(255, 72, 175, 80),
            unselectedItemColor: Colors.grey,
            items: List.generate(
              _navItems.length,
              (index) {
                final item = _navItems[index];
                return BottomNavigationBarItem(
                  icon: CustomSvgIcon(
                    iconPath: item.iconPath,
                    isSelected: _selectedIndex == index,
                    layerToToggle: item.layerToToggle,
                  ),
                  label: '',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String iconPath;
  final String? layerToToggle;

  NavItem({
    required this.iconPath,
    this.layerToToggle,
  });
}

/// Versión StatefulWidget para el ícono SVG, carga el asset solo una vez
class CustomSvgIcon extends StatefulWidget {
  final String iconPath;
  final bool isSelected;
  final String? layerToToggle;

  const CustomSvgIcon({
    super.key,
    required this.iconPath,
    this.isSelected = false,
    this.layerToToggle,
  });

  @override
  _CustomSvgIconState createState() => _CustomSvgIconState();
}

class _CustomSvgIconState extends State<CustomSvgIcon> {
  String? _svgString;
  Color _extractedColor = const Color.fromARGB(255, 187, 209, 179);

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    final svgStr =
        await DefaultAssetBundle.of(context).loadString(widget.iconPath);
    setState(() {
      _svgString = svgStr;
    });
    _updateSvg();
  }

  void _updateSvg() {
    if (_svgString != null) {
      final document = XmlDocument.parse(_svgString!);

      if (widget.layerToToggle != null) {
        final layerElements = document.findAllElements('*').where(
              (element) => element.getAttribute('id') == widget.layerToToggle,
            );

        for (var layerElement in layerElements) {
          final fillAttribute = layerElement.getAttribute('fill');
          if (fillAttribute != null) {
            try {
              _extractedColor = _parseColor(fillAttribute);
            } catch (_) {
              _extractedColor = const Color.fromARGB(255, 187, 209, 179);
            }
          }
          if (!widget.isSelected) {
            layerElement.setAttribute('display', 'none');
          } else {
            layerElement.removeAttribute('display');
          }
        }
      }
      setState(() {
        _svgString = document.toXmlString();
      });
    }
  }

  @override
  void didUpdateWidget(covariant CustomSvgIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _updateSvg();
    }
  }

  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    } else if (colorString.startsWith('rgb')) {
      final values = colorString
          .replaceAll(RegExp(r'[^0-9,]'), '')
          .split(',')
          .map((v) => int.parse(v))
          .toList();
      return Color.fromRGBO(values[0], values[1], values[2], 1);
    }
    return const Color.fromARGB(255, 187, 209, 179);
  }

  @override
  Widget build(BuildContext context) {
    if (_svgString == null) {
      return const SizedBox(
        width: 60,
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: widget.isSelected ? _extractedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SvgPicture.string(
          _svgString!,
          width: 65,
          height: 65,
        ),
      ),
    );
  }
}
