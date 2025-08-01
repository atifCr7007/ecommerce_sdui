import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cart_service.dart';
import '../services/payment_service.dart';
import '../services/order_service.dart';
import '../mock_data/mock_service.dart';
import '../config/app_config.dart';
import '../utils/debug_logger.dart';

class CartController extends GetxController {
  // Services
  late final CartService _cartService;
  late final MockDataService _mockDataService;
  late final PaymentService _paymentService;
  late final OrderService _orderService;

  // State variables - GetX observables
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final Rxn<Cart> cart = Rxn<Cart>();
  final RxString cartId = ''.obs;
  final RxBool isAddingToCart = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxnString currentShopId = RxnString();
  final RxnString currentShopName = RxnString();

  // Getters
  int get itemCount => cart.value?.items.length ?? 0;
  int get totalQuantity =>
      cart.value?.items.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;
  String get formattedTotal => cart.value?.formattedTotal ?? '\$0.00';
  String get formattedSubtotal => cart.value?.formattedSubtotal ?? '\$0.00';

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      debugPrint('[CartController] Initializing cart controller...');
    }
    _initializeServices();
    _loadCartId();
  }

  void _initializeServices() {
    try {
      _cartService = CartService();
      _mockDataService = MockDataService();
      _paymentService = PaymentService();
      _orderService = OrderService();
      if (kDebugMode) {
        debugPrint('[CartController] Services initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartController] Error initializing services: $e');
      }
      rethrow;
    }
  }

  Future<void> _loadCartId() async {
    try {
      if (kDebugMode) {
        debugPrint('[CartController] Loading cart ID from preferences...');
      }

      final prefs = await SharedPreferences.getInstance();
      final savedCartId = prefs.getString('cart_id');

      if (savedCartId != null && savedCartId.isNotEmpty) {
        cartId.value = savedCartId;
        if (kDebugMode) {
          debugPrint('[CartController] Found existing cart ID: $savedCartId');
        }
        await loadCart();
      } else {
        if (kDebugMode) {
          debugPrint(
            '[CartController] No existing cart ID found, creating new cart',
          );
        }
        await createNewCart();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartController] Error loading cart ID: $e');
      }
      await createNewCart();
    }
  }

  Future<void> createNewCart() async {
    try {
      isLoading.value = true;
      error.value = null;

      if (AppConfig.useMockData) {
        // For mock data, generate a cart ID
        cartId.value = 'cart_${DateTime.now().millisecondsSinceEpoch}';
        cart.value = Cart(
          id: cartId.value,
          items: [],
          subtotal: 0,
          total: 0,
          currencyCode: 'INR',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        final response = await _cartService.createCart();
        cart.value = response.cart;
        cartId.value = response.cart.id;
      }

      // Save cart ID to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_id', cartId.value);
    } catch (e) {
      error.value = 'Failed to create cart: $e';
      debugPrint('Error creating cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCart() async {
    if (cartId.value.isEmpty) return;

    try {
      isLoading.value = true;
      error.value = null;

      if (AppConfig.useMockData) {
        final response = await _mockDataService.getCart(cartId.value);
        cart.value = response.cart;
      } else {
        final response = await _cartService.getCart(cartId.value);
        cart.value = response.cart;
      }
    } catch (e) {
      error.value = 'Failed to load cart: $e';
      debugPrint('Error loading cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Set the current shop context for the cart
  void setShopContext(String shopId, String shopName) {
    currentShopId.value = shopId;
    currentShopName.value = shopName;
    if (kDebugMode) {
      debugPrint('[CartController] Set shop context: $shopName ($shopId)');
    }
  }

  /// Clear the shop context
  void clearShopContext() {
    currentShopId.value = null;
    currentShopName.value = null;
    if (kDebugMode) {
      debugPrint('[CartController] Cleared shop context');
    }
  }

  Future<bool> addToCart(
    String productId,
    String variantId, {
    int quantity = 1,
    String? shopId,
    String? shopName,
  }) async {
    try {
      DebugLogger.cartOperation(
        'Adding item to cart',
        productId: productId,
        variantId: variantId,
        quantity: quantity,
      );

      isAddingToCart.value = true;
      error.value = null;

      // Set shop context if provided
      if (shopId != null && shopName != null) {
        setShopContext(shopId, shopName);
      }

      if (cartId.value.isEmpty) {
        if (kDebugMode) {
          debugPrint('[CartController] No cart ID found, creating new cart');
        }
        await createNewCart();
      }

      if (AppConfig.useMockData) {
        if (kDebugMode) {
          debugPrint(
            '[CartController] Using mock data service for add to cart',
          );
        }
        final response = await _mockDataService.addToCart(
          productId,
          variantId,
          quantity: quantity,
          cartId: cartId.value,
        );
        cart.value = response.cart;
      } else {
        if (kDebugMode) {
          debugPrint(
            '[CartController] Using real cart service for add to cart',
          );
        }
        final response = await _cartService.addToCart(
          productId,
          variantId,
          quantity: quantity,
          cartId: cartId.value,
        );
        cart.value = response.cart;
      }

      DebugLogger.cartOperation(
        'Successfully added item to cart',
        productId: productId,
        variantId: variantId,
        quantity: quantity,
        totalItems: itemCount,
        totalAmount: cart.value?.total.toDouble(),
      );

      // Show success message with better styling
      Get.snackbar(
        'Success',
        'Item added to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      return true;
    } catch (e) {
      error.value = 'Failed to add item to cart: $e';
      if (kDebugMode) {
        debugPrint('[CartController] Error adding to cart: $e');
      }

      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      return false;
    } finally {
      isAddingToCart.value = false;
    }
  }

  Future<bool> updateQuantity(String lineItemId, int quantity) async {
    if (cartId.value.isEmpty) return false;

    try {
      isLoading.value = true;
      error.value = null;

      if (AppConfig.useMockData) {
        final response = await _mockDataService.updateCartItemQuantity(
          cartId.value,
          lineItemId,
          quantity,
        );
        cart.value = response.cart;
      } else {
        final response = await _cartService.updateCartItem(
          cartId.value,
          lineItemId,
          quantity,
        );
        cart.value = response.cart;
      }

      return true;
    } catch (e) {
      error.value = 'Failed to update item: $e';
      debugPrint('Error updating cart item: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> removeItem(String lineItemId) async {
    if (cartId.value.isEmpty) return false;

    try {
      isLoading.value = true;
      error.value = null;

      if (AppConfig.useMockData) {
        final response = await _mockDataService.removeCartItem(
          cartId.value,
          lineItemId,
        );
        cart.value = response.cart;
      } else {
        final response = await _cartService.removeFromCart(
          cartId.value,
          lineItemId,
        );
        cart.value = response.cart;
      }

      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      return true;
    } catch (e) {
      error.value = 'Failed to remove item: $e';
      debugPrint('Error removing cart item: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearCart() async {
    if (cartId.value.isEmpty) return;

    try {
      isLoading.value = true;
      error.value = null;

      if (AppConfig.useMockData) {
        await createNewCart();
      } else {
        final response = await _cartService.clearCart(cartId.value);
        cart.value = response.cart;
      }

      // Clear shop context when cart is cleared
      clearShopContext();

      Get.snackbar(
        'Success',
        'Cart cleared',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = 'Failed to clear cart: $e';
      debugPrint('Error clearing cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Process payment for current cart
  Future<bool> processPayment({
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    Map<String, dynamic>? shippingAddress,
    Map<String, dynamic>? billingAddress,
    String? customerNotes,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint(
          '[CartController] Starting payment process for customer: $customerName',
        );
      }

      final currentCart = cart.value;
      if (currentCart == null || currentCart.items.isEmpty) {
        error.value = 'Cart is empty';
        return false;
      }

      isProcessingPayment.value = true;
      error.value = null;

      // Process payment through Razorpay
      final paymentResult = await _paymentService.processPayment(
        cart: currentCart,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        description:
            'Purchase from SDUI E-commerce - ${currentCart.items.length} items',
      );

      if (paymentResult.success) {
        if (kDebugMode) {
          debugPrint(
            '[CartController] Payment successful: ${paymentResult.paymentId}',
          );
        }

        // Create order record
        final order = await _orderService.createOrder(
          cart: currentCart,
          paymentResult: paymentResult,
          shippingAddress: shippingAddress,
          billingAddress: billingAddress,
          customerNotes: customerNotes,
        );

        if (kDebugMode) {
          debugPrint(
            '[CartController] Order created successfully: ${order.id}',
          );
        }

        // Clear cart after successful payment
        await clearCart();

        // Show success message
        Get.snackbar(
          'Payment Successful!',
          'Your order has been placed successfully. Order ID: ${order.id}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        // Navigate to order confirmation
        Get.toNamed('/order-confirmation', arguments: order);

        return true;
      } else {
        if (kDebugMode) {
          debugPrint(
            '[CartController] Payment failed: ${paymentResult.errorMessage}',
          );
        }

        error.value = paymentResult.errorMessage ?? 'Payment failed';

        // Show error message
        Get.snackbar(
          'Payment Failed',
          paymentResult.errorMessage ??
              'Payment could not be processed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CartController] Error processing payment: $e');
      }

      error.value = 'Payment processing failed: $e';

      Get.snackbar(
        'Error',
        'An error occurred while processing payment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      return false;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  @override
  void onClose() {
    _cartService.dispose();
    _paymentService.dispose();
    super.onClose();
  }
}
