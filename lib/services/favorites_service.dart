import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

/// Service class for handling favorites/bookmarks functionality.
/// 
/// This service provides methods for:
/// - Adding products to favorites
/// - Removing products from favorites
/// - Getting all favorite products
/// - Checking if a product is favorited
/// - Persisting favorites to local storage
class FavoritesService {
  static const String _favoritesKey = 'user_favorites';
  
  /// Adds a product to favorites
  /// 
  /// Parameters:
  /// - [product]: The product to add to favorites
  /// 
  /// Returns: true if successfully added, false if already exists
  Future<bool> addToFavorites(Product product) async {
    try {
      final favorites = await getFavorites();
      
      // Check if product is already in favorites
      final isAlreadyFavorite = favorites.any((fav) => fav.id == product.id);
      if (isAlreadyFavorite) {
        return false;
      }
      
      favorites.add(product);
      await _saveFavorites(favorites);
      
      debugPrint('Added ${product.title} to favorites');
      return true;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      throw FavoritesServiceException('Failed to add product to favorites: $e');
    }
  }
  
  /// Removes a product from favorites
  /// 
  /// Parameters:
  /// - [productId]: The ID of the product to remove
  /// 
  /// Returns: true if successfully removed, false if not found
  Future<bool> removeFromFavorites(String productId) async {
    try {
      final favorites = await getFavorites();
      final initialLength = favorites.length;
      
      favorites.removeWhere((product) => product.id == productId);
      
      if (favorites.length < initialLength) {
        await _saveFavorites(favorites);
        debugPrint('Removed product $productId from favorites');
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      throw FavoritesServiceException('Failed to remove product from favorites: $e');
    }
  }
  
  /// Checks if a product is in favorites
  /// 
  /// Parameters:
  /// - [productId]: The ID of the product to check
  /// 
  /// Returns: true if product is favorited, false otherwise
  Future<bool> isFavorite(String productId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((product) => product.id == productId);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }
  
  /// Gets all favorite products
  /// 
  /// Returns: List of favorite products
  Future<List<Product>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      final favorites = favoritesJson
          .map((jsonString) {
            try {
              final json = jsonDecode(jsonString) as Map<String, dynamic>;
              return Product.fromJson(json);
            } catch (e) {
              debugPrint('Error parsing favorite product: $e');
              return null;
            }
          })
          .where((product) => product != null)
          .cast<Product>()
          .toList();
      
      return favorites;
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
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
      final isCurrentlyFavorite = await isFavorite(product.id);
      
      if (isCurrentlyFavorite) {
        await removeFromFavorites(product.id);
        return false;
      } else {
        await addToFavorites(product);
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      throw FavoritesServiceException('Failed to toggle favorite status: $e');
    }
  }
  
  /// Gets the count of favorite products
  /// 
  /// Returns: Number of favorite products
  Future<int> getFavoritesCount() async {
    try {
      final favorites = await getFavorites();
      return favorites.length;
    } catch (e) {
      debugPrint('Error getting favorites count: $e');
      return 0;
    }
  }
  
  /// Clears all favorites
  /// 
  /// Returns: true if successfully cleared
  Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      debugPrint('Cleared all favorites');
      return true;
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
      throw FavoritesServiceException('Failed to clear favorites: $e');
    }
  }
  
  /// Saves favorites to local storage
  /// 
  /// Parameters:
  /// - [favorites]: List of favorite products to save
  Future<void> _saveFavorites(List<Product> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = favorites
          .map((product) => jsonEncode(product.toJson()))
          .toList();
      
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
      throw FavoritesServiceException('Failed to save favorites: $e');
    }
  }
  
  /// Imports favorites from a JSON string (for backup/restore)
  /// 
  /// Parameters:
  /// - [jsonString]: JSON string containing favorites data
  /// 
  /// Returns: true if successfully imported
  Future<bool> importFavorites(String jsonString) async {
    try {
      final json = jsonDecode(jsonString) as List<dynamic>;
      final products = json
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      
      await _saveFavorites(products);
      debugPrint('Imported ${products.length} favorites');
      return true;
    } catch (e) {
      debugPrint('Error importing favorites: $e');
      throw FavoritesServiceException('Failed to import favorites: $e');
    }
  }
  
  /// Exports favorites to a JSON string (for backup/restore)
  /// 
  /// Returns: JSON string containing favorites data
  Future<String> exportFavorites() async {
    try {
      final favorites = await getFavorites();
      final json = favorites.map((product) => product.toJson()).toList();
      return jsonEncode(json);
    } catch (e) {
      debugPrint('Error exporting favorites: $e');
      throw FavoritesServiceException('Failed to export favorites: $e');
    }
  }
}

/// Custom exception class for favorites service errors
class FavoritesServiceException implements Exception {
  final String message;
  
  const FavoritesServiceException(this.message);
  
  @override
  String toString() => 'FavoritesServiceException: $message';
}
