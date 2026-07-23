import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/core/services/shop_service.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import 'package:piensa_play/core/services/connectivity_service.dart';
import 'package:piensa_play/core/services/audio_service.dart';
import 'package:piensa_play/features/shop/domain/entities/shop_item.dart';
import 'package:piensa_play/features/shop/presentation/widgets/shop_item_card.dart';
import 'package:piensa_play/features/shop/presentation/widgets/purchase_dialog.dart';
import 'package:piensa_play/features/home/presentation/widgets/custom_bottom_nav_bar.dart';

/// Página de la tienda de monedas
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  final ShopService _shopService = ShopService();
  final AudioService _audioService = AudioService();

  late TabController _tabController;
  List<ShopItem> _allItems = [];
  bool _isLoading = true;
  int _coins = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final items = await _shopService.getShopItems();
    final coins = AppDataService.instance.achievement.coins;

    setState(() {
      _allItems = items;
      _coins = coins;
      _isLoading = false;
    });
  }

  List<ShopItem> get _avatars =>
      _allItems.where((i) => i.category == ShopItemCategory.avatar).toList();

  List<ShopItem> get _powerups =>
      _allItems.where((i) => i.category == ShopItemCategory.powerup).toList();

  bool get _english => Localizations.localeOf(context).languageCode == 'en';

  Future<void> _onPurchase(ShopItem item) async {
    if (item.isPurchased) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_english ? 'You already own this item' : 'Ya tienes este item'),
          backgroundColor: AppTheme.primaryDark,
        ),
      );
      return;
    }

    if (!_shopService.canAfford(item.price)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _english ? 'Not enough coins' : 'No tienes suficientes monedas',
          ),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }

    // La compra usa una transacción atómica para no gastar monedas dos veces,
    // y eso requiere conexión. Se avisa antes de pedir confirmación en vez de
    // fallar en silencio tras el diálogo.
    if (!ConnectivityService.instance.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _english
                ? 'You need an internet connection to buy items'
                : 'Necesitas conexión a internet para comprar',
          ),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => PurchaseDialog(item: item),
    );

    if (confirmed == true) {
      HapticFeedback.mediumImpact();

      final success = await _shopService.purchaseItem(item);

      if (success && mounted) {
        // Reproducir sonido de compra exitosa
        _audioService.playCorrect();

        // Recargar datos
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.celebration_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _english
                          ? 'You bought ${item.name}!'
                          : '¡Compraste ${item.name}!',
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        }
      } else if (mounted) {
        // No debería ocurrir tras los guardas previos (saldo desincronizado,
        // ítem ya comprado en otro dispositivo, error de red puntual). Se avisa
        // en vez de dejar al usuario sin respuesta tras confirmar.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _english
                  ? "Couldn't complete the purchase. Try again."
                  : 'No se pudo completar la compra. Inténtalo de nuevo.',
            ),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.tertiaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.storefront_rounded),
            const SizedBox(width: 10),
            Text(
              _english ? 'Shop' : 'Tienda',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on_rounded,
                  size: 18,
                  color: AppTheme.primaryDark,
                ),
                const SizedBox(width: 6),
                Text(
                  '$_coins',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentYellow,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(
              icon: const Icon(Icons.person),
              text: _english ? 'Avatars' : 'Avatares',
            ),
            const Tab(icon: Icon(Icons.flash_on), text: 'Power-ups'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppTheme.accentYellow),
            )
          : TabBarView(
              controller: _tabController,
              children: [_buildItemGrid(_avatars), _buildItemGrid(_powerups)],
            ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
          // index == 1 is already on shop
        },
      ),
    );
  }

  Widget _buildItemGrid(List<ShopItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _english ? 'No items available' : 'No hay items disponibles',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ShopItemCard(
          item: item,
          canAfford: _shopService.canAfford(item.price),
          onTap: () => _onPurchase(item),
        );
      },
    );
  }
}
