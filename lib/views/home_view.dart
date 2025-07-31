import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/ui_models.dart';
import '../parsers/json_parser.dart';
import '../utils/debug_logger.dart';

class HomeView extends StatefulWidget {
  final String? shopId;

  const HomeView({super.key, this.shopId});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UIScreen? _homeScreen;
  bool _isLoading = true;
  String? _error;
  String? _selectedShopId;

  @override
  void initState() {
    super.initState();
    // Get shop ID from widget parameter or route parameters
    _selectedShopId = widget.shopId ?? Get.parameters['shopId'];
    if (_selectedShopId != null) {
      DebugLogger.jsonParsing('HomeView initialized with shop ID: $_selectedShopId');
    }
    _loadHomeScreen();
  }

  Future<void> _loadHomeScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load the home screen JSON with proper null safety checks
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/home_page.json',
      );

      // Parse JSON with null safety
      final dynamic decodedJson = json.decode(jsonString);
      if (decodedJson == null) {
        throw Exception('JSON file is empty or invalid');
      }

      final Map<String, dynamic>? jsonData =
          decodedJson as Map<String, dynamic>?;
      if (jsonData == null) {
        throw Exception('JSON structure is not a valid Map<String, dynamic>');
      }

      // Validate required fields
      if (!jsonData.containsKey('screenId') ||
          !jsonData.containsKey('components')) {
        throw Exception('JSON missing required fields: screenId or components');
      }

      DebugLogger.jsonParsing(
        'Home screen JSON loaded successfully',
        componentType: 'screen',
        screenId: jsonData['screenId'] as String?,
        componentCount: (jsonData['components'] as List?)?.length,
      );

      setState(() {
        _homeScreen = UIScreen.fromJson(jsonData);
        _isLoading = false;
      });

      // Initialize the home controller
      if (mounted) {
        final homeController = Get.find<HomeController>();
        await homeController.initializeHome();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load home screen: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadHomeScreen,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_homeScreen == null) {
      return const Scaffold(body: Center(child: Text('No content available')));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadHomeScreen();
          if (mounted) {
            final homeController = Get.find<HomeController>();
            if (mounted) {
              await homeController.refresh();
            }
          }
        },
        child: Obx(() {
          final homeController = Get.find<HomeController>();

          if (homeController.isLoading.value && _homeScreen == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (homeController.error.value != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Connection Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      homeController.error.value!,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => homeController.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return _buildHomeContent();
        }),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: JsonUIParser.parseScreen(_homeScreen!, context),
    );
  }
}
