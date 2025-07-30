import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/utils/json_ui_parser.dart';
import 'package:ecommerce_sdui/models/ui_models.dart';
import 'package:ecommerce_sdui/controllers/home_controller.dart';

void main() {
  group('JsonUIParser CategoryTabs Tests', () {
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

    testWidgets('JsonUIParser can parse categorytabs component', (
      WidgetTester tester,
    ) async {
      // Create a test UIComponent for categorytabs
      final categoryTabsComponent = UIComponent(
        type: 'categorytabs',
        id: 'test_category_tabs',
        properties: {
          'title': 'Test Categories',
          'tabs': [
            {
              'id': 'electronics',
              'name': 'Electronics',
              'categoryId': 'electronics',
            },
            {'id': 'clothing', 'name': 'Clothing', 'categoryId': 'clothing'},
          ],
          'defaultTab': 'electronics',
          'productLimit': 6,
        },
      );

      // Build the widget using JsonUIParser
      await tester.pumpWidget(
        GetMaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: JsonUIParser.parseComponent(categoryTabsComponent, context),
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify the component was parsed correctly and rendered
      expect(find.text('Test Categories'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Clothing'), findsOneWidget);
    });

    testWidgets('JsonUIParser handles unknown component type', (
      WidgetTester tester,
    ) async {
      // Create a test UIComponent with unknown type
      final unknownComponent = UIComponent(
        type: 'unknowncomponent',
        id: 'test_unknown',
        properties: {},
      );

      // Build the widget using JsonUIParser
      await tester.pumpWidget(
        GetMaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: JsonUIParser.parseComponent(unknownComponent, context),
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify the unknown component error is displayed
      expect(find.text('Unknown component: unknowncomponent'), findsOneWidget);
    });

    testWidgets('JsonUIParser handles categorytabs with case insensitivity', (
      WidgetTester tester,
    ) async {
      // Create a test UIComponent with uppercase type
      final categoryTabsComponent = UIComponent(
        type: 'CATEGORYTABS',
        id: 'test_category_tabs_upper',
        properties: {
          'title': 'Uppercase Test',
          'tabs': [
            {'id': 'books', 'name': 'Books', 'categoryId': 'books'},
          ],
          'defaultTab': 'books',
          'productLimit': 4,
        },
      );

      // Build the widget using JsonUIParser
      await tester.pumpWidget(
        GetMaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: JsonUIParser.parseComponent(categoryTabsComponent, context),
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify the component was parsed correctly despite uppercase
      expect(find.text('Uppercase Test'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);
    });
  });
}
