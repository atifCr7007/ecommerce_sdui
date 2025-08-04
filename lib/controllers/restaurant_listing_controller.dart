import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/mock_restaurant_service.dart';

/// Controller for restaurant listing screen
/// Handles filtering, sorting, search, and navigation
class RestaurantListingController extends GetxController {
  final MockRestaurantService _restaurantService = MockRestaurantService();

  // Observable state
  final isLoading = false.obs;
  final error = RxnString();
  final restaurants = <Restaurant>[].obs;
  final filteredRestaurants = <Restaurant>[].obs;
  final searchQuery = ''.obs;
  final selectedFilters = <RestaurantFilter>[].obs;
  final selectedSort = RestaurantSort.relevance.obs;
  final categoryFilter = ''.obs; // For category-specific filtering (pizza, burger, etc.)

  // Filter options
  final availableFilters = [
    RestaurantFilter.pureVeg,
    RestaurantFilter.fastDelivery,
    RestaurantFilter.budgetFriendly,
    RestaurantFilter.topRated,
    RestaurantFilter.offers,
  ];

  // Sort options
  final availableSorts = [
    RestaurantSort.relevance,
    RestaurantSort.rating,
    RestaurantSort.deliveryTime,
    RestaurantSort.costLowToHigh,
    RestaurantSort.costHighToLow,
  ];

  @override
  void onInit() {
    super.onInit();
    loadRestaurants();
  }

  /// Load all restaurants
  Future<void> loadRestaurants() async {
    try {
      isLoading.value = true;
      error.value = null;

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final allRestaurants = _restaurantService.getAllRestaurants();
      restaurants.value = allRestaurants;
      
      // Apply initial filtering
      _applyFiltersAndSort();
      
      debugPrint('[RestaurantListingController] Loaded ${allRestaurants.length} restaurants');
    } catch (e) {
      error.value = 'Failed to load restaurants: $e';
      debugPrint('[RestaurantListingController] Error loading restaurants: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Set category filter (from navigation)
  void setCategoryFilter(String category) {
    categoryFilter.value = category.toLowerCase();
    _applyFiltersAndSort();
    debugPrint('[RestaurantListingController] Set category filter: $category');
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _applyFiltersAndSort();
    debugPrint('[RestaurantListingController] Search query updated: $query');
  }

  /// Toggle filter
  void toggleFilter(RestaurantFilter filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    _applyFiltersAndSort();
    debugPrint('[RestaurantListingController] Toggled filter: ${filter.displayName}');
  }

  /// Update sort option
  void updateSort(RestaurantSort sort) {
    selectedSort.value = sort;
    _applyFiltersAndSort();
    debugPrint('[RestaurantListingController] Sort updated: ${sort.displayName}');
  }

  /// Clear all filters
  void clearFilters() {
    selectedFilters.clear();
    searchQuery.value = '';
    selectedSort.value = RestaurantSort.relevance;
    _applyFiltersAndSort();
    debugPrint('[RestaurantListingController] Cleared all filters');
  }

  /// Apply filters and sorting
  void _applyFiltersAndSort() {
    var filtered = List<Restaurant>.from(restaurants);

    // Apply category filter first
    if (categoryFilter.value.isNotEmpty) {
      filtered = filtered.where((restaurant) {
        return restaurant.cuisines.any((cuisine) => 
          cuisine.toLowerCase().contains(categoryFilter.value));
      }).toList();
    }

    // Apply search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query) ||
               restaurant.cuisines.any((cuisine) => cuisine.toLowerCase().contains(query)) ||
               restaurant.location.toLowerCase().contains(query);
      }).toList();
    }

    // Apply selected filters
    for (final filter in selectedFilters) {
      switch (filter) {
        case RestaurantFilter.pureVeg:
          filtered = filtered.where((restaurant) => restaurant.isVeg).toList();
          break;
        case RestaurantFilter.fastDelivery:
          filtered = filtered.where((restaurant) => restaurant.isFastDelivery).toList();
          break;
        case RestaurantFilter.budgetFriendly:
          filtered = filtered.where((restaurant) => restaurant.isBudgetFriendly).toList();
          break;
        case RestaurantFilter.topRated:
          filtered = filtered.where((restaurant) => restaurant.rating >= 4.0).toList();
          break;
        case RestaurantFilter.offers:
          filtered = filtered.where((restaurant) => restaurant.hasOffers).toList();
          break;
        case RestaurantFilter.all:
          // No filtering needed
          break;
      }
    }

    // Apply sorting
    switch (selectedSort.value) {
      case RestaurantSort.relevance:
        // Keep original order or sort by rating
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case RestaurantSort.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case RestaurantSort.deliveryTime:
        filtered.sort((a, b) => a.averageDeliveryMinutes.compareTo(b.averageDeliveryMinutes));
        break;
      case RestaurantSort.costLowToHigh:
        filtered.sort((a, b) {
          final aPrice = int.tryParse(a.priceRange.replaceAll('₹', '').split('-')[0]) ?? 0;
          final bPrice = int.tryParse(b.priceRange.replaceAll('₹', '').split('-')[0]) ?? 0;
          return aPrice.compareTo(bPrice);
        });
        break;
      case RestaurantSort.costHighToLow:
        filtered.sort((a, b) {
          final aPrice = int.tryParse(a.priceRange.replaceAll('₹', '').split('-')[1]) ?? 0;
          final bPrice = int.tryParse(b.priceRange.replaceAll('₹', '').split('-')[1]) ?? 0;
          return bPrice.compareTo(aPrice);
        });
        break;
    }

    filteredRestaurants.value = filtered;
  }

  /// Navigate to restaurant detail (shop detail)
  void navigateToRestaurant(String restaurantId) {
    debugPrint('[RestaurantListingController] Navigating to restaurant: $restaurantId');
    Get.toNamed('/shop-detail', parameters: {'shopId': restaurantId});
  }

  /// Navigate to search screen
  void navigateToSearch() {
    debugPrint('[RestaurantListingController] Navigating to search');
    Get.toNamed('/search');
  }

  /// Toggle favorite status
  void toggleFavorite(String restaurantId) {
    _restaurantService.toggleFavorite(restaurantId);
    
    // Update local state
    final index = restaurants.indexWhere((r) => r.id == restaurantId);
    if (index != -1) {
      restaurants[index] = restaurants[index].copyWith(
        isFavorite: !restaurants[index].isFavorite,
      );
    }
    
    // Reapply filters to update filtered list
    _applyFiltersAndSort();
    
    debugPrint('[RestaurantListingController] Toggled favorite for: $restaurantId');
  }

  /// Show filter bottom sheet
  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(context),
    );
  }

  /// Show sort bottom sheet
  void showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSortBottomSheet(context),
    );
  }

  /// Build filter bottom sheet
  Widget _buildFilterBottomSheet(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  clearFilters();
                  Navigator.pop(context);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...availableFilters.map((filter) => Obx(() => CheckboxListTile(
            title: Text(filter.displayName),
            value: selectedFilters.contains(filter),
            onChanged: (value) => toggleFilter(filter),
            controlAffinity: ListTileControlAffinity.leading,
          ))),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  /// Build sort bottom sheet
  Widget _buildSortBottomSheet(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...availableSorts.map((sort) => Obx(() => RadioListTile<RestaurantSort>(
            title: Text(sort.displayName),
            value: sort,
            groupValue: selectedSort.value,
            onChanged: (value) {
              if (value != null) {
                updateSort(value);
                Navigator.pop(context);
              }
            },
          ))),
        ],
      ),
    );
  }

  /// Get results count text
  String get resultsCountText {
    final count = filteredRestaurants.length;
    return '$count restaurants to explore';
  }
}
