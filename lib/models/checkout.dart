import 'package:json_annotation/json_annotation.dart';

part 'checkout.g.dart';

/// Delivery details for checkout
@JsonSerializable()
class DeliveryDetails {
  final String fullName;
  final String email;
  final String mobileNumber;
  final String deliveryAddress;

  DeliveryDetails({
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.deliveryAddress,
  });

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) =>
      _$DeliveryDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryDetailsToJson(this);
}

/// Payment mode options
enum PaymentMode {
  @JsonValue('credit_card')
  creditCard,
  @JsonValue('debit_card')
  debitCard,
  @JsonValue('upi')
  upi,
  @JsonValue('net_banking')
  netBanking,
  @JsonValue('cash_on_delivery')
  cashOnDelivery,
}

/// Payment type (online/offline)
enum PaymentType {
  @JsonValue('online')
  online,
  @JsonValue('offline')
  offline,
}

/// Coupon information
@JsonSerializable()
class CouponInfo {
  final String code;
  final String name;
  final double discountPercentage;
  final int discountAmount;
  final bool isValid;

  CouponInfo({
    required this.code,
    required this.name,
    required this.discountPercentage,
    required this.discountAmount,
    required this.isValid,
  });

  factory CouponInfo.fromJson(Map<String, dynamic> json) =>
      _$CouponInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CouponInfoToJson(this);
}

/// Order summary for checkout
@JsonSerializable()
class OrderSummary {
  final int subtotal;
  final int discountAmount;
  final int total;
  final int itemCount;
  final String currencyCode;
  final CouponInfo? appliedCoupon;

  OrderSummary({
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.itemCount,
    required this.currencyCode,
    this.appliedCoupon,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSummaryToJson(this);
}

/// Complete checkout data
@JsonSerializable()
class CheckoutData {
  final DeliveryDetails? deliveryDetails;
  final PaymentMode? paymentMode;
  final PaymentType paymentType;
  final OrderSummary orderSummary;
  final String? couponCode;

  CheckoutData({
    this.deliveryDetails,
    this.paymentMode,
    required this.paymentType,
    required this.orderSummary,
    this.couponCode,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) =>
      _$CheckoutDataFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutDataToJson(this);
}

/// Order status
enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('processing')
  processing,
  @JsonValue('shipped')
  shipped,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
}

/// Order item
@JsonSerializable()
class OrderItem {
  final String id;
  final String variantId;
  final String title;
  final String? description;
  final String? thumbnail;
  final int quantity;
  final int unitPrice;
  final int total;
  final String? color;
  final String? size;

  OrderItem({
    required this.id,
    required this.variantId,
    required this.title,
    this.description,
    this.thumbnail,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.color,
    this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  /// Create OrderItem from CartItem
  factory OrderItem.fromCartItem(dynamic cartItem) {
    return OrderItem(
      id: cartItem.id,
      variantId: cartItem.variantId,
      title: cartItem.title,
      description: cartItem.description,
      thumbnail: cartItem.thumbnail,
      quantity: cartItem.quantity,
      unitPrice: cartItem.unitPrice,
      total: cartItem.total,
      color: cartItem.color,
      size: cartItem.size,
    );
  }
}

/// Complete order
@JsonSerializable()
class Order {
  final String id;
  final List<OrderItem> items;
  final DeliveryDetails deliveryDetails;
  final PaymentMode paymentMode;
  final PaymentType paymentType;
  final OrderStatus status;
  final int subtotal;
  final int discountAmount;
  final int total;
  final String currencyCode;
  final CouponInfo? appliedCoupon;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.items,
    required this.deliveryDetails,
    required this.paymentMode,
    required this.paymentType,
    required this.status,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.currencyCode,
    this.appliedCoupon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  /// Create a copy of this order with some fields replaced
  Order copyWith({
    String? id,
    List<OrderItem>? items,
    DeliveryDetails? deliveryDetails,
    PaymentMode? paymentMode,
    PaymentType? paymentType,
    OrderStatus? status,
    int? subtotal,
    int? discountAmount,
    int? total,
    String? currencyCode,
    CouponInfo? appliedCoupon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      deliveryDetails: deliveryDetails ?? this.deliveryDetails,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentType: paymentType ?? this.paymentType,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      total: total ?? this.total,
      currencyCode: currencyCode ?? this.currencyCode,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Order response
@JsonSerializable()
class OrderResponse {
  final Order order;
  final String? message;

  OrderResponse({required this.order, this.message});

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}
