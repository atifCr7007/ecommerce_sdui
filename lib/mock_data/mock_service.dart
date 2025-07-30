import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:ecommerce_sdui/models/product.dart';
import 'package:ecommerce_sdui/models/category.dart' as cat;
import 'package:ecommerce_sdui/services/cart_service.dart';

/// Mock data service that provides realistic data matching Medusa API structure.
///
/// This service is designed to:
/// - Provide consistent, realistic mock data for development and testing
/// - Match the exact structure of Medusa Commerce API responses
/// - Support all the same operations as the real API services
/// - Enable seamless switching between mock and real data
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final Random _random = Random();
  List<Product>? _cachedProducts;
  List<cat.ProductCategory>? _cachedCategories;
  final Map<String, Cart> _carts = {};

  /// Loads mock products from JSON file
  Future<List<Product>> getProducts({
    int? limit,
    int? offset,
    String? categoryId,
    String? searchQuery,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      if (_cachedProducts == null) {
        await _loadMockProducts();
      }

      var products = List<Product>.from(_cachedProducts!);

      // Apply category filter
      if (categoryId != null && categoryId.isNotEmpty) {
        products = products.where((product) {
          return product.categories?.any((cat) => cat.id == categoryId) ??
              false;
        }).toList();
      }

      // Apply search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        products = products.where((product) {
          return product.title.toLowerCase().contains(query) ||
              (product.description?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      // Apply sorting
      if (sortBy != null) {
        products.sort((a, b) {
          int comparison = 0;

          switch (sortBy) {
            case 'title':
              comparison = a.title.compareTo(b.title);
              break;
            case 'price':
            case 'variants.prices.amount':
              final priceA = a.variants?.first.prices?.first.amount ?? 0;
              final priceB = b.variants?.first.prices?.first.amount ?? 0;
              comparison = priceA.compareTo(priceB);
              break;
            case 'created_at':
              // For mock data, we'll use a random order
              comparison = _random.nextBool() ? 1 : -1;
              break;
            default:
              comparison = 0;
          }

          return sortOrder == 'desc' || sortBy.startsWith('-')
              ? -comparison
              : comparison;
        });
      }

      // Apply pagination
      final startIndex = offset ?? 0;
      final endIndex = limit != null ? startIndex + limit : products.length;

      if (startIndex >= products.length) {
        return [];
      }

      return products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );
    } catch (e) {
      debugPrint('Error loading mock products: $e');
      return _generateFallbackProducts(limit ?? 20);
    }
  }

  /// Gets a single product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      if (_cachedProducts == null) {
        await _loadMockProducts();
      }

      return _cachedProducts!.firstWhere(
        (product) => product.id == productId,
        orElse: () => _generateSingleProduct(productId),
      );
    } catch (e) {
      debugPrint('Error getting product by ID: $e');
      return _generateSingleProduct(productId);
    }
  }

  /// Loads mock categories from JSON file
  Future<List<cat.ProductCategory>> getCategories() async {
    try {
      if (_cachedCategories == null) {
        await _loadMockCategories();
      }

      return List<cat.ProductCategory>.from(_cachedCategories!);
    } catch (e) {
      debugPrint('Error loading mock categories: $e');
      return _generateFallbackCategories();
    }
  }

  /// Gets a single category by ID
  Future<cat.ProductCategory?> getCategoryById(String categoryId) async {
    try {
      final categories = await getCategories();
      return categories.firstWhere(
        (category) => category.id == categoryId,
        orElse: () => _generateSingleCategory(categoryId),
      );
    } catch (e) {
      debugPrint('Error getting category by ID: $e');
      return _generateSingleCategory(categoryId);
    }
  }

  /// Simulates adding item to cart
  Future<CartResponse> addToCart(
    String productId,
    String variantId, {
    int quantity = 1,
    String? cartId,
  }) async {
    try {
      cartId ??= _generateCartId();

      final cart = _carts[cartId] ?? _createEmptyCart(cartId);
      final product = await getProductById(productId);

      if (product == null) {
        throw Exception('Product not found');
      }

      // Check if item already exists in cart
      final existingItemIndex = cart.items.indexWhere(
        (item) => item.variantId == variantId,
      );

      if (existingItemIndex >= 0) {
        // Update existing item quantity
        final existingItem = cart.items[existingItemIndex];
        final newQuantity = existingItem.quantity + quantity;
        final newTotal = existingItem.unitPrice * newQuantity;

        cart.items[existingItemIndex] = CartItem(
          id: existingItem.id,
          variantId: variantId,
          title: product.title,
          description: product.description,
          thumbnail: product.thumbnail,
          quantity: newQuantity,
          unitPrice: existingItem.unitPrice,
          total: newTotal,
        );
      } else {
        // Add new item
        final unitPrice = product.variants?.first.prices?.first.amount ?? 2000;
        final total = unitPrice * quantity;

        cart.items.add(
          CartItem(
            id: 'item_${DateTime.now().millisecondsSinceEpoch}',
            variantId: variantId,
            title: product.title,
            description: product.description,
            thumbnail: product.thumbnail,
            quantity: quantity,
            unitPrice: unitPrice,
            total: total,
          ),
        );
      }

      // Recalculate totals
      final subtotal = cart.items.fold(0, (sum, item) => sum + item.total);
      final updatedCart = Cart(
        id: cart.id,
        items: cart.items,
        subtotal: subtotal,
        total:
            subtotal, // In a real app, this would include taxes, shipping, etc.
        currencyCode: cart.currencyCode,
        createdAt: cart.createdAt,
        updatedAt: DateTime.now(),
      );

      _carts[cartId] = updatedCart;
      return CartResponse(cart: updatedCart);
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      throw Exception('Failed to add item to cart: $e');
    }
  }

  /// Simulates getting cart contents
  Future<CartResponse> getCart(String cartId) async {
    try {
      final cart = _carts[cartId] ?? _createEmptyCart(cartId);
      return CartResponse(cart: cart);
    } catch (e) {
      debugPrint('Error getting cart: $e');
      throw Exception('Failed to get cart: $e');
    }
  }

  /// Loads mock products from hardcoded data
  Future<void> _loadMockProducts() async {
    try {
      // For now, use hardcoded data instead of JSON files
      // This ensures the app works while we fix the asset loading
      _cachedProducts = _generateFallbackProducts(20);
      debugPrint('Loaded ${_cachedProducts!.length} mock products');
    } catch (e) {
      debugPrint('Failed to load mock products, generating fallback data: $e');
      _cachedProducts = _generateFallbackProducts(10);
    }
  }

  /// Loads mock categories from hardcoded data
  Future<void> _loadMockCategories() async {
    try {
      // For now, use hardcoded data instead of JSON files
      // This ensures the app works while we fix the asset loading
      _cachedCategories = _generateFallbackCategories();
      debugPrint('Loaded ${_cachedCategories!.length} mock categories');
    } catch (e) {
      debugPrint(
        'Failed to load mock categories, generating fallback data: $e',
      );
      _cachedCategories = _generateFallbackCategories();
    }
  }

  /// Gets real image URL based on category and product number
  String _getCategoryImageUrl(String category, int productNumber) {
    final categoryImages = {
      'Electronics': [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=300&h=300&fit=crop',
      ],
      'Clothing': [
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=300&h=300&fit=crop',
      ],
      'Books': [
        'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop',
      ],
      'Home & Garden': [
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=300&h=300&fit=crop',
      ],
      'Sports': [
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1593786481097-74fa64ee5b3c?w=300&h=300&fit=crop',
      ],
      'Beauty': [
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=300&h=300&fit=crop',
        'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=300&h=300&fit=crop',
      ],
    };

    final images = categoryImages[category] ?? categoryImages['Electronics']!;
    return images[productNumber.abs() % images.length];
  }

  /// Generates fallback products when JSON loading fails
  List<Product> _generateFallbackProducts(int count) {
    final categories = [
      'Electronics',
      'Clothing',
      'Books',
      'Home & Garden',
      'Sports',
      'Beauty',
      'Toys',
      'Automotive',
      'Health',
      'Food & Beverages',
    ];

    return List.generate(count, (index) {
      final categoryName = categories[index % categories.length];
      return _generateSingleProduct('fallback_product_$index', categoryName);
    });
  }

  /// Generates a single product
  Product _generateSingleProduct(String productId, [String? categoryName]) {
    final category = categoryName ?? 'General';
    final productNumber = productId.hashCode % 1000;

    // Map category names to IDs
    final categoryMap = {
      'Electronics': 'electronics',
      'Clothing': 'clothing',
      'Books': 'books',
      'Home & Garden': 'home',
      'Sports': 'sports',
      'Beauty': 'beauty',
      'Toys': 'toys',
      'Automotive': 'automotive',
      'Health': 'health',
      'Food & Beverages': 'food',
      'General': 'general',
    };

    final categoryId = categoryMap[category] ?? 'general';

    return Product(
      id: productId,
      title: '$category Product ${productNumber.abs()}',
      description:
          'High-quality $category product with excellent features and great value.',
      thumbnail: _getCategoryImageUrl(category, productNumber),
      images: [
        ProductImage(
          id: '${productId}_img_1',
          url: _getCategoryImageUrl(category, productNumber),
        ),
      ],
      variants: [
        ProductVariant(
          id: '${productId}_variant_1',
          title: 'Default Variant',
          prices: [
            ProductVariantPrice(
              id: '${productId}_price_1',
              currencyCode: 'INR',
              amount:
                  99900 + (productNumber.abs() % 500000), // ₹999 to ₹5999 range
            ),
          ],
        ),
      ],
      categories: [
        ProductCategory(
          id: categoryId,
          name: category,
          description: '$category products and accessories',
        ),
      ],
    );
  }

  /// Generates fallback categories
  List<cat.ProductCategory> _generateFallbackCategories() {
    final categoryData = [
      {
        'id': 'electronics',
        'name': 'Electronics',
        'description': 'Electronic devices and gadgets',
      },
      {
        'id': 'clothing',
        'name': 'Clothing & Fashion',
        'description': 'Apparel and fashion accessories',
      },
      {
        'id': 'books',
        'name': 'Books & Media',
        'description': 'Books, magazines, and media content',
      },
      {
        'id': 'home',
        'name': 'Home & Garden',
        'description': 'Home improvement and garden supplies',
      },
      {
        'id': 'sports',
        'name': 'Sports & Outdoors',
        'description': 'Sports equipment and outdoor gear',
      },
    ];

    return categoryData
        .map(
          (data) => cat.ProductCategory(
            id: data['id']!,
            name: data['name']!,
            description: data['description']!,
            isActive: true,
            isInternal: false,
            rank: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        )
        .toList();
  }

  /// Generates a single category
  cat.ProductCategory _generateSingleCategory(String categoryId) {
    return cat.ProductCategory(
      id: categoryId,
      name: 'Category ${categoryId.hashCode % 100}',
      description: 'Generated category for $categoryId',
      isActive: true,
      isInternal: false,
      rank: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Creates an empty cart
  Cart _createEmptyCart(String cartId) {
    return Cart(
      id: cartId,
      items: [],
      subtotal: 0,
      total: 0,
      currencyCode: 'USD',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Generates a unique cart ID
  String _generateCartId() {
    return 'cart_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
  }

  /// Clears all cached data
  void clearCache() {
    _cachedProducts = null;
    _cachedCategories = null;
    _carts.clear();
  }
}
