import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/firestore_provider.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import 'package:piensa_play/core/services/user_id_provider.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import 'package:piensa_play/features/shop/domain/entities/shop_item.dart';

/// Servicio para manejar la tienda de monedas
/// Usa el cache de AppDataService para funcionamiento offline
class ShopService {
  static final ShopService _instance = ShopService._internal();
  factory ShopService() => _instance;
  ShopService._internal();

  final FirebaseFirestore _firestore = FirestoreProvider.instance;

  /// Obtiene todos los items de la tienda (desde cache de AppDataService)
  Future<List<ShopItem>> getShopItems() async {
    // Usar cache de AppDataService si está disponible
    final cachedItems = AppDataService.instance.shopItems;
    if (cachedItems.isNotEmpty) {
      AppLogger.log('SHOP: Using cached items (${cachedItems.length})');
      return cachedItems;
    }

    // Si no hay cache, cargar desde Firestore
    try {
      final snapshot = await _firestore
          .collection('shop_items')
          .orderBy('price')
          .get();

      final userId = UserIdProvider.currentUserId;
      final purchasedSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('purchased_items')
          .get();

      final purchasedIds = purchasedSnapshot.docs.map((d) => d.id).toSet();

      final items = snapshot.docs.map((doc) {
        final item = ShopItem.fromJson({'id': doc.id, ...doc.data()});
        return item.copyWith(isPurchased: purchasedIds.contains(item.id));
      }).toList();

      AppLogger.log('SHOP: Loaded ${items.length} items from Firestore');
      return items;
    } catch (e) {
      AppLogger.error('SHOP: Error loading items: $e');
      return [];
    }
  }

  /// Verifica si el usuario puede pagar un item
  bool canAfford(int price) {
    final coins = AppDataService.instance.achievement.coins;
    return coins >= price;
  }

  /// Compra un item
  Future<bool> purchaseItem(ShopItem item) async {
    try {
      final userId = UserIdProvider.currentUserId;
      final achievement = AppDataService.instance.achievement;

      if (!canAfford(item.price)) {
        AppLogger.warning('SHOP: Not enough coins');
        return false;
      }

      // Verificar si ya está comprado (desde cache de AppDataService)
      if (AppDataService.instance.purchasedItemIds.contains(item.id)) {
        AppLogger.warning('SHOP: Item already purchased');
        return false;
      }

      // Descontar monedas
      final newCoins = achievement.coins - item.price;
      final isStreakFreeze =
          item.category == ShopItemCategory.powerup &&
          item.id == 'streak_freeze';

      // 1. Actualizar caché primero -> UI inmediata, online u offline.
      AppDataService.instance.markItemAsPurchased(item.id);
      AppDataService.instance.updateAchievement(
        achievement.copyWith(coins: newCoins),
      );
      if (isStreakFreeze) {
        AppDataService.instance.updateStreakFreezeCount(
          AppDataService.instance.streakFreezeCount + 1,
        );
      }

      // 2. Persistir en Firestore como batch atómico, en segundo plano.
      //    No se hace `await` del commit: con la persistencia activada ese
      //    Future no resuelve offline; el batch queda en cola y se sincroniza
      //    de forma atómica al reconectar.
      final batch = _firestore.batch();

      batch.update(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('achievements')
            .doc('current'),
        {'coins': newCoins},
      );

      batch.set(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('purchased_items')
            .doc(item.id),
        {'purchasedAt': FieldValue.serverTimestamp(), 'price': item.price},
      );

      if (isStreakFreeze) {
        batch.set(
          _firestore
              .collection('users')
              .doc(userId)
              .collection('inventory')
              .doc('streak_freeze'),
          {'count': FieldValue.increment(1)},
          SetOptions(merge: true),
        );
      }

      batch.commit().catchError((e) {
        AppLogger.error('SHOP: Error persisting purchase: $e');
      });

      AppLogger.success('SHOP: Purchased ${item.name} for ${item.price} coins');
      return true;
    } catch (e) {
      AppLogger.error('SHOP: Error purchasing item: $e');
      return false;
    }
  }

  /// Obtiene los avatares comprados
  Future<List<ShopItem>> getPurchasedAvatars() async {
    final items = await getShopItems();
    return items
        .where((i) => i.category == ShopItemCategory.avatar && i.isPurchased)
        .toList();
  }

  /// Obtiene la cantidad de streak freezes disponibles (desde cache)
  int getStreakFreezeCount() {
    return AppDataService.instance.streakFreezeCount;
  }

  /// Usa un streak freeze
  Future<bool> useStreakFreeze() async {
    try {
      final count = getStreakFreezeCount();
      if (count <= 0) {
        AppLogger.warning('SHOP: No streak freezes available');
        return false;
      }

      final userId = UserIdProvider.currentUserId;

      // Caché primero (offline-ok), persistencia en segundo plano.
      AppDataService.instance.updateStreakFreezeCount(count - 1);

      _firestore
          .collection('users')
          .doc(userId)
          .collection('inventory')
          .doc('streak_freeze')
          .update({'count': FieldValue.increment(-1)})
          .catchError((e) {
            AppLogger.error('SHOP: Error persisting streak freeze use: $e');
          });

      AppLogger.success('SHOP: Used streak freeze');
      return true;
    } catch (e) {
      AppLogger.error('SHOP: Error using streak freeze: $e');
      return false;
    }
  }
}
