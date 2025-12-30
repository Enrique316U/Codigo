import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/store_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:green_cloud/widgets/firebase_coins_display.dart';
import 'package:green_cloud/services/firebase_game_data_service.dart';

class TiendaScreen extends StatefulWidget {
  const TiendaScreen({Key? key}) : super(key: key);

  @override
  State<TiendaScreen> createState() => _TiendaScreenState();
}

class _TiendaScreenState extends State<TiendaScreen> {
  // Variable que parece estar siendo utilizada pero no fue declarada

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<StoreModel>(builder: (context, storeModel, child) {
      // Mostrar loading mientras se inicializa
      if (!storeModel.isInitialized) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF1F8E9),
        body: Stack(
          children: [
            // Fondo principal
            Positioned.fill(
              child: Container(
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
              ),
            ),

            // Barra de rectángulos en la parte superior (toldo fijo)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 150, // Altura fija del toldo
              child: _buildStripedBanner(size.width),
            ),

            // Íconos encima del toldo
            Positioned(
              top: 50, // Posición ajustada para que quede encima del toldo
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.storefront,
                              size: 18, color: Colors.green[800]),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tienda',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FirebaseCoinsDisplay(),
                  ],
                ),
              ),
            ),

            // Contenido desplazable
            Positioned.fill(
              top: 150, // El contenido comienza justo debajo del toldo
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y Monedas (eliminar esta sección ya que ahora está encima del toldo)
                      // Sustituir por un espacio en blanco para mantener el espaciado
                      const SizedBox(height: 20),

                      // Categorías y productos
                      ...storeModel.categories.map((category) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategory(category),
                            _buildGridItems(context, category, storeModel),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStripedBanner(double width) {
    final rectWidth = width / 9; // 9 rectángulos

    return Container(
      width: width,
      height: 500, // Altura del banner
      child: Stack(
        children: [
          // Toldo principal
          Row(
            children: List.generate(9, (index) {
              // Alterna entre colores verde
              final isDark = index % 2 == 0;

              return Container(
                width: rectWidth,
                decoration: BoxDecoration(
                  // Solo bordes redondeados en la parte inferior
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.65, 0.7, 8.0],
                    colors: isDark
                        ? [
                            const Color(0xFF2E7D32),
                            const Color(0xFF388E3C),
                            const Color(0xFF4CAF50),
                            const Color(0xFF66BB6A),
                          ]
                        : [
                            const Color(0xFF4CAF50),
                            const Color(0xFF66BB6A),
                            const Color(0xFF81C784),
                            const Color(0xFFA5D6A7),
                          ],
                  ),
                ),
              );
            }),
          ),

          // Líneas decorativas del toldo
          ...List.generate(8, (index) {
            return Positioned(
              left: rectWidth * (index + 1),
              top: 0,
              bottom: 0,
              width: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green[900]!.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategory(String title) {
    IconData categoryIcon;
    Color categoryColor;

    // Asignar íconos y colores según la categoría
    switch (title.toLowerCase()) {
      case 'macetas':
        categoryIcon = Icons.local_florist;
        categoryColor = Colors.green[600]!;
        break;
      case 'semillas':
        categoryIcon = Icons.eco;
        categoryColor = Colors.brown[600]!;
        break;
      case 'herramientas':
        categoryIcon = Icons.handyman;
        categoryColor = Colors.blue[600]!;
        break;
      case 'decoración':
        categoryIcon = Icons.palette;
        categoryColor = Colors.purple[600]!;
        break;
      default:
        categoryIcon = Icons.shopping_cart;
        categoryColor = Colors.green[600]!;
    }

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withOpacity(0.1),
            categoryColor.withOpacity(0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.1),
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
              color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              categoryIcon,
              color: categoryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ver todo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: categoryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItems(
      BuildContext context, String category, StoreModel storeModel) {
    final items = storeModel.availableItems[category] ?? [];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Optimizaciones de rendimiento
      cacheExtent: 500.0, // Pre-cachea elementos fuera de pantalla
      addAutomaticKeepAlives: false, // No mantener widgets fuera de pantalla
      addRepaintBoundaries: true, // Optimizar repaint
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isPurchased = storeModel.isItemPurchased(item.id);

        return GestureDetector(
          onTap: () {
            if (!isPurchased) {
              _showPurchaseDialog(context, item, category, storeModel);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text('Ya tienes ${item.name}'),
                    ],
                  ),
                  backgroundColor: Colors.green[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: isPurchased
                  ? LinearGradient(
                      colors: [
                        Colors.green[50]!,
                        Colors.green[100]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey[50]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isPurchased ? Colors.green.shade400 : Colors.grey.shade200,
                width: isPurchased ? 2.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isPurchased
                      ? Colors.green.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.15),
                  spreadRadius: isPurchased ? 3 : 1,
                  blurRadius: isPurchased ? 8 : 4,
                  offset: Offset(0, isPurchased ? 4 : 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen principal más grande
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: isPurchased
                              ? LinearGradient(
                                  colors: [
                                    Colors.green[100]!,
                                    Colors.green[200]!,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey[100]!,
                                    Colors.grey[200]!,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: isPurchased
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: category == 'Macetas'
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    item.image,
                                    fit: BoxFit.contain,
                                    color: isPurchased
                                        ? Colors.green.shade700
                                        : null,
                                  ),
                                )
                              : category == 'Fondos'
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: [
                                          // Vista previa del fondo - versión directa
                                          Positioned.fill(
                                            child: Image.asset(
                                              item.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                color: Colors.grey.shade300,
                                                child: Icon(
                                                  Icons.landscape,
                                                  color: Colors.grey.shade600,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Overlay semi-transparente con ícono
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.3),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Ícono de paisaje en la esquina
                                          Positioned(
                                            bottom: 4,
                                            right: 4,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Icon(
                                                Icons.landscape,
                                                color: isPurchased
                                                    ? Colors.green.shade700
                                                    : Colors.grey.shade700,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      item.name.substring(0, 1),
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: isPurchased
                                            ? Colors.green[800]
                                            : Colors.grey[700],
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(1, 1),
                                            blurRadius: 2,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                          ),
                                        ],
                                      ),
                                    ),
                        ),
                      ),
                      if (isPurchased)
                        const Positioned(
                          right: 4,
                          top: 4,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPurchased ? Colors.green[800] : Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                // Mostrar precio o estado de comprado
                if (isPurchased)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[500]!, Colors.green[600]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'TUYO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[300]!, Colors.amber[500]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on,
                            color: Colors.white, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          '${item.price}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context, StoreItem item,
      String category, StoreModel storeModel) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 10,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 450),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.green[50]!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header con botón cerrar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[400]!, Colors.green[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🛒 Comprar Item',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Imagen del item mejorada con vista previa para fondos
                  Container(
                    height: category == 'Fondos' ? 150 : 100,
                    width: category == 'Fondos' ? 200 : 100,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[100]!, Colors.green[200]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: category == 'Macetas'
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(
                                  item.image,
                                  fit: BoxFit.contain,
                                  width: 68,
                                  height: 68,
                                ),
                              ),
                            )
                          : category == 'Fondos'
                              ? Stack(
                                  children: [
                                    // Vista previa completa del fondo - versión directa
                                    Positioned.fill(
                                      child: Image.asset(
                                        item.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          color: Colors.grey.shade300,
                                          child: Center(
                                            child: Icon(
                                              Icons.landscape,
                                              color: Colors.grey.shade600,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Overlay con texto "Vista Previa"
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.preview,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Vista Previa',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    item.name.substring(0, 1),
                                    style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),

                  // Nombre del item mejorado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (category == 'Fondos') ...[
                          const SizedBox(height: 8),
                          Text(
                            'Fondo de pantalla para tu jardín',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[600],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Precio mejorado
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[100]!, Colors.amber[200]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on,
                            color: Colors.amber[800], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '${item.price}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                        Text(
                          ' monedas',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.amber[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Saldo actual mejorado
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: storeModel.coins >= item.price
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: storeModel.coins >= item.price
                            ? Colors.green[300]!
                            : Colors.red[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          storeModel.coins >= item.price
                              ? Icons.account_balance_wallet
                              : Icons.warning,
                          color: storeModel.coins >= item.price
                              ? Colors.green[700]
                              : Colors.red[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tu saldo: ${storeModel.coins} monedas',
                          style: TextStyle(
                            fontSize: 14,
                            color: storeModel.coins >= item.price
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón de compra mejorado
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: storeModel.coins >= item.price
                            ? () {
                                print('🔘 BOTÓN COMPRAR PRESIONADO');
                                _processPurchase(
                                    context, item, category, storeModel);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: storeModel.coins >= item.price
                                ? LinearGradient(
                                    colors: [
                                      Colors.green[500]!,
                                      Colors.green[700]!
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.grey[400]!,
                                      Colors.grey[600]!
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: storeModel.coins >= item.price
                                ? [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                storeModel.coins >= item.price
                                    ? Icons.shopping_cart
                                    : Icons.block,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                storeModel.coins >= item.price
                                    ? '¡Comprar Ahora!'
                                    : 'Fondos Insuficientes',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _processPurchase(BuildContext context, StoreItem item,
      String category, StoreModel storeModel) async {
    print('\n🎬 === PROCESANDO COMPRA EN UI ===');
    print('📱 Item seleccionado: ${item.name}');
    print('💳 Saldo mostrado en UI: ${storeModel.coins}');

    // Verificar si hay suficientes monedas antes de intentar comprar
    if (storeModel.coins < item.price) {
      print('💸 UI: Monedas insuficientes');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Necesitas ${item.price - storeModel.coins} monedas más para comprar ${item.name}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    print('✅ UI: Procediendo con la compra...');

    // Guardar en Firebase
    try {
      final firebaseService = FirebaseGameDataService();
      final purchaseSuccess = await firebaseService.purchaseItem(
        item.id,
        item.price,
      );

      if (!purchaseSuccess) {
        print(
            '❌ Firebase: No se pudo completar la compra (fondos insuficientes)');
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No tienes suficientes monedas'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      print('✅ Firebase: Compra guardada exitosamente');
    } catch (e) {
      print('❌ Error al guardar compra en Firebase: $e');
      // Continuar con la compra local aunque falle Firebase
    }

    // También guardar localmente
    final success = storeModel.purchaseItem(item, category);
    print('📱 Resultado recibido en UI: $success');
    print('💰 Nuevo saldo en UI: ${storeModel.coins}');

    // Cerrar el diálogo de compra
    Navigator.of(context).pop();

    if (success) {
      print('🎉 UI: Compra exitosa, actualizando interfaz');
      // Debug: mostrar estado actual del modelo
      storeModel.debugShowCurrentState();

      // Forzar una actualización del estado
      setState(() {});

      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¡Has comprado ${item.name}!'),
              if (category == 'Macetas')
                const Text(
                    'Ya puedes cambiar tu maceta en la pantalla principal'),
              if (category == 'Fondos')
                const Text(
                    'Ya puedes cambiar tu fondo en la pantalla principal'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      print('❌ UI: Compra falló');
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ya tienes ${item.name} en tu inventario'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
    print('🎬 === PROCESO UI COMPLETADO ===\n');
  }
}
