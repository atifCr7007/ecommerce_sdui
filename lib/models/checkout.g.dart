// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryDetails _$DeliveryDetailsFromJson(Map<String, dynamic> json) =>
    DeliveryDetails(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      mobileNumber: json['mobileNumber'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
    );

Map<String, dynamic> _$DeliveryDetailsToJson(DeliveryDetails instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'deliveryAddress': instance.deliveryAddress,
    };

CouponInfo _$CouponInfoFromJson(Map<String, dynamic> json) => CouponInfo(
  code: json['code'] as String,
  name: json['name'] as String,
  discountPercentage: (json['discountPercentage'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num).toInt(),
  isValid: json['isValid'] as bool,
);

Map<String, dynamic> _$CouponInfoToJson(CouponInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'discountPercentage': instance.discountPercentage,
      'discountAmount': instance.discountAmount,
      'isValid': instance.isValid,
    };

OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) => OrderSummary(
  subtotal: (json['subtotal'] as num).toInt(),
  discountAmount: (json['discountAmount'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  itemCount: (json['itemCount'] as num).toInt(),
  currencyCode: json['currencyCode'] as String,
  appliedCoupon: json['appliedCoupon'] == null
      ? null
      : CouponInfo.fromJson(json['appliedCoupon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderSummaryToJson(OrderSummary instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'discountAmount': instance.discountAmount,
      'total': instance.total,
      'itemCount': instance.itemCount,
      'currencyCode': instance.currencyCode,
      'appliedCoupon': instance.appliedCoupon,
    };

CheckoutData _$CheckoutDataFromJson(Map<String, dynamic> json) => CheckoutData(
  deliveryDetails: json['deliveryDetails'] == null
      ? null
      : DeliveryDetails.fromJson(
          json['deliveryDetails'] as Map<String, dynamic>,
        ),
  paymentMode: $enumDecodeNullable(_$PaymentModeEnumMap, json['paymentMode']),
  paymentType: $enumDecode(_$PaymentTypeEnumMap, json['paymentType']),
  orderSummary: OrderSummary.fromJson(
    json['orderSummary'] as Map<String, dynamic>,
  ),
  couponCode: json['couponCode'] as String?,
);

Map<String, dynamic> _$CheckoutDataToJson(CheckoutData instance) =>
    <String, dynamic>{
      'deliveryDetails': instance.deliveryDetails,
      'paymentMode': _$PaymentModeEnumMap[instance.paymentMode],
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType]!,
      'orderSummary': instance.orderSummary,
      'couponCode': instance.couponCode,
    };

const _$PaymentModeEnumMap = {
  PaymentMode.creditCard: 'credit_card',
  PaymentMode.debitCard: 'debit_card',
  PaymentMode.upi: 'upi',
  PaymentMode.netBanking: 'net_banking',
  PaymentMode.cashOnDelivery: 'cash_on_delivery',
};

const _$PaymentTypeEnumMap = {
  PaymentType.online: 'online',
  PaymentType.offline: 'offline',
};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  id: json['id'] as String,
  variantId: json['variantId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  thumbnail: json['thumbnail'] as String?,
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  color: json['color'] as String?,
  size: json['size'] as String?,
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'id': instance.id,
  'variantId': instance.variantId,
  'title': instance.title,
  'description': instance.description,
  'thumbnail': instance.thumbnail,
  'quantity': instance.quantity,
  'unitPrice': instance.unitPrice,
  'total': instance.total,
  'color': instance.color,
  'size': instance.size,
};

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  deliveryDetails: DeliveryDetails.fromJson(
    json['deliveryDetails'] as Map<String, dynamic>,
  ),
  paymentMode: $enumDecode(_$PaymentModeEnumMap, json['paymentMode']),
  paymentType: $enumDecode(_$PaymentTypeEnumMap, json['paymentType']),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  subtotal: (json['subtotal'] as num).toInt(),
  discountAmount: (json['discountAmount'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  currencyCode: json['currencyCode'] as String,
  appliedCoupon: json['appliedCoupon'] == null
      ? null
      : CouponInfo.fromJson(json['appliedCoupon'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'items': instance.items,
  'deliveryDetails': instance.deliveryDetails,
  'paymentMode': _$PaymentModeEnumMap[instance.paymentMode]!,
  'paymentType': _$PaymentTypeEnumMap[instance.paymentType]!,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'subtotal': instance.subtotal,
  'discountAmount': instance.discountAmount,
  'total': instance.total,
  'currencyCode': instance.currencyCode,
  'appliedCoupon': instance.appliedCoupon,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      order: Order.fromJson(json['order'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{'order': instance.order, 'message': instance.message};
