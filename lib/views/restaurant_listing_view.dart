import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/restaurant_listing_controller.dart';
import '../models/restaurant.dart';
import '../utils/stac.dart';

/// Restaurant listing view that displays restaurants based on category
/// Uses SDUI (Server-Driven UI) with JSON configuration
class RestaurantListingView extends StatefulWidget {
  final String category;

  const RestaurantListingView({
    super.key,
    required this.category,
  });

  @override
  State<RestaurantListingView> createState() => _RestaurantListingViewState();
}

class _RestaurantListingViewState extends State<RestaurantListingView> {
  Map<String, dynamic>? _uiConfig;
  bool _isLoading = true;
  late RestaurantListingController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _loadJsonUI();
  }

  void _initializeController() {
    // Initialize controller and set category filter if provided
    _controller = Get.put(RestaurantListingController());
    if (widget.category.isNotEmpty) {
      _controller.setCategoryFilter(widget.category);
    }
  }

  Future<void> _loadJsonUI() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json_ui/restaurant_listing.json');
      final decodedJson = json.decode(jsonString);

      // Print JSON to terminal for debugging as requested
      debugPrint('🔍 [RESTAURANT_LISTING_JSON] Loading UI configuration:');
      debugPrint('📄 JSON Content: ${json.encode(decodedJson)}');
      debugPrint('🎯 Component Type: ${decodedJson['type']}');
      debugPrint('📊 Component Count: ${_countComponents(decodedJson)}');
      debugPrint('🍔 [RESTAURANT_LISTING] Category: ${widget.category}');
      debugPrint('📱 [RESTAURANT_LISTING] Screen loaded successfully');

      setState(() {
        _uiConfig = decodedJson;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading restaurant listing UI: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _countComponents(dynamic json) {
    if (json is Map<String, dynamic>) {
      int count = 1;
      json.forEach((key, value) {
        if (value is Map || value is List) {
          count += _countComponents(value);
        }
      });
      return count;
    } else if (json is List) {
      int count = 0;
      for (var item in json) {
        count += _countComponents(item);
      }
      return count;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _uiConfig == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Use Obx only for reactive controller data, not for static JSON
    return Obx(() {
      // This ensures the UI rebuilds when controller state changes
      final _ = _controller.filteredRestaurants; // Access reactive variable to trigger rebuilds

      debugPrint('🔄 [GETX_REBUILD] Restaurant listing rebuilding with ${_controller.filteredRestaurants.length} restaurants');

      return Stac.fromJson(_uiConfig!, context);
    });
  }



  @override
  void dispose() {
    // Don't dispose the controller here as it might be used by other screens
    super.dispose();
  }
}
