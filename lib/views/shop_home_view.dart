import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/models/shop.dart';
import 'package:ecommerce_sdui/models/shop_theme.dart';
import 'package:ecommerce_sdui/services/mock_shop_service.dart';
import 'package:ecommerce_sdui/controllers/cart_controller.dart';
import 'package:ecommerce_sdui/utils/stac.dart';
import 'package:ecommerce_sdui/utils/debug_logger.dart';

class ShopHomeView extends StatefulWidget {
  final String? shopId;
  final String? shopName;

  const ShopHomeView({
    super.key,
    this.shopId,
    this.shopName,
  });

  @override
  State<ShopHomeView> createState() => _ShopHomeViewState();
}

class _ShopHomeViewState extends State<ShopHomeView> {
  final MockShopService _mockShopService = MockShopService();
  final CartController _cartController = Get.find<CartController>();
  
  Shop? _shop;
  ShopTheme? _shopTheme;
  Map<String, dynamic>? _shopUIConfig;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShopData();
  }

  Future<void> _loadShopData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get shop ID from widget parameter or route parameters
      final shopId = widget.shopId ?? Get.parameters['shopId'];
      final shopName = widget.shopName ?? Get.parameters['shopName'];

      if (shopId == null) {
        throw Exception('Shop ID is required');
      }

      DebugLogger.jsonParsing('ShopHomeView loading shop: $shopId');

      // Load shop data
      final shop = _mockShopService.getShopById(shopId);
      if (shop == null) {
        throw Exception('Shop not found: $shopId');
      }

      // Load shop theme
      final shopTheme = _mockShopService.getShopTheme(shopId);
      if (shopTheme == null) {
        throw Exception('Shop theme not found: $shopId');
      }

      // Set shop context in cart controller
      _cartController.setShopContext(shopId, shopName ?? shop.name);

      // Load shop UI configuration
      final uiConfig = await _loadShopUIConfig(shop);

      setState(() {
        _shop = shop;
        _shopTheme = shopTheme;
        _shopUIConfig = uiConfig;
        _isLoading = false;
      });

      DebugLogger.jsonParsing('ShopHomeView loaded successfully: ${shop.name}');
    } catch (e) {
      setState(() {
        _error = 'Failed to load shop: $e';
        _isLoading = false;
      });
      DebugLogger.jsonParsing('ShopHomeView error: $e');
    }
  }

  Future<Map<String, dynamic>> _loadShopUIConfig(Shop shop) async {
    try {
      // Try to load shop-specific UI config first
      String jsonString;
      try {
        jsonString = await rootBundle.loadString(
          'assets/json_ui/shops/${shop.id}.json',
        );
        DebugLogger.jsonParsing('Loaded shop-specific UI: ${shop.id}.json');
      } catch (e) {
        // Fallback to category-based template
        try {
          jsonString = await rootBundle.loadString(
            'assets/json_ui/shop_templates/${shop.category}.json',
          );
          DebugLogger.jsonParsing('Loaded category template: ${shop.category}.json');
        } catch (e) {
          // Fallback to default shop template
          jsonString = await rootBundle.loadString(
            'assets/json_ui/shop_templates/default.json',
          );
          DebugLogger.jsonParsing('Loaded default shop template');
        }
      }

      final dynamic decodedJson = json.decode(jsonString);
      if (decodedJson is! Map<String, dynamic>) {
        throw Exception('Invalid JSON format');
      }

      return decodedJson;
    } catch (e) {
      DebugLogger.jsonParsing('Error loading shop UI config: $e');
      // Return a basic default configuration
      return _getDefaultShopConfig();
    }
  }

  Map<String, dynamic> _getDefaultShopConfig() {
    return {
      "type": "scaffold",
      "body": {
        "type": "singleChildScrollView",
        "child": {
          "type": "padding",
          "padding": {"all": 16},
          "child": {
            "type": "column",
            "crossAxisAlignment": "start",
            "spacing": 24,
            "children": [
              {
                "type": "container",
                "padding": {"all": 20},
                "decoration": {
                  "color": _shopTheme?.primaryColor ?? "#2196F3",
                  "borderRadius": 16
                },
                "child": {
                  "type": "column",
                  "crossAxisAlignment": "start",
                  "spacing": 8,
                  "children": [
                    {
                      "type": "text",
                      "data": _shop?.name ?? "Shop",
                      "style": {
                        "fontSize": 24,
                        "fontWeight": "bold",
                        "color": "#FFFFFF"
                      }
                    },
                    {
                      "type": "text",
                      "data": _shop?.description ?? "Welcome to our shop",
                      "style": {
                        "fontSize": 16,
                        "color": "#FFFFFF"
                      }
                    }
                  ]
                }
              },
              {
                "type": "text",
                "data": "Featured Products",
                "style": {
                  "fontSize": 20,
                  "fontWeight": "w600",
                  "color": "#1A1A1A"
                }
              },
              {
                "type": "container",
                "height": 200,
                "child": {
                  "type": "center",
                  "child": {
                    "type": "text",
                    "data": "Products coming soon...",
                    "style": {
                      "fontSize": 16,
                      "color": "#666666"
                    }
                  }
                }
              }
            ]
          }
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
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
                onPressed: _loadShopData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_shop == null || _shopTheme == null || _shopUIConfig == null) {
      return const Scaffold(
        body: Center(
          child: Text('Shop data not available'),
        ),
      );
    }

    // Apply shop theme
    return Theme(
      data: _shopTheme!.toThemeData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_shop!.name),
          backgroundColor: _shopTheme!.appBarColorValue,
          foregroundColor: _shopTheme!.textColorValue,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                // TODO: Implement shop favorite functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // TODO: Implement shop share functionality
              },
            ),
          ],
        ),
        body: Stac.fromJson(_shopUIConfig!, context),
      ),
    );
  }
}
