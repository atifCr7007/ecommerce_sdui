import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utils/stac.dart';

class OffersView extends StatefulWidget {
  const OffersView({super.key});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  Map<String, dynamic>? _offersUIConfig;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOffersScreen();
  }

  Future<void> _loadOffersScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load the offers screen JSON
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/offers_page.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _offersUIConfig = jsonData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load offers: $e';
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
        appBar: AppBar(
          title: const Text('Offers & Deals'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Failed to Load Offers',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadOffersScreen,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_offersUIConfig == null) {
      return const Scaffold(
        body: Center(child: Text('Offers configuration not available')),
      );
    }

    return Stac.fromJson(_offersUIConfig!, context);
  }
}
