import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

/// Restaurant model for the restaurant listing screen
@JsonSerializable()
class Restaurant {
  final String id;
  final String name;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final List<String> cuisines;
  final String location;
  final String distance;
  final String imageUrl;
  final bool isVeg;
  final bool isFavorite;
  final List<String> tags;
  final String priceRange;
  final List<String> offers;
  final String deliveryFee;
  final bool isOpen;

  Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.cuisines,
    required this.location,
    required this.distance,
    required this.imageUrl,
    required this.isVeg,
    required this.isFavorite,
    required this.tags,
    required this.priceRange,
    required this.offers,
    required this.deliveryFee,
    required this.isOpen,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  /// Create a copy of the restaurant with updated fields
  Restaurant copyWith({
    String? id,
    String? name,
    double? rating,
    int? reviewCount,
    String? deliveryTime,
    List<String>? cuisines,
    String? location,
    String? distance,
    String? imageUrl,
    bool? isVeg,
    bool? isFavorite,
    List<String>? tags,
    String? priceRange,
    List<String>? offers,
    String? deliveryFee,
    bool? isOpen,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      cuisines: cuisines ?? this.cuisines,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      imageUrl: imageUrl ?? this.imageUrl,
      isVeg: isVeg ?? this.isVeg,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      priceRange: priceRange ?? this.priceRange,
      offers: offers ?? this.offers,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  /// Get formatted cuisine string
  String get cuisineString => cuisines.join(', ');

  /// Get formatted rating string
  String get ratingString => '$rating (${reviewCount}K+)';

  /// Check if restaurant has offers
  bool get hasOffers => offers.isNotEmpty;

  /// Get primary offer text
  String get primaryOffer => offers.isNotEmpty ? offers.first : '';

  /// Check if restaurant delivers fast (less than 30 minutes)
  bool get isFastDelivery {
    final minutes = int.tryParse(deliveryTime.split('-')[0]) ?? 60;
    return minutes < 30;
  }

  /// Check if restaurant is in budget (less than ₹300)
  bool get isBudgetFriendly {
    final priceRange = this.priceRange.replaceAll('₹', '');
    final maxPrice = int.tryParse(priceRange.split('-')[1]) ?? 1000;
    return maxPrice <= 300;
  }

  /// Get star rating as integer for display
  int get starRating => rating.round();

  /// Get delivery time in minutes (average)
  int get averageDeliveryMinutes {
    final parts = deliveryTime.split('-');
    if (parts.length == 2) {
      final min = int.tryParse(parts[0]) ?? 0;
      final max = int.tryParse(parts[1].replaceAll(' mins', '')) ?? 0;
      return ((min + max) / 2).round();
    }
    return 30; // default
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Restaurant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Restaurant{id: $id, name: $name, rating: $rating, cuisines: $cuisines}';
  }
}

/// Restaurant filter options
enum RestaurantFilter {
  all,
  pureVeg,
  fastDelivery,
  budgetFriendly,
  topRated,
  offers,
}

/// Restaurant sort options
enum RestaurantSort {
  relevance,
  rating,
  deliveryTime,
  costLowToHigh,
  costHighToLow,
}

/// Extension for filter display names
extension RestaurantFilterExtension on RestaurantFilter {
  String get displayName {
    switch (this) {
      case RestaurantFilter.all:
        return 'All';
      case RestaurantFilter.pureVeg:
        return 'Pure Veg';
      case RestaurantFilter.fastDelivery:
        return 'Less than 30 mins';
      case RestaurantFilter.budgetFriendly:
        return 'Less than ₹300';
      case RestaurantFilter.topRated:
        return 'Ratings 4.0+';
      case RestaurantFilter.offers:
        return 'Offers';
    }
  }
}

/// Extension for sort display names
extension RestaurantSortExtension on RestaurantSort {
  String get displayName {
    switch (this) {
      case RestaurantSort.relevance:
        return 'Relevance';
      case RestaurantSort.rating:
        return 'Rating';
      case RestaurantSort.deliveryTime:
        return 'Delivery Time';
      case RestaurantSort.costLowToHigh:
        return 'Cost: Low to High';
      case RestaurantSort.costHighToLow:
        return 'Cost: High to Low';
    }
  }
}
