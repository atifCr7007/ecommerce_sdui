import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/models/shop.dart';
import 'package:ecommerce_sdui/mock_data/mock_service.dart';
import 'package:ecommerce_sdui/config/app_config.dart';

class MarketplaceController extends GetxController {
  final MockDataService _mockDataService = MockDataService();

  // Observable state
  final isLoading = false.obs;
  final error = RxnString();
  final shops = <Shop>[].obs;
  final selectedShop = Rxn<ShopWithProducts>();
  final searchQuery = ''.obs;
  final selectedCategory = Rxn<ShopCategory>();

  // Filtered shops based on search and category
  List<Shop> get filteredShops {
    var filtered = shops.toList();

    // Filter by category
    if (selectedCategory.value != null) {
      filtered = filtered
          .where(
            (shop) =>
                shop.category.toLowerCase() ==
                selectedCategory.value!.name.toLowerCase(),
          )
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered
          .where(
            (shop) =>
                shop.name.toLowerCase().contains(query) ||
                shop.description.toLowerCase().contains(query) ||
                shop.category.toLowerCase().contains(query),
          )
          .toList();
    }

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    // Use Future.delayed to avoid setState during build
    Future.delayed(Duration.zero, () {
      loadMarketplace();
    });
  }

  /// Load all shops in marketplace
  Future<void> loadMarketplace() async {
    try {
      isLoading.value = true;
      error.value = null;

      debugPrint('[MarketplaceController] Loading marketplace...');

      if (AppConfig.useMockData) {
        final response = await _mockDataService.getMarketplace();
        shops.value = response.shops;
        debugPrint(
          '[MarketplaceController] Loaded ${response.shops.length} shops',
        );
      } else {
        // TODO: Implement real API call
        shops.value = [];
      }
    } catch (e) {
      error.value = 'Failed to load marketplace: $e';
      debugPrint('[MarketplaceController] Error loading marketplace: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load specific shop with products
  Future<void> loadShop(String shopId) async {
    try {
      isLoading.value = true;
      error.value = null;

      debugPrint('[MarketplaceController] Loading shop: $shopId');

      if (AppConfig.useMockData) {
        final response = await _mockDataService.getShop(shopId);
        selectedShop.value = response.shopWithProducts;
        debugPrint(
          '[MarketplaceController] Loaded shop: ${response.shopWithProducts.shop.name}',
        );
        debugPrint(
          '[MarketplaceController] Shop has ${response.shopWithProducts.products.length} products',
        );
      } else {
        // TODO: Implement real API call
        selectedShop.value = null;
      }
    } catch (e) {
      error.value = 'Failed to load shop: $e';
      debugPrint('[MarketplaceController] Error loading shop: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search shops
  void searchShops(String query) {
    searchQuery.value = query;
    debugPrint('[MarketplaceController] Searching shops with query: $query');
  }

  /// Filter by category
  void filterByCategory(ShopCategory? category) {
    selectedCategory.value = category;
    debugPrint(
      '[MarketplaceController] Filtering by category: ${category?.displayName ?? 'All'}',
    );
  }

  /// Clear filters
  void clearFilters() {
    searchQuery.value = '';
    selectedCategory.value = null;
    debugPrint('[MarketplaceController] Cleared all filters');
  }

  /// Refresh marketplace
  Future<void> refreshMarketplace() async {
    await loadMarketplace();
  }

  /// Navigate to shop - redirects to home view with shop context
  void navigateToShop(String shopId) {
    debugPrint('[MarketplaceController] Navigating to home view with shop: $shopId');
    // Navigate to home view and pass the shop ID as a parameter
    Get.toNamed('/home', parameters: {'shopId': shopId});
  }

  /// Get shops by category
  List<Shop> getShopsByCategory(ShopCategory category) {
    return shops
        .where(
          (shop) => shop.category.toLowerCase() == category.name.toLowerCase(),
        )
        .toList();
  }

  /// Get featured shops (top rated)
  List<Shop> getFeaturedShops({int limit = 5}) {
    final sortedShops = shops.toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sortedShops.take(limit).toList();
  }

  /// Get shop statistics
  Map<String, dynamic> getMarketplaceStatistics() {
    final totalShops = shops.length;
    final activeShops = shops.where((shop) => shop.isActive).length;
    final verifiedShops = shops.where((shop) => shop.isVerified).length;
    final averageRating = shops.isEmpty
        ? 0.0
        : shops.fold(0.0, (sum, shop) => sum + shop.rating) / shops.length;

    // Group by category
    final categoryStats = <String, int>{};
    for (final shop in shops) {
      categoryStats[shop.category] = (categoryStats[shop.category] ?? 0) + 1;
    }

    return {
      'total_shops': totalShops,
      'active_shops': activeShops,
      'verified_shops': verifiedShops,
      'average_rating': averageRating,
      'category_stats': categoryStats,
    };
  }

  /// Get category display name
  String getCategoryDisplayName(String category) {
    try {
      final shopCategory = ShopCategory.values.firstWhere(
        (cat) => cat.name.toLowerCase() == category.toLowerCase(),
      );
      return shopCategory.displayName;
    } catch (e) {
      return category
          .replaceAll('_', ' ')
          .split(' ')
          .map(
            (word) =>
                word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
          )
          .join(' ');
    }
  }

  /// Get category icon
  String getCategoryIcon(String category) {
    try {
      final shopCategory = ShopCategory.values.firstWhere(
        (cat) => cat.name.toLowerCase() == category.toLowerCase(),
      );
      return shopCategory.icon;
    } catch (e) {
      return '🏪'; // Default shop icon
    }
  }

  /// Check if shop is favorited (placeholder for future implementation)
  bool isShopFavorited(String shopId) {
    // TODO: Implement shop favorites functionality
    return false;
  }

  /// Toggle shop favorite (placeholder for future implementation)
  Future<void> toggleShopFavorite(String shopId) async {
    // TODO: Implement shop favorites functionality
    debugPrint('[MarketplaceController] Toggle favorite for shop: $shopId');
  }
}
