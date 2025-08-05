import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String title;
  final String? description;
  final String? handle;
  final String? status;
  final List<ProductImage>? images;
  final String? thumbnail;
  final List<ProductOption>? options;
  final List<ProductVariant>? variants;
  final List<ProductCategory>? categories;
  final String? type;
  final List<String>? tags;
  final bool? discountable;
  final String? externalId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Additional properties for SDUI
  final double? price;
  final double? originalPrice;
  final String? category;
  final String? shopId;
  final bool? isVegetarian;
  final int? reviewCount;

  Product({
    required this.id,
    required this.title,
    this.description,
    this.handle,
    this.status,
    this.images,
    this.thumbnail,
    this.options,
    this.variants,
    this.categories,
    this.type,
    this.tags,
    this.discountable,
    this.externalId,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.originalPrice,
    this.category,
    this.shopId,
    this.isVegetarian,
    this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // Helper methods for UI
  String get displayPrice {
    if (variants != null && variants!.isNotEmpty) {
      final prices = variants!
          .where((v) => v.prices != null && v.prices!.isNotEmpty)
          .map((v) => v.prices!.first.amount)
          .toList();
      if (prices.isNotEmpty) {
        final minPrice = prices.reduce((a, b) => a < b ? a : b);
        return '\$${(minPrice / 100).toStringAsFixed(2)}';
      }
    }
    return '\$0.00';
  }

  String get displayImage {
    if (images != null && images!.isNotEmpty) {
      return images!.first.url;
    }
    return thumbnail ?? '';
  }

  double get rating {
    // Mock rating for demo purposes
    return 4.0 + (id.hashCode % 10) / 10;
  }
}

@JsonSerializable()
class ProductImage {
  final String id;
  final String url;
  final Map<String, dynamic>? metadata;

  ProductImage({required this.id, required this.url, this.metadata});

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);
  Map<String, dynamic> toJson() => _$ProductImageToJson(this);
}

@JsonSerializable()
class ProductOption {
  final String id;
  final String title;
  final List<ProductOptionValue>? values;

  ProductOption({required this.id, required this.title, this.values});

  factory ProductOption.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionToJson(this);
}

@JsonSerializable()
class ProductOptionValue {
  final String id;
  final String value;
  final String? optionId;

  ProductOptionValue({required this.id, required this.value, this.optionId});

  factory ProductOptionValue.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionValueFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionValueToJson(this);
}

@JsonSerializable()
class ProductVariant {
  final String id;
  final String title;
  final String? sku;
  final String? barcode;
  final String? ean;
  final String? upc;
  final int? inventoryQuantity;
  final bool? allowBackorder;
  final bool? manageInventory;
  final String? hsCode;
  final String? originCountry;
  final String? midCode;
  final String? material;
  final int? weight;
  final int? length;
  final int? height;
  final int? width;
  final String? color;
  final String? size;
  final List<ProductVariantPrice>? prices;

  ProductVariant({
    required this.id,
    required this.title,
    this.sku,
    this.barcode,
    this.ean,
    this.upc,
    this.inventoryQuantity,
    this.allowBackorder,
    this.manageInventory,
    this.hsCode,
    this.originCountry,
    this.midCode,
    this.material,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.color,
    this.size,
    this.prices,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);
  Map<String, dynamic> toJson() => _$ProductVariantToJson(this);
}

@JsonSerializable()
class ProductVariantPrice {
  final String id;
  final String currencyCode;
  final int amount;
  final String? regionId;

  ProductVariantPrice({
    required this.id,
    required this.currencyCode,
    required this.amount,
    this.regionId,
  });

  factory ProductVariantPrice.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantPriceFromJson(json);
  Map<String, dynamic> toJson() => _$ProductVariantPriceToJson(this);
}

@JsonSerializable()
class ProductCategory {
  final String id;
  final String name;
  final String? handle;
  final String? description;
  final bool? isActive;
  final bool? isInternal;
  final int? rank;
  final String? parentCategoryId;

  ProductCategory({
    required this.id,
    required this.name,
    this.handle,
    this.description,
    this.isActive,
    this.isInternal,
    this.rank,
    this.parentCategoryId,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}
