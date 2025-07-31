import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/marketplace_controller.dart';
import '../utils/stac.dart';
import '../utils/debug_logger.dart';

class MarketplaceView extends StatefulWidget {
  final String? shopId;
  
  const MarketplaceView({super.key, this.shopId});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  Map<String, dynamic>? _marketplaceJson;
  bool _isLoading = true;
  String? _error;
  final MarketplaceController _controller = Get.find<MarketplaceController>();

  @override
  void initState() {
    super.initState();
    _loadMarketplaceUI();

    // If shopId is provided, handle shop-specific logic
    if (widget.shopId != null) {
      DebugLogger.jsonParsing('MarketplaceView initialized with shopId: ${widget.shopId}');
    }
  }

  Future<void> _loadMarketplaceUI() async {
    try {
      DebugLogger.jsonParsing('Loading marketplace UI from JSON...');

      final String jsonString = await rootBundle.loadString('assets/json_ui/marketplace.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      DebugLogger.jsonParsing('JSON loaded successfully, ready for Stac parsing...');

      setState(() {
        _marketplaceJson = jsonData;
        _isLoading = false;
        _error = null;
      });

      DebugLogger.jsonParsing('Marketplace JSON loaded successfully');

    } catch (e, stackTrace) {
      DebugLogger.jsonParsing('Error loading marketplace UI: $e');
      DebugLogger.jsonParsing('Stack trace: $stackTrace');

      setState(() {
        _isLoading = false;
        _error = 'Failed to load marketplace: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
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
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadMarketplaceUI();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_marketplaceJson == null) {
      return const Scaffold(
        body: Center(
          child: Text('No marketplace data available'),
        ),
      );
    }

    return Stac.fromJson(_marketplaceJson!, context);
  }
}
