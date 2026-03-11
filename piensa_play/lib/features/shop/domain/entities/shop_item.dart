/// Modelo de item de la tienda
class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final ShopItemCategory category;
  final String assetPath; // Ruta de la imagen del avatar o icono
  final bool isPurchased;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.assetPath,
    this.isPurchased = false,
  });

  ShopItem copyWith({bool? isPurchased}) {
    return ShopItem(
      id: id,
      name: name,
      description: description,
      price: price,
      category: category,
      assetPath: assetPath,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'category': category.toJson(),
    'assetPath': assetPath,
  };

  factory ShopItem.fromJson(Map<String, dynamic> json) => ShopItem(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    price: json['price'] ?? 0,
    category: ShopItemCategoryExtension.fromJson(json['category']),
    assetPath: json['assetPath'] ?? '',
  );
}

/// Categorías de items en la tienda
enum ShopItemCategory { avatar, powerup }

extension ShopItemCategoryExtension on ShopItemCategory {
  String toJson() {
    switch (this) {
      case ShopItemCategory.avatar:
        return 'avatar';
      case ShopItemCategory.powerup:
        return 'powerup';
    }
  }

  static ShopItemCategory fromJson(String? value) {
    switch (value) {
      case 'avatar':
        return ShopItemCategory.avatar;
      case 'powerup':
        return ShopItemCategory.powerup;
      default:
        return ShopItemCategory.avatar;
    }
  }
}
