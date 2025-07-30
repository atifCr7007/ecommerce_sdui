import 'package:flutter/foundation.dart';
import '../models/category.dart' as cat;
import 'api_service.dart';

/// Service class for handling category-related API operations.
/// 
/// This service provides methods for:
/// - Fetching all product categories
/// - Getting individual category details
/// - Fetching products within a category
/// - Managing category hierarchy
/// 
/// All methods return Future objects and handle errors appropriately.
class CategoryService {
  final ApiService _apiService;
  
  CategoryService({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  /// Fetches all product categories
  /// 
  /// Parameters:
  /// - [includeDescendants]: Whether to include child categories (default: true)
  /// - [useCache]: Whether to use cached results (default: true)
  Future<List<cat.ProductCategory>> fetchCategories({
    bool includeDescendants = true,
    bool useCache = true,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (includeDescendants) {
        queryParams['include_descendants_tree'] = 'true';
      }

      final response = await _apiService.get(
        '/store/product-categories',
        queryParams: queryParams,
        useCache: useCache,
      );

      final categoryResponse = cat.CategoryResponse.fromJson(response);
      return categoryResponse.productCategories;
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      throw CategoryServiceException('Failed to fetch categories: $e');
    }
  }

  /// Fetches a single category by its ID
  /// 
  /// Parameters:
  /// - [categoryId]: The unique identifier of the category
  /// - [includeDescendants]: Whether to include child categories
  /// - [useCache]: Whether to use cached results (default: true)
  Future<cat.ProductCategory> fetchCategoryById(
    String categoryId, {
    bool includeDescendants = true,
    bool useCache = true,
  }) async {
    try {
      if (categoryId.isEmpty) {
        throw CategoryServiceException('Category ID cannot be empty');
      }

      final queryParams = <String, String>{};
      
      if (includeDescendants) {
        queryParams['include_descendants_tree'] = 'true';
      }

      final response = await _apiService.get(
        '/store/product-categories/$categoryId',
        queryParams: queryParams,
        useCache: useCache,
      );

      final categoryData = response['product_category'];
      if (categoryData == null) {
        throw CategoryServiceException('Category not found');
      }

      return cat.ProductCategory.fromJson(categoryData);
    } catch (e) {
      debugPrint('Error fetching category $categoryId: $e');
      throw CategoryServiceException('Failed to fetch category: $e');
    }
  }

  /// Fetches the top-level (root) categories
  /// 
  /// Parameters:
  /// - [useCache]: Whether to use cached results (default: true)
  Future<List<cat.ProductCategory>> fetchRootCategories({
    bool useCache = true,
  }) async {
    try {
      final allCategories = await fetchCategories(
        includeDescendants: false,
        useCache: useCache,
      );
      
      // Filter for root categories (those without a parent)
      return allCategories.where((category) => 
        category.parentCategoryId == null || category.parentCategoryId!.isEmpty
      ).toList();
    } catch (e) {
      debugPrint('Error fetching root categories: $e');
      throw CategoryServiceException('Failed to fetch root categories: $e');
    }
  }

  /// Fetches child categories for a given parent category
  /// 
  /// Parameters:
  /// - [parentCategoryId]: The ID of the parent category
  /// - [useCache]: Whether to use cached results (default: true)
  Future<List<cat.ProductCategory>> fetchChildCategories(
    String parentCategoryId, {
    bool useCache = true,
  }) async {
    try {
      if (parentCategoryId.isEmpty) {
        throw CategoryServiceException('Parent category ID cannot be empty');
      }

      final allCategories = await fetchCategories(
        includeDescendants: true,
        useCache: useCache,
      );
      
      // Filter for categories that have the specified parent
      return allCategories.where((category) => 
        category.parentCategoryId == parentCategoryId
      ).toList();
    } catch (e) {
      debugPrint('Error fetching child categories: $e');
      throw CategoryServiceException('Failed to fetch child categories: $e');
    }
  }

  /// Searches for categories by name
  /// 
  /// Parameters:
  /// - [query]: The search query
  /// - [useCache]: Whether to use cached results (default: true)
  Future<List<cat.ProductCategory>> searchCategories(
    String query, {
    bool useCache = true,
  }) async {
    try {
      if (query.trim().isEmpty) {
        throw CategoryServiceException('Search query cannot be empty');
      }

      final allCategories = await fetchCategories(useCache: useCache);
      final searchTerm = query.trim().toLowerCase();
      
      // Filter categories by name or description
      return allCategories.where((category) {
        final nameMatch = category.name.toLowerCase().contains(searchTerm);
        final descriptionMatch = category.description?.toLowerCase().contains(searchTerm) ?? false;
        return nameMatch || descriptionMatch;
      }).toList();
    } catch (e) {
      debugPrint('Error searching categories: $e');
      throw CategoryServiceException('Failed to search categories: $e');
    }
  }

  /// Gets the category hierarchy path for a given category
  /// 
  /// Parameters:
  /// - [categoryId]: The category to get the path for
  /// - [useCache]: Whether to use cached results (default: true)
  /// 
  /// Returns a list of categories from root to the specified category
  Future<List<cat.ProductCategory>> getCategoryPath(
    String categoryId, {
    bool useCache = true,
  }) async {
    try {
      if (categoryId.isEmpty) {
        throw CategoryServiceException('Category ID cannot be empty');
      }

      final allCategories = await fetchCategories(useCache: useCache);
      final categoryMap = <String, cat.ProductCategory>{};
      
      // Create a map for quick lookup
      for (final category in allCategories) {
        categoryMap[category.id] = category;
      }
      
      final path = <cat.ProductCategory>[];
      String? currentId = categoryId;
      
      // Build path from child to root
      while (currentId != null && categoryMap.containsKey(currentId)) {
        final category = categoryMap[currentId]!;
        path.insert(0, category); // Insert at beginning to build root-to-child path
        currentId = category.parentCategoryId;
      }
      
      return path;
    } catch (e) {
      debugPrint('Error getting category path: $e');
      throw CategoryServiceException('Failed to get category path: $e');
    }
  }

  /// Gets category statistics (product count, etc.)
  /// 
  /// Parameters:
  /// - [categoryId]: The category to get statistics for
  /// - [useCache]: Whether to use cached results (default: true)
  Future<CategoryStats> getCategoryStats(
    String categoryId, {
    bool useCache = true,
  }) async {
    try {
      if (categoryId.isEmpty) {
        throw CategoryServiceException('Category ID cannot be empty');
      }

      // In a real implementation, this might be a dedicated endpoint
      // For now, we'll simulate by counting products in the category
      final response = await _apiService.get(
        '/store/products',
        queryParams: {
          'category_id[]': categoryId,
          'limit': '1', // We only need the count
        },
        useCache: useCache,
      );

      final productCount = response['count'] as int? ?? 0;
      
      return CategoryStats(
        categoryId: categoryId,
        productCount: productCount,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error getting category stats: $e');
      throw CategoryServiceException('Failed to get category stats: $e');
    }
  }

  /// Clears the category service cache
  void clearCache() {
    _apiService.clearCache();
  }

  /// Disposes the service and cleans up resources
  void dispose() {
    _apiService.dispose();
  }
}

/// Model for category statistics
class CategoryStats {
  final String categoryId;
  final int productCount;
  final DateTime lastUpdated;

  CategoryStats({
    required this.categoryId,
    required this.productCount,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'productCount': productCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory CategoryStats.fromJson(Map<String, dynamic> json) {
    return CategoryStats(
      categoryId: json['categoryId'] as String,
      productCount: json['productCount'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

/// Custom exception class for category service errors
class CategoryServiceException implements Exception {
  final String message;

  const CategoryServiceException(this.message);

  @override
  String toString() => 'CategoryServiceException: $message';
}
