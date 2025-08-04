// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
  id: json['id'] as String,
  name: json['name'] as String,
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  deliveryTime: json['deliveryTime'] as String,
  cuisines: (json['cuisines'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  location: json['location'] as String,
  distance: json['distance'] as String,
  imageUrl: json['imageUrl'] as String,
  isVeg: json['isVeg'] as bool,
  isFavorite: json['isFavorite'] as bool,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  priceRange: json['priceRange'] as String,
  offers: (json['offers'] as List<dynamic>).map((e) => e as String).toList(),
  deliveryFee: json['deliveryFee'] as String,
  isOpen: json['isOpen'] as bool,
);

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'deliveryTime': instance.deliveryTime,
      'cuisines': instance.cuisines,
      'location': instance.location,
      'distance': instance.distance,
      'imageUrl': instance.imageUrl,
      'isVeg': instance.isVeg,
      'isFavorite': instance.isFavorite,
      'tags': instance.tags,
      'priceRange': instance.priceRange,
      'offers': instance.offers,
      'deliveryFee': instance.deliveryFee,
      'isOpen': instance.isOpen,
    };
