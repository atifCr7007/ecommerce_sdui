// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  logo: json['logo'] as String,
  bannerImage: json['bannerImage'] as String?,
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  category: json['category'] as String,
  isVerified: json['isVerified'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  featuredProductIds: (json['featuredProductIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  contact: ShopContact.fromJson(json['contact'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'logo': instance.logo,
  'bannerImage': instance.bannerImage,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'category': instance.category,
  'isVerified': instance.isVerified,
  'isActive': instance.isActive,
  'featuredProductIds': instance.featuredProductIds,
  'contact': instance.contact,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

ShopContact _$ShopContactFromJson(Map<String, dynamic> json) => ShopContact(
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  website: json['website'] as String?,
  address: json['address'] == null
      ? null
      : ShopAddress.fromJson(json['address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShopContactToJson(ShopContact instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'website': instance.website,
      'address': instance.address,
    };

ShopAddress _$ShopAddressFromJson(Map<String, dynamic> json) => ShopAddress(
  street: json['street'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  country: json['country'] as String,
  zipCode: json['zipCode'] as String,
);

Map<String, dynamic> _$ShopAddressToJson(ShopAddress instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'zipCode': instance.zipCode,
    };

ShopWithProducts _$ShopWithProductsFromJson(Map<String, dynamic> json) =>
    ShopWithProducts(
      shop: Shop.fromJson(json['shop'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredProducts: (json['featuredProducts'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShopWithProductsToJson(ShopWithProducts instance) =>
    <String, dynamic>{
      'shop': instance.shop,
      'products': instance.products,
      'featuredProducts': instance.featuredProducts,
    };

MarketplaceResponse _$MarketplaceResponseFromJson(Map<String, dynamic> json) =>
    MarketplaceResponse(
      shops: (json['shops'] as List<dynamic>)
          .map((e) => Shop.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalShops: (json['totalShops'] as num).toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MarketplaceResponseToJson(
  MarketplaceResponse instance,
) => <String, dynamic>{
  'shops': instance.shops,
  'totalShops': instance.totalShops,
  'message': instance.message,
};

ShopResponse _$ShopResponseFromJson(Map<String, dynamic> json) => ShopResponse(
  shopWithProducts: ShopWithProducts.fromJson(
    json['shopWithProducts'] as Map<String, dynamic>,
  ),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ShopResponseToJson(ShopResponse instance) =>
    <String, dynamic>{
      'shopWithProducts': instance.shopWithProducts,
      'message': instance.message,
    };
