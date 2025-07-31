import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/models/checkout.dart';
import 'package:ecommerce_sdui/mock_data/mock_service.dart';
import 'package:ecommerce_sdui/config/app_config.dart';

class OrdersController extends GetxController {
  final MockDataService _mockDataService = MockDataService();

  // Observable state
  final isLoading = false.obs;
  final error = RxnString();
  final orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  /// Load all orders
  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      error.value = null;

      debugPrint('[OrdersController] Loading orders...');

      if (AppConfig.useMockData) {
        final ordersList = await _mockDataService.getOrders();
        orders.value = ordersList;
        debugPrint('[OrdersController] Loaded ${ordersList.length} orders from mock service');
      } else {
        // TODO: Implement real API call
        orders.value = [];
      }

    } catch (e) {
      error.value = 'Failed to load orders: $e';
      debugPrint('[OrdersController] Error loading orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get order by ID
  Future<Order?> getOrder(String orderId) async {
    try {
      debugPrint('[OrdersController] Getting order: $orderId');
      
      if (AppConfig.useMockData) {
        return await _mockDataService.getOrder(orderId);
      } else {
        // TODO: Implement real API call
        return null;
      }
    } catch (e) {
      debugPrint('[OrdersController] Error getting order: $e');
      return null;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      isLoading.value = true;
      error.value = null;

      debugPrint('[OrdersController] Updating order status: $orderId -> $status');

      if (AppConfig.useMockData) {
        final response = await _mockDataService.updateOrderStatus(orderId, status);
        
        // Update the order in the local list
        final orderIndex = orders.indexWhere((order) => order.id == orderId);
        if (orderIndex != -1) {
          orders[orderIndex] = response.order;
          orders.refresh(); // Trigger UI update
        }
        
        debugPrint('[OrdersController] Order status updated successfully');
        return true;
      } else {
        // TODO: Implement real API call
        return false;
      }
    } catch (e) {
      error.value = 'Failed to update order status: $e';
      debugPrint('[OrdersController] Error updating order status: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh orders
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  /// Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }

  /// Get order statistics
  Map<String, dynamic> getOrderStatistics() {
    final totalOrders = orders.length;
    final completedOrders = orders.where((order) => order.status == OrderStatus.delivered).length;
    final pendingOrders = orders.where((order) => 
      order.status == OrderStatus.pending || 
      order.status == OrderStatus.confirmed ||
      order.status == OrderStatus.processing ||
      order.status == OrderStatus.shipped
    ).length;
    
    final totalRevenue = orders
        .where((order) => order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + (order.total / 100));

    return {
      'total_orders': totalOrders,
      'completed_orders': completedOrders,
      'pending_orders': pendingOrders,
      'total_revenue': totalRevenue,
      'formatted_revenue': '₹${totalRevenue.toStringAsFixed(2)}',
    };
  }

  /// Format order status for display
  String getOrderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get status color
  Color getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
