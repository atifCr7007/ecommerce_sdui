import 'package:intl/intl.dart';
import '../services/cart_service.dart';

enum PaymentStatus {
  pending,
  completed,
  failed,
  cancelled,
  refunded,
}

enum OrderStatus {
  placed,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
}

class Order {
  final String id;
  final String paymentId;
  final String? razorpayOrderId;
  final String? razorpaySignature;
  final List<CartItem> items;
  final double totalAmount;
  final double subtotalAmount;
  final double taxAmount;
  final double shippingAmount;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String currency;
  final Map<String, dynamic>? shippingAddress;
  final Map<String, dynamic>? billingAddress;
  final String? customerNotes;
  final Map<String, dynamic>? paymentDetails;

  Order({
    required this.id,
    required this.paymentId,
    this.razorpayOrderId,
    this.razorpaySignature,
    required this.items,
    required this.totalAmount,
    required this.subtotalAmount,
    this.taxAmount = 0.0,
    this.shippingAmount = 0.0,
    required this.paymentStatus,
    this.orderStatus = OrderStatus.placed,
    required this.createdAt,
    this.updatedAt,
    this.currency = 'INR',
    this.shippingAddress,
    this.billingAddress,
    this.customerNotes,
    this.paymentDetails,
  });

  // Getters for formatted values
  String get formattedTotal => _formatCurrency(totalAmount);
  String get formattedSubtotal => _formatCurrency(subtotalAmount);
  String get formattedTax => _formatCurrency(taxAmount);
  String get formattedShipping => _formatCurrency(shippingAmount);
  
  String get formattedCreatedAt => DateFormat('dd MMM yyyy, hh:mm a').format(createdAt);
  String get formattedUpdatedAt => updatedAt != null 
      ? DateFormat('dd MMM yyyy, hh:mm a').format(updatedAt!)
      : '';

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  String get statusDisplayName {
    switch (orderStatus) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  String get paymentStatusDisplayName {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Payment Pending';
      case PaymentStatus.completed:
        return 'Payment Completed';
      case PaymentStatus.failed:
        return 'Payment Failed';
      case PaymentStatus.cancelled:
        return 'Payment Cancelled';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  // Factory constructor for creating Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      paymentId: json['paymentId'] as String,
      razorpayOrderId: json['razorpayOrderId'] as String?,
      razorpaySignature: json['razorpaySignature'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      subtotalAmount: (json['subtotalAmount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAmount: (json['shippingAmount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: PaymentStatus.values.firstWhere(
        (status) => status.name == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      orderStatus: OrderStatus.values.firstWhere(
        (status) => status.name == json['orderStatus'],
        orElse: () => OrderStatus.placed,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      currency: json['currency'] as String? ?? 'INR',
      shippingAddress: json['shippingAddress'] as Map<String, dynamic>?,
      billingAddress: json['billingAddress'] as Map<String, dynamic>?,
      customerNotes: json['customerNotes'] as String?,
      paymentDetails: json['paymentDetails'] as Map<String, dynamic>?,
    );
  }

  // Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentId': paymentId,
      'razorpayOrderId': razorpayOrderId,
      'razorpaySignature': razorpaySignature,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'subtotalAmount': subtotalAmount,
      'taxAmount': taxAmount,
      'shippingAmount': shippingAmount,
      'paymentStatus': paymentStatus.name,
      'orderStatus': orderStatus.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'currency': currency,
      'shippingAddress': shippingAddress,
      'billingAddress': billingAddress,
      'customerNotes': customerNotes,
      'paymentDetails': paymentDetails,
    };
  }

  // Create a copy of the order with updated fields
  Order copyWith({
    String? id,
    String? paymentId,
    String? razorpayOrderId,
    String? razorpaySignature,
    List<CartItem>? items,
    double? totalAmount,
    double? subtotalAmount,
    double? taxAmount,
    double? shippingAmount,
    PaymentStatus? paymentStatus,
    OrderStatus? orderStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? currency,
    Map<String, dynamic>? shippingAddress,
    Map<String, dynamic>? billingAddress,
    String? customerNotes,
    Map<String, dynamic>? paymentDetails,
  }) {
    return Order(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
      razorpaySignature: razorpaySignature ?? this.razorpaySignature,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currency: currency ?? this.currency,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      customerNotes: customerNotes ?? this.customerNotes,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, paymentId: $paymentId, totalAmount: $formattedTotal, status: $statusDisplayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
