import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/shop/domain/entities/shop_item.dart';
import 'app_data_service.dart';
import 'logger_service.dart';
import 'user_id_provider.dart';

/// Tienda con saldo atomico y distincion entre compras unicas y consumibles.
class ShopService {
  static final ShopService _instance = ShopService._internal();
  factory ShopService() => _instance;
  ShopService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ShopItem>> getShopItems() async {
    final cachedItems = AppDataService.instance.shopItems;
    if (cachedItems.isNotEmpty) {
      return cachedItems
          .map(
            (item) => item.copyWith(
              isPurchased:
                  item.category == ShopItemCategory.avatar &&
                  AppDataService.instance.purchasedItemIds.contains(item.id),
            ),
          )
          .toList();
    }

    try {
      final itemsSnapshot = await _firestore
          .collection('shop_items')
          .orderBy('price')
          .get();
      final userId = UserIdProvider.currentUserId;
      final purchasedSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('purchased_items')
          .get();
      final purchasedIds = purchasedSnapshot.docs.map((doc) => doc.id).toSet();

      return itemsSnapshot.docs.map((doc) {
        final item = ShopItem.fromJson({'id': doc.id, ...doc.data()});
        return item.copyWith(
          isPurchased:
              item.category == ShopItemCategory.avatar &&
              purchasedIds.contains(item.id),
        );
      }).toList();
    } catch (error) {
      AppLogger.error('SHOP: loading failed: $error');
      return cachedItems;
    }
  }

  bool canAfford(int price) =>
      AppDataService.instance.achievement.coins >= price;

  Future<bool> purchaseItem(ShopItem item) async {
    final userId = UserIdProvider.currentUserId;
    final userRef = _firestore.collection('users').doc(userId);
    final achievementRef = userRef.collection('achievements').doc('current');
    final cachedAchievement = AppDataService.instance.achievement;
    final isConsumable = item.category == ShopItemCategory.powerup;
    var newCoins = cachedAchievement.coins;

    try {
      await _firestore.runTransaction((transaction) async {
        final achievementSnapshot = await transaction.get(achievementRef);
        final remoteCoins = achievementSnapshot.exists
            ? (achievementSnapshot.data()?['coins'] as int? ?? 0)
            : cachedAchievement.coins;
        if (remoteCoins < item.price) throw StateError('insufficient-coins');

        final purchaseRef = userRef.collection('purchased_items').doc(item.id);
        if (!isConsumable) {
          final purchaseSnapshot = await transaction.get(purchaseRef);
          if (purchaseSnapshot.exists) throw StateError('already-purchased');
        }

        newCoins = remoteCoins - item.price;
        transaction.set(achievementRef, {
          'coins': newCoins,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (isConsumable) {
          transaction.set(userRef.collection('inventory').doc(item.id), {
            'count': FieldValue.increment(1),
          }, SetOptions(merge: true));
        } else {
          transaction.set(purchaseRef, {
            'purchasedAt': FieldValue.serverTimestamp(),
            'price': item.price,
          });
        }
      });

      if (isConsumable) {
        if (item.id == 'streak_freeze') {
          AppDataService.instance.updateStreakFreezeCount(
            AppDataService.instance.streakFreezeCount + 1,
          );
        }
      } else {
        AppDataService.instance.markItemAsPurchased(item.id);
      }
      AppDataService.instance.updateAchievement(
        cachedAchievement.copyWith(coins: newCoins),
      );
      return true;
    } on StateError catch (error) {
      AppLogger.warning('SHOP: ${error.message}');
      return false;
    } catch (error) {
      AppLogger.error('SHOP: purchase failed: $error');
      return false;
    }
  }

  Future<List<ShopItem>> getPurchasedAvatars() async {
    final items = await getShopItems();
    return items
        .where(
          (item) =>
              item.category == ShopItemCategory.avatar && item.isPurchased,
        )
        .toList();
  }

  int getStreakFreezeCount() => AppDataService.instance.streakFreezeCount;

  Future<bool> useStreakFreeze() async {
    final userId = UserIdProvider.currentUserId;
    final inventoryRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .doc('streak_freeze');
    var remaining = getStreakFreezeCount();

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(inventoryRef);
        final count = snapshot.data()?['count'] as int? ?? 0;
        if (count <= 0) throw StateError('empty-inventory');
        remaining = count - 1;
        transaction.set(inventoryRef, {
          'count': remaining,
        }, SetOptions(merge: true));
      });
      AppDataService.instance.updateStreakFreezeCount(remaining);
      return true;
    } catch (error) {
      AppLogger.warning('SHOP: freeze not consumed: $error');
      return false;
    }
  }
}
