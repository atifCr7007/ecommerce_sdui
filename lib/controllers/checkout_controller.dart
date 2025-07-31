import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/models/checkout.dart';
import 'package:ecommerce_sdui/services/cart_service.dart';
import 'package:ecommerce_sdui/controllers/cart_controller.dart';
import 'package:ecommerce_sdui/mock_data/mock_service.dart';
import 'package:ecommerce_sdui/config/app_config.dart';

class CheckoutController extends GetxController {
  final MockDataService _mockDataService = MockDataService();
  final CartController _cartController = Get.find<CartController>();

  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final couponController = TextEditingController();

  // Form validation
  final formKey = GlobalKey<FormState>();

  // Observable state
  final isLoading = false.obs;
  final error = RxnString();
  final selectedPaymentMode = Rxn<PaymentMode>();
  final selectedPaymentType = PaymentType.online.obs;
  final appliedCoupon = Rxn<CouponInfo>();
  final orderSummary = Rxn<OrderSummary>();

  // Available payment modes
  final List<PaymentMode> onlinePaymentModes = [
    PaymentMode.creditCard,
    PaymentMode.debitCard,
    PaymentMode.upi,
    PaymentMode.netBanking,
  ];

  final List<PaymentMode> offlinePaymentModes = [PaymentMode.cashOnDelivery];

  @override
  void onInit() {
    super.onInit();

    // Initial calculation with delay to ensure cart is loaded
    Future.delayed(const Duration(milliseconds: 100), () {
      _calculateOrderSummary();
    });

    // Listen to cart changes with null safety
    ever(_cartController.cart, (cart) {
      if (cart != null) {
        _calculateOrderSummary();
      }
    });

    // Listen to coupon changes
    ever(appliedCoupon, (_) => _calculateOrderSummary());
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    couponController.dispose();
    super.onClose();
  }

  /// Calculate order summary with discounts
  void _calculateOrderSummary() {
    final cart = _cartController.cart.value;
    if (cart == null) return;

    final subtotal = cart.subtotal;
    final itemCount = cart.items.fold(0, (sum, item) => sum + item.quantity);

    int discountAmount = 0;
    if (appliedCoupon.value != null) {
      discountAmount = appliedCoupon.value!.discountAmount;
    }

    final total = subtotal - discountAmount;

    orderSummary.value = OrderSummary(
      subtotal: subtotal,
      discountAmount: discountAmount,
      total: total > 0 ? total : 0,
      itemCount: itemCount,
      currencyCode: cart.currencyCode,
      appliedCoupon: appliedCoupon.value,
    );
  }

  /// Validate and apply coupon code
  Future<void> applyCoupon(String code) async {
    if (code.trim().isEmpty) {
      removeCoupon();
      return;
    }

    try {
      isLoading.value = true;
      error.value = null;

      // Mock coupon validation - in real app, this would be an API call
      if (code.toUpperCase() == 'ECOM') {
        final cart = _cartController.cart.value;
        if (cart != null) {
          final discountPercentage = 30.0;
          final discountAmount = ((cart.subtotal * discountPercentage) / 100)
              .round();

          appliedCoupon.value = CouponInfo(
            code: code.toUpperCase(),
            name: 'ECOM 30% Off',
            discountPercentage: discountPercentage,
            discountAmount: discountAmount,
            isValid: true,
          );

          Get.snackbar(
            'Success',
            'Coupon applied! You saved ₹${(discountAmount / 100).toStringAsFixed(2)}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        error.value = 'Invalid coupon code';
        Get.snackbar(
          'Error',
          'Invalid coupon code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      error.value = 'Failed to apply coupon: $e';
      debugPrint('Error applying coupon: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove applied coupon
  void removeCoupon() {
    appliedCoupon.value = null;
    couponController.clear();
    Get.snackbar(
      'Info',
      'Coupon removed',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Set payment type and reset payment mode
  void setPaymentType(PaymentType type) {
    selectedPaymentType.value = type;
    selectedPaymentMode.value = null; // Reset payment mode when type changes
  }

  /// Set payment mode
  void setPaymentMode(PaymentMode mode) {
    selectedPaymentMode.value = mode;
  }

  /// Validate form
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (selectedPaymentMode.value == null) {
      Get.snackbar(
        'Error',
        'Please select a payment method',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  /// Create delivery details from form
  DeliveryDetails _createDeliveryDetails() {
    return DeliveryDetails(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      mobileNumber: mobileController.text.trim(),
      deliveryAddress: addressController.text.trim(),
    );
  }

  /// Process checkout
  Future<void> processCheckout() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      error.value = null;

      final deliveryDetails = _createDeliveryDetails();
      final cart = _cartController.cart.value;

      if (cart == null || cart.items.isEmpty) {
        throw Exception('Cart is empty');
      }

      // Create order items from cart items
      final orderItems = cart.items
          .map((item) => OrderItem.fromCartItem(item))
          .toList();

      // Create order
      final order = Order(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        items: orderItems,
        deliveryDetails: deliveryDetails,
        paymentMode: selectedPaymentMode.value!,
        paymentType: selectedPaymentType.value,
        status: OrderStatus.pending,
        subtotal: orderSummary.value!.subtotal,
        discountAmount: orderSummary.value!.discountAmount,
        total: orderSummary.value!.total,
        currencyCode: orderSummary.value!.currencyCode,
        appliedCoupon: appliedCoupon.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (selectedPaymentType.value == PaymentType.offline) {
        // For offline payment (COD), confirm order directly
        await _confirmOrder(order);
      } else {
        // For online payment, navigate to payment gateway
        await _processOnlinePayment(order);
      }
    } catch (e) {
      error.value = 'Checkout failed: $e';
      debugPrint('Error during checkout: $e');
      Get.snackbar(
        'Error',
        'Checkout failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Confirm order (for offline payments)
  Future<void> _confirmOrder(Order order) async {
    try {
      // Save order to mock service
      final response = await _mockDataService.createOrder(order);
      debugPrint('[CheckoutController] Order created: ${response.order.id}');

      // Clear cart
      await _cartController.clearCart();
      debugPrint('[CheckoutController] Cart cleared after order creation');

      // Show success message
      Get.snackbar(
        'Success',
        'Order placed successfully! Order ID: ${order.id}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Navigate back to home and then to orders tab
      Get.back(); // Go back to cart
      Get.back(); // Go back to home

      // Switch to orders tab (index 3 in bottom navigation)
      // This assumes the main app has a way to switch tabs
      // For now, just navigate back to home
    } catch (e) {
      debugPrint('[CheckoutController] Error confirming order: $e');
      Get.snackbar(
        'Error',
        'Failed to place order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Process online payment
  Future<void> _processOnlinePayment(Order order) async {
    // Navigate to payment gateway with order data
    final result = await Get.toNamed(
      '/payment',
      arguments: {'order': order, 'amount': orderSummary.value!.total},
    );

    if (result == true) {
      // Payment successful
      final confirmedOrder = order.copyWith(status: OrderStatus.confirmed);
      await _confirmOrder(confirmedOrder);
    }
  }
}
