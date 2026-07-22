import 'package:flutter/material.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/features/shop/domain/entities/shop_item.dart';

/// Card para mostrar un item de la tienda
class ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool canAfford;
  final VoidCallback onTap;

  const ShopItemCard({
    super.key,
    required this.item,
    required this.canAfford,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = item.price >= 1000;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPremium
              ? Border.all(color: Colors.amber, width: 2)
              : item.isPurchased
              ? Border.all(color: AppTheme.accentGreen, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagen del avatar o icono
                  Expanded(child: _buildImage(isDark)),
                  const SizedBox(height: 8),

                  // Nombre
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Precio o badge "Comprado"
                  if (item.isPurchased)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Tuyo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: canAfford
                            ? AppTheme.accentYellow
                            : (isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            size: 12,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.price}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: canAfford
                                  ? Colors.black87
                                  : (isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Badge premium
            if (isPremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.amber, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.star_rounded, size: 11, color: Colors.white),
                      SizedBox(width: 3),
                      Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
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

  Widget _buildImage(bool isDark) {
    // Si es un power-up, usar mismo estilo que avatares
    if (item.category == ShopItemCategory.powerup) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.accentBlue.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: item.assetPath.isNotEmpty
              ? Image.asset(
                  item.assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.accentBlue.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.ac_unit,
                        size: 40,
                        color: AppTheme.accentBlue,
                      ),
                    );
                  },
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.ac_unit,
                    size: 40,
                    color: AppTheme.accentBlue,
                  ),
                ),
        ),
      );
    }

    // Si es avatar, intentar cargar imagen
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.accentYellow.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          item.assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si la imagen no existe
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.primaryDark.withValues(alpha: 0.3)
                    : AppTheme.primaryDark.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: isDark ? Colors.white70 : AppTheme.primaryDark,
              ),
            );
          },
        ),
      ),
    );
  }
}
