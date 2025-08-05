import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/unified_models.dart';
import '../models/shop.dart';

/// Centralized Mock API Service - Single source of truth for all mock data
/// Replaces MockShopService, MockDataService, and other fragmented services
/// Ensures consistent data across the entire SDUI platform
class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  final Random _random = Random();
  
  // Cache for performance
  List<ShopModel>? _cachedShops;
  List<ProductModel>? _cachedProducts;
  List<OfferModel>? _cachedOffers;
  final Map<String, CartModel> _carts = {};

  /// Get all shops with IDs matching JSON templates
  Future<List<ShopModel>> getShops() async {
    if (_cachedShops != null) return _cachedShops!;

    _cachedShops = [
      // Shops matching JSON template IDs
      ShopModel(
        id: 'shop_001',
        name: 'Spice Garden Restaurant',
        description: 'Authentic Indian cuisine with traditional spices and flavors',
        logo: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&h=400&fit=crop',
        rating: 4.5,
        reviewCount: 1250,
        category: 'food',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['spice_biryani', 'butter_chicken', 'naan_bread'],
        contact: ShopContact(
          email: 'contact@spicegarden.com',
          phone: '+91 98765 43210',
          website: 'https://spicegarden.com',
          address: ShopAddress(
            street: '123 MG Road',
            city: 'Bangalore',
            state: 'Karnataka',
            country: 'India',
            zipCode: '560001',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#FF6B35',
          secondaryColor: '#F7931E',
          backgroundColor: '#FFF8F0',
          textColor: '#2C1810',
        ),
        deliveryTime: '25-30 mins',
        specialOffer: 'Free delivery on orders above ₹299',
        tags: ['Popular', 'Indian', 'Spicy'],
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now(),
      ),

      ShopModel(
        id: 'shop_002',
        name: 'TechZone Electronics',
        description: 'Latest gadgets and electronics with warranty and support',
        logo: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800&h=400&fit=crop',
        rating: 4.3,
        reviewCount: 890,
        category: 'electronics',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['smartphone_pro', 'wireless_earbuds', 'smart_watch'],
        contact: ShopContact(
          email: 'support@techzone.com',
          phone: '+91 87654 32109',
          website: 'https://techzone.com',
          address: ShopAddress(
            street: '456 Tech Street',
            city: 'Mumbai',
            state: 'Maharashtra',
            country: 'India',
            zipCode: '400001',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#2196F3',
          secondaryColor: '#64B5F6',
          backgroundColor: '#E3F2FD',
          textColor: '#0D47A1',
        ),
        deliveryTime: '1-2 days',
        specialOffer: '10% off on first purchase',
        tags: ['Electronics', 'Gadgets', 'Tech'],
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now(),
      ),

      ShopModel(
        id: 'shop_003',
        name: 'Fashion Forward',
        description: 'Trendy clothing and accessories for modern lifestyle',
        logo: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=400&fit=crop',
        rating: 4.2,
        reviewCount: 567,
        category: 'fashion',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['summer_dress', 'denim_jacket', 'sneakers'],
        contact: ShopContact(
          email: 'hello@fashionforward.com',
          phone: '+91 76543 21098',
          website: 'https://fashionforward.com',
          address: ShopAddress(
            street: '789 Fashion Avenue',
            city: 'Delhi',
            state: 'Delhi',
            country: 'India',
            zipCode: '110001',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#E91E63',
          secondaryColor: '#F06292',
          backgroundColor: '#FCE4EC',
          textColor: '#880E4F',
        ),
        deliveryTime: '2-3 days',
        specialOffer: 'Buy 2 Get 1 Free on selected items',
        tags: ['Fashion', 'Trendy', 'Clothing'],
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
      ),

      ShopModel(
        id: 'shop_004',
        name: 'Green Grocery',
        description: 'Fresh fruits, vegetables, and organic produce delivered daily',
        logo: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&h=400&fit=crop',
        rating: 4.7,
        reviewCount: 1890,
        category: 'grocery',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['organic_apples', 'fresh_spinach', 'tomatoes'],
        contact: ShopContact(
          email: 'orders@greengrocery.com',
          phone: '+91 65432 10987',
          website: 'https://greengrocery.com',
          address: ShopAddress(
            street: '321 Green Street',
            city: 'Pune',
            state: 'Maharashtra',
            country: 'India',
            zipCode: '411001',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#4CAF50',
          secondaryColor: '#81C784',
          backgroundColor: '#E8F5E8',
          textColor: '#1B5E20',
        ),
        deliveryTime: '2-4 hours',
        specialOffer: 'Fresh produce guaranteed',
        tags: ['Organic', 'Fresh', 'Healthy'],
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
      ),

      ShopModel(
        id: 'gourmet-kitchen',
        name: 'Cheelizza - India Ka Pizza',
        description: 'Authentic Indian-style pizzas with traditional flavors and spices',
        logo: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&h=400&fit=crop',
        rating: 4.6,
        reviewCount: 2340,
        category: 'food',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['tandoori_pizza', 'paneer_tikka_pizza', 'masala_garlic_bread'],
        contact: ShopContact(
          email: 'orders@cheelizza.com',
          phone: '+91 98765 12345',
          website: 'https://cheelizza.com',
          address: ShopAddress(
            street: '567 Pizza Plaza',
            city: 'Bangalore',
            state: 'Karnataka',
            country: 'India',
            zipCode: '560002',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#FF5722',
          secondaryColor: '#FF8A65',
          backgroundColor: '#FFF3E0',
          textColor: '#BF360C',
        ),
        deliveryTime: '20-25 mins',
        specialOffer: 'Free pizza on orders above ₹599',
        tags: ['Pizza', 'Indian', 'Popular'],
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now(),
      ),

      ShopModel(
        id: 'sweet-delights',
        name: 'Sweet Delights',
        description: 'Delicious cakes, cookies, and desserts made with love and premium ingredients',
        logo: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&h=400&fit=crop',
        rating: 4.8,
        reviewCount: 2150,
        category: 'food',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['chocolate_brownie', 'vanilla_cupcake', 'strawberry_cheesecake'],
        contact: ShopContact(
          email: 'orders@sweetdelights.com',
          phone: '+91 54321 09876',
          website: 'https://sweetdelights.com',
          address: ShopAddress(
            street: '456 Sweet Street',
            city: 'Delhi',
            state: 'Delhi',
            country: 'India',
            zipCode: '110001',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#E91E63',
          secondaryColor: '#F06292',
          backgroundColor: '#FCE4EC',
          textColor: '#880E4F',
        ),
        deliveryTime: '20-25 mins',
        specialOffer: 'Sweet treats made with love',
        tags: ['Desserts', 'Sweet', 'Premium'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),

      // Missing shops from shops_tab.json
      ShopModel(
        id: 'pizza-hut',
        name: 'Pizza Hut Express',
        description: 'World-famous pizzas, pasta, and garlic bread delivered hot and fresh',
        logo: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&h=400&fit=crop',
        rating: 4.3,
        reviewCount: 3420,
        category: 'food',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['margherita_pizza', 'pepperoni_pizza', 'garlic_bread'],
        contact: ShopContact(
          email: 'orders@pizzahut.com',
          phone: '+91 98765 54321',
          website: 'https://pizzahut.com',
          address: ShopAddress(
            street: '789 Pizza Street',
            city: 'Mumbai',
            state: 'Maharashtra',
            country: 'India',
            zipCode: '400001',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#D84315',
          secondaryColor: '#FF8A65',
          backgroundColor: '#FFF3E0',
          textColor: '#BF360C',
        ),
        deliveryTime: '20-25 mins',
        specialOffer: 'Buy 1 Get 1 Free on selected pizzas',
        tags: ['Pizza', 'Fast Food', 'Popular'],
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      ),

      ShopModel(
        id: 'fresh-bowl-co',
        name: 'Fresh Bowl Co.',
        description: 'Healthy salads, smoothie bowls, and nutritious wraps made with fresh ingredients',
        logo: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200&h=200&fit=crop',
        bannerImage: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&h=400&fit=crop',
        rating: 4.6,
        reviewCount: 1890,
        category: 'food',
        isVerified: true,
        isActive: true,
        featuredProductIds: ['quinoa_bowl', 'green_smoothie', 'chicken_wrap'],
        contact: ShopContact(
          email: 'hello@freshbowlco.com',
          phone: '+91 87654 32109',
          website: 'https://freshbowlco.com',
          address: ShopAddress(
            street: '321 Health Street',
            city: 'Bangalore',
            state: 'Karnataka',
            country: 'India',
            zipCode: '560001',
          ),
        ),
        theme: const ShopThemeData(
          primaryColor: '#2E7D32',
          secondaryColor: '#81C784',
          backgroundColor: '#E8F5E8',
          textColor: '#1B5E20',
        ),
        deliveryTime: '15-20 mins',
        specialOffer: 'Fresh & healthy guaranteed',
        tags: ['Healthy', 'Fresh', 'Organic'],
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
      ),
    ];

    return _cachedShops!;
  }

  /// Get shop by ID
  Future<ShopModel?> getShopById(String shopId) async {
    final shops = await getShops();
    try {
      return shops.firstWhere((shop) => shop.id == shopId);
    } catch (e) {
      debugPrint('[MockApiService] Shop not found: $shopId');
      return null;
    }
  }

  /// Get shop details by tenant ID (alias for getShopById for multi-tenant compatibility)
  /// This method simulates a real multi-tenant environment where each shop has a tenantId
  Future<ShopModel?> getShopDetailsByTenantId(String tenantId) async {
    debugPrint('[MockApiService] Getting shop details for tenantId: $tenantId');
    return await getShopById(tenantId);
  }

  /// Get shops by category
  Future<List<ShopModel>> getShopsByCategory(String category) async {
    final shops = await getShops();
    return shops.where((shop) => shop.category == category).toList();
  }

  /// Get top rated shops
  Future<List<ShopModel>> getTopRatedShops({int limit = 5}) async {
    final shops = await getShops();
    final sortedShops = List<ShopModel>.from(shops);
    sortedShops.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedShops.take(limit).toList();
  }

  /// Get featured shops (in the spotlight)
  Future<List<ShopModel>> getFeaturedShops({int limit = 6}) async {
    final shops = await getShops();
    return shops.where((shop) => shop.isVerified).take(limit).toList();
  }

  /// Get products for a specific shop with proper names
  Future<List<ProductModel>> getProducts(String shopId) async {
    if (_cachedProducts == null) {
      await _loadProducts();
    }

    return _cachedProducts!.where((product) => product.shopId == shopId).toList();
  }

  /// Get product by ID with proper name mapping
  Future<ProductModel?> getProductById(String productId) async {
    if (_cachedProducts == null) {
      await _loadProducts();
    }

    try {
      return _cachedProducts!.firstWhere((product) => product.id == productId);
    } catch (e) {
      // Generate a product if not found
      return _generateProduct(productId);
    }
  }

  /// Get products by category for category navigation
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    if (_cachedProducts == null) {
      await _loadProducts();
    }

    return _cachedProducts!.where((product) => product.category == category).toList();
  }

  /// Get promotional offers for banner carousels
  Future<List<OfferModel>> getOffers() async {
    if (_cachedOffers != null) return _cachedOffers!;

    _cachedOffers = [
      OfferModel(
        id: 'offer_001',
        title: 'Summer Sale',
        description: 'Up to 50% off on summer collection',
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=800&h=400&fit=crop',
        discountType: 'percentage',
        discountValue: 50.0,
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 23)),
        isActive: true,
        tags: ['Summer', 'Sale', 'Fashion'],
      ),
      OfferModel(
        id: 'offer_002',
        title: 'Free Delivery Weekend',
        description: 'Free delivery on all orders this weekend',
        imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=400&fit=crop',
        discountType: 'fixed',
        discountValue: 0.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 2)),
        isActive: true,
        tags: ['Delivery', 'Weekend', 'Free'],
      ),
      OfferModel(
        id: 'offer_003',
        title: 'Pizza Combo Deal',
        description: 'Buy 2 pizzas get 1 free at Cheelizza',
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&h=400&fit=crop',
        shopId: 'gourmet-kitchen',
        discountType: 'bogo',
        discountValue: 1.0,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 10)),
        isActive: true,
        tags: ['Pizza', 'Combo', 'BOGO'],
      ),
    ];

    return _cachedOffers!;
  }

  /// Get cart data with proper product mapping
  Future<CartModel> getCart(String cartId) async {
    if (_carts.containsKey(cartId)) {
      return _carts[cartId]!;
    }

    // Create empty cart
    final cart = CartModel(
      id: cartId,
      items: [],
      subtotal: 0.0,
      tax: 0.0,
      deliveryFee: 0.0,
      total: 0.0,
      currency: 'INR',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _carts[cartId] = cart;
    return cart;
  }

  /// Add item to cart with correct shop association
  Future<CartModel> addToCart(String productId, int quantity, String cartId) async {
    final product = await getProductById(productId);
    if (product == null) {
      throw Exception('Product not found: $productId');
    }

    final cart = await getCart(cartId);
    final existingItemIndex = cart.items.indexWhere((item) => item.productId == productId);

    List<CartItemModel> updatedItems = List.from(cart.items);

    if (existingItemIndex >= 0) {
      // Update existing item
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = CartItemModel(
        id: existingItem.id,
        productId: productId,
        productName: product.name,
        productImage: product.imageUrl,
        unitPrice: product.price,
        quantity: existingItem.quantity + quantity,
        shopId: product.shopId,
        shopName: product.shopName,
        currency: product.currency,
        metadata: {},
        addedAt: existingItem.addedAt,
      );
    } else {
      // Add new item
      updatedItems.add(CartItemModel(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        productName: product.name,
        productImage: product.imageUrl,
        unitPrice: product.price,
        quantity: quantity,
        shopId: product.shopId,
        shopName: product.shopName,
        currency: product.currency,
        metadata: {},
        addedAt: DateTime.now(),
      ));
    }

    final subtotal = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.18; // 18% GST
    final deliveryFee = subtotal > 299 ? 0.0 : 40.0; // Free delivery above ₹299

    final updatedCart = CartModel(
      id: cartId,
      items: updatedItems,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: subtotal + tax + deliveryFee,
      currency: 'INR',
      createdAt: cart.createdAt,
      updatedAt: DateTime.now(),
    );

    _carts[cartId] = updatedCart;
    debugPrint('[MockApiService] Added ${product.name} to cart. Total items: ${updatedCart.itemCount}');
    return updatedCart;
  }

  /// Remove item from cart
  Future<CartModel> removeFromCart(String productId, String cartId) async {
    final cart = await getCart(cartId);
    final updatedItems = cart.items.where((item) => item.productId != productId).toList();

    final subtotal = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.18;
    final deliveryFee = subtotal > 299 ? 0.0 : 40.0;

    final updatedCart = CartModel(
      id: cartId,
      items: updatedItems,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: subtotal + tax + deliveryFee,
      currency: 'INR',
      createdAt: cart.createdAt,
      updatedAt: DateTime.now(),
    );

    _carts[cartId] = updatedCart;
    return updatedCart;
  }

  /// Load products with proper names and shop associations
  Future<void> _loadProducts() async {
    _cachedProducts = [
      // Sweet Delights products
      ProductModel(
        id: 'chocolate_brownie',
        name: 'Gooey Chocolate Brownie',
        description: 'Rich, fudgy chocolate brownie with premium cocoa',
        imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=400&fit=crop',
        price: 120.0,
        currency: 'INR',
        shopId: 'sweet-delights',
        shopName: 'Sweet Delights',
        category: 'desserts',
        tags: ['Chocolate', 'Brownie', 'Sweet'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.8,
        reviewCount: 156,
        metadata: {'calories': 280, 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'vanilla_cupcake',
        name: 'Classic Vanilla Cupcake',
        description: 'Fluffy vanilla cupcake with buttercream frosting',
        imageUrl: 'https://images.unsplash.com/photo-1587668178277-295251f900ce?w=400&h=400&fit=crop',
        price: 80.0,
        currency: 'INR',
        shopId: 'sweet-delights',
        shopName: 'Sweet Delights',
        category: 'desserts',
        tags: ['Vanilla', 'Cupcake', 'Classic'],
        isAvailable: true,
        isFeatured: false,
        rating: 4.6,
        reviewCount: 89,
        metadata: {'calories': 220, 'allergens': ['gluten', 'dairy', 'eggs']},
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'strawberry_cheesecake',
        name: 'Strawberry Cheesecake',
        description: 'Creamy cheesecake topped with fresh strawberries',
        imageUrl: 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&h=400&fit=crop',
        price: 180.0,
        currency: 'INR',
        shopId: 'sweet-delights',
        shopName: 'Sweet Delights',
        category: 'desserts',
        tags: ['Strawberry', 'Cheesecake', 'Premium'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.9,
        reviewCount: 234,
        metadata: {'calories': 350, 'allergens': ['gluten', 'dairy', 'eggs']},
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),

      // Pizza Hut products
      ProductModel(
        id: 'margherita_pizza',
        name: 'Margherita Pizza',
        description: 'Classic pizza with fresh mozzarella, tomato sauce, and basil',
        imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400&h=400&fit=crop',
        price: 299.0,
        currency: 'INR',
        shopId: 'pizza-hut',
        shopName: 'Pizza Hut Express',
        category: 'pizza',
        tags: ['Pizza', 'Vegetarian', 'Classic'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.4,
        reviewCount: 567,
        metadata: {'size': 'Medium', 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'pepperoni_pizza',
        name: 'Pepperoni Pizza',
        description: 'Delicious pizza topped with spicy pepperoni and cheese',
        imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&h=400&fit=crop',
        price: 399.0,
        currency: 'INR',
        shopId: 'pizza-hut',
        shopName: 'Pizza Hut Express',
        category: 'pizza',
        tags: ['Pizza', 'Pepperoni', 'Spicy'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.5,
        reviewCount: 789,
        metadata: {'size': 'Medium', 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'garlic_bread',
        name: 'Garlic Bread',
        description: 'Crispy bread sticks with garlic butter and herbs',
        imageUrl: 'https://images.unsplash.com/photo-1619985632461-f33748ef8d3d?w=400&h=400&fit=crop',
        price: 149.0,
        currency: 'INR',
        shopId: 'pizza-hut',
        shopName: 'Pizza Hut Express',
        category: 'sides',
        tags: ['Garlic', 'Bread', 'Sides'],
        isAvailable: true,
        isFeatured: false,
        rating: 4.2,
        reviewCount: 234,
        metadata: {'pieces': 6, 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now(),
      ),

      // Fresh Bowl Co. products
      ProductModel(
        id: 'quinoa_bowl',
        name: 'Quinoa Power Bowl',
        description: 'Nutritious quinoa bowl with fresh vegetables and avocado',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop',
        price: 249.0,
        currency: 'INR',
        shopId: 'fresh-bowl-co',
        shopName: 'Fresh Bowl Co.',
        category: 'healthy',
        tags: ['Quinoa', 'Healthy', 'Vegan'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.7,
        reviewCount: 345,
        metadata: {'calories': 420, 'allergens': []},
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'green_smoothie',
        name: 'Green Detox Smoothie',
        description: 'Refreshing smoothie with spinach, apple, and ginger',
        imageUrl: 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400&h=400&fit=crop',
        price: 179.0,
        currency: 'INR',
        shopId: 'fresh-bowl-co',
        shopName: 'Fresh Bowl Co.',
        category: 'beverages',
        tags: ['Smoothie', 'Detox', 'Healthy'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.6,
        reviewCount: 198,
        metadata: {'calories': 180, 'allergens': []},
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'chicken_wrap',
        name: 'Grilled Chicken Wrap',
        description: 'Healthy wrap with grilled chicken, fresh vegetables, and hummus',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=400&fit=crop',
        price: 219.0,
        currency: 'INR',
        shopId: 'fresh-bowl-co',
        shopName: 'Fresh Bowl Co.',
        category: 'wraps',
        tags: ['Chicken', 'Wrap', 'Protein'],
        isAvailable: true,
        isFeatured: false,
        rating: 4.5,
        reviewCount: 156,
        metadata: {'calories': 380, 'allergens': ['gluten']},
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now(),
      ),

      // Spice Garden Restaurant (shop_001) products
      ProductModel(
        id: 'spice_biryani',
        name: 'Authentic Hyderabadi Biryani',
        description: 'Aromatic basmati rice with tender mutton and traditional spices',
        imageUrl: 'https://images.unsplash.com/photo-1563379091339-03246963d96c?w=400&h=400&fit=crop',
        price: 349.0,
        currency: 'INR',
        shopId: 'shop_001',
        shopName: 'Spice Garden Restaurant',
        category: 'main_course',
        tags: ['Biryani', 'Spicy', 'Traditional'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.8,
        reviewCount: 892,
        metadata: {'spice_level': 'Medium', 'allergens': ['dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'butter_chicken',
        name: 'Butter Chicken',
        description: 'Creamy tomato-based curry with tender chicken pieces',
        imageUrl: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=400&h=400&fit=crop',
        price: 289.0,
        currency: 'INR',
        shopId: 'shop_001',
        shopName: 'Spice Garden Restaurant',
        category: 'main_course',
        tags: ['Chicken', 'Curry', 'Popular'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.7,
        reviewCount: 654,
        metadata: {'spice_level': 'Mild', 'allergens': ['dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'naan_bread',
        name: 'Garlic Naan',
        description: 'Soft, fluffy bread with garlic and herbs, baked in tandoor',
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&h=400&fit=crop',
        price: 89.0,
        currency: 'INR',
        shopId: 'shop_001',
        shopName: 'Spice Garden Restaurant',
        category: 'bread',
        tags: ['Naan', 'Garlic', 'Tandoor'],
        isAvailable: true,
        isFeatured: false,
        rating: 4.5,
        reviewCount: 234,
        metadata: {'pieces': 2, 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),

      // Cheelizza - India Ka Pizza (gourmet-kitchen) products
      ProductModel(
        id: 'tandoori_pizza',
        name: 'Tandoori Chicken Pizza',
        description: 'Indian-style pizza with tandoori chicken and traditional spices',
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=400&fit=crop',
        price: 449.0,
        currency: 'INR',
        shopId: 'gourmet-kitchen',
        shopName: 'Cheelizza - India Ka Pizza',
        category: 'pizza',
        tags: ['Pizza', 'Tandoori', 'Indian'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.6,
        reviewCount: 567,
        metadata: {'size': 'Large', 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'paneer_tikka_pizza',
        name: 'Paneer Tikka Pizza',
        description: 'Vegetarian pizza with marinated paneer and bell peppers',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=400&fit=crop',
        price: 399.0,
        currency: 'INR',
        shopId: 'gourmet-kitchen',
        shopName: 'Cheelizza - India Ka Pizza',
        category: 'pizza',
        tags: ['Pizza', 'Paneer', 'Vegetarian'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.5,
        reviewCount: 423,
        metadata: {'size': 'Large', 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'masala_garlic_bread',
        name: 'Masala Garlic Bread',
        description: 'Crispy bread with Indian masala and garlic butter',
        imageUrl: 'https://images.unsplash.com/photo-1619985632461-f33748ef8d3d?w=400&h=400&fit=crop',
        price: 169.0,
        currency: 'INR',
        shopId: 'gourmet-kitchen',
        shopName: 'Cheelizza - India Ka Pizza',
        category: 'sides',
        tags: ['Garlic Bread', 'Masala', 'Spicy'],
        isAvailable: true,
        isFeatured: false,
        rating: 4.3,
        reviewCount: 189,
        metadata: {'pieces': 4, 'allergens': ['gluten', 'dairy']},
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now(),
      ),

      // Green Grocery (shop_004) products
      ProductModel(
        id: 'organic_apples',
        name: 'Organic Red Apples',
        description: 'Fresh, crisp organic apples from local farms',
        imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop',
        price: 149.0,
        currency: 'INR',
        shopId: 'shop_004',
        shopName: 'Green Grocery',
        category: 'fruits',
        tags: ['Organic', 'Fresh', 'Healthy'],
        isAvailable: true,
        isFeatured: true,
        rating: 4.7,
        reviewCount: 234,
        metadata: {'weight': '1kg', 'allergens': []},
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'fresh_spinach',
        name: 'Fresh Baby Spinach',
        description: 'Tender baby spinach leaves, perfect for salads and cooking',
        imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&h=400&fit=crop',
        price: 89.0,
        currency: 'INR',
        shopId: 'shop_004',
        shopName: 'Green Grocery',
        category: 'vegetables',
        tags: ['Spinach', 'Leafy', 'Organic'],
        isAvailable: true,
        isFeatured: false,
        rating: 4.6,
        reviewCount: 156,
        metadata: {'weight': '250g', 'allergens': []},
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'tomatoes',
        name: 'Fresh Tomatoes',
        description: 'Ripe, juicy tomatoes perfect for cooking and salads',
        imageUrl: 'https://images.unsplash.com/photo-1546470427-e26264be0b0d?w=400&h=400&fit=crop',
        price: 69.0,
        currency: 'INR',
        shopId: 'shop_004',
        shopName: 'Green Grocery',
        category: 'vegetables',
        tags: ['Tomatoes', 'Fresh', 'Cooking'],
        isAvailable: true,
        isFeatured: false,
        rating: 4.4,
        reviewCount: 98,
        metadata: {'weight': '500g', 'allergens': []},
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Generate a product if not found in cache
  ProductModel _generateProduct(String productId) {
    final shopId = _extractShopIdFromProductId(productId);
    final shopName = _getShopNameById(shopId);

    return ProductModel(
      id: productId,
      name: _generateProductName(productId),
      description: 'Delicious item from $shopName',
      imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=400&fit=crop',
      price: _random.nextDouble() * 500 + 50, // ₹50-₹550
      currency: 'INR',
      shopId: shopId,
      shopName: shopName,
      category: 'food',
      tags: ['Generated'],
      isAvailable: true,
      isFeatured: false,
      rating: 3.5 + _random.nextDouble() * 1.5, // 3.5-5.0
      reviewCount: _random.nextInt(200) + 10,
      metadata: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String _extractShopIdFromProductId(String productId) {
    if (productId.contains('sweet-delights')) return 'sweet-delights';
    if (productId.contains('pizza-hut')) return 'pizza-hut';
    if (productId.contains('fresh-bowl-co')) return 'fresh-bowl-co';
    if (productId.contains('gourmet-kitchen')) return 'gourmet-kitchen';
    if (productId.contains('shop_001')) return 'shop_001';
    if (productId.contains('shop_002')) return 'shop_002';
    if (productId.contains('shop_003')) return 'shop_003';
    if (productId.contains('shop_004')) return 'shop_004';
    return 'sweet-delights'; // Default
  }

  String _getShopNameById(String shopId) {
    switch (shopId) {
      case 'sweet-delights': return 'Sweet Delights';
      case 'pizza-hut': return 'Pizza Hut Express';
      case 'fresh-bowl-co': return 'Fresh Bowl Co.';
      case 'gourmet-kitchen': return 'Cheelizza - India Ka Pizza';
      case 'shop_001': return 'Spice Garden Restaurant';
      case 'shop_002': return 'TechZone Electronics';
      case 'shop_003': return 'Fashion Forward';
      case 'shop_004': return 'Green Grocery';
      default: return 'Unknown Shop';
    }
  }

  String _generateProductName(String productId) {
    final names = [
      'Gooey Chocolate Brownie',
      'Classic Vanilla Cupcake',
      'Strawberry Cheesecake',
      'Tandoori Pizza',
      'Paneer Tikka Pizza',
      'Masala Garlic Bread',
      'Spice Garden Biryani',
      'Butter Chicken',
      'Fresh Naan Bread',
    ];
    return names[_random.nextInt(names.length)];
  }

  /// Clear all cached data
  void clearCache() {
    _cachedShops = null;
    _cachedProducts = null;
    _cachedOffers = null;
    _carts.clear();
  }
}
