import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../models/category.dart' as cat;
import '../models/banner.dart';
import '../models/ui_models.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../config/app_config.dart';
import '../mock_data/mock_service.dart';

class HomeController extends GetxController {
  // Services
  late final ProductService _productService;
  late final CategoryService _categoryService;
  late final MockDataService _mockDataService;

  // State variables - GetX observables
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final RxList<Product> products = <Product>[].obs;
  final RxList<cat.ProductCategory> categories = <cat.ProductCategory>[].obs;
  final RxList<Banner> banners = <Banner>[].obs;
  final Rxn<UIScreen> homeScreen = Rxn<UIScreen>();
  final RxString selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize services based on configuration
    if (AppConfig.useMockData) {
      _mockDataService = MockDataService();
    } else {
      _productService = ProductService();
      _categoryService = CategoryService();
    }
  }

  // Initialize home data
  Future<void> initializeHome() async {
    isLoading.value = true;
    error.value = null;

    try {
      await Future.wait([
        loadHomeScreenUI(),
        fetchCategories(),
        loadProducts(),
        fetchBanners(),
      ]);
    } catch (e) {
      error.value = 'Failed to initialize home: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Load home screen UI from JSON
  Future<void> loadHomeScreenUI() async {
    try {
      // In a real app, this would load from assets or network
      final jsonString = await _loadHomeScreenJson();
      final jsonData = json.decode(jsonString);
      homeScreen.value = UIScreen.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load home screen UI: $e');
    }
  }

  // Fetch products using service layer
  Future<List<Product>> fetchProducts({int? limit, String? categoryId}) async {
    try {
      if (AppConfig.useMockData) {
        return await _mockDataService.getProducts(
          limit: limit,
          categoryId: categoryId,
        );
      } else {
        final response = await _productService.fetchProducts(
          limit: limit ?? 20,
          categoryId: categoryId,
        );
        return response.products;
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      // Return mock data as fallback
      return _getMockProducts(limit ?? 10);
    }
  }

  // Fetch categories using service layer
  Future<void> fetchCategories() async {
    try {
      if (AppConfig.useMockData) {
        categories.value = await _mockDataService.getCategories();
      } else {
        categories.value = await _categoryService.fetchCategories();
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      // Use mock data as fallback
      categories.value = _getMockCategories();
    }
  }

  // Fetch products for the controller instance
  Future<void> loadProducts({int? limit, String? categoryId}) async {
    try {
      products.value = await fetchProducts(
        limit: limit,
        categoryId: categoryId,
      );
    } catch (e) {
      debugPrint('Error fetching products: $e');
      products.value = _getMockProducts(limit ?? 10);
    }
  }

  // Fetch banners (mock implementation)
  Future<void> fetchBanners() async {
    try {
      // In a real app, this would fetch from an API
      banners.value = _getMockBanners();
    } catch (e) {
      debugPrint('Error fetching banners: $e');
      banners.value = [];
    }
  }

  // Select category and filter products
  Future<void> selectCategory(String categoryId) async {
    if (selectedCategoryId.value == categoryId) return;

    selectedCategoryId.value = categoryId;
    isLoading.value = true;

    try {
      await loadProducts(categoryId: categoryId.isEmpty ? null : categoryId);
    } catch (e) {
      error.value = 'Failed to load products for category: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh all data
  @override
  Future<void> refresh() async {
    await initializeHome();
  }

  // Helper method to get real product images
  static String _getProductImageUrl(int index) {
    final productImages = [
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop', // Headphones
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop', // Sneakers
      'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=300&fit=crop', // Books
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300&h=300&fit=crop', // T-shirt
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=300&fit=crop', // Home decor
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop', // Sports equipment
      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=300&fit=crop', // Beauty products
      'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=300&h=300&fit=crop', // Watch
      'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=300&h=300&fit=crop', // Laptop
      'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=300&h=300&fit=crop', // Sunglasses
    ];
    return productImages[index % productImages.length];
  }

  // Mock data methods for demo purposes
  static List<Product> _getMockProducts(int limit) {
    final mockProducts = <Product>[];

    for (int i = 0; i < limit; i++) {
      mockProducts.add(
        Product(
          id: 'product_$i',
          title: 'Product ${i + 1}',
          description:
              'This is a sample product description for product ${i + 1}',
          thumbnail: _getProductImageUrl(i),
          images: [ProductImage(id: 'img_$i', url: _getProductImageUrl(i))],
          variants: [
            ProductVariant(
              id: 'variant_$i',
              title: 'Default Variant',
              prices: [
                ProductVariantPrice(
                  id: 'price_$i',
                  currencyCode: 'INR',
                  amount:
                      (99900 +
                      (i * 50000)), // Price in paise (₹999 + ₹500 increments)
                ),
              ],
            ),
          ],
        ),
      );
    }

    return mockProducts;
  }

  List<cat.ProductCategory> _getMockCategories() {
    return [
      cat.ProductCategory(
        id: 'cat_1',
        name: 'Electronics',
        isActive: true,
        isInternal: false,
        rank: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      cat.ProductCategory(
        id: 'cat_2',
        name: 'Clothing',
        isActive: true,
        isInternal: false,
        rank: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      cat.ProductCategory(
        id: 'cat_3',
        name: 'Books',
        isActive: true,
        isInternal: false,
        rank: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      cat.ProductCategory(
        id: 'cat_4',
        name: 'Home & Garden',
        isActive: true,
        isInternal: false,
        rank: 4,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      cat.ProductCategory(
        id: 'cat_5',
        name: 'Sports',
        isActive: true,
        isInternal: false,
        rank: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<Banner> _getMockBanners() {
    return [
      Banner(
        id: 'banner_1',
        title: 'Summer Sale',
        subtitle: 'Up to 50% off',
        imageUrl:
            'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=800&h=300&fit=crop',
        isActive: true,
        priority: 1,
      ),
      Banner(
        id: 'banner_2',
        title: 'New Arrivals',
        subtitle: 'Check out our latest products',
        imageUrl:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=300&fit=crop',
        isActive: true,
        priority: 2,
      ),
      Banner(
        id: 'banner_3',
        title: 'Black Friday',
        subtitle: 'Biggest discounts of the year',
        imageUrl:
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&h=300&fit=crop',
        isActive: true,
        priority: 3,
      ),
    ];
  }

  // Load home screen JSON from assets
  Future<String> _loadHomeScreenJson() async {
    try {
      // Load from assets file instead of hardcoded JSON
      return await rootBundle.loadString('assets/json_ui/home_page.json');
    } catch (e) {
      // Fallback to basic JSON if assets loading fails
      debugPrint('Failed to load home_page.json from assets: $e');
      return '''
      {
        "screenId": "home",
        "title": "Home",
        "theme": {
          "primaryColor": "#2196F3",
          "secondaryColor": "#FF5722",
          "backgroundColor": "#FFFFFF",
          "textColor": "#212121"
        },
        "components": [
          {
            "type": "carousel",
            "properties": {
              "images": [
                "https://via.placeholder.com/800x300/FF5722/FFFFFF?text=Slide+1",
                "https://via.placeholder.com/800x300/2196F3/FFFFFF?text=Slide+2",
                "https://via.placeholder.com/800x300/4CAF50/FFFFFF?text=Slide+3"
              ],
              "autoPlay": true,
              "autoPlayInterval": 3,
              "showIndicators": true,
              "height": 200
            }
          },
          {
            "type": "productlist",
            "properties": {
              "title": "Popular Products",
              "isHorizontal": true,
              "showViewAll": true,
              "limit": 10
            }
          }
        ]
      }
      ''';
    }
  }
}
