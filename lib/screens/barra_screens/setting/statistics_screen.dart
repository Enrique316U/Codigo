import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/user.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, child) {
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
              _buildCustomHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConsecutiveDaysSection(userModel),
                      const SizedBox(height: 24),
                      _buildHoursPerDaySection(userModel),
                      const SizedBox(height: 24),
                      _buildAchievementsSection(userModel),
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
            onTap: () => Navigator.of(context).pop(),
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
              Icons.analytics,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Estadísticas',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: Colors.green[600], size: 16),
                const SizedBox(width: 4),
                Consumer<UserModel>(
                  builder: (context, userModel, child) {
                    return Text(
                      'Nv. ${userModel.level}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsecutiveDaysSection(UserModel userModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.calendar_today,
                      color: Colors.green[600], size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Días Seguidos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...List.generate(7, (index) {
                  // Determinar si el círculo debe estar lleno o vacío
                  // Si la racha es mayor a 0 y es múltiplo de 7, mostramos todo lleno
                  final int filledCount = (userModel.consecutiveDays % 7 == 0 &&
                          userModel.consecutiveDays > 0)
                      ? 7
                      : userModel.consecutiveDays % 7;

                  final isFilled = index < filledCount;
                  return _buildDayCircle(index + 1, isFilled);
                }),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${userModel.consecutiveDays} días consecutivos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCircle(int day, bool isFilled) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isFilled
                ? LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isFilled ? null : Colors.grey[200],
            border: Border.all(
              color: isFilled ? Colors.green.shade600 : Colors.grey.shade400,
              width: 2,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                color: isFilled ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getDayName(day),
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Lun';
      case 2:
        return 'Mar';
      case 3:
        return 'Mié';
      case 4:
        return 'Jue';
      case 5:
        return 'Vie';
      case 6:
        return 'Sáb';
      case 7:
        return 'Dom';
      default:
        return '';
    }
  }

  Widget _buildHoursPerDaySection(UserModel userModel) {
    // Los datos vienen en minutos
    List<int> minutesPerDay = userModel.hoursPerDay;

    // Encontrar el valor máximo en minutos
    int maxMinutes = minutesPerDay.isEmpty
        ? 300 // 5 horas por defecto
        : minutesPerDay.reduce((curr, next) => curr > next ? curr : next);

    // Convertir a horas para el cálculo de escala (mínimo 5 horas)
    int maxHours = (maxMinutes / 60).ceil();
    if (maxHours < 5) maxHours = 5;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horas al Día',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Eje Y
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ...List.generate(6, (index) {
                        // Generar etiquetas de 0 a maxHours
                        // index 0 -> maxHours
                        // index 5 -> 0
                        double val = maxHours * (5 - index) / 5.0;
                        // Mostrar sin decimales si es entero
                        String label = val % 1 == 0
                            ? '${val.toInt()}h'
                            : '${val.toStringAsFixed(1)}h';

                        return Text(
                          label,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Barras
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...List.generate(minutesPerDay.length, (index) {
                          // Calcular altura de la barra
                          double hours = minutesPerDay[index] / 60.0;
                          final double barHeight = (hours / maxHours) * 150;

                          // Días de la semana, comenzando desde hoy hacia atrás
                          final int daysAgo = minutesPerDay.length - 1 - index;
                          String dayLabel;

                          if (daysAgo == 0) {
                            dayLabel = 'Hoy';
                          } else if (daysAgo == 1) {
                            dayLabel = 'Ayer';
                          } else {
                            dayLabel = '$daysAgo d';
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Tooltip(
                                message:
                                    '${(minutesPerDay[index] / 60).toStringAsFixed(1)}h',
                                child: Container(
                                  width: 30,
                                  height: barHeight < 1
                                      ? 1
                                      : barHeight, // Altura mínima visible
                                  decoration: BoxDecoration(
                                    color: Colors.pink[300],
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dayLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        }),
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
  }

  Widget _buildAchievementsSection(UserModel userModel) {
    // En una aplicación real, esto podría mostrar estadísticas de logros
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.emoji_events,
                      color: Colors.green[600], size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Resumen de Logros',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAchievementItem(
              'Experiencia Total',
              '${userModel.experiencePoints} puntos',
              Icons.star,
              Colors.amber,
              0.7,
            ),
            const SizedBox(height: 10),
            _buildAchievementItem(
              'Nivel Actual',
              'Nivel ${userModel.level}',
              Icons.trending_up,
              Colors.green,
              userModel.experienceProgress,
            ),
            const SizedBox(height: 10),
            _buildAchievementItem(
              'Uso Semanal',
              '${(userModel.hoursPerDay.fold(0, (p, c) => p + c) / 60).toStringAsFixed(1)} horas',
              Icons.timer,
              Colors.blue,
              0.85,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(
    String title,
    String value,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: color,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
