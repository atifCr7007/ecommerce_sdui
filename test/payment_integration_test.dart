import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_sdui/services/payment_service.dart';
import 'package:ecommerce_sdui/services/order_service.dart';
import 'package:ecommerce_sdui/services/cart_service.dart';
import 'package:ecommerce_sdui/models/order.dart';

void main() {
  group('Payment Integration Tests', () {
    late PaymentService paymentService;
    late OrderService orderService;

    setUp(() {
      paymentService = PaymentService();
      orderService = OrderService();
    });

    tearDown(() {
      paymentService.dispose();
    });

    test('PaymentService should initialize correctly', () {
      expect(paymentService, isNotNull);
    });

    test('OrderService should initialize correctly', () {
      expect(orderService, isNotNull);
    });

    test('Currency formatting should work correctly', () {
      // Test INR currency formatting
      final formatted1 = PaymentService.formatCurrency(1000.50);
      expect(formatted1, contains('₹'));
      expect(formatted1, contains('1,000.50'));

      final formatted2 = PaymentService.formatCurrency(99.99);
      expect(formatted2, contains('₹'));
      expect(formatted2, contains('99.99'));

      final formatted3 = PaymentService.formatCurrency(0);
      expect(formatted3, contains('₹'));
      expect(formatted3, contains('0.00'));
    });

    test('USD to INR conversion should work', () {
      final usdAmount = 100.0;
      final inrAmount = PaymentService.convertUsdToInr(usdAmount);

      expect(inrAmount, greaterThan(usdAmount));
      expect(inrAmount, equals(8300.0)); // 100 * 83 (mock rate)
    });

    test('Order creation should work with mock data', () async {
      // Create a mock cart
      final mockCart = Cart(
        id: 'test-cart-123',
        items: [
          CartItem(
            id: 'item-1',
            variantId: 'variant-1',
            title: 'Test Product 1',
            description: 'Test description',
            quantity: 2,
            unitPrice: 5000, // ₹50.00 in paise
            total: 10000, // ₹100.00 in paise
            thumbnail: 'https://example.com/image1.jpg',
          ),
          CartItem(
            id: 'item-2',
            variantId: 'variant-2',
            title: 'Test Product 2',
            description: 'Another test product',
            quantity: 1,
            unitPrice: 7500, // ₹75.00 in paise
            total: 7500, // ₹75.00 in paise
            thumbnail: 'https://example.com/image2.jpg',
          ),
        ],
        subtotal: 17500, // ₹175.00 in paise
        total: 17500, // ₹175.00 in paise
        currencyCode: 'INR',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create a mock payment result
      final mockPaymentResult = PaymentResult(
        success: true,
        paymentId: 'pay_test_123456789',
        orderId: 'order_test_123456789',
        signature: 'test_signature_hash',
      );

      // Create order
      final order = await orderService.createOrder(
        cart: mockCart,
        paymentResult: mockPaymentResult,
        shippingAddress: {
          'name': 'Test User',
          'address': '123 Test Street',
          'city': 'Test City',
          'state': 'Test State',
          'pincode': '123456',
        },
        customerNotes: 'Test order notes',
      );

      // Verify order creation
      expect(order, isNotNull);
      expect(order.id, isNotEmpty);
      expect(order.paymentId, equals('pay_test_123456789'));
      expect(order.razorpayOrderId, equals('order_test_123456789'));
      expect(order.items.length, equals(2));
      expect(order.paymentStatus, equals(PaymentStatus.completed));
      expect(order.orderStatus, equals(OrderStatus.placed));
      expect(order.currency, equals('INR'));
      expect(order.totalAmount, greaterThan(0));
      expect(order.formattedTotal, contains('₹'));
    });

    test('Order retrieval should work', () async {
      // Get all orders
      final orders = await orderService.getOrders();
      expect(orders, isNotNull);
      expect(orders, isA<List<Order>>());
    });

    test('Order statistics should work', () async {
      final stats = await orderService.getOrderStatistics();
      expect(stats, isNotNull);
      expect(stats, isA<Map<String, dynamic>>());
      expect(stats.containsKey('total_orders'), isTrue);
      expect(stats.containsKey('completed_orders'), isTrue);
      expect(stats.containsKey('total_revenue'), isTrue);
      expect(stats.containsKey('formatted_revenue'), isTrue);
    });

    test('Order status updates should work', () async {
      // This test would require an existing order
      // For now, just test that the method doesn't throw
      final result = await orderService.updateOrderStatus(
        'non-existent-order',
        OrderStatus.confirmed,
      );
      expect(result, isFalse); // Should return false for non-existent order
    });

    test('Payment status updates should work', () async {
      // This test would require an existing order
      // For now, just test that the method doesn't throw
      final result = await orderService.updatePaymentStatus(
        'non-existent-order',
        PaymentStatus.completed,
      );
      expect(result, isFalse); // Should return false for non-existent order
    });

    test('Cart currency formatting should use INR', () {
      final cart = Cart(
        id: 'test-cart',
        items: [],
        subtotal: 10000, // ₹100.00 in paise
        total: 11800, // ₹118.00 in paise (with tax)
        currencyCode: 'INR',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(cart.formattedTotal, contains('₹'));
      expect(cart.formattedSubtotal, contains('₹'));
      expect(cart.currencyCode, equals('INR'));
    });

    test('Order model should handle all payment statuses', () {
      for (final status in PaymentStatus.values) {
        final order = Order(
          id: 'test-order',
          paymentId: 'test-payment',
          items: [],
          totalAmount: 100.0,
          subtotalAmount: 85.0,
          paymentStatus: status,
          createdAt: DateTime.now(),
        );

        expect(order.paymentStatusDisplayName, isNotEmpty);
        expect(order.paymentStatus, equals(status));
      }
    });

    test('Order model should handle all order statuses', () {
      for (final status in OrderStatus.values) {
        final order = Order(
          id: 'test-order',
          paymentId: 'test-payment',
          items: [],
          totalAmount: 100.0,
          subtotalAmount: 85.0,
          paymentStatus: PaymentStatus.completed,
          orderStatus: status,
          createdAt: DateTime.now(),
        );

        expect(order.statusDisplayName, isNotEmpty);
        expect(order.orderStatus, equals(status));
      }
    });
  });
}
