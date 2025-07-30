import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'api_service.dart';

/// Service class for handling product-related API operations.
/// 
/// This service provides methods for:
/// - Fetching products with filtering and pagination
/// - Getting individual product details
/// - Searching products
/// - Managing product favorites
/// 
/// All methods return Future objects and handle errors appropriately.
class ProductService {
  final ApiService _apiService;
  
  ProductService({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  /// Fetches a list of products with optional filtering and pagination
  /// 
  /// Parameters:
  /// - [limit]: Maximum number of products to return (default: 20)
  /// - [offset]: Number of products to skip for pagination (default: 0)
  /// - [categoryId]: Filter products by category ID
  /// - [searchQuery]: Search products by title or description
  /// - [sortBy]: Sort products by field (title, price, created_at)
  /// - [sortOrder]: Sort order (asc, desc)
  /// - [useCache]: Whether to use cached results (default: true)
  Future<ProductListResponse> fetchProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? searchQuery,
    String? sortBy,
    String? sortOrder,
    bool useCache = true,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      // Add optional filters
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['category_id[]'] = categoryId;
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        String orderParam = sortBy;
        if (sortOrder == 'desc') {
          orderParam = '-$sortBy';
        }
        queryParams['order'] = orderParam;
      }

      final response = await _apiService.get(
        '/store/products',
        queryParams: queryParams,
        useCache: useCache,
      );

      return ProductListResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching products: $e');
      throw ProductServiceException('Failed to fetch products: $e');
    }
  }

  /// Fetches a single product by its ID
  /// 
  /// Parameters:
  /// - [productId]: The unique identifier of the product
  /// - [useCache]: Whether to use cached results (default: true)
  Future<Product> fetchProductById(
    String productId, {
    bool useCache = true,
  }) async {
    try {
      if (productId.isEmpty) {
        throw ProductServiceException('Product ID cannot be empty');
      }

      final response = await _apiService.get(
        '/store/products/$productId',
        useCache: useCache,
      );

      final productData = response['product'];
      if (productData == null) {
        throw ProductServiceException('Product not found');
      }

      return Product.fromJson(productData);
    } catch (e) {
      debugPrint('Error fetching product $productId: $e');
      throw ProductServiceException('Failed to fetch product: $e');
    }
  }

  /// Searches for products based on a query string
  /// 
  /// Parameters:
  /// - [query]: The search query
  /// - [limit]: Maximum number of results (default: 20)
  /// - [categoryId]: Optional category filter
  /// - [sortBy]: Sort results by field
  /// - [sortOrder]: Sort order (asc, desc)
  Future<ProductListResponse> searchProducts(
    String query, {
    int limit = 20,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      if (query.trim().isEmpty) {
        throw ProductServiceException('Search query cannot be empty');
      }

      return await fetchProducts(
        limit: limit,
        searchQuery: query.trim(),
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
        useCache: false, // Don't cache search results
      );
    } catch (e) {
      debugPrint('Error searching products: $e');
      throw ProductServiceException('Failed to search products: $e');
    }
  }

  /// Fetches related products for a given product
  /// 
  /// Parameters:
  /// - [productId]: The product to find related items for
  /// - [limit]: Maximum number of related products (default: 5)
  Future<List<Product>> fetchRelatedProducts(
    String productId, {
    int limit = 5,
  }) async {
    try {
      // For now, we'll fetch products from the same category
      // In a real implementation, this might use ML recommendations
      final product = await fetchProductById(productId);
      
      if (product.categories != null && product.categories!.isNotEmpty) {
        final categoryId = product.categories!.first.id;
        final response = await fetchProducts(
          limit: limit + 1, // Get one extra to exclude the current product
          categoryId: categoryId,
          useCache: true,
        );
        
        // Filter out the current product
        final relatedProducts = response.products
            .where((p) => p.id != productId)
            .take(limit)
            .toList();
            
        return relatedProducts;
      }
      
      // Fallback: return recent products
      final response = await fetchProducts(
        limit: limit,
        sortBy: 'created_at',
        sortOrder: 'desc',
      );
      
      return response.products.where((p) => p.id != productId).take(limit).toList();
    } catch (e) {
      debugPrint('Error fetching related products: $e');
      throw ProductServiceException('Failed to fetch related products: $e');
    }
  }

  /// Fetches featured products
  /// 
  /// Parameters:
  /// - [limit]: Maximum number of featured products (default: 10)
  Future<List<Product>> fetchFeaturedProducts({int limit = 10}) async {
    try {
      final response = await fetchProducts(
        limit: limit,
        sortBy: 'created_at',
        sortOrder: 'desc',
        useCache: true,
      );
      
      return response.products;
    } catch (e) {
      debugPrint('Error fetching featured products: $e');
      throw ProductServiceException('Failed to fetch featured products: $e');
    }
  }

  /// Toggles the favorite status of a product
  /// 
  /// Note: This is a placeholder implementation. In a real app,
  /// this would sync with user preferences on the backend.
  /// 
  /// Parameters:
  /// - [productId]: The product to toggle favorite status for
  /// - [isFavorite]: The new favorite status
  Future<bool> toggleProductFavorite(String productId, bool isFavorite) async {
    try {
      // In a real implementation, this would make an API call to save the preference
      // For now, we'll just simulate the operation
      await Future.delayed(const Duration(milliseconds: 500));
      
      debugPrint('Product $productId favorite status: $isFavorite');
      return isFavorite;
    } catch (e) {
      debugPrint('Error toggling product favorite: $e');
      throw ProductServiceException('Failed to update favorite status: $e');
    }
  }

  /// Clears the product service cache
  void clearCache() {
    _apiService.clearCache();
  }

  /// Disposes the service and cleans up resources
  void dispose() {
    _apiService.dispose();
  }
}

/// Response model for product list API calls
class ProductListResponse {
  final List<Product> products;
  final int count;
  final int offset;
  final int limit;

  ProductListResponse({
    required this.products,
    required this.count,
    required this.offset,
    required this.limit,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final productList = json['products'] as List<dynamic>? ?? [];
    
    return ProductListResponse(
      products: productList.map((productJson) => Product.fromJson(productJson)).toList(),
      count: json['count'] as int? ?? productList.length,
      offset: json['offset'] as int? ?? 0,
      limit: json['limit'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Custom exception class for product service errors
class ProductServiceException implements Exception {
  final String message;

  const ProductServiceException(this.message);

  @override
  String toString() => 'ProductServiceException: $message';
}
