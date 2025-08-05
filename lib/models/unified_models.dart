import 'package:ecommerce_sdui/models/shop.dart';

/// Unified data models for centralized mock data management
/// These models ensure consistency across the entire SDUI platform

/// Enhanced Shop Model with additional metadata for SDUI platform
class ShopModel {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String bannerImage;
  final double rating;
  final int reviewCount;
  final String category;
  final bool isVerified;
  final bool isActive;
  final List<String> featuredProductIds;
  final ShopContact contact;
  final ShopThemeData theme;
  final String deliveryTime;
  final String specialOffer;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ShopModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.bannerImage,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.isVerified,
    required this.isActive,
    required this.featuredProductIds,
    required this.contact,
    required this.theme,
    required this.deliveryTime,
    required this.specialOffer,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to legacy Shop model for backward compatibility
  Shop toShop() {
    return Shop(
      id: id,
      name: name,
      description: description,
      logo: logo,
      bannerImage: bannerImage,
      rating: rating,
      reviewCount: reviewCount,
      category: category,
      isVerified: isVerified,
      isActive: isActive,
      featuredProductIds: featuredProductIds,
      contact: contact,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'bannerImage': bannerImage,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'isVerified': isVerified,
      'isActive': isActive,
      'featuredProductIds': featuredProductIds,
      'contact': contact.toJson(),
      'theme': theme.toJson(),
      'deliveryTime': deliveryTime,
      'specialOffer': specialOffer,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Shop theme data for consistent UI styling
class ShopThemeData {
  final String primaryColor;
  final String secondaryColor;
  final String backgroundColor;
  final String textColor;

  const ShopThemeData({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
    };
  }
}

/// Promotional offers and deals for banner carousels
class OfferModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? shopId; // null for platform-wide offers
  final String? productId; // null for shop-wide offers
  final String discountType; // 'percentage', 'fixed', 'bogo'
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final List<String> tags;

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.shopId,
    this.productId,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'shopId': shopId,
      'productId': productId,
      'discountType': discountType,
      'discountValue': discountValue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'tags': tags,
    };
  }
}

/// Enhanced Product Model with proper naming and shop associations
class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String currency;
  final String shopId;
  final String shopName;
  final String category;
  final List<String> tags;
  final bool isAvailable;
  final bool isFeatured;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.shopId,
    required this.shopName,
    required this.category,
    required this.tags,
    required this.isAvailable,
    required this.isFeatured,
    required this.rating,
    required this.reviewCount,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'currency': currency,
      'shopId': shopId,
      'shopName': shopName,
      'category': category,
      'tags': tags,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'rating': rating,
      'reviewCount': reviewCount,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Cart item with proper product-to-shop mapping
class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;
  final String shopId;
  final String shopName;
  final String currency;
  final Map<String, dynamic> metadata;
  final DateTime addedAt;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.shopId,
    required this.shopName,
    required this.currency,
    required this.metadata,
    required this.addedAt,
  });

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'shopId': shopId,
      'shopName': shopName,
      'currency': currency,
      'totalPrice': totalPrice,
      'metadata': metadata,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

/// Cart model with proper shop grouping
class CartModel {
  final String id;
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Group items by shop for better organization
  Map<String, List<CartItemModel>> get itemsByShop {
    final Map<String, List<CartItemModel>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.shopId, () => []).add(item);
    }
    return grouped;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'total': total,
      'currency': currency,
      'itemCount': itemCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
