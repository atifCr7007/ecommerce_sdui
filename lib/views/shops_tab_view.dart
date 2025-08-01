import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/utils/stac.dart';
import 'package:ecommerce_sdui/utils/debug_logger.dart';

class ShopsTabView extends StatefulWidget {
  const ShopsTabView({super.key});

  @override
  State<ShopsTabView> createState() => _ShopsTabViewState();
}

class _ShopsTabViewState extends State<ShopsTabView> {
  Map<String, dynamic>? _shopsUIConfig;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShopsTabUI();
  }

  Future<void> _loadShopsTabUI() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      DebugLogger.jsonParsing('ShopsTabView loading shops tab UI configuration');

      // Load shops tab UI configuration from dedicated JSON file
      final String jsonString = await rootBundle.loadString('assets/json_ui/shops_tab.json');
      DebugLogger.jsonParsing('Loaded shops tab UI from shops_tab.json');

      final dynamic decodedJson = json.decode(jsonString);
      if (decodedJson is! Map<String, dynamic>) {
        throw Exception('Invalid JSON format');
      }

      setState(() {
        _shopsUIConfig = decodedJson;
        _isLoading = false;
      });

      DebugLogger.jsonParsing('ShopsTabView loaded successfully');
    } catch (e) {
      setState(() {
        _error = 'Failed to load shops tab: $e';
        _isLoading = false;
      });
      DebugLogger.jsonParsing('ShopsTabView error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadShopsTabUI,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_shopsUIConfig == null) {
      return const Center(
        child: Text('Shops tab configuration not available'),
      );
    }

    return Stac.fromJson(_shopsUIConfig!, context);
  }
}
