import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/controllers/cart_controller.dart';
import 'package:ecommerce_sdui/views/cart_view.dart';

void main() {
  group('Cart Functionality Tests', () {
    late CartController cartController;

    setUp(() {
      // Initialize GetX
      Get.testMode = true;

      // Initialize cart controller
      cartController = CartController();
      Get.put(cartController);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('Cart view should display empty state initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(GetMaterialApp(home: const CartView()));

      // Wait for initialization
      await tester.pumpAndSettle();

      // Should show empty cart state
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add some items to get started'), findsOneWidget);
      expect(find.text('Continue Shopping'), findsOneWidget);
    });

    testWidgets('Cart view should handle loading state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(GetMaterialApp(home: const CartView()));

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Should show empty cart state after loading
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('Cart controller should initialize properly', (
      WidgetTester tester,
    ) async {
      expect(cartController.itemCount, equals(0));
      expect(cartController.totalQuantity, equals(0));
      expect(cartController.formattedTotal, equals('\$0.00'));
      expect(cartController.formattedSubtotal, equals('\$0.00'));
    });

    test('Cart controller should handle add to cart', () async {
      // Test adding an item to cart
      final result = await cartController.addToCart(
        'test-product-1',
        'test-variant-1',
        quantity: 2,
      );

      expect(result, isTrue);
      // Note: In mock mode, the cart might not immediately reflect changes
      // This depends on the mock implementation
    });

    test('Cart controller should handle cart operations', () async {
      // Test cart loading
      await cartController.loadCart();

      // Test creating new cart
      await cartController.createNewCart();

      // Verify cart ID is set
      expect(cartController.cartId.value, isNotEmpty);
    });
  });

  group('Cart View Widget Tests', () {
    testWidgets('Cart view should have proper app bar', (
      WidgetTester tester,
    ) async {
      Get.testMode = true;
      Get.put(CartController());

      await tester.pumpWidget(GetMaterialApp(home: const CartView()));

      await tester.pumpAndSettle();

      // Check app bar
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Empty cart should show continue shopping button', (
      WidgetTester tester,
    ) async {
      Get.testMode = true;
      Get.put(CartController());

      await tester.pumpWidget(GetMaterialApp(home: const CartView()));

      await tester.pumpAndSettle();

      // Find and tap continue shopping button
      final continueButton = find.text('Continue Shopping');
      expect(continueButton, findsOneWidget);

      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Should navigate back (pop the current route)
      // In test environment, this might not have visible effect
    });
  });
}
