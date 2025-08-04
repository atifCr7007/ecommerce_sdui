import '../models/restaurant.dart';

/// Mock service for restaurant data
/// Provides realistic restaurant data for the restaurant listing screen
class MockRestaurantService {
  static final MockRestaurantService _instance = MockRestaurantService._internal();
  factory MockRestaurantService() => _instance;
  MockRestaurantService._internal();

  /// List of mock restaurants with diverse food types
  static final List<Restaurant> _mockRestaurants = [
    Restaurant(
      id: 'rest_001',
      name: 'McDonald\'s',
      rating: 4.6,
      reviewCount: 2100,
      deliveryTime: '10-15 mins',
      cuisines: ['Burgers', 'Beverages', 'Cafe'],
      location: 'Vashi',
      distance: '0.6 km',
      imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: false,
      tags: ['fast-food', 'popular'],
      priceRange: '₹150-₹300',
      offers: ['ITEMS AT ₹99'],
      deliveryFee: 'Free delivery',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_002',
      name: 'Wendy\'s Burgers',
      rating: 4.2,
      reviewCount: 3700,
      deliveryTime: '30-35 mins',
      cuisines: ['Burgers', 'American', 'Fast Food'],
      location: 'Vashi',
      distance: '2.6 km',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: true,
      tags: ['guilt-free', 'options-available'],
      priceRange: '₹200-₹400',
      offers: [],
      deliveryFee: 'Free delivery',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_003',
      name: 'China Town',
      rating: 4.3,
      reviewCount: 990,
      deliveryTime: '25-30 mins',
      cuisines: ['Chinese', 'Beverages'],
      location: 'Vashi',
      distance: '2.4 km',
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03246963d51a?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: false,
      tags: ['authentic', 'spicy'],
      priceRange: '₹250-₹500',
      offers: [],
      deliveryFee: '₹25 delivery fee',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_004',
      name: 'Pizza Palace',
      rating: 4.5,
      reviewCount: 1850,
      deliveryTime: '20-25 mins',
      cuisines: ['Pizza', 'Italian', 'Beverages'],
      location: 'Nerul',
      distance: '1.2 km',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: false,
      tags: ['wood-fired', 'authentic'],
      priceRange: '₹300-₹600',
      offers: ['Buy 1 Get 1 Free'],
      deliveryFee: 'Free delivery',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_005',
      name: 'Spice Garden',
      rating: 4.4,
      reviewCount: 1250,
      deliveryTime: '35-40 mins',
      cuisines: ['Indian', 'North Indian', 'Biryani'],
      location: 'Vashi',
      distance: '1.8 km',
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&h=300&fit=crop',
      isVeg: true,
      isFavorite: true,
      tags: ['pure-veg', 'traditional'],
      priceRange: '₹200-₹450',
      offers: ['20% off up to ₹50'],
      deliveryFee: 'Free delivery',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_006',
      name: 'Sushi Express',
      rating: 4.7,
      reviewCount: 890,
      deliveryTime: '40-45 mins',
      cuisines: ['Japanese', 'Sushi', 'Asian'],
      location: 'Belapur',
      distance: '3.2 km',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: false,
      tags: ['premium', 'fresh'],
      priceRange: '₹500-₹1000',
      offers: [],
      deliveryFee: '₹35 delivery fee',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_007',
      name: 'Taco Bell',
      rating: 4.1,
      reviewCount: 2450,
      deliveryTime: '25-30 mins',
      cuisines: ['Mexican', 'Fast Food', 'Wraps'],
      location: 'Vashi',
      distance: '1.5 km',
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38174c4a6c7b?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: false,
      tags: ['spicy', 'mexican'],
      priceRange: '₹150-₹350',
      offers: ['Free delivery'],
      deliveryFee: 'Free delivery',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_008',
      name: 'Green Leaf Cafe',
      rating: 4.8,
      reviewCount: 650,
      deliveryTime: '30-35 mins',
      cuisines: ['Healthy', 'Salads', 'Beverages'],
      location: 'Nerul',
      distance: '2.1 km',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop',
      isVeg: true,
      isFavorite: true,
      tags: ['pure-veg', 'healthy', 'organic'],
      priceRange: '₹200-₹400',
      offers: ['Healthy combo at ₹199'],
      deliveryFee: 'Free delivery',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_009',
      name: 'Burger King',
      rating: 4.3,
      reviewCount: 3200,
      deliveryTime: '15-20 mins',
      cuisines: ['Burgers', 'Fast Food', 'American'],
      location: 'Vashi',
      distance: '0.8 km',
      imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: false,
      tags: ['flame-grilled', 'popular'],
      priceRange: '₹180-₹350',
      offers: ['2 Burgers at ₹199'],
      deliveryFee: 'Free delivery',
      isOpen: true,
    ),
    Restaurant(
      id: 'rest_010',
      name: 'Noodle House',
      rating: 4.0,
      reviewCount: 1100,
      deliveryTime: '35-40 mins',
      cuisines: ['Chinese', 'Noodles', 'Thai'],
      location: 'Belapur',
      distance: '2.8 km',
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=300&fit=crop',
      isVeg: false,
      isFavorite: false,
      tags: ['authentic', 'spicy'],
      priceRange: '₹220-₹450',
      offers: [],
      deliveryFee: '₹30 delivery fee',
      isOpen: true,
    ),
  ];

  /// Get all restaurants
  List<Restaurant> getAllRestaurants() {
    return List<Restaurant>.from(_mockRestaurants);
  }

  /// Get restaurant by ID
  Restaurant? getRestaurantById(String restaurantId) {
    try {
      return _mockRestaurants.firstWhere((restaurant) => restaurant.id == restaurantId);
    } catch (e) {
      return null;
    }
  }

  /// Get restaurants by cuisine type
  List<Restaurant> getRestaurantsByCuisine(String cuisine) {
    return _mockRestaurants
        .where((restaurant) => 
            restaurant.cuisines.any((c) => c.toLowerCase().contains(cuisine.toLowerCase())))
        .toList();
  }

  /// Get vegetarian restaurants
  List<Restaurant> getVegetarianRestaurants() {
    return _mockRestaurants.where((restaurant) => restaurant.isVeg).toList();
  }

  /// Get restaurants with delivery time less than specified minutes
  List<Restaurant> getRestaurantsWithFastDelivery(int maxMinutes) {
    return _mockRestaurants.where((restaurant) {
      final deliveryTime = restaurant.deliveryTime;
      final minutes = int.tryParse(deliveryTime.split('-')[0]) ?? 60;
      return minutes <= maxMinutes;
    }).toList();
  }

  /// Get restaurants within price range
  List<Restaurant> getRestaurantsInPriceRange(int minPrice, int maxPrice) {
    return _mockRestaurants.where((restaurant) {
      final priceRange = restaurant.priceRange;
      final prices = priceRange.replaceAll('₹', '').split('-');
      if (prices.length == 2) {
        final min = int.tryParse(prices[0]) ?? 0;
        final max = int.tryParse(prices[1]) ?? 1000;
        return min >= minPrice && max <= maxPrice;
      }
      return false;
    }).toList();
  }

  /// Search restaurants by name or cuisine
  List<Restaurant> searchRestaurants(String query) {
    final lowerQuery = query.toLowerCase();
    return _mockRestaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(lowerQuery) ||
             restaurant.cuisines.any((cuisine) => cuisine.toLowerCase().contains(lowerQuery)) ||
             restaurant.location.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get top rated restaurants
  List<Restaurant> getTopRatedRestaurants({int limit = 10}) {
    final sortedRestaurants = List<Restaurant>.from(_mockRestaurants);
    sortedRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedRestaurants.take(limit).toList();
  }

  /// Get favorite restaurants
  List<Restaurant> getFavoriteRestaurants() {
    return _mockRestaurants.where((restaurant) => restaurant.isFavorite).toList();
  }

  /// Toggle favorite status
  void toggleFavorite(String restaurantId) {
    final index = _mockRestaurants.indexWhere((restaurant) => restaurant.id == restaurantId);
    if (index != -1) {
      _mockRestaurants[index] = _mockRestaurants[index].copyWith(
        isFavorite: !_mockRestaurants[index].isFavorite,
      );
    }
  }
}
