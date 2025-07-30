import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Asset Loading Tests', () {
    testWidgets('Cart JSON asset should load successfully', (WidgetTester tester) async {
      // Test loading cart.json asset
      try {
        final String jsonString = await rootBundle.loadString('assets/json_ui/cart.json');
        expect(jsonString.isNotEmpty, true);
        
        // Test JSON parsing
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        expect(jsonData.containsKey('screenId'), true);
        expect(jsonData.containsKey('components'), true);
        expect(jsonData['screenId'], 'cart');
        
        print('✅ Cart JSON loaded successfully: ${jsonString.length} characters');
      } catch (e) {
        fail('Failed to load cart.json: $e');
      }
    });

    testWidgets('Bookmarks JSON asset should load successfully', (WidgetTester tester) async {
      // Test loading bookmarks.json asset
      try {
        final String jsonString = await rootBundle.loadString('assets/json_ui/bookmarks.json');
        expect(jsonString.isNotEmpty, true);
        
        // Test JSON parsing
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        expect(jsonData.containsKey('screenId'), true);
        expect(jsonData.containsKey('components'), true);
        expect(jsonData['screenId'], 'bookmarks');
        
        print('✅ Bookmarks JSON loaded successfully: ${jsonString.length} characters');
      } catch (e) {
        fail('Failed to load bookmarks.json: $e');
      }
    });

    testWidgets('All JSON UI assets should be valid', (WidgetTester tester) async {
      final List<String> assetPaths = [
        'assets/json_ui/cart.json',
        'assets/json_ui/bookmarks.json',
        'assets/json_ui/home_page.json',
        'assets/json_ui/product_detail.json',
        'assets/json_ui/search_page.json',
        'assets/json_ui/category_page.json',
      ];

      for (final assetPath in assetPaths) {
        try {
          final String jsonString = await rootBundle.loadString(assetPath);
          expect(jsonString.isNotEmpty, true);
          
          // Test JSON parsing
          final Map<String, dynamic> jsonData = json.decode(jsonString);
          expect(jsonData.containsKey('screenId'), true);
          
          print('✅ $assetPath loaded and parsed successfully');
        } catch (e) {
          fail('Failed to load or parse $assetPath: $e');
        }
      }
    });
  });
}
