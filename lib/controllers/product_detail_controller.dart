import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../controllers/home_controller.dart';

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

  // Load product details
  Future<void> loadProduct(String productId) async {
    isLoading.value = true;
    error.value = null;

    try {
      await Future.wait([_fetchProduct(productId), _fetchRelatedProducts()]);
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
        } else {
          throw Exception('Product not found');
        }
      } else {
        throw Exception('Failed to fetch product: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching product: $e');
      // Use mock data for demo purposes
      product.value = _getMockProduct(productId);
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
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;

    // In a real app, this would sync with backend
    _saveFavoriteStatus();
  }

  // Cart management
  void addToCart() {
    if (product.value == null) return;

    // In a real app, this would add to cart via API
    debugPrint(
      'Adding ${product.value!.title} to cart (quantity: ${quantity.value})',
    );

    // Show success message or navigate to cart
    _showAddToCartSuccess();
  }

  // Refresh product data
  @override
  Future<void> refresh() async {
    if (product.value != null) {
      await loadProduct(product.value!.id);
    }
  }

  void _saveFavoriteStatus() {
    // In a real app, this would save to local storage or API
    debugPrint(
      'Favorite status for ${product.value?.title}: ${isFavorite.value}',
    );
  }

  void _showAddToCartSuccess() {
    // In a real app, this would show a snackbar or navigate to cart
    debugPrint('Product added to cart successfully!');
  }

  // Mock data for demo purposes
  Product _getMockProduct(String productId) {
    return Product(
      id: productId,
      title: 'Premium Wireless Headphones',
      description:
          '''
Experience crystal-clear audio with our premium wireless headphones. 
Featuring advanced noise cancellation technology, 30-hour battery life, 
and comfortable over-ear design perfect for long listening sessions.

Key Features:
• Active Noise Cancellation
• 30-hour battery life
• Premium leather ear cushions
• Bluetooth 5.0 connectivity
• Quick charge: 15 min = 3 hours playback
• Foldable design for easy storage

Perfect for music lovers, professionals, and anyone who values high-quality audio.
      '''
              .trim(),
      thumbnail:
          'https://via.placeholder.com/400x400/2196F3/FFFFFF?text=Premium+Headphones',
      images: [
        ProductImage(
          id: 'img_1',
          url:
              'https://via.placeholder.com/400x400/2196F3/FFFFFF?text=Premium+Headphones',
        ),
        ProductImage(
          id: 'img_2',
          url:
              'https://via.placeholder.com/400x400/4CAF50/FFFFFF?text=Side+View',
        ),
        ProductImage(
          id: 'img_3',
          url:
              'https://via.placeholder.com/400x400/FF9800/FFFFFF?text=Detail+View',
        ),
      ],
      variants: [
        ProductVariant(
          id: 'variant_1',
          title: 'Black - Standard',
          prices: [
            ProductVariantPrice(
              id: 'price_1',
              currencyCode: 'USD',
              amount: 29999, // $299.99 in cents
            ),
          ],
        ),
      ],
      categories: [ProductCategory(id: 'cat_electronics', name: 'Electronics')],
    );
  }

  // Reset controller state
  void reset() {
    product.value = null;
    quantity.value = 1;
    isFavorite.value = false;
    relatedProducts.clear();
    error.value = null;
    isLoading.value = false;
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
