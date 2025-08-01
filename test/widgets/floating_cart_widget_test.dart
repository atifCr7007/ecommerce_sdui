import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/common/floating_cart_widget.dart';
import 'package:ecommerce_sdui/controllers/cart_controller.dart';
import 'package:ecommerce_sdui/models/cart.dart';
import 'package:ecommerce_sdui/models/cart_item.dart';
import 'package:ecommerce_sdui/models/product.dart';
import 'package:ecommerce_sdui/models/product_variant.dart';

void main() {
  group('FloatingCartWidget Tests', () {
    late CartController cartController;

    setUp(() {
      // Initialize GetX
      Get.testMode = true;
      
      // Create and register CartController
      cartController = CartController();
      Get.put(cartController);
    });

    tearDown(() {
      // Clean up GetX
      Get.reset();
    });

    testWidgets('FloatingCartWidget should be hidden when cart is empty', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Container(child: Text('Main Content')),
                FloatingCartWidget(),
              ],
            ),
          ),
        ),
      );

      // Verify that FloatingCartWidget is not visible (should be SizedBox.shrink)
      expect(find.byType(FloatingCartWidget), findsOneWidget);
      expect(find.text('Current Shop'), findsNothing);
      expect(find.text('View Full Menu'), findsNothing);
    });

    testWidgets('FloatingCartWidget should appear when cart has items', (WidgetTester tester) async {
      // Create a mock cart with items
      final mockProduct = Product(
        id: 'product1',
        title: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        currencyCode: 'USD',
        images: [],
        variants: [
          ProductVariant(
            id: 'variant1',
            title: 'Default',
            price: 10.0,
            currencyCode: 'USD',
            availableForSale: true,
          ),
        ],
        availableForSale: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockCartItem = CartItem(
        id: 'item1',
        productId: 'product1',
        variantId: 'variant1',
        quantity: 1,
        price: 10.0,
        currencyCode: 'USD',
        product: mockProduct,
        variant: mockProduct.variants.first,
      );

      final mockCart = Cart(
        id: 'cart1',
        items: [mockCartItem],
        subtotal: 10.0,
        total: 10.0,
        currencyCode: 'USD',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Set cart and shop context
      cartController.cart.value = mockCart;
      cartController.setShopContext('shop1', 'Test Shop');

      // Build the widget
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Container(child: Text('Main Content')),
                FloatingCartWidget(),
              ],
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify that FloatingCartWidget is visible with correct content
      expect(find.byType(FloatingCartWidget), findsOneWidget);
      expect(find.text('Test Shop'), findsOneWidget);
      expect(find.text('1 item'), findsOneWidget);
      expect(find.text('View Full Menu'), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('FloatingCartWidget should hide on cart route', (WidgetTester tester) async {
      // Create a mock cart with items
      final mockProduct = Product(
        id: 'product1',
        title: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        currencyCode: 'USD',
        images: [],
        variants: [
          ProductVariant(
            id: 'variant1',
            title: 'Default',
            price: 10.0,
            currencyCode: 'USD',
            availableForSale: true,
          ),
        ],
        availableForSale: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockCartItem = CartItem(
        id: 'item1',
        productId: 'product1',
        variantId: 'variant1',
        quantity: 1,
        price: 10.0,
        currencyCode: 'USD',
        product: mockProduct,
        variant: mockProduct.variants.first,
      );

      final mockCart = Cart(
        id: 'cart1',
        items: [mockCartItem],
        subtotal: 10.0,
        total: 10.0,
        currencyCode: 'USD',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Set cart and shop context
      cartController.cart.value = mockCart;
      cartController.setShopContext('shop1', 'Test Shop');

      // Build the widget with cart route
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/cart',
          getPages: [
            GetPage(
              name: '/cart',
              page: () => Scaffold(
                body: Stack(
                  children: [
                    Container(child: Text('Cart Page')),
                    FloatingCartWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify that FloatingCartWidget is hidden on cart route
      expect(find.text('Test Shop'), findsNothing);
      expect(find.text('View Full Menu'), findsNothing);
      expect(find.text('Checkout'), findsNothing);
    });

    testWidgets('Delete button should clear cart', (WidgetTester tester) async {
      // Create a mock cart with items
      final mockProduct = Product(
        id: 'product1',
        title: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        currencyCode: 'USD',
        images: [],
        variants: [
          ProductVariant(
            id: 'variant1',
            title: 'Default',
            price: 10.0,
            currencyCode: 'USD',
            availableForSale: true,
          ),
        ],
        availableForSale: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockCartItem = CartItem(
        id: 'item1',
        productId: 'product1',
        variantId: 'variant1',
        quantity: 1,
        price: 10.0,
        currencyCode: 'USD',
        product: mockProduct,
        variant: mockProduct.variants.first,
      );

      final mockCart = Cart(
        id: 'cart1',
        items: [mockCartItem],
        subtotal: 10.0,
        total: 10.0,
        currencyCode: 'USD',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Set cart and shop context
      cartController.cart.value = mockCart;
      cartController.setShopContext('shop1', 'Test Shop');

      // Build the widget
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Container(child: Text('Main Content')),
                FloatingCartWidget(),
              ],
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify that FloatingCartWidget is visible
      expect(find.text('Test Shop'), findsOneWidget);

      // Find and tap the delete button
      final deleteButton = find.byIcon(Icons.close);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Clear Cart'), findsOneWidget);
      expect(find.text('Are you sure you want to clear your cart?'), findsOneWidget);

      // Tap confirm button
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      // Verify cart is cleared and widget is hidden
      expect(cartController.cart.value?.items.isEmpty ?? true, true);
      expect(find.text('Test Shop'), findsNothing);
    });
  });
}
