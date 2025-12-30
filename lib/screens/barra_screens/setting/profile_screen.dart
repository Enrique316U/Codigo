import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/store_model.dart';
import 'package:green_cloud/models/user.dart';
import 'package:green_cloud/widgets/universal_avatar.dart';
import 'package:green_cloud/models/achievements_model.dart';
import 'package:green_cloud/screens/barra_screens/setting/statistics_screen.dart';
import 'package:green_cloud/screens/barra_screens/setting/settings_screen.dart';
import 'package:green_cloud/screens/barra_screens/setting/friends_screen.dart';
import 'package:green_cloud/screens/barra_screens/setting/global_screen.dart';
import 'package:green_cloud/screens/barra_screens/Rank/rank.dart';
import 'package:avatar_plus/avatar_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Cargar usuarios globales reales al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserModel>(context, listen: false).loadGlobalUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StoreModel, UserModel>(
        builder: (context, storeModel, userModel, child) {
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
              _buildProfileHeader(storeModel, userModel, context),
              _buildTabBar(),
              _buildTabBarView(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileHeader(
      StoreModel storeModel, UserModel userModel, BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icono de estadísticas
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StatisticsScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child:
                      Icon(Icons.analytics, color: Colors.green[600], size: 24),
                ),
              ),

              // Avatar de usuario con monedas
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  UniversalAvatar(
                    size: 84,
                    showBorder: true,
                    borderColor: Colors.white,
                    borderWidth: 4,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade400, Colors.amber.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${storeModel.coins}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Icono de ajustes
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child:
                      Icon(Icons.settings, color: Colors.green[600], size: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            userModel.name,
            style: const TextStyle(
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
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Nivel ${userModel.level}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${userModel.experiencePoints}/${userModel.experienceToNextLevel} EXP',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                    Text('${(userModel.experienceProgress * 100).toInt()}%',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: userModel.experienceProgress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          _buildStoreItemsSection(storeModel),
          const SizedBox(height: 10),
          _buildAchievementsSection(context),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.green[600],
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[500]!, Colors.green[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 20),
                SizedBox(width: 8),
                Text('Amigos'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.public, size: 20),
                SizedBox(width: 8),
                Text('Global'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(),
          _buildGlobalTab(),
        ],
      ),
    );
  }

  Widget _buildFriendsTab() {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.people,
                              color: Colors.green[600], size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Mis amigos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendsScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[400]!, Colors.green[600]!],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Ver más',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: userModel.friends.length,
                  itemBuilder: (context, index) {
                    final friend = userModel.friends[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.green.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: friend.useCustomAvatar &&
                                          friend.avatarJson != null &&
                                          friend.avatarJson!.isNotEmpty
                                      ? ClipOval(
                                          child: AvatarPlus(
                                            friend.avatarJson!,
                                            height: 50,
                                            width: 50,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              AssetImage(friend.profileImage),
                                        ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.shade400,
                                        Colors.amber.shade600
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                  child: const Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    friend.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: friend.experienceProgress,
                                      backgroundColor: Colors.green.shade100,
                                      color: Colors.green.shade600,
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Nv. ${friend.level}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlobalTab() {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.public,
                              color: Colors.green[600], size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Ranking global',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showSearch(
                              context: context,
                              delegate: UserSearchDelegate(userModel),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.search,
                                color: Colors.green[600], size: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GlobalScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green[400]!,
                                  Colors.green[600]!
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Ver más',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: userModel.globalUsers.length,
                  itemBuilder: (context, index) {
                    final user = userModel.globalUsers[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Ranking badge
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: index == 0
                                      ? [
                                          Colors.amber.shade400,
                                          Colors.amber.shade600
                                        ]
                                      : index == 1
                                          ? [
                                              Colors.grey.shade300,
                                              Colors.grey.shade500
                                            ]
                                          : index == 2
                                              ? [
                                                  Colors.orange.shade300,
                                                  Colors.orange.shade500
                                                ]
                                              : [
                                                  Colors.green.shade200,
                                                  Colors.green.shade400
                                                ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Avatar with coin indicator
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.green.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: user.useCustomAvatar &&
                                          user.avatarJson != null &&
                                          user.avatarJson!.isNotEmpty
                                      ? ClipOval(
                                          child: AvatarPlus(
                                            user.avatarJson!,
                                            height: 44,
                                            width: 44,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 22,
                                          backgroundImage:
                                              AssetImage(user.profileImage),
                                        ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.shade400,
                                        Colors.amber.shade600
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                  child: const Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // User info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: user.experienceProgress,
                                      backgroundColor: Colors.green.shade100,
                                      color: Colors.green.shade600,
                                      minHeight: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Level and add friend
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Nv. ${user.level}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ),
                                if (!user.isFriend) ...[
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      // Lógica para añadir amigo
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.person_add,
                                                  color: Colors.white),
                                              const SizedBox(width: 8),
                                              Text(
                                                  'Solicitud enviada a ${user.name}'),
                                            ],
                                          ),
                                          backgroundColor: Colors.green[600],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green[400]!,
                                            Colors.green[600]!
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person_add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoreItemsSection(StoreModel storeModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItemCategory(
              'Fondos',
              storeModel.getPurchasedCountByCategory('Fondos'),
              Icons.wallpaper),
          _buildItemCategory(
              'Macetas',
              storeModel.getPurchasedCountByCategory('Macetas'),
              Icons.featured_play_list),
          _buildItemCategory('Pets',
              storeModel.getPurchasedCountByCategory('Pets'), Icons.pets),
          _buildItemCategory(
              'Accesorios',
              storeModel.getPurchasedCountByCategory('Accesorios'),
              Icons.category),
        ],
      ),
    );
  }

  Widget _buildItemCategory(String title, String count, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.teal),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          count,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Consumer<AchievementsModel>(
      builder: (context, achievementsModel, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Logros',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogrosScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAchievementCategory(
                    'Medallas',
                    achievementsModel.getMedalsProgress(),
                    Icons.emoji_events,
                    Colors.pink[200]!,
                  ),
                  _buildAchievementCategory(
                    'Plantas',
                    achievementsModel.getPlantsProgress(),
                    Icons.eco,
                    Colors.green[300]!,
                  ),
                  _buildAchievementCategory(
                    'Criaturas',
                    achievementsModel.getCreaturesProgress(),
                    Icons.pets,
                    Colors.orange[300]!,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementCategory(
      String title, String progress, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          progress,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  final UserModel userModel;

  UserSearchDelegate(this.userModel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = userModel.searchUsers(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final user = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(user.profileImage),
          ),
          title: Text(user.name),
          subtitle: Text(user.username),
          trailing: Text('Nivel ${user.level}'),
        );
      },
    );
  }
}
