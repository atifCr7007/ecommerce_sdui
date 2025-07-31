import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/ui_models.dart';
import '../utils/json_ui_parser.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  UIScreen? _ordersScreen;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrdersScreen();
  }

  Future<void> _loadOrdersScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      if (kDebugMode) {
        debugPrint('[OrdersView] Loading orders screen JSON...');
      }

      // Load the orders screen JSON
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/orders.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      if (kDebugMode) {
        debugPrint('[OrdersView] ===== ORDERS JSON UI =====');
        debugPrint('[OrdersView] JSON Content: $jsonString');
        debugPrint('[OrdersView] Parsed Data: $jsonData');
        debugPrint('[OrdersView] ===========================');
      }

      setState(() {
        _ordersScreen = UIScreen.fromJson(jsonData);
        _isLoading = false;
      });

      if (kDebugMode) {
        debugPrint('[OrdersView] Orders screen loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OrdersView] Error loading orders screen: $e');
      }
      setState(() {
        _error = 'Failed to load orders screen: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadOrdersScreen,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_ordersScreen == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
        body: const Center(child: Text('No content available')),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('My Orders'),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       onPressed: _loadOrdersScreen,
      //       icon: const Icon(Icons.refresh),
      //       tooltip: 'Refresh',
      //     ),
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: _loadOrdersScreen,
        child: _buildOrdersContent(),
      ),
    );
  }

  Widget _buildOrdersContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: JsonUIParser.parseScreen(_ordersScreen!, context),
    );
  }
}
