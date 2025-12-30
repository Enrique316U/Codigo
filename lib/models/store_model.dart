import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreModel extends ChangeNotifier {
  int _coins = 100000; // Dinero inicial para pruebas
  final List<PurchasedItem> _purchasedItems = [];
  String _selectedPotId = 'maceta_01'; // Maceta por defecto
  String _selectedBackgroundId = 'fondo_misti'; // Fondo por defecto
  bool _isInitialized = false;

  // Getters públicos
  int get coins => _coins;
  String get selectedPotId => _selectedPotId;
  String get selectedBackgroundId => _selectedBackgroundId;
  bool get isInitialized => _isInitialized;

  // Categorías disponibles en la tienda
  final List<String> categories = ['Fondos', 'Macetas'];

  // Items disponibles en la tienda por categoría
  final Map<String, List<StoreItem>> availableItems = {
    'Fondos': [
      StoreItem(
          id: 'fondo_misti',
          name: 'Fondo Misti',
          price: 0, // Gratis por defecto
          image: 'lib/assets/images/fondos/fondo_misti.jpg'),
      StoreItem(
          id: 'fondo_iglesia',
          name: 'Fondo Iglesia',
          price: 500,
          image: 'lib/assets/images/fondos/fondo_iglesia.jpg'),
      StoreItem(
          id: 'fondo_yanahuara',
          name: 'Fondo Yanahuara',
          price: 750,
          image: 'lib/assets/images/fondos/fondo_yanahuara.jpg'),
      StoreItem(
          id: 'fondo_montaña',
          name: 'Fondo Montaña',
          price: 1000,
          image: 'lib/assets/images/fondos/fondo_montaña.jpg'),
      StoreItem(
          id: 'fondo_ingles_plaza',
          name: 'Fondo Plaza Inglés',
          price: 1250,
          image: 'lib/assets/images/fondos/fondo_ingles_plaza.jpg'),
      StoreItem(
          id: 'fondo_casas',
          name: 'Casas Tradicionales',
          price: 1500,
          image: 'lib/assets/images/fondos/fondo_casas.jpg'),
      StoreItem(
          id: 'fondo_cascada',
          name: 'Cascada Natural',
          price: 1750,
          image: 'lib/assets/images/fondos/fondo_cascada.jpg'),
      StoreItem(
          id: 'fondo_flamencos',
          name: 'Lago de Flamencos',
          price: 2000,
          image: 'lib/assets/images/fondos/fondo_flamencos.jpg'),
    ],
    'Macetas': [
      StoreItem(
          id: 'maceta_01',
          name: 'Maceta Clásica',
          price: 0, // Gratis por defecto
          image: 'lib/assets/images/pots/maceta_01.svg'),
      StoreItem(
          id: 'maceta_02',
          name: 'Maceta Moderna',
          price: 500,
          image: 'lib/assets/images/pots/maceta_02.svg'),
      StoreItem(
          id: 'maceta_03',
          name: 'Maceta Elegante',
          price: 750,
          image: 'lib/assets/images/pots/maceta_03.svg'),
      StoreItem(
          id: 'maceta_04',
          name: 'Maceta Premium',
          price: 1000,
          image: 'lib/assets/images/pots/maceta_04.svg'),
      StoreItem(
          id: 'maceta_05',
          name: 'Maceta Decorativa',
          price: 1250,
          image: 'lib/assets/images/pots/maceta_05.svg'),
      StoreItem(
          id: 'maceta_06',
          name: 'Maceta Artística',
          price: 1500,
          image: 'lib/assets/images/pots/maceta_06.svg'),
      StoreItem(
          id: 'maceta_07',
          name: 'Maceta Exclusiva',
          price: 2000,
          image: 'lib/assets/images/pots/maceta_07.svg'),
      StoreItem(
          id: 'maceta_08',
          name: 'Maceta Única',
          price: 2500,
          image: 'lib/assets/images/pots/maceta_08.svg'),
    ],
  };

  StoreModel() {
    print('🏪 Creando nueva instancia de StoreModel');
    _initializeData();
  }

  // Inicializar datos y elementos por defecto
  Future<void> _initializeData() async {
    print('🔄 Inicializando datos del StoreModel...');
    await loadData();
    print('📂 Datos cargados desde SharedPreferences');
    _initializeDefaultItems();
    _isInitialized = true;
    print('✅ StoreModel inicializado completamente');
  }

  // Inicializar elementos por defecto (como la primera maceta gratuita)
  void _initializeDefaultItems() {
    print('🔧 Inicializando elementos por defecto...');
    print('📋 Items comprados antes: ${_purchasedItems.length}');

    // Asegurar que la primera maceta esté "comprada" por defecto
    if (!isItemPurchased('maceta_01')) {
      print('🎁 Agregando maceta gratuita por defecto');
      _purchasedItems.add(
        PurchasedItem(
          itemId: 'maceta_01',
          category: 'Macetas',
          purchaseDate: DateTime.now(),
        ),
      );
      print(
          '📋 Items comprados después de agregar gratuita: ${_purchasedItems.length}');
      saveData();
      notifyListeners();
    } else {
      print('✅ La maceta gratuita ya está en el inventario');
    }

    // Asegurar que el primer fondo esté "comprado" por defecto
    if (!isItemPurchased('fondo_misti')) {
      print('🎁 Agregando fondo gratuito por defecto');
      _purchasedItems.add(
        PurchasedItem(
          itemId: 'fondo_misti',
          category: 'Fondos',
          purchaseDate: DateTime.now(),
        ),
      );
      print(
          '📋 Items comprados después de agregar fondo gratuito: ${_purchasedItems.length}');
      saveData();
      notifyListeners();
    } else {
      print('✅ El fondo gratuito ya está en el inventario');
    }
  }

  // Debug: mostrar estado actual
  void debugShowCurrentState() {
    print('\n🔍 === ESTADO ACTUAL DEL MODELO ===');
    print('💰 Monedas: $_coins');
    print('🏺 Maceta seleccionada: $_selectedPotId');
    print('🖼️ Fondo seleccionado: $_selectedBackgroundId');
    print('📦 Items comprados: ${_purchasedItems.length}');
    for (var item in _purchasedItems) {
      print('  - ${item.itemId} (${item.category})');
    }
    print('🔍 === FIN ESTADO ===\n');
  }

  // Obtener la imagen de la maceta seleccionada
  String get selectedPotImage {
    final selectedPot = availableItems['Macetas']?.firstWhere(
      (item) => item.id == _selectedPotId,
      orElse: () => availableItems['Macetas']!.first,
    );
    return selectedPot?.image ?? 'lib/assets/images/pots/maceta_01.svg';
  }

  // Obtener la imagen del fondo seleccionado
  String get selectedBackgroundImage {
    final selectedBackground = availableItems['Fondos']?.firstWhere(
      (item) => item.id == _selectedBackgroundId,
      orElse: () => availableItems['Fondos']!.first,
    );
    return selectedBackground?.image ??
        'lib/assets/images/fondos/fondo_misti.svg';
  }

  // Métodos para obtener compras por categoría
  List<PurchasedItem> getPurchasedItemsByCategory(String category) {
    return _purchasedItems.where((item) => item.category == category).toList();
  }

  // Obtener la cantidad de items comprados por categoría
  String getPurchasedCountByCategory(String category) {
    int purchased =
        _purchasedItems.where((item) => item.category == category).length;
    int total = availableItems[category]?.length ?? 0;
    return '$purchased/$total';
  }

  // Verificar si un ítem ya ha sido comprado
  bool isItemPurchased(String itemId) {
    final result = _purchasedItems.any((item) => item.itemId == itemId);
    // Solo mostrar log para items específicos si es necesario debug
    // print('🔍 ¿Está comprado $itemId? $result (Total items: ${_purchasedItems.length})');
    return result;
  }

  // Añadir monedas al usuario
  void addCoins(int amount) {
    _coins += amount;
    saveData();
    notifyListeners();
  }

  // Establecer monedas (usado por sincronización)
  void setCoins(int amount) {
    _coins = amount;
    saveData();
    notifyListeners();
  }

  // Comprar un ítem
  bool purchaseItem(StoreItem item, String category) {
    print('🛒 === INICIANDO COMPRA ===');
    print('📦 Item: ${item.name} (${item.id})');
    print('💰 Precio: ${item.price} monedas');
    print('💳 Saldo actual: $_coins monedas');

    // Verificar si ya está comprado
    if (isItemPurchased(item.id)) {
      print('❌ COMPRA CANCELADA: Ya está comprado');
      return false;
    }

    // Verificar si hay suficientes monedas
    if (_coins < item.price) {
      print('❌ COMPRA CANCELADA: Monedas insuficientes');
      print('💸 Necesitas ${item.price - _coins} monedas más');
      return false;
    }

    // Guardar saldo anterior para confirmar el cambio
    final int saldoAnterior = _coins;

    // Realizar la compra
    _coins -= item.price;
    _purchasedItems.add(
      PurchasedItem(
        itemId: item.id,
        category: category,
        purchaseDate: DateTime.now(),
      ),
    );

    print('✅ COMPRA EXITOSA!');
    print('💰 Saldo anterior: $saldoAnterior');
    print('💰 Saldo nuevo: $_coins');
    print('📦 Total items comprados: ${_purchasedItems.length}');
    print('🔄 Guardando datos y notificando UI...');

    saveData();
    notifyListeners();

    print('🎉 === COMPRA COMPLETADA ===');
    return true;
  }

  // Seleccionar una maceta (solo si está comprada)
  bool selectPot(String potId) {
    print('🎯 Seleccionando maceta: $potId');
    // Verificar si la maceta está comprada
    if (isItemPurchased(potId)) {
      _selectedPotId = potId;
      saveData();
      notifyListeners();
      return true;
    }
    print('❌ Maceta no comprada');
    return false;
  }

  // Obtener macetas compradas (incluyendo la gratuita)
  List<StoreItem> getOwnedPots() {
    final allPots = availableItems['Macetas'] ?? [];
    final ownedPots = allPots.where((pot) => isItemPurchased(pot.id)).toList();

    print('🏺 Macetas disponibles: ${ownedPots.length}/${allPots.length}');
    return ownedPots;
  }

  // Seleccionar un fondo (solo si está comprado)
  bool selectBackground(String backgroundId) {
    print('🖼️ Seleccionando fondo: $backgroundId');
    // Verificar si el fondo está comprado
    if (isItemPurchased(backgroundId)) {
      _selectedBackgroundId = backgroundId;
      saveData();
      notifyListeners();
      return true;
    }
    print('❌ Fondo no comprado');
    return false;
  }

  // Obtener fondos comprados (incluyendo el gratuito)
  List<StoreItem> getOwnedBackgrounds() {
    final allBackgrounds = availableItems['Fondos'] ?? [];
    final ownedBackgrounds = allBackgrounds
        .where((background) => isItemPurchased(background.id))
        .toList();

    print(
        '🖼️ Fondos disponibles: ${ownedBackgrounds.length}/${allBackgrounds.length}');
    return ownedBackgrounds;
  }

  // Obtener la ruta SVG del fondo seleccionado para la pantalla principal
  String getSelectedBackgroundSvgPath() {
    // Usar SVG directamente para pantalla principal (máxima calidad)
    return 'lib/assets/images/fondos/$_selectedBackgroundId.svg';
  }

  // Obtener la ruta JPG del fondo seleccionado para la tienda
  String getSelectedBackgroundJpgPath() {
    // Convertir el ID del fondo a la ruta JPG para tienda
    return 'lib/assets/images/fondos/$_selectedBackgroundId.jpg';
  }

  // Obtener el StoreItem del fondo seleccionado
  StoreItem? getSelectedBackgroundItem() {
    final allBackgrounds = availableItems['Fondos'] ?? [];
    try {
      return allBackgrounds.firstWhere((bg) => bg.id == _selectedBackgroundId);
    } catch (e) {
      print('⚠️ Fondo seleccionado no encontrado: $_selectedBackgroundId');
      return null;
    }
  }

  // Guardar datos en SharedPreferences
  Future<void> saveData() async {
    print('💾 === GUARDANDO DATOS ===');
    print('💰 Monedas a guardar: $_coins');
    print('🏺 Maceta seleccionada: $_selectedPotId');
    print('📦 Items a guardar: ${_purchasedItems.length}');

    final prefs = await SharedPreferences.getInstance();

    // Guardar monedas
    await prefs.setInt('coins', _coins);

    // Guardar maceta seleccionada
    await prefs.setString('selectedPotId', _selectedPotId);

    // Guardar fondo seleccionado
    await prefs.setString('selectedBackgroundId', _selectedBackgroundId);

    // Guardar items comprados
    final List<String> purchasedItemsJson =
        _purchasedItems.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList('purchasedItems', purchasedItemsJson);

    // Verificar que se guardó correctamente
    final savedCoins = prefs.getInt('coins');
    print('✅ Monedas guardadas confirmadas: $savedCoins');
    print('💾 === DATOS GUARDADOS ===');
  }

  // Cargar datos de SharedPreferences
  Future<void> loadData() async {
    print('📂 Cargando datos...');
    final prefs = await SharedPreferences.getInstance();

    // Cargar monedas
    _coins = prefs.getInt('coins') ?? 100000;
    print('💰 Monedas: $_coins');

    // Cargar maceta seleccionada
    _selectedPotId = prefs.getString('selectedPotId') ?? 'maceta_01';

    // Cargar fondo seleccionado
    _selectedBackgroundId =
        prefs.getString('selectedBackgroundId') ?? 'fondo_misti';

    // Cargar items comprados
    final List<String>? purchasedItemsJson =
        prefs.getStringList('purchasedItems');

    _purchasedItems.clear();
    if (purchasedItemsJson != null) {
      for (String itemJson in purchasedItemsJson) {
        try {
          final Map<String, dynamic> itemMap = jsonDecode(itemJson);
          final item = PurchasedItem.fromJson(itemMap);
          _purchasedItems.add(item);
        } catch (e) {
          print('❌ Error cargando item: $e');
        }
      }
    }

    print('📂 ${_purchasedItems.length} items cargados');
    notifyListeners();
  }

  // Método para limpiar todos los datos (útil para testing)
  Future<void> clearAllData() async {
    print('🧹 Limpiando todos los datos...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _coins = 100000;
    _selectedPotId = 'maceta_01';
    _purchasedItems.clear();
    _isInitialized = false;

    await _initializeData();
    print('🆕 Datos reiniciados');
  }

  // Métodos para cargar desde Firebase
  void loadFromFirebase({
    int? coins,
    String? selectedPotId,
    String? selectedBackgroundId,
    Map<String, dynamic>? purchasedItems,
  }) {
    print('📥 Cargando datos desde Firebase al StoreModel...');

    if (coins != null) {
      _coins = coins;
      print('💰 Monedas cargadas: $_coins');
    }

    if (selectedPotId != null) {
      _selectedPotId = selectedPotId;
      print('🏺 Maceta seleccionada: $_selectedPotId');
    }

    if (selectedBackgroundId != null) {
      _selectedBackgroundId = selectedBackgroundId;
      print('🖼️ Fondo seleccionado: $_selectedBackgroundId');
    }

    if (purchasedItems != null) {
      _purchasedItems.clear();
      purchasedItems.forEach((key, value) {
        final item = value as Map<String, dynamic>;
        _purchasedItems.add(
          PurchasedItem(
            itemId: item['itemId'] ?? key,
            category: item['category'] ?? 'Unknown',
            purchaseDate: item['purchaseDate'] != null
                ? DateTime.fromMillisecondsSinceEpoch(item['purchaseDate'])
                : DateTime.now(),
          ),
        );
      });
      print('📦 Items comprados cargados: ${_purchasedItems.length}');
    }

    notifyListeners();
    saveData(); // Guardar en SharedPreferences también
    print('✅ Datos de Firebase cargados al StoreModel');
  }
}

class StoreItem {
  final String id;
  final String name;
  final int price;
  final String image;

  StoreItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

class PurchasedItem {
  final String itemId;
  final String category;
  final DateTime purchaseDate;

  PurchasedItem({
    required this.itemId,
    required this.category,
    required this.purchaseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'category': category,
      'purchaseDate': purchaseDate.toIso8601String(),
    };
  }

  factory PurchasedItem.fromJson(Map<String, dynamic> json) {
    return PurchasedItem(
      itemId: json['itemId'],
      category: json['category'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
    );
  }
}
