import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import '../models/product.dart';
import '../controllers/home_controller.dart';
import '../controllers/cart_controller.dart';
import '../mock_data/mock_service.dart';
import '../controllers/favorites_controller.dart';

class ProductDetailController extends GetxController {
  // Base URLs - In production, these would come from environment variables
  static const String _baseUrl = 'https://medusa-public-api.herokuapp.com';

  // State variables - GetX observables
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final Rxn<Product> product = Rxn<Product>();
  final RxInt quantity = 1.obs;
  final RxBool isFavorite = false.obs;
  final RxList<Product> relatedProducts = <Product>[].obs;
  final RxBool isAddingToCart = false.obs;

  // Variant selection
  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final Rx<ProductVariant?> selectedVariant = Rx<ProductVariant?>(null);

  // Load product details
  Future<void> loadProduct(String productId) async {
    isLoading.value = true;
    error.value = null;

    try {
      await Future.wait([_fetchProduct(productId), _fetchRelatedProducts()]);
      // Load favorite status after product is loaded
      await _loadFavoriteStatus();
    } catch (e) {
      error.value = 'Failed to load product: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch single product
  Future<void> _fetchProduct(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/store/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productData = data['product'];
        if (productData != null) {
          product.value = Product.fromJson(productData);
          _initializeVariantSelection();
        } else {
          throw Exception('Product not found');
        }
      } else {
        throw Exception('Failed to fetch product: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching product: $e');
      // Use mock data for demo purposes
      product.value = await _getMockProduct(productId);
      _initializeVariantSelection();
    }
  }

  // Fetch related products
  Future<void> _fetchRelatedProducts() async {
    try {
      relatedProducts.value = await Get.find<HomeController>().fetchProducts(
        limit: 5,
      );
    } catch (e) {
      debugPrint('Error fetching related products: $e');
      relatedProducts.value = [];
    }
  }

  // Quantity management
  void increaseQuantity() {
    if (quantity.value < 99) {
      quantity.value++;
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void setQuantity(int newQuantity) {
    if (newQuantity >= 1 && newQuantity <= 99) {
      quantity.value = newQuantity;
    }
  }

  // Favorite management
  Future<void> toggleFavorite() async {
    final currentProduct = product.value;
    if (currentProduct == null) return;

    try {
      final favoritesController = Get.find<FavoritesController>();
      final newStatus = await favoritesController.toggleFavorite(
        currentProduct,
      );
      isFavorite.value = newStatus;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      // Revert the UI state if there was an error
      isFavorite.value = !isFavorite.value;
    }
  }

  // Cart management
  Future<void> addToCart() async {
    if (product.value == null) return;

    try {
      isAddingToCart.value = true;

      // Get the cart controller
      final cartController = Get.find<CartController>();

      // Get the selected variant ID or fallback to first variant
      final variantId =
          selectedVariant.value?.id ??
          product.value!.variants?.first.id ??
          product.value!.id;

      // Add to cart
      final success = await cartController.addToCart(
        product.value!.id,
        variantId,
        quantity: quantity.value,
      );

      if (success) {
        debugPrint('Successfully added ${product.value!.title} to cart');
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isAddingToCart.value = false;
    }
  }

  // Refresh product data
  @override
  Future<void> refresh() async {
    if (product.value != null) {
      await loadProduct(product.value!.id);
    }
  }

  // Load favorite status for the current product
  Future<void> _loadFavoriteStatus() async {
    final currentProduct = product.value;
    if (currentProduct == null) return;

    try {
      final favoritesController = Get.find<FavoritesController>();
      await favoritesController.loadFavoriteStatus(currentProduct.id);
      isFavorite.value = favoritesController.isFavorite(currentProduct.id);
    } catch (e) {
      debugPrint('Error loading favorite status: $e');
      isFavorite.value = false;
    }
  }

  // Share functionality
  Future<void> shareProduct() async {
    final currentProduct = product.value;
    if (currentProduct == null) return;

    try {
      final productUrl = 'https://onemart.app/product/${currentProduct.id}';
      final shareText =
          '''
Check out this amazing product!

${currentProduct.title}
${currentProduct.displayPrice}

${currentProduct.description ?? 'Great product with excellent features.'}

Shop now: $productUrl

#OneMart #Shopping #${currentProduct.categories?.first.name.replaceAll(' ', '') ?? 'Product'}
'''
              .trim();

      await Share.share(
        shareText,
        subject: 'Check out ${currentProduct.title} on OneMart',
      );

      debugPrint('Product shared successfully');
    } catch (e) {
      debugPrint('Error sharing product: $e');
      Get.snackbar(
        'Error',
        'Failed to share product',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Mock data for demo purposes - loads actual product from mock data
  Future<Product> _getMockProduct(String productId) async {
    try {
      // Use the mock data service to get the actual product
      final mockService = MockDataService();

      // Use the proper async method to get product by ID
      final product = await mockService.getProductById(productId);

      if (product != null) {
        return product;
      }

      // If product not found, get the first available product
      final products = await mockService.getProducts(limit: 1);
      if (products.isNotEmpty) {
        return products.first;
      }

      // If no products available, generate a fallback
      throw Exception('No products available');
    } catch (e) {
      debugPrint('Error loading mock product: $e');
      // Fallback to hardcoded product if mock service fails
      return Product(
        id: productId,
        title: 'Premium Wireless Headphones',
        description:
            'High-quality wireless headphones with noise cancellation.',
        thumbnail:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop&crop=center',
        images: [
          ProductImage(
            id: 'img_1',
            url:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop&crop=center',
          ),
        ],
        variants: [
          ProductVariant(
            id: 'variant_1',
            title: 'Black - Standard',
            prices: [
              ProductVariantPrice(
                id: 'price_1',
                currencyCode: 'INR',
                amount: 2999900,
              ),
            ],
          ),
        ],
        categories: [ProductCategory(id: 'electronics', name: 'Electronics')],
      );
    }
  }

  // Variant selection methods
  void selectColor(String color) {
    selectedColor.value = color;
    _updateSelectedVariant();
  }

  void selectSize(String size) {
    selectedSize.value = size;
    _updateSelectedVariant();
  }

  void _updateSelectedVariant() {
    final currentProduct = product.value;
    if (currentProduct?.variants == null) return;

    // Find variant that matches selected color and size
    ProductVariant? matchingVariant;

    for (final variant in currentProduct!.variants!) {
      final colorMatches =
          selectedColor.value.isEmpty || variant.color == selectedColor.value;
      final sizeMatches =
          selectedSize.value.isEmpty || variant.size == selectedSize.value;

      if (colorMatches && sizeMatches) {
        matchingVariant = variant;
        break;
      }
    }

    // If no exact match, try to find partial matches
    if (matchingVariant == null) {
      for (final variant in currentProduct.variants!) {
        if (selectedColor.value.isNotEmpty &&
            variant.color == selectedColor.value) {
          matchingVariant = variant;
          break;
        }
        if (selectedSize.value.isNotEmpty &&
            variant.size == selectedSize.value) {
          matchingVariant = variant;
          break;
        }
      }
    }

    // Fallback to first variant if no match found
    selectedVariant.value = matchingVariant ?? currentProduct.variants!.first;
  }

  // Initialize variant selection when product is loaded
  void _initializeVariantSelection() {
    final currentProduct = product.value;
    if (currentProduct?.variants == null || currentProduct!.variants!.isEmpty) {
      return;
    }

    // Set default selections to first available options
    final firstVariant = currentProduct.variants!.first;
    if (firstVariant.color != null && selectedColor.value.isEmpty) {
      selectedColor.value = firstVariant.color!;
    }
    if (firstVariant.size != null && selectedSize.value.isEmpty) {
      selectedSize.value = firstVariant.size!;
    }

    _updateSelectedVariant();
  }

  // Reset controller state
  void reset() {
    product.value = null;
    quantity.value = 1;
    isFavorite.value = false;
    relatedProducts.clear();
    error.value = null;
    isLoading.value = false;
    selectedColor.value = '';
    selectedSize.value = '';
    selectedVariant.value = null;
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
