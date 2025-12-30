import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_cloud/models/user.dart';
import 'package:avatar_plus/avatar_plus.dart';

/// Widget universal para mostrar avatares que puede usar tanto
/// avatares personalizados como imágenes tradicionales
class UniversalAvatar extends StatelessWidget {
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const UniversalAvatar({
    Key? key,
    this.size = 50.0,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 2.0,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        // Determinar si está usando Avatar Plus
        // También usar Avatar Plus si no hay imagen de perfil válida
        bool isUsingAvatarPlus = (userModel.useCustomAvatar &&
                userModel.avatarJson != null &&
                userModel.avatarJson!.isNotEmpty) ||
            (userModel.profileImage.isEmpty);

        Color borderColorToUse = borderColor ??
            (isUsingAvatarPlus
                ? Colors.purple.shade300
                : Colors.green.shade300);

        Color shadowColor = isUsingAvatarPlus ? Colors.purple : Colors.green;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: showBorder
                ? Border.all(
                    color: borderColorToUse,
                    width: borderWidth,
                  )
                : null,
            boxShadow: boxShadow ??
                (showBorder
                    ? [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null),
          ),
          child: ClipOval(
            child: _buildAvatarContent(userModel),
          ),
        );
      },
    );
  }

  Widget _buildAvatarContent(UserModel userModel) {
    // Si el usuario tiene un avatar personalizado y está activado
    // O si no tiene imagen de perfil configurada (fallback a avatar generado)
    bool shouldUseAvatarPlus = userModel.useCustomAvatar ||
        (userModel.profileImage.isEmpty &&
            userModel.avatarJson != null &&
            userModel.avatarJson!.isNotEmpty);

    if (shouldUseAvatarPlus) {
      // Usar Avatar Plus - el avatarJson contiene el ID del avatar
      if (userModel.avatarJson != null && userModel.avatarJson!.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade100,
                Colors.purple.shade200,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.05),
            child: AvatarPlus(
              userModel.avatarJson!,
              height: size * 0.9,
              width: size * 0.9,
            ),
          ),
        );
      }
    }

    // Usar imagen tradicional de perfil como fallback
    // Si la imagen de perfil está vacía, usar el avatar por defecto
    if (userModel.profileImage.isEmpty) {
      return _buildDefaultAvatar();
    }

    return Image.asset(
      userModel.profileImage,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultAvatar();
      },
    );
  }

  Widget _buildDefaultAvatar() {
    // Si no hay imagen ni avatar, mostrar un avatar generado por defecto
    // Esto evita mostrar el icono genérico aburrido
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade100,
            Colors.purple.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.05),
        child: AvatarPlus(
          "avatar1", // Avatar por defecto seguro
          height: size * 0.9,
          width: size * 0.9,
        ),
      ),
    );
  }
}

/// Widget para mostrar un avatar con opciones de edición
class EditableAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const EditableAvatar({
    Key? key,
    this.size = 100.0,
    this.onTap,
    this.showEditIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        // Determinar si está usando Avatar Plus
        bool isUsingAvatarPlus = (userModel.useCustomAvatar &&
                userModel.avatarJson != null &&
                userModel.avatarJson!.isNotEmpty) ||
            (userModel.profileImage.isEmpty);

        MaterialColor themeColor =
            isUsingAvatarPlus ? Colors.purple : Colors.green;

        return GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              UniversalAvatar(
                size: size,
                showBorder: true,
                borderColor: themeColor.shade400,
                borderWidth: 3,
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              if (showEditIcon)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: size * 0.3,
                    height: size * 0.3,
                    decoration: BoxDecoration(
                      color: themeColor[600],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: size * 0.15,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget para mostrar avatares de amigos (sin funcionalidad de edición)
class FriendAvatar extends StatelessWidget {
  final double size;
  final String profileImage;
  final bool showBorder;

  const FriendAvatar({
    Key? key,
    this.size = 50.0,
    required this.profileImage,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: Colors.green.shade300,
                width: 2,
              )
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          profileImage,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              color: Colors.grey.shade200,
              child: Icon(
                Icons.person,
                size: size * 0.6,
                color: Colors.grey.shade600,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Widget para alternar entre avatar personalizado e imagen tradicional
class AvatarToggle extends StatelessWidget {
  const AvatarToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.face_retouching_natural,
                  color: Colors.green[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usar Avatar Personalizado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mostrar tu avatar creado en lugar de la foto de perfil',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: userModel.useCustomAvatar,
                  onChanged: (value) {
                    userModel.setUseCustomAvatar(value);
                  },
                  activeColor: Colors.green[600],
                  activeTrackColor: Colors.green[200],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
