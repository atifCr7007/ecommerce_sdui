import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/marketplace_controller.dart';
import '../models/ui_models.dart';
import '../utils/json_ui_parser.dart';
import '../utils/debug_logger.dart';

class MarketplaceView extends StatefulWidget {
  final String? shopId; // Optional shop ID for navigation

  const MarketplaceView({super.key, this.shopId});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  UIScreen? _marketplaceScreen;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMarketplaceScreen();
  }

  Future<void> _loadMarketplaceScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      DebugLogger.jsonParsing(
        'Loading marketplace screen JSON',
        componentType: 'screen',
        screenId: 'marketplace_screen',
      );

      // Load the marketplace screen JSON
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/marketplace.json',
      );

      // Parse JSON with validation
      Map<String, dynamic> jsonData;
      try {
        jsonData = json.decode(jsonString) as Map<String, dynamic>;
        DebugLogger.jsonParsing(
          'Successfully parsed marketplace JSON data',
          componentType: 'screen',
        );
      } catch (parseError) {
        DebugLogger.jsonParsing(
          'JSON parsing error: $parseError',
          componentType: 'screen',
          error: parseError,
        );
        throw Exception('Failed to parse marketplace.json: $parseError');
      }

      // Validate required fields
      if (!jsonData.containsKey('screen') ||
          !jsonData['screen'].containsKey('components')) {
        throw Exception(
          'Invalid marketplace.json structure: missing required fields',
        );
      }

      DebugLogger.jsonParsing(
        'Marketplace screen JSON loaded successfully',
        componentType: 'screen',
        screenId: jsonData['screen']['screenId'] as String?,
        componentCount: (jsonData['screen']['components'] as List?)?.length,
      );

      setState(() {
        _marketplaceScreen = UIScreen.fromJson(jsonData['screen']);
        _isLoading = false;
      });

      // Initialize the marketplace controller
      if (mounted) {
        final controller = Get.put(MarketplaceController());
        await controller.loadMarketplace();
      }
    } catch (e) {
      DebugLogger.jsonParsing(
        'Failed to load marketplace screen: $e',
        componentType: 'screen',
        error: e,
      );
      setState(() {
        _error = 'Failed to load marketplace screen: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Marketplace',
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadMarketplaceScreen,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_marketplaceScreen == null) {
      return const Scaffold(
        body: Center(child: Text('No marketplace content available')),
      );
    }

    final controller = Get.find<MarketplaceController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_marketplaceScreen!.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return _buildErrorState(controller);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshMarketplace,
          child: _buildMarketplaceContent(controller),
        );
      }),
    );
  }

  Widget _buildMarketplaceContent(MarketplaceController controller) {
    // Use the standard JSON UI parser to render the marketplace screen
    return JsonUIParser.parseScreen(_marketplaceScreen!, context);
  }

  Widget _buildErrorState(MarketplaceController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Marketplace',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error.value!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.refreshMarketplace,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
