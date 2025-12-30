import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:green_cloud/models/achievements_model.dart';
import 'package:green_cloud/models/plant_encyclopedia_model.dart';
import 'package:green_cloud/screens/barra_screens/Rank/medal_detail_screen.dart';
import 'package:green_cloud/screens/barra_screens/Rank/plant_detail_screen.dart';
import 'package:green_cloud/screens/barra_screens/Rank/creature_detail_screen.dart';

class LogrosScreen extends StatefulWidget {
  const LogrosScreen({Key? key}) : super(key: key);

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Calculamos tamaños adaptativos
    final double cardPadding = screenWidth * 0.04; // 4% del ancho
    final double iconSizeBase = screenWidth * 0.1; // 10% del ancho
    final double fontSizeTitle = screenWidth * 0.045; // 4.5% del ancho
    final double fontSizeSubtitle = screenWidth * 0.035; // 3.5% del ancho

    return Consumer<AchievementsModel>(
        builder: (context, achievementsModel, child) {
      return Scaffold(
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
              // AppBar personalizada
              Container(
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Mis Logros',
                      style: TextStyle(
                        fontSize: fontSizeTitle + 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Contenido principal
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    children: [
                      _buildStatusCards(context, achievementsModel,
                          iconSizeBase, fontSizeTitle, fontSizeSubtitle),
                      SizedBox(
                          height: screenHeight * 0.025), // 2.5% de la altura
                      Expanded(
                        child: _buildAchievementList(achievementsModel,
                            iconSizeBase, fontSizeTitle, fontSizeSubtitle),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatusCards(BuildContext context, AchievementsModel model,
      double iconSize, double titleSize, double subtitleSize) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          _buildAchievementSummaryCard('Medallas', model.getMedalsProgress(),
              Icons.emoji_events, const Color(0xFFFFF3E0), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedallasScreen(),
              ),
            );
          }, iconSize, titleSize, subtitleSize),
        ],
      ),
    );
  }

  Widget _buildAchievementSummaryCard(
      String title,
      String progress,
      IconData icon,
      Color color,
      VoidCallback onTap,
      double iconSize,
      double titleSize,
      double subtitleSize) {
    // Calculamos tamaños relativos para el card
    final screenWidth = MediaQuery.of(context).size.width;
    final cardVerticalMargin = screenWidth * 0.015; // 1.5% del ancho
    final cardVerticalPadding = screenWidth * 0.02; // 2% del ancho
    final arrowSize = iconSize * 0.4; // 40% del tamaño del ícono principal

    return LayoutBuilder(builder: (context, constraints) {
      // Adaptamos los tamaños según el ancho disponible
      final availableWidth = constraints.maxWidth;
      // Si el ancho es muy pequeño, ajustamos aún más
      final adjustedIconSize = availableWidth < 320 ? iconSize * 0.8 : iconSize;
      final adjustedTitleSize =
          availableWidth < 320 ? titleSize * 0.9 : titleSize;

      return Container(
        margin: EdgeInsets.symmetric(vertical: cardVerticalMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(cardVerticalPadding + 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon,
                        size: adjustedIconSize, color: Colors.green[700]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: adjustedTitleSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          progress,
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: Colors.green[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green[600],
                      size: arrowSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAchievementList(AchievementsModel model, double iconSize,
      double titleSize, double subtitleSize) {
    // Crear una lista con los últimos 5 logros desbloqueados (en realidad serían los más recientes)
    List<Achievement> recentAchievements = [];

    // Añadir medallas desbloqueadas (Solo si existen en la lista actual)
    for (String id in model.unlockedMedals) {
      try {
        final medal = model.allMedals.firstWhere((m) => m.id == id);
        recentAchievements.add(medal);
      } catch (e) {
        // Ignorar medallas antiguas que ya no existen
      }
    }

    // Añadir plantas desbloqueadas
    for (String id in model.unlockedPlants) {
      try {
        final plant = model.allPlants.firstWhere((p) => p.id == id);
        recentAchievements.add(plant);
      } catch (e) {
        // Ignorar plantas antiguas
      }
    }

    // Añadir criaturas desbloqueadas
    for (String id in model.unlockedCreatures) {
      try {
        final creature = model.allCreatures.firstWhere((c) => c.id == id);
        recentAchievements.add(creature);
      } catch (e) {
        // Ignorar criaturas antiguas
      }
    }

    // Limitar a los 5 más recientes (en un caso real ordenarías por fecha)
    if (recentAchievements.length > 5) {
      recentAchievements = recentAchievements.sublist(0, 5);
    }

    return ListView.builder(
      itemCount: recentAchievements.length,
      itemBuilder: (context, index) {
        final achievement = recentAchievements[index];
        Color color;

        // Asignar color según la categoría
        switch (achievement.category) {
          case 'medals':
            color = const Color(0xFFFFF3E0);
            break;
          case 'plants':
            color = const Color(0xFFE8F5E8);
            break;
          case 'creatures':
            color = const Color(0xFFF3E5F5);
            break;
          default:
            color = const Color(0xFFE3F2FD);
        }

        return _buildRecentAchievementItem(
            achievement.name,
            achievement.description,
            achievement.iconData,
            color,
            iconSize * 0.8, // 80% del tamaño de ícono base
            titleSize * 0.9, // 90% del tamaño de título base
            subtitleSize * 0.9 // 90% del tamaño de subtítulo base
            );
      },
    );
  }

  Widget _buildRecentAchievementItem(
      String title,
      String description,
      IconData icon,
      Color color,
      double iconSize,
      double titleSize,
      double subtitleSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardVerticalMargin = screenWidth * 0.01; // 1% del ancho
    final cardPadding = screenWidth * 0.03; // 3% del ancho
    final containerSize = iconSize * 1.2; // 20% más grande que el ícono

    return Container(
      margin: EdgeInsets.symmetric(vertical: cardVerticalMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.shade200,
          width: 1,
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
        padding: EdgeInsets.all(cardPadding),
        child: Row(
          children: [
            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: iconSize, color: Colors.green[700]),
            ),
            SizedBox(width: screenWidth * 0.03), // 3% del ancho
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: iconSize * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de Medallas
class MedallasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsModel>(builder: (context, model, child) {
      return Scaffold(
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
              // AppBar personalizada
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[600]!, Colors.amber[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Medallas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Contenido principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progreso de Medallas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: model.getMedalsProgressValue(),
                                backgroundColor: Colors.grey[200],
                                color: Colors.amber[600],
                                minHeight: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  model.getMedalsProgress(),
                                  style: TextStyle(
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Nivel Dorado',
                                  style: TextStyle(
                                    color: Colors.amber[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: model.allMedals.length,
                          itemBuilder: (context, index) {
                            final medal = model.allMedals[index];
                            final isUnlocked = model.isMedalUnlocked(medal.id);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MedalDetailScreen(medalId: medal.id),
                                  ),
                                );
                              },
                              child: _buildMedal(medal, isUnlocked),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMedal(Achievement medal, bool unlocked) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked ? Colors.amber.shade300 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: unlocked
                ? Colors.amber.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: unlocked
                  ? LinearGradient(
                      colors: [Colors.amber.shade300, Colors.amber.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade200, Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: _buildMedalIcon(medal, unlocked),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              medal.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: unlocked ? Colors.amber[700] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedalIcon(Achievement medal, bool unlocked) {
    if (unlocked && medal.imagePath != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          medal.imagePath!,
          fit: BoxFit.contain,
        ),
      );
    }

    return unlocked
        ? Icon(medal.iconData ?? Icons.emoji_events,
            size: 32, color: Colors.white)
        : Icon(Icons.lock_outline, size: 24, color: Colors.grey[600]);
  }
}

// Pantalla de Plantas
class PlantasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allPlants = PlantEncyclopediaModel.allPlants;
    final unlockedPlants = PlantEncyclopediaModel.getUnlockedPlants();

    return Scaffold(
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
            // AppBar personalizada
            Container(
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_florist,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Plantas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Contenido principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progreso de Plantas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: unlockedPlants.length / allPlants.length,
                              backgroundColor: Colors.grey[200],
                              color: Colors.green[600],
                              minHeight: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${unlockedPlants.length}/${allPlants.length}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Botánico Experto',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: allPlants.length,
                        itemBuilder: (context, index) {
                          final plant = allPlants[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlantDetailScreen(plantId: plant.id),
                                ),
                              );
                            },
                            child: _buildEncyclopediaPlantCard(plant),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEncyclopediaPlantCard(EncyclopediaPlant plant) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plant.isUnlocked ? plant.rarityColor : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (plant.isUnlocked ? plant.rarityColor : Colors.grey)
                .withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header con rareza
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: plant.isUnlocked
                  ? plant.rarityColor.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Text(
              plant.isUnlocked ? plant.rarityName : 'BLOQUEADA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: plant.isUnlocked ? plant.rarityColor : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Contenido principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Imagen de la planta
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: plant.isUnlocked
                          ? plant.rarityColor.withOpacity(0.1)
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: plant.isUnlocked
                            ? plant.rarityColor
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: plant.isUnlocked
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              plant.iconPath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.eco,
                                  size: 30,
                                  color: plant.rarityColor,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.lock,
                            size: 25,
                            color: Colors.grey[500],
                          ),
                  ),

                  const SizedBox(height: 8),

                  // Nombre de la planta
                  Text(
                    plant.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: plant.isUnlocked
                          ? Colors.green[800]
                          : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Tipo de planta
                  Text(
                    plant.type,
                    style: TextStyle(
                      fontSize: 11,
                      color: plant.isUnlocked
                          ? Colors.green[600]
                          : Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Estadísticas básicas (solo si está desbloqueada)
                  if (plant.isUnlocked) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wb_sunny,
                              size: 12, color: Colors.amber[700]),
                          const SizedBox(width: 2),
                          Text(
                            '${plant.sunCost}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Toca para desbloquear',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantItem(
      String title, String type, bool unlocked, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked ? Colors.green.shade300 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: unlocked
                ? Colors.green.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: unlocked
                    ? LinearGradient(
                        colors: [Colors.green.shade300, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade200, Colors.grey.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: unlocked
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'lib/assets/images/plants/sunflower.png', // Placeholder o lógica para obtener imagen si estuviera disponible en este contexto
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.eco,
                            size: 32,
                            color: Colors.white,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.lock_outline,
                      size: 24,
                      color: Colors.grey[600],
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: unlocked ? Colors.green[800] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 14,
                      color: unlocked ? Colors.green[600] : Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: unlocked ? Colors.green[50] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                unlocked ? Icons.check_circle : Icons.lock_outline,
                color: unlocked ? Colors.green[700] : Colors.grey[600],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de Criaturas
class CriaturasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsModel>(builder: (context, model, child) {
      return Scaffold(
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
              // AppBar personalizada
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[400]!, Colors.purple[300]!],
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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Criaturas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Contenido principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progreso de Criaturas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: model.getCreaturesProgressValue(),
                                backgroundColor: Colors.grey[200],
                                color: Colors.purple[600],
                                minHeight: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  model.getCreaturesProgress(),
                                  style: TextStyle(
                                    color: Colors.purple[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Explorador Mágico',
                                  style: TextStyle(
                                    color: Colors.purple[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: model.allCreatures.length,
                          itemBuilder: (context, index) {
                            final creature = model.allCreatures[index];
                            final isUnlocked =
                                model.isCreatureUnlocked(creature.id);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatureDetailScreen(
                                        creatureId: creature.id),
                                  ),
                                );
                              },
                              child: _buildCriaturaItem(
                                  creature.name,
                                  isUnlocked,
                                  isUnlocked ? creature.imagePath ?? '' : ''),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCriaturaItem(String name, bool unlocked, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked ? Colors.purple.shade300 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: unlocked
                ? Colors.purple.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: unlocked
                    ? LinearGradient(
                        colors: [
                          Colors.purple.shade200,
                          Colors.purple.shade400
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade200, Colors.grey.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: unlocked
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade200,
                                  Colors.purple.shade400
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.pets,
                              size: 40,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.lock_outline,
                      size: 40,
                      color: Colors.grey[600],
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: unlocked ? Colors.purple[700] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (unlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber[600]),
                    Icon(Icons.star, size: 14, color: Colors.amber[600]),
                    Icon(Icons.star, size: 14, color: Colors.grey[400]),
                    Icon(Icons.star, size: 14, color: Colors.grey[400]),
                    Icon(Icons.star, size: 14, color: Colors.grey[400]),
                  ],
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Bloqueado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LogrosScreen(),
  ));
}
