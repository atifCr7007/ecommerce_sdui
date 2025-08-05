import 'package:flutter/foundation.dart';
import '../models/unified_models.dart';
import 'mock_api_service.dart';

/// Kong API Gateway Service - Abstraction layer for API operations
/// Provides seamless switching between mock and real API modes
/// 
/// Usage:
/// - Set `useMockMode = true` for development with mock data
/// - Set `useMockMode = false` for production with real Kong API
class KongService {
  static final KongService _instance = KongService._internal();
  factory KongService() => _instance;
  KongService._internal();

  // Configuration flag - change this to switch between mock and real API
  static const bool useMockMode = true; // Set to false for production

  final MockApiService _mockApiService = MockApiService();
  
  // Real API configuration (for production)
  static const String _baseUrl = 'https://your-kong-gateway.com/api/v1';
  static const String _apiKey = 'your-api-key';

  /// Get all shops
  Future<List<ShopModel>> getShops() async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getShops()');
      return await _mockApiService.getShops();
    } else {
      debugPrint('[KongService] Using real API for getShops()');
      return await _getShopsFromApi();
    }
  }

  /// Get shop by ID
  Future<ShopModel?> getShopById(String shopId) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getShopById($shopId)');
      return await _mockApiService.getShopById(shopId);
    } else {
      debugPrint('[KongService] Using real API for getShopById($shopId)');
      return await _getShopByIdFromApi(shopId);
    }
  }

  /// Get shops by category
  Future<List<ShopModel>> getShopsByCategory(String category) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getShopsByCategory($category)');
      return await _mockApiService.getShopsByCategory(category);
    } else {
      debugPrint('[KongService] Using real API for getShopsByCategory($category)');
      return await _getShopsByCategoryFromApi(category);
    }
  }

  /// Get top rated shops
  Future<List<ShopModel>> getTopRatedShops({int limit = 5}) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getTopRatedShops(limit: $limit)');
      return await _mockApiService.getTopRatedShops(limit: limit);
    } else {
      debugPrint('[KongService] Using real API for getTopRatedShops(limit: $limit)');
      return await _getTopRatedShopsFromApi(limit);
    }
  }

  /// Get featured shops (in the spotlight)
  Future<List<ShopModel>> getFeaturedShops({int limit = 6}) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getFeaturedShops(limit: $limit)');
      return await _mockApiService.getFeaturedShops(limit: limit);
    } else {
      debugPrint('[KongService] Using real API for getFeaturedShops(limit: $limit)');
      return await _getFeaturedShopsFromApi(limit);
    }
  }

  /// Get products for a specific shop
  Future<List<ProductModel>> getProducts(String shopId) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getProducts($shopId)');
      return await _mockApiService.getProducts(shopId);
    } else {
      debugPrint('[KongService] Using real API for getProducts($shopId)');
      return await _getProductsFromApi(shopId);
    }
  }

  /// Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getProductById($productId)');
      return await _mockApiService.getProductById(productId);
    } else {
      debugPrint('[KongService] Using real API for getProductById($productId)');
      return await _getProductByIdFromApi(productId);
    }
  }

  /// Get products by category for category navigation
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getProductsByCategory($category)');
      return await _mockApiService.getProductsByCategory(category);
    } else {
      debugPrint('[KongService] Using real API for getProductsByCategory($category)');
      return await _getProductsByCategoryFromApi(category);
    }
  }

  /// Get promotional offers
  Future<List<OfferModel>> getOffers() async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getOffers()');
      return await _mockApiService.getOffers();
    } else {
      debugPrint('[KongService] Using real API for getOffers()');
      return await _getOffersFromApi();
    }
  }

  /// Get cart data
  Future<CartModel> getCart(String cartId) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for getCart($cartId)');
      return await _mockApiService.getCart(cartId);
    } else {
      debugPrint('[KongService] Using real API for getCart($cartId)');
      return await _getCartFromApi(cartId);
    }
  }

  /// Add item to cart
  Future<CartModel> addToCart(String productId, int quantity, String cartId) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for addToCart($productId, $quantity, $cartId)');
      return await _mockApiService.addToCart(productId, quantity, cartId);
    } else {
      debugPrint('[KongService] Using real API for addToCart($productId, $quantity, $cartId)');
      return await _addToCartApi(productId, quantity, cartId);
    }
  }

  /// Remove item from cart
  Future<CartModel> removeFromCart(String productId, String cartId) async {
    if (useMockMode) {
      debugPrint('[KongService] Using mock data for removeFromCart($productId, $cartId)');
      return await _mockApiService.removeFromCart(productId, cartId);
    } else {
      debugPrint('[KongService] Using real API for removeFromCart($productId, $cartId)');
      return await _removeFromCartApi(productId, cartId);
    }
  }

  // Real API methods (implement these when connecting to actual Kong API)
  
  Future<List<ShopModel>> _getShopsFromApi() async {
    // TODO: Implement real API call to Kong gateway
    // Example:
    // final response = await http.get(
    //   Uri.parse('$_baseUrl/shops'),
    //   headers: {'Authorization': 'Bearer $_apiKey'},
    // );
    // return parseShopsFromResponse(response);
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<ShopModel?> _getShopByIdFromApi(String shopId) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<ShopModel>> _getShopsByCategoryFromApi(String category) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<ShopModel>> _getTopRatedShopsFromApi(int limit) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<ShopModel>> _getFeaturedShopsFromApi(int limit) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<ProductModel>> _getProductsFromApi(String shopId) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<ProductModel?> _getProductByIdFromApi(String productId) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<ProductModel>> _getProductsByCategoryFromApi(String category) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<OfferModel>> _getOffersFromApi() async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<CartModel> _getCartFromApi(String cartId) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<CartModel> _addToCartApi(String productId, int quantity, String cartId) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<CartModel> _removeFromCartApi(String productId, String cartId) async {
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  /// Clear cache (useful for development)
  void clearCache() {
    if (useMockMode) {
      _mockApiService.clearCache();
    }
    // For real API, you might want to clear any local caches
  }
}
