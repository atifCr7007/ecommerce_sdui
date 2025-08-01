import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_sdui/utils/stac.dart';
import 'package:ecommerce_sdui/utils/debug_logger.dart';

class NewHomeView extends StatefulWidget {
  const NewHomeView({super.key});

  @override
  State<NewHomeView> createState() => _NewHomeViewState();
}

class _NewHomeViewState extends State<NewHomeView> {
  Map<String, dynamic>? _homeUIConfig;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHomeUI();
  }

  Future<void> _loadHomeUI() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      DebugLogger.jsonParsing('NewHomeView loading home UI configuration');

      // Load home UI configuration
      String jsonString;
      try {
        jsonString = await rootBundle.loadString('assets/json_ui/home_page.json');
        DebugLogger.jsonParsing('Loaded home UI from home_page.json');
      } catch (e) {
        // Fallback to home page fallback configuration
        try {
          jsonString = await rootBundle.loadString('assets/json_ui/home_page_fallback.json');
          DebugLogger.jsonParsing('Loaded home UI from home_page_fallback.json');
        } catch (e2) {
          throw Exception('Failed to load both home_page.json and home_page_fallback.json: $e2');
        }
      }

      final dynamic decodedJson = json.decode(jsonString);
      if (decodedJson is! Map<String, dynamic>) {
        throw Exception('Invalid JSON format');
      }

      setState(() {
        _homeUIConfig = decodedJson;
        _isLoading = false;
      });

      DebugLogger.jsonParsing('NewHomeView loaded successfully');
    } catch (e) {
      setState(() {
        _error = 'Failed to load home: $e';
        _isLoading = false;
      });
      DebugLogger.jsonParsing('NewHomeView error: $e');
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
              onPressed: _loadHomeUI,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_homeUIConfig == null) {
      return const Center(
        child: Text('Home configuration not available'),
      );
    }

    return Stac.fromJson(_homeUIConfig!, context);
  }
}
