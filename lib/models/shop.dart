import 'package:json_annotation/json_annotation.dart';
import 'package:ecommerce_sdui/models/product.dart';

part 'shop.g.dart';

/// Shop/Store model for marketplace
@JsonSerializable()
class Shop {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String? bannerImage;
  final String? image; // Main shop image
  final String imageUrl; // Computed image URL for compatibility
  final double rating;
  final int reviewCount;
  final String category;
  final bool isVerified;
  final bool isActive;
  final List<String> featuredProductIds;
  final ShopContact contact;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional properties for SDUI
  final List<String> tags;
  final String deliveryTime;
  final List<String> cuisines;
  final String location;
  final String distance;
  final bool isOpen;
  final double deliveryFee;
  final double minimumOrder;



  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    this.bannerImage,
    this.image,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.isVerified = false,
    this.isActive = true,
    required this.featuredProductIds,
    required this.contact,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.deliveryTime = '30-45 mins',
    this.cuisines = const [],
    this.location = 'Unknown',
    this.distance = '2.5 km',
    this.isOpen = true,
    this.deliveryFee = 0.0,
    this.minimumOrder = 0.0,
  }) : imageUrl = bannerImage ?? image ?? logo;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);

  /// Get formatted rating text
  String get formattedRating => '$rating/5.0 ($reviewCount reviews)';

  /// Get star rating display
  String get starRating => '★' * rating.floor() + '☆' * (5 - rating.floor());
}

/// Shop contact information
@JsonSerializable()
class ShopContact {
  final String? email;
  final String? phone;
  final String? website;
  final ShopAddress? address;

  ShopContact({
    this.email,
    this.phone,
    this.website,
    this.address,
  });

  factory ShopContact.fromJson(Map<String, dynamic> json) => _$ShopContactFromJson(json);
  Map<String, dynamic> toJson() => _$ShopContactToJson(this);
}

/// Shop address information
@JsonSerializable()
class ShopAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;

  ShopAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
  });

  factory ShopAddress.fromJson(Map<String, dynamic> json) => _$ShopAddressFromJson(json);
  Map<String, dynamic> toJson() => _$ShopAddressToJson(this);

  /// Get formatted address
  String get formattedAddress => '$street, $city, $state $zipCode, $country';
}

/// Shop with products for detailed view
@JsonSerializable()
class ShopWithProducts {
  final Shop shop;
  final List<Product> products;
  final List<Product> featuredProducts;

  ShopWithProducts({
    required this.shop,
    required this.products,
    required this.featuredProducts,
  });

  factory ShopWithProducts.fromJson(Map<String, dynamic> json) => _$ShopWithProductsFromJson(json);
  Map<String, dynamic> toJson() => _$ShopWithProductsToJson(this);
}

/// Marketplace response containing shops
@JsonSerializable()
class MarketplaceResponse {
  final List<Shop> shops;
  final int totalShops;
  final String? message;

  MarketplaceResponse({
    required this.shops,
    required this.totalShops,
    this.message,
  });

  factory MarketplaceResponse.fromJson(Map<String, dynamic> json) => _$MarketplaceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MarketplaceResponseToJson(this);
}

/// Shop response for single shop
@JsonSerializable()
class ShopResponse {
  final ShopWithProducts shopWithProducts;
  final String? message;

  ShopResponse({
    required this.shopWithProducts,
    this.message,
  });

  factory ShopResponse.fromJson(Map<String, dynamic> json) => _$ShopResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ShopResponseToJson(this);
}

/// Shop categories enum
enum ShopCategory {
  @JsonValue('electronics')
  electronics,
  @JsonValue('clothing')
  clothing,
  @JsonValue('books')
  books,
  @JsonValue('home_garden')
  homeGarden,
  @JsonValue('sports')
  sports,
  @JsonValue('beauty')
  beauty,
  @JsonValue('toys')
  toys,
  @JsonValue('automotive')
  automotive,
  @JsonValue('food')
  food,
  @JsonValue('health')
  health,
}

/// Extension to get category display names
extension ShopCategoryExtension on ShopCategory {
  String get displayName {
    switch (this) {
      case ShopCategory.electronics:
        return 'Electronics';
      case ShopCategory.clothing:
        return 'Clothing & Fashion';
      case ShopCategory.books:
        return 'Books & Media';
      case ShopCategory.homeGarden:
        return 'Home & Garden';
      case ShopCategory.sports:
        return 'Sports & Outdoors';
      case ShopCategory.beauty:
        return 'Beauty & Personal Care';
      case ShopCategory.toys:
        return 'Toys & Games';
      case ShopCategory.automotive:
        return 'Automotive';
      case ShopCategory.food:
        return 'Food & Beverages';
      case ShopCategory.health:
        return 'Health & Wellness';
    }
  }

  String get icon {
    switch (this) {
      case ShopCategory.electronics:
        return '📱';
      case ShopCategory.clothing:
        return '👕';
      case ShopCategory.books:
        return '📚';
      case ShopCategory.homeGarden:
        return '🏠';
      case ShopCategory.sports:
        return '⚽';
      case ShopCategory.beauty:
        return '💄';
      case ShopCategory.toys:
        return '🧸';
      case ShopCategory.automotive:
        return '🚗';
      case ShopCategory.food:
        return '🍕';
      case ShopCategory.health:
        return '💊';
    }
  }
}
