import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../services/cart_service.dart';
import '../services/payment_service.dart';

class OrderService {
  static const String _ordersKey = 'user_orders';
  static const String _orderCounterKey = 'order_counter';

  /// Create a new order from cart and payment result
  Future<Order> createOrder({
    required Cart cart,
    required PaymentResult paymentResult,
    Map<String, dynamic>? shippingAddress,
    Map<String, dynamic>? billingAddress,
    String? customerNotes,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint(
          '[OrderService] Creating order from cart with ${cart.items.length} items',
        );
      }

      // Generate unique order ID
      final orderId = await _generateOrderId();

      // Calculate amounts
      final subtotal = cart.subtotalAmount;
      final tax = subtotal * 0.18; // 18% GST
      final shipping = subtotal > 500 ? 0.0 : 50.0; // Free shipping above ₹500
      final total = subtotal + tax + shipping;

      // Create order
      final order = Order(
        id: orderId,
        paymentId: paymentResult.paymentId ?? '',
        razorpayOrderId: paymentResult.orderId,
        razorpaySignature: paymentResult.signature,
        items: List.from(cart.items), // Create a copy of cart items
        totalAmount: total,
        subtotalAmount: subtotal,
        taxAmount: tax,
        shippingAmount: shipping,
        paymentStatus: paymentResult.success
            ? PaymentStatus.completed
            : PaymentStatus.failed,
        orderStatus: OrderStatus.placed,
        createdAt: DateTime.now(),
        currency: 'INR',
        shippingAddress: shippingAddress,
        billingAddress: billingAddress,
        customerNotes: customerNotes,
        paymentDetails: {
          'payment_method': 'razorpay',
          'payment_id': paymentResult.paymentId,
          'order_id': paymentResult.orderId,
          'signature': paymentResult.signature,
          'success': paymentResult.success,
          'error_message': paymentResult.errorMessage,
          'error_details': paymentResult.errorDetails,
        },
      );

      // Save order to local storage
      await _saveOrder(order);

      if (kDebugMode) {
        debugPrint('[OrderService] Order created successfully: ${order.id}');
      }

      return order;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Error creating order: $e');
      }
      rethrow;
    }
  }

  /// Get all orders for the user
  Future<List<Order>> getOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getStringList(_ordersKey) ?? [];

      final orders = ordersJson
          .map((orderJson) => Order.fromJson(jsonDecode(orderJson)))
          .toList();

      // Sort by creation date (newest first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (kDebugMode) {
        debugPrint('[OrderService] Retrieved ${orders.length} orders');
      }

      return orders;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Error retrieving orders: $e');
      }
      return [];
    }
  }

  /// Get a specific order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      final orders = await getOrders();
      return orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw Exception('Order not found'),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Order not found: $orderId');
      }
      return null;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final orders = await getOrders();
      final orderIndex = orders.indexWhere((order) => order.id == orderId);

      if (orderIndex == -1) {
        if (kDebugMode) {
          debugPrint(
            '[OrderService] Order not found for status update: $orderId',
          );
        }
        return false;
      }

      // Update the order
      orders[orderIndex] = orders[orderIndex].copyWith(
        orderStatus: newStatus,
        updatedAt: DateTime.now(),
      );

      // Save updated orders
      await _saveAllOrders(orders);

      if (kDebugMode) {
        debugPrint(
          '[OrderService] Order status updated: $orderId -> ${newStatus.name}',
        );
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Error updating order status: $e');
      }
      return false;
    }
  }

  /// Update payment status
  Future<bool> updatePaymentStatus(
    String orderId,
    PaymentStatus newStatus,
  ) async {
    try {
      final orders = await getOrders();
      final orderIndex = orders.indexWhere((order) => order.id == orderId);

      if (orderIndex == -1) {
        if (kDebugMode) {
          debugPrint(
            '[OrderService] Order not found for payment status update: $orderId',
          );
        }
        return false;
      }

      // Update the order
      orders[orderIndex] = orders[orderIndex].copyWith(
        paymentStatus: newStatus,
        updatedAt: DateTime.now(),
      );

      // Save updated orders
      await _saveAllOrders(orders);

      if (kDebugMode) {
        debugPrint(
          '[OrderService] Payment status updated: $orderId -> ${newStatus.name}',
        );
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Error updating payment status: $e');
      }
      return false;
    }
  }

  /// Get orders by status
  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    final orders = await getOrders();
    return orders.where((order) => order.orderStatus == status).toList();
  }

  /// Get orders by payment status
  Future<List<Order>> getOrdersByPaymentStatus(PaymentStatus status) async {
    final orders = await getOrders();
    return orders.where((order) => order.paymentStatus == status).toList();
  }

  /// Clear all orders (for testing purposes)
  Future<void> clearAllOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_ordersKey);
      await prefs.remove(_orderCounterKey);

      if (kDebugMode) {
        debugPrint('[OrderService] All orders cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Error clearing orders: $e');
      }
    }
  }

  /// Save a single order
  Future<void> _saveOrder(Order order) async {
    final orders = await getOrders();
    orders.add(order);
    await _saveAllOrders(orders);
  }

  /// Save all orders to local storage
  Future<void> _saveAllOrders(List<Order> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = orders
          .map((order) => jsonEncode(order.toJson()))
          .toList();

      await prefs.setStringList(_ordersKey, ordersJson);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Error saving orders: $e');
      }
      rethrow;
    }
  }

  /// Generate unique order ID
  Future<String> _generateOrderId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final counter = prefs.getInt(_orderCounterKey) ?? 1000;
      final newCounter = counter + 1;

      await prefs.setInt(_orderCounterKey, newCounter);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'ORD${newCounter}_$timestamp';
    } catch (e) {
      // Fallback to timestamp-based ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'ORD_$timestamp';
    }
  }

  /// Get order statistics
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final orders = await getOrders();

      final totalOrders = orders.length;
      final completedOrders = orders
          .where((o) => o.paymentStatus == PaymentStatus.completed)
          .length;
      final totalRevenue = orders
          .where((o) => o.paymentStatus == PaymentStatus.completed)
          .fold(0.0, (sum, order) => sum + order.totalAmount);

      return {
        'total_orders': totalOrders,
        'completed_orders': completedOrders,
        'pending_orders': totalOrders - completedOrders,
        'total_revenue': totalRevenue,
        'formatted_revenue': PaymentService.formatCurrency(totalRevenue),
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderService] Error getting statistics: $e');
      }
      return {};
    }
  }
}
