import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_sdui/models/product.dart';
import 'package:ecommerce_sdui/models/category.dart' as cat;
import 'package:ecommerce_sdui/models/checkout.dart';
import 'package:ecommerce_sdui/models/shop.dart';
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
  List<Shop>? _cachedShops;
  final Map<String, Cart> _carts = {};
  final Map<String, Order> _orders = {};
  final Map<String, List<Product>> _shopProducts = {};

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

      debugPrint(
        '[MockDataService] Adding to cart: productId=$productId, variantId=$variantId, quantity=$quantity',
      );
      debugPrint(
        '[MockDataService] Current cart items count: ${cart.items.length}',
      );

      // Check if item already exists in cart
      final existingItemIndex = cart.items.indexWhere(
        (item) => item.variantId == variantId,
      );

      debugPrint('[MockDataService] Existing item index: $existingItemIndex');

      if (existingItemIndex >= 0) {
        // Update existing item quantity
        final existingItem = cart.items[existingItemIndex];
        final newQuantity = existingItem.quantity + quantity;
        final newTotal = existingItem.unitPrice * newQuantity;

        debugPrint(
          '[MockDataService] Updating existing item: ${existingItem.title}, old quantity: ${existingItem.quantity}, new quantity: $newQuantity',
        );

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
        // Find the selected variant to get color and size
        final selectedVariant = product.variants?.firstWhere(
          (variant) => variant.id == variantId,
          orElse: () => product.variants!.first,
        );

        final unitPrice = selectedVariant?.prices?.first.amount ?? 2000;
        final total = unitPrice * quantity;

        debugPrint(
          '[MockDataService] Adding new item: ${product.title}, quantity: $quantity, unitPrice: $unitPrice, color: ${selectedVariant?.color}, size: ${selectedVariant?.size}',
        );

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
            color: selectedVariant?.color,
            size: selectedVariant?.size,
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

      debugPrint(
        '[MockDataService] Final cart state: ${updatedCart.items.length} items',
      );
      for (int i = 0; i < updatedCart.items.length; i++) {
        final item = updatedCart.items[i];
        debugPrint(
          '[MockDataService] Item $i: ${item.title} (variantId: ${item.variantId}, quantity: ${item.quantity})',
        );
      }

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

  /// Updates the quantity of an item in the cart
  Future<CartResponse> updateCartItemQuantity(
    String cartId,
    String itemId,
    int quantity,
  ) async {
    try {
      final cart = _carts[cartId] ?? _createEmptyCart(cartId);

      final itemIndex = cart.items.indexWhere((item) => item.id == itemId);
      if (itemIndex == -1) {
        throw Exception('Item not found in cart');
      }

      if (quantity <= 0) {
        // Remove item if quantity is 0 or negative
        return removeCartItem(cartId, itemId);
      }

      final item = cart.items[itemIndex];
      final newTotal = item.unitPrice * quantity;

      final updatedItem = CartItem(
        id: item.id,
        variantId: item.variantId,
        title: item.title,
        description: item.description,
        thumbnail: item.thumbnail,
        quantity: quantity,
        unitPrice: item.unitPrice,
        total: newTotal,
        color: item.color,
        size: item.size,
      );

      cart.items[itemIndex] = updatedItem;

      // Recalculate totals
      final subtotal = cart.items.fold(0, (sum, item) => sum + item.total);
      final updatedCart = Cart(
        id: cart.id,
        items: cart.items,
        subtotal: subtotal,
        total: subtotal,
        currencyCode: cart.currencyCode,
        createdAt: cart.createdAt,
        updatedAt: DateTime.now(),
      );

      _carts[cartId] = updatedCart;

      debugPrint(
        '[MockDataService] Updated item quantity: ${item.title}, new quantity: $quantity',
      );

      return CartResponse(cart: updatedCart);
    } catch (e) {
      debugPrint('Error updating cart item quantity: $e');
      throw Exception('Failed to update item quantity: $e');
    }
  }

  /// Removes an item from the cart
  Future<CartResponse> removeCartItem(String cartId, String itemId) async {
    try {
      final cart = _carts[cartId] ?? _createEmptyCart(cartId);

      final itemIndex = cart.items.indexWhere((item) => item.id == itemId);
      if (itemIndex == -1) {
        throw Exception('Item not found in cart');
      }

      final removedItem = cart.items[itemIndex];
      cart.items.removeAt(itemIndex);

      // Recalculate totals
      final subtotal = cart.items.fold(0, (sum, item) => sum + item.total);
      final updatedCart = Cart(
        id: cart.id,
        items: cart.items,
        subtotal: subtotal,
        total: subtotal,
        currencyCode: cart.currencyCode,
        createdAt: cart.createdAt,
        updatedAt: DateTime.now(),
      );

      _carts[cartId] = updatedCart;

      debugPrint(
        '[MockDataService] Removed item from cart: ${removedItem.title}',
      );

      return CartResponse(cart: updatedCart);
    } catch (e) {
      debugPrint('Error removing cart item: $e');
      throw Exception('Failed to remove item: $e');
    }
  }

  /// Loads mock products from JSON file
  Future<void> _loadMockProducts() async {
    try {
      // Try to load from JSON file first
      final String jsonString = await rootBundle.loadString(
        'lib/mock_data/products.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> productsJson = jsonData['products'] as List<dynamic>;

      _cachedProducts = productsJson
          .map(
            (productJson) =>
                Product.fromJson(productJson as Map<String, dynamic>),
          )
          .toList();

      debugPrint('Loaded ${_cachedProducts!.length} mock products from JSON');
    } catch (e) {
      debugPrint(
        'Failed to load mock products from JSON, generating fallback data: $e',
      );
      _cachedProducts = _generateFallbackProducts(20);
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
      variants: _generateVariantsForCategory(
        productId,
        category,
        productNumber,
      ),
      categories: [
        ProductCategory(
          id: categoryId,
          name: category,
          description: '$category products and accessories',
        ),
      ],
    );
  }

  /// Generates variants based on product category
  List<ProductVariant> _generateVariantsForCategory(
    String productId,
    String category,
    int productNumber,
  ) {
    final basePrice =
        99900 + (productNumber.abs() % 500000); // ₹999 to ₹5999 range

    switch (category.toLowerCase()) {
      case 'electronics':
        // Electronics: Color variants
        return [
          ProductVariant(
            id: '${productId}_variant_black',
            title: 'Black',
            color: 'Black',
            prices: [
              ProductVariantPrice(
                id: '${productId}_price_black',
                currencyCode: 'INR',
                amount: basePrice,
              ),
            ],
          ),
          ProductVariant(
            id: '${productId}_variant_white',
            title: 'White',
            color: 'White',
            prices: [
              ProductVariantPrice(
                id: '${productId}_price_white',
                currencyCode: 'INR',
                amount: basePrice,
              ),
            ],
          ),
          ProductVariant(
            id: '${productId}_variant_silver',
            title: 'Silver',
            color: 'Silver',
            prices: [
              ProductVariantPrice(
                id: '${productId}_price_silver',
                currencyCode: 'INR',
                amount: basePrice + 20000, // ₹200 more for silver
              ),
            ],
          ),
        ];

      case 'clothing':
        // Clothing: Size and color combinations
        final variants = <ProductVariant>[];
        final colors = ['Black', 'White', 'Blue', 'Red'];
        final sizes = ['S', 'M', 'L', 'XL'];

        for (final color in colors) {
          for (final size in sizes) {
            variants.add(
              ProductVariant(
                id: '${productId}_variant_${color.toLowerCase()}_${size.toLowerCase()}',
                title: '$size - $color',
                color: color,
                size: size,
                prices: [
                  ProductVariantPrice(
                    id: '${productId}_price_${color.toLowerCase()}_${size.toLowerCase()}',
                    currencyCode: 'INR',
                    amount: basePrice,
                  ),
                ],
              ),
            );
          }
        }
        return variants;

      case 'sports':
        // Sports (shoes): Size and color combinations
        final variants = <ProductVariant>[];
        final colors = ['Black', 'White', 'Red', 'Blue'];
        final sizes = ['7', '8', '9', '10', '11'];

        for (final color in colors) {
          for (final size in sizes) {
            variants.add(
              ProductVariant(
                id: '${productId}_variant_${color.toLowerCase()}_size$size',
                title: 'Size $size - $color',
                color: color,
                size: size,
                prices: [
                  ProductVariantPrice(
                    id: '${productId}_price_${color.toLowerCase()}_size$size',
                    currencyCode: 'INR',
                    amount:
                        basePrice +
                        (color == 'Red' ? 5000 : 0), // Red costs ₹50 more
                  ),
                ],
              ),
            );
          }
        }
        return variants;

      default:
        // Default: Single variant
        return [
          ProductVariant(
            id: '${productId}_variant_1',
            title: 'Default Variant',
            prices: [
              ProductVariantPrice(
                id: '${productId}_price_1',
                currencyCode: 'INR',
                amount: basePrice,
              ),
            ],
          ),
        ];
    }
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

  /// Creates a new order
  Future<OrderResponse> createOrder(Order order) async {
    try {
      _orders[order.id] = order;
      debugPrint('[MockDataService] Order created: ${order.id}');
      return OrderResponse(order: order, message: 'Order created successfully');
    } catch (e) {
      debugPrint('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  /// Gets all orders for a user
  Future<List<Order>> getOrders() async {
    try {
      final orders = _orders.values.toList();
      // Sort by creation date (newest first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      debugPrint('[MockDataService] Retrieved ${orders.length} orders');
      return orders;
    } catch (e) {
      debugPrint('Error getting orders: $e');
      throw Exception('Failed to get orders: $e');
    }
  }

  /// Gets a specific order by ID
  Future<Order?> getOrder(String orderId) async {
    try {
      final order = _orders[orderId];
      debugPrint('[MockDataService] Retrieved order: $orderId');
      return order;
    } catch (e) {
      debugPrint('Error getting order: $e');
      throw Exception('Failed to get order: $e');
    }
  }

  /// Updates order status
  Future<OrderResponse> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      final order = _orders[orderId];
      if (order == null) {
        throw Exception('Order not found');
      }

      final updatedOrder = order.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      _orders[orderId] = updatedOrder;
      debugPrint('[MockDataService] Order status updated: $orderId -> $status');

      return OrderResponse(
        order: updatedOrder,
        message: 'Order status updated successfully',
      );
    } catch (e) {
      debugPrint('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Gets marketplace with all shops
  Future<MarketplaceResponse> getMarketplace() async {
    try {
      if (_cachedShops == null) {
        _cachedShops = await _generateMockShops();
      }

      debugPrint('[MockDataService] Retrieved ${_cachedShops!.length} shops');
      return MarketplaceResponse(
        shops: _cachedShops!,
        totalShops: _cachedShops!.length,
        message: 'Marketplace loaded successfully',
      );
    } catch (e) {
      debugPrint('Error getting marketplace: $e');
      throw Exception('Failed to get marketplace: $e');
    }
  }

  /// Gets specific shop with products
  Future<ShopResponse> getShop(String shopId) async {
    try {
      if (_cachedShops == null) {
        _cachedShops = await _generateMockShops();
      }

      final shop = _cachedShops!.firstWhere(
        (s) => s.id == shopId,
        orElse: () => throw Exception('Shop not found'),
      );

      // Get or generate products for this shop
      if (!_shopProducts.containsKey(shopId)) {
        _shopProducts[shopId] = await _generateShopProducts(shop);
      }

      final products = _shopProducts[shopId]!;
      final featuredProducts = products
          .where((p) => shop.featuredProductIds.contains(p.id))
          .toList();

      final shopWithProducts = ShopWithProducts(
        shop: shop,
        products: products,
        featuredProducts: featuredProducts,
      );

      debugPrint(
        '[MockDataService] Retrieved shop: ${shop.name} with ${products.length} products',
      );
      return ShopResponse(
        shopWithProducts: shopWithProducts,
        message: 'Shop loaded successfully',
      );
    } catch (e) {
      debugPrint('Error getting shop: $e');
      throw Exception('Failed to get shop: $e');
    }
  }

  /// Generates mock shops
  Future<List<Shop>> _generateMockShops() async {
    final shops = <Shop>[];
    final categories = [
      'electronics',
      'clothing',
      'books',
      'home_garden',
      'sports',
    ];
    final shopNames = [
      'TechHub Electronics',
      'Fashion Forward',
      'BookWorm Paradise',
      'Home Sweet Home',
      'SportZone',
      'Gadget Galaxy',
      'Style Studio',
      'Literary Lounge',
      'Garden Grove',
      'Fitness First',
      'Digital Dreams',
      'Trendy Threads',
      'Page Turner',
      'Cozy Corner',
      'Active Life',
    ];

    for (int i = 0; i < shopNames.length; i++) {
      final category = categories[i % categories.length];
      final rating = 3.5 + (_random.nextDouble() * 1.5); // 3.5 to 5.0
      final reviewCount = 50 + _random.nextInt(500); // 50 to 550 reviews

      shops.add(
        Shop(
          id: 'shop_${i + 1}',
          name: shopNames[i],
          description: _getShopDescription(category),
          logo: 'https://picsum.photos/200/200?random=${i + 100}',
          bannerImage: 'https://picsum.photos/800/300?random=${i + 200}',
          rating: double.parse(rating.toStringAsFixed(1)),
          reviewCount: reviewCount,
          category: category,
          isVerified: _random.nextBool(),
          isActive: true,
          featuredProductIds: [], // Will be populated when generating products
          contact: ShopContact(
            email:
                '${shopNames[i].toLowerCase().replaceAll(' ', '')}@example.com',
            phone:
                '+1-${_random.nextInt(900) + 100}-${_random.nextInt(900) + 100}-${_random.nextInt(9000) + 1000}',
            website:
                'https://${shopNames[i].toLowerCase().replaceAll(' ', '')}.com',
            address: ShopAddress(
              street: '${_random.nextInt(9999) + 1} ${_getRandomStreetName()}',
              city: _getRandomCity(),
              state: _getRandomState(),
              country: 'United States',
              zipCode: '${_random.nextInt(90000) + 10000}',
            ),
          ),
          createdAt: DateTime.now().subtract(
            Duration(days: _random.nextInt(365)),
          ),
          updatedAt: DateTime.now(),
        ),
      );
    }

    return shops;
  }

  /// Generates products for a specific shop
  Future<List<Product>> _generateShopProducts(Shop shop) async {
    final allProducts = await getProducts();
    final categoryProducts = allProducts
        .where(
          (p) =>
              p.categories?.any(
                (c) =>
                    c.name.toLowerCase().contains(shop.category.toLowerCase()),
              ) ??
              false,
        )
        .toList();

    // If no category match, take random products
    if (categoryProducts.isEmpty) {
      categoryProducts.addAll(allProducts.take(10));
    }

    // Take 8-15 products for each shop
    final shopProductCount = 8 + _random.nextInt(8);
    final shopProducts = categoryProducts.take(shopProductCount).toList();

    // Update featured product IDs
    final featuredCount = (shopProducts.length * 0.3).ceil().clamp(1, 4);
    final featuredIds = shopProducts
        .take(featuredCount)
        .map((p) => p.id)
        .toList();

    // Update the shop's featured product IDs (this is a simplification for mock data)
    shop.featuredProductIds.clear();
    shop.featuredProductIds.addAll(featuredIds);

    return shopProducts;
  }

  String _getShopDescription(String category) {
    switch (category) {
      case 'electronics':
        return 'Your one-stop destination for the latest electronics and gadgets';
      case 'clothing':
        return 'Trendy fashion and clothing for all occasions';
      case 'books':
        return 'Discover amazing books and literary treasures';
      case 'home_garden':
        return 'Everything you need for your home and garden';
      case 'sports':
        return 'Sports equipment and fitness gear for active lifestyles';
      default:
        return 'Quality products and excellent service';
    }
  }

  String _getRandomStreetName() {
    final streets = [
      'Main St',
      'Oak Ave',
      'Pine Rd',
      'Elm Dr',
      'Maple Ln',
      'Cedar Blvd',
    ];
    return streets[_random.nextInt(streets.length)];
  }

  String _getRandomCity() {
    final cities = [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
      'Philadelphia',
    ];
    return cities[_random.nextInt(cities.length)];
  }

  String _getRandomState() {
    final states = ['NY', 'CA', 'IL', 'TX', 'AZ', 'PA'];
    return states[_random.nextInt(states.length)];
  }

  /// Clears all cached data
  void clearCache() {
    _cachedProducts = null;
    _cachedCategories = null;
    _cachedShops = null;
    _carts.clear();
    _orders.clear();
    _shopProducts.clear();
  }
}
