import 'package:flutter/material.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/core/services/shop_service.dart';

/// Diálogo para seleccionar avatar
class AvatarSelectorDialog extends StatefulWidget {
  final String currentAvatarId;
  final Function(String avatarId, String? assetPath) onSelect;

  const AvatarSelectorDialog({
    super.key,
    required this.currentAvatarId,
    required this.onSelect,
  });

  @override
  State<AvatarSelectorDialog> createState() => _AvatarSelectorDialogState();
}

class _AvatarSelectorDialogState extends State<AvatarSelectorDialog> {
  final ShopService _shopService = ShopService();
  List<_AvatarOption> _avatars = [];
  bool _isLoading = true;
  String? _selectedId;

  // Avatares por defecto (gratis)
  static const List<Map<String, String>> _defaultAvatars = [
    {
      'id': 'cocodrilo',
      'name': 'Cocodrilo',
      'path': 'assets/avatars/cocodrilo.png',
    },
    {'id': 'jaguar', 'name': 'Jaguar', 'path': 'assets/avatars/jaguar.png'},
    {'id': 'pajaro', 'name': 'Pájaro', 'path': 'assets/avatars/pajaro.png'},
    {'id': 'tortuga', 'name': 'Tortuga', 'path': 'assets/avatars/tortuga.png'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedId = widget.currentAvatarId;
    _loadAvatars();
  }

  Future<void> _loadAvatars() async {
    // Cargar avatares por defecto
    final defaultList = _defaultAvatars
        .map(
          (a) => _AvatarOption(
            id: a['id']!,
            name: a['name']!,
            assetPath: a['path']!,
            isDefault: true,
            isPurchased: true,
          ),
        )
        .toList();

    // Cargar avatares comprados de la tienda
    final purchasedItems = await _shopService.getPurchasedAvatars();
    final purchasedList = purchasedItems
        .map(
          (item) => _AvatarOption(
            id: item.id,
            name: item.name,
            assetPath: item.assetPath,
            isDefault: false,
            isPurchased: true,
          ),
        )
        .toList();

    setState(() {
      _avatars = [...defaultList, ...purchasedList];
      _isLoading = false;
    });
  }

  void _onAvatarTap(String id, String assetPath) {
    setState(() => _selectedId = id);
  }

  void _onConfirm() {
    if (_selectedId != null) {
      final selected = _avatars.firstWhere((a) => a.id == _selectedId);
      widget.onSelect(_selectedId!, selected.assetPath);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            Text(
              'Elige tu Avatar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona un avatar para tu perfil',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            // Grid de avatares
            _isLoading
                ? const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SizedBox(
                    height: 280,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: _avatars.length,
                      itemBuilder: (context, index) {
                        final avatar = _avatars[index];
                        final isSelected = avatar.id == _selectedId;

                        return GestureDetector(
                          onTap: () =>
                              _onAvatarTap(avatar.id, avatar.assetPath),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accentYellow.withValues(alpha: 0.2)
                                  : (isDark
                                        ? AppTheme.surfaceDark
                                        : Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(
                                      color: AppTheme.accentYellow,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Avatar image
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.accentYellow
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      avatar.assetPath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.person,
                                        size: 30,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Name
                                Text(
                                  avatar.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Badge for premium
                                if (!avatar.isDefault)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentGreen,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        '✨',
                                        style: TextStyle(fontSize: 8),
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
            const SizedBox(height: 20),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarOption {
  final String id;
  final String name;
  final String assetPath;
  final bool isDefault;
  final bool isPurchased;

  _AvatarOption({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.isDefault,
    required this.isPurchased,
  });
}
