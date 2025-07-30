import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../services/cart_service.dart';

class PaymentResult {
  final bool success;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String? errorMessage;
  final Map<String, dynamic>? errorDetails;

  PaymentResult({
    required this.success,
    this.paymentId,
    this.orderId,
    this.signature,
    this.errorMessage,
    this.errorDetails,
  });

  @override
  String toString() {
    return 'PaymentResult(success: $success, paymentId: $paymentId, orderId: $orderId, errorMessage: $errorMessage)';
  }
}

class PaymentService {
  static const String _keyId = 'rzp_test_ZUpflviU0kpnf0';
  static const String _secretKey = 'vaVSn1chhm19HW809rG0X8HS';
  
  late Razorpay _razorpay;
  PaymentResult? _currentPaymentResult;
  
  // Callback functions
  Function(PaymentResult)? _onPaymentComplete;

  PaymentService() {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
    if (kDebugMode) {
      debugPrint('[PaymentService] Razorpay initialized successfully');
    }
  }

  /// Start payment process
  Future<PaymentResult> processPayment({
    required Cart cart,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? description,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('[PaymentService] Starting payment process for cart: ${cart.formattedTotal}');
      }

      // Convert amount to paise (Razorpay expects amount in smallest currency unit)
      final amountInPaise = (cart.totalAmount * 100).round();
      
      // Generate unique order ID
      final orderId = _generateOrderId();
      
      final options = {
        'key': _keyId,
        'amount': amountInPaise,
        'currency': 'INR',
        'name': 'SDUI E-commerce',
        'description': description ?? 'Purchase from SDUI E-commerce',
        'order_id': orderId,
        'prefill': {
          'contact': customerPhone,
          'email': customerEmail,
          'name': customerName,
        },
        'theme': {
          'color': '#2196F3',
        },
        'modal': {
          'ondismiss': () {
            if (kDebugMode) {
              debugPrint('[PaymentService] Payment modal dismissed');
            }
          }
        },
        'notes': {
          'cart_items': cart.items.length.toString(),
          'total_quantity': cart.items.fold(0, (sum, item) => sum + item.quantity).toString(),
        },
      };

      if (kDebugMode) {
        debugPrint('[PaymentService] Payment options: ${jsonEncode(options)}');
      }

      // Reset current payment result
      _currentPaymentResult = null;

      // Open Razorpay checkout
      _razorpay.open(options);

      // Wait for payment completion (with timeout)
      return await _waitForPaymentCompletion();
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PaymentService] Error processing payment: $e');
      }
      
      return PaymentResult(
        success: false,
        errorMessage: 'Failed to initiate payment: $e',
        errorDetails: {'exception': e.toString()},
      );
    }
  }

  /// Wait for payment completion with timeout
  Future<PaymentResult> _waitForPaymentCompletion() async {
    const maxWaitTime = Duration(minutes: 10); // 10 minutes timeout
    const checkInterval = Duration(milliseconds: 500);
    
    final startTime = DateTime.now();
    
    while (_currentPaymentResult == null) {
      if (DateTime.now().difference(startTime) > maxWaitTime) {
        if (kDebugMode) {
          debugPrint('[PaymentService] Payment timeout');
        }
        return PaymentResult(
          success: false,
          errorMessage: 'Payment timeout',
          errorDetails: {'reason': 'timeout'},
        );
      }
      
      await Future.delayed(checkInterval);
    }
    
    return _currentPaymentResult!;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (kDebugMode) {
      debugPrint('[PaymentService] Payment success: ${response.paymentId}');
      debugPrint('[PaymentService] Order ID: ${response.orderId}');
      debugPrint('[PaymentService] Signature: ${response.signature}');
    }

    _currentPaymentResult = PaymentResult(
      success: true,
      paymentId: response.paymentId,
      orderId: response.orderId,
      signature: response.signature,
    );

    _onPaymentComplete?.call(_currentPaymentResult!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (kDebugMode) {
      debugPrint('[PaymentService] Payment error: ${response.code} - ${response.message}');
      debugPrint('[PaymentService] Error details: ${response.error}');
    }

    _currentPaymentResult = PaymentResult(
      success: false,
      errorMessage: response.message ?? 'Payment failed',
      errorDetails: {
        'code': response.code,
        'error': response.error,
      },
    );

    _onPaymentComplete?.call(_currentPaymentResult!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (kDebugMode) {
      debugPrint('[PaymentService] External wallet selected: ${response.walletName}');
    }

    // For now, treat external wallet as cancellation
    // In production, you might want to handle this differently
    _currentPaymentResult = PaymentResult(
      success: false,
      errorMessage: 'Payment cancelled - External wallet selected',
      errorDetails: {'walletName': response.walletName},
    );

    _onPaymentComplete?.call(_currentPaymentResult!);
  }

  /// Generate unique order ID
  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return 'ORDER_${timestamp}_$random';
  }

  /// Format amount to INR currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Convert USD to INR (mock conversion rate)
  static double convertUsdToInr(double usdAmount) {
    const conversionRate = 83.0; // Mock conversion rate
    return usdAmount * conversionRate;
  }

  /// Set payment completion callback
  void setPaymentCompleteCallback(Function(PaymentResult) callback) {
    _onPaymentComplete = callback;
  }

  /// Dispose resources
  void dispose() {
    if (kDebugMode) {
      debugPrint('[PaymentService] Disposing Razorpay resources');
    }
    _razorpay.clear();
  }
}
