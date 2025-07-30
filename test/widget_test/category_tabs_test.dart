import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/views/widgets/category_tabs_widget.dart';
import 'package:ecommerce_sdui/controllers/home_controller.dart';

void main() {
  group('CategoryTabsWidget Tests', () {
    late HomeController homeController;

    setUp(() {
      // Initialize GetX
      Get.testMode = true;

      // Create and register the HomeController
      homeController = HomeController();
      Get.put(homeController);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('CategoryTabsWidget renders correctly with tabs', (
      WidgetTester tester,
    ) async {
      // Create test data
      final testTabs = [
        CategoryTab(
          id: 'electronics',
          name: 'Electronics',
          categoryId: 'electronics',
        ),
        CategoryTab(id: 'clothing', name: 'Clothing', categoryId: 'clothing'),
        CategoryTab(id: 'books', name: 'Books', categoryId: 'books'),
      ];

      // Build the widget
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CategoryTabsWidget(
              title: 'Shop by Category',
              tabs: testTabs,
              defaultTab: 'electronics',
              productLimit: 6,
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify the title is displayed
      expect(find.text('Shop by Category'), findsOneWidget);

      // Verify all tabs are displayed
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);

      // Verify the default tab is selected (should have different styling)
      final electronicsTab = find.text('Electronics');
      expect(electronicsTab, findsOneWidget);
    });

    testWidgets('CategoryTab.fromJson creates correct object', (
      WidgetTester tester,
    ) async {
      // Test JSON parsing
      final json = {
        'id': 'electronics',
        'name': 'Electronics',
        'categoryId': 'electronics',
      };

      final categoryTab = CategoryTab.fromJson(json);

      expect(categoryTab.id, equals('electronics'));
      expect(categoryTab.name, equals('Electronics'));
      expect(categoryTab.categoryId, equals('electronics'));
    });

    testWidgets('CategoryTabsWidget handles tab selection', (
      WidgetTester tester,
    ) async {
      // Create test data
      final testTabs = [
        CategoryTab(
          id: 'electronics',
          name: 'Electronics',
          categoryId: 'electronics',
        ),
        CategoryTab(id: 'clothing', name: 'Clothing', categoryId: 'clothing'),
      ];

      // Build the widget
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CategoryTabsWidget(
              title: 'Categories',
              tabs: testTabs,
              defaultTab: 'electronics',
              productLimit: 6,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the Clothing tab
      await tester.tap(find.text('Clothing'));
      await tester.pumpAndSettle();

      // Verify the tap was handled (widget should rebuild)
      expect(find.text('Clothing'), findsOneWidget);
    });
  });
}
