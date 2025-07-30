import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/ui_models.dart';
import '../services/order_service.dart';

class OrderStatisticsWidget extends StatefulWidget {
  final UIComponent component;

  const OrderStatisticsWidget({
    super.key,
    required this.component,
  });

  @override
  State<OrderStatisticsWidget> createState() => _OrderStatisticsWidgetState();
}

class _OrderStatisticsWidgetState extends State<OrderStatisticsWidget> {
  late final OrderService _orderService;
  Map<String, dynamic> _statistics = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _orderService = OrderService();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stats = await _orderService.getOrderStatistics();
      
      if (kDebugMode) {
        debugPrint('[OrderStatisticsWidget] Loaded statistics: $stats');
      }

      setState(() {
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrderStatisticsWidget] Error loading statistics: $e');
      }
      
      setState(() {
        _error = 'Failed to load statistics: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Error loading statistics',
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    if (_statistics.isEmpty) {
      return const SizedBox.shrink();
    }

    final showTotalOrders = widget.component.properties?['showTotalOrders'] as bool? ?? true;
    final showTotalSpent = widget.component.properties?['showTotalSpent'] as bool? ?? true;
    final showCompletedOrders = widget.component.properties?['showCompletedOrders'] as bool? ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (showTotalOrders) ...[
              Expanded(
                child: _buildStatCard(
                  'Total Orders',
                  '${_statistics['total_orders'] ?? 0}',
                  Icons.shopping_cart,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (showCompletedOrders) ...[
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  '${_statistics['completed_orders'] ?? 0}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              if (showTotalSpent) const SizedBox(width: 12),
            ],
            if (showTotalSpent)
              Expanded(
                child: _buildStatCard(
                  'Total Spent',
                  _statistics['formatted_revenue'] ?? '₹0.00',
                  Icons.account_balance_wallet,
                  Colors.orange,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
