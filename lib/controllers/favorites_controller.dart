import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/favorites_service.dart';
import '../models/product.dart';

class FavoritesController extends GetxController {
  // Services
  late final FavoritesService _favoritesService;

  // State variables - GetX observables
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final RxList<Product> favorites = <Product>[].obs;
  final RxMap<String, bool> favoriteStatus = <String, bool>{}.obs;

  // Getters
  int get favoritesCount => favorites.length;
  bool get hasFavorites => favorites.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
    loadFavorites();
  }

  void _initializeService() {
    _favoritesService = FavoritesService();
  }

  /// Loads all favorite products
  Future<void> loadFavorites() async {
    try {
      if (kDebugMode) {
        debugPrint('[FavoritesController] Loading favorites...');
      }

      isLoading.value = true;
      error.value = null;

      final favoriteProducts = await _favoritesService.getFavorites();
      favorites.value = favoriteProducts;

      // Update favorite status map
      favoriteStatus.clear();
      for (final product in favoriteProducts) {
        favoriteStatus[product.id] = true;
      }

      if (kDebugMode) {
        debugPrint(
          '[FavoritesController] Loaded ${favoriteProducts.length} favorites',
        );
      }
    } catch (e) {
      error.value = 'Failed to load favorites: $e';
      if (kDebugMode) {
        debugPrint('[FavoritesController] Error loading favorites: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds a product to favorites
  ///
  /// Parameters:
  /// - [product]: The product to add to favorites
  ///
  /// Returns: true if successfully added
  Future<bool> addToFavorites(Product product) async {
    try {
      final success = await _favoritesService.addToFavorites(product);

      if (success) {
        favorites.add(product);
        favoriteStatus[product.id] = true;

        Get.snackbar(
          'Added to Favorites',
          '${product.title} has been added to your favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      error.value = 'Failed to add to favorites: $e';
      debugPrint('Error adding to favorites: $e');

      Get.snackbar(
        'Error',
        'Failed to add item to favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      return false;
    }
  }

  /// Removes a product from favorites
  ///
  /// Parameters:
  /// - [productId]: The ID of the product to remove
  ///
  /// Returns: true if successfully removed
  Future<bool> removeFromFavorites(String productId) async {
    try {
      final success = await _favoritesService.removeFromFavorites(productId);

      if (success) {
        favorites.removeWhere((product) => product.id == productId);
        favoriteStatus[productId] = false;

        Get.snackbar(
          'Removed from Favorites',
          'Item has been removed from your favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      error.value = 'Failed to remove from favorites: $e';
      debugPrint('Error removing from favorites: $e');

      Get.snackbar(
        'Error',
        'Failed to remove item from favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      return false;
    }
  }

  /// Toggles favorite status of a product
  ///
  /// Parameters:
  /// - [product]: The product to toggle
  ///
  /// Returns: true if product is now favorited, false if removed
  Future<bool> toggleFavorite(Product product) async {
    try {
      final newStatus = await _favoritesService.toggleFavorite(product);

      if (newStatus) {
        // Product was added to favorites
        if (!favorites.any((fav) => fav.id == product.id)) {
          favorites.add(product);
        }
        favoriteStatus[product.id] = true;

        Get.snackbar(
          'Added to Favorites',
          '${product.title} has been added to your favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Product was removed from favorites
        favorites.removeWhere((fav) => fav.id == product.id);
        favoriteStatus[product.id] = false;

        Get.snackbar(
          'Removed from Favorites',
          '${product.title} has been removed from your favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return newStatus;
    } catch (e) {
      error.value = 'Failed to toggle favorite: $e';
      debugPrint('Error toggling favorite: $e');

      Get.snackbar(
        'Error',
        'Failed to update favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      return favoriteStatus[product.id] ?? false;
    }
  }

  /// Checks if a product is favorited
  ///
  /// Parameters:
  /// - [productId]: The ID of the product to check
  ///
  /// Returns: true if product is favorited
  bool isFavorite(String productId) {
    return favoriteStatus[productId] ?? false;
  }

  /// Loads favorite status for a specific product
  ///
  /// Parameters:
  /// - [productId]: The ID of the product to check
  Future<void> loadFavoriteStatus(String productId) async {
    try {
      final isFav = await _favoritesService.isFavorite(productId);
      favoriteStatus[productId] = isFav;
    } catch (e) {
      debugPrint('Error loading favorite status for $productId: $e');
      favoriteStatus[productId] = false;
    }
  }

  /// Clears all favorites
  Future<void> clearAllFavorites() async {
    try {
      isLoading.value = true;

      final success = await _favoritesService.clearFavorites();

      if (success) {
        favorites.clear();
        favoriteStatus.clear();

        Get.snackbar(
          'Favorites Cleared',
          'All favorites have been removed',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      error.value = 'Failed to clear favorites: $e';
      debugPrint('Error clearing favorites: $e');

      Get.snackbar(
        'Error',
        'Failed to clear favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes the favorites list
  @override
  Future<void> refresh() async {
    if (kDebugMode) {
      debugPrint('[FavoritesController] Refreshing favorites...');
    }
    await loadFavorites();
  }

  /// Searches favorites by query
  ///
  /// Parameters:
  /// - [query]: Search query
  ///
  /// Returns: List of matching favorite products
  List<Product> searchFavorites(String query) {
    if (query.isEmpty) return favorites;

    final lowerQuery = query.toLowerCase();
    return favorites.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          (product.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          (product.categories?.any(
                (cat) => cat.name.toLowerCase().contains(lowerQuery),
              ) ??
              false);
    }).toList();
  }

  /// Gets favorites by category
  ///
  /// Parameters:
  /// - [categoryId]: The category ID to filter by
  ///
  /// Returns: List of favorite products in the category
  List<Product> getFavoritesByCategory(String categoryId) {
    return favorites.where((product) {
      return product.categories?.any((cat) => cat.id == categoryId) ?? false;
    }).toList();
  }
}
