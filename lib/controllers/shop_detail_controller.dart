import 'package:get/get.dart';
import 'package:ecommerce_sdui/models/shop.dart';
import 'package:ecommerce_sdui/models/product.dart';
import 'package:ecommerce_sdui/services/mock_shop_service.dart';
import 'package:ecommerce_sdui/mock_data/mock_service.dart';
import 'package:ecommerce_sdui/utils/debug_logger.dart';
import 'expandable_section_controller.dart';

class ShopDetailController extends GetxController {
  final MockShopService _mockShopService = MockShopService();
  final MockDataService _mockDataService = MockDataService();

  // Observable state
  final isLoading = false.obs;
  final error = RxnString();
  final selectedShop = Rxn<Shop>();
  final shopProducts = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final shopDetailUIConfig = Rxn<Map<String, dynamic>>();
  
  // Filter state
  final searchQuery = ''.obs;
  final selectedFilters = <String>[].obs;
  final availableFilters = <String>[
    'Pure Veg',
    'Ratings 4.0+',
    'Buy 1 Get 1',
    'Bestseller'
  ].obs;

  /// Load shop detail with products and UI configuration
  Future<void> loadShopDetail(String shopId) async {
    try {
      isLoading.value = true;
      error.value = null;

      // Initialize expandable section controller
      Get.put(ExpandableSectionController(), permanent: true);

      DebugLogger.jsonParsing('ShopDetailController loading shop: $shopId');

      // Load shop data
      final shop = _mockShopService.getShopById(shopId);
      if (shop == null) {
        throw Exception('Shop not found: $shopId');
      }

      selectedShop.value = shop;

      // Load shop products
      await _loadShopProducts(shopId);

      // Shop detail is now native Flutter, no need to load JSON UI
      DebugLogger.jsonParsing('ShopDetailController using native Flutter UI for shop: ${shop.name}');

      DebugLogger.jsonParsing('ShopDetailController loaded successfully: ${shop.name}');
    } catch (e) {
      error.value = 'Failed to load shop: $e';
      DebugLogger.jsonParsing('ShopDetailController error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load products for the shop
  Future<void> _loadShopProducts(String shopId) async {
    try {
      // Generate food products for the shop
      final products = await _generateFoodProducts(shopId);
      shopProducts.value = products;
      filteredProducts.value = products;
    } catch (e) {
      DebugLogger.jsonParsing('Error loading shop products: $e');
      shopProducts.value = [];
      filteredProducts.value = [];
    }
  }

  /// Generate food products based on the shop
  Future<List<Product>> _generateFoodProducts(String shopId) async {
    final products = <Product>[];
    
    // Food items based on the screenshot
    final foodItems = [
      {
        'name': 'Gooey Chocolate Brownie',
        'originalPrice': 129.0,
        'discountedPrice': 99.0,
        'rating': 4.6,
        'reviewCount': 83,
        'image': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=300&h=300&fit=crop',
        'isVeg': false,
      },
      {
        'name': 'Mummys Special [Small]',
        'originalPrice': 159.0,
        'discountedPrice': 99.0,
        'rating': 4.6,
        'reviewCount': 41,
        'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=300&fit=crop',
        'isVeg': true,
      },
      {
        'name': 'Margherita Pizza [Medium]',
        'originalPrice': 199.0,
        'discountedPrice': 149.0,
        'rating': 4.4,
        'reviewCount': 156,
        'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&h=300&fit=crop',
        'isVeg': true,
      },
      {
        'name': 'Chicken Tikka Pizza [Large]',
        'originalPrice': 299.0,
        'discountedPrice': 249.0,
        'rating': 4.7,
        'reviewCount': 203,
        'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=300&fit=crop',
        'isVeg': false,
      },
      {
        'name': 'Cheese Garlic Bread',
        'originalPrice': 89.0,
        'discountedPrice': 69.0,
        'rating': 4.3,
        'reviewCount': 92,
        'image': 'https://images.unsplash.com/photo-1549611012-230f25d0b83d?w=300&h=300&fit=crop',
        'isVeg': true,
      },
      {
        'name': 'Chocolate Lava Cake',
        'originalPrice': 119.0,
        'discountedPrice': 99.0,
        'rating': 4.8,
        'reviewCount': 67,
        'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=300&h=300&fit=crop',
        'isVeg': true,
      },
    ];

    for (int i = 0; i < foodItems.length; i++) {
      final item = foodItems[i];
      products.add(
        Product(
          id: 'food_${shopId}_${i + 1}',
          title: item['name'] as String,
          description: 'Delicious ${item['name']} made with fresh ingredients',
          thumbnail: item['image'] as String,
          tags: [
            if (item['isVeg'] as bool) 'vegetarian',
            if ((item['originalPrice'] as double) > (item['discountedPrice'] as double)) 'discount',
            if ((item['rating'] as double) >= 4.5) 'bestseller',
          ],
          createdAt: DateTime.now().subtract(Duration(days: i * 10)),
          updatedAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }

    return products;
  }



  /// Filter products based on search query and selected filters
  void filterProducts() {
    var filtered = shopProducts.toList();

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               (product.description?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
      }).toList();
    }

    // Apply selected filters
    for (final filter in selectedFilters) {
      switch (filter) {
        case 'Pure Veg':
          filtered = filtered.where((product) => product.tags?.contains('vegetarian') ?? false).toList();
          break;
        case 'Ratings 4.0+':
          filtered = filtered.where((product) => product.rating >= 4.0).toList();
          break;
        case 'Buy 1 Get 1':
          // For demo purposes, assume products with discount have this offer
          filtered = filtered.where((product) => product.tags?.contains('discount') ?? false).toList();
          break;
        case 'Bestseller':
          filtered = filtered.where((product) => product.tags?.contains('bestseller') ?? false).toList();
          break;
      }
    }

    filteredProducts.value = filtered;
  }

  /// Toggle filter selection
  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    filterProducts();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterProducts();
  }

  /// Add product to cart
  void addToCart(String productId) {
    // TODO: Implement cart functionality
    DebugLogger.jsonParsing('Adding product to cart: $productId');
  }
}
