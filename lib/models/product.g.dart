// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  handle: json['handle'] as String?,
  status: json['status'] as String?,
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  thumbnail: json['thumbnail'] as String?,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => ProductOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  variants: (json['variants'] as List<dynamic>?)
      ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
      .toList(),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  discountable: json['discountable'] as bool?,
  externalId: json['externalId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'handle': instance.handle,
  'status': instance.status,
  'images': instance.images,
  'thumbnail': instance.thumbnail,
  'options': instance.options,
  'variants': instance.variants,
  'categories': instance.categories,
  'type': instance.type,
  'tags': instance.tags,
  'discountable': instance.discountable,
  'externalId': instance.externalId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) => ProductImage(
  id: json['id'] as String,
  url: json['url'] as String,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ProductImageToJson(ProductImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'metadata': instance.metadata,
    };

ProductOption _$ProductOptionFromJson(Map<String, dynamic> json) =>
    ProductOption(
      id: json['id'] as String,
      title: json['title'] as String,
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => ProductOptionValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductOptionToJson(ProductOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'values': instance.values,
    };

ProductOptionValue _$ProductOptionValueFromJson(Map<String, dynamic> json) =>
    ProductOptionValue(
      id: json['id'] as String,
      value: json['value'] as String,
      optionId: json['optionId'] as String?,
    );

Map<String, dynamic> _$ProductOptionValueToJson(ProductOptionValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'optionId': instance.optionId,
    };

ProductVariant _$ProductVariantFromJson(Map<String, dynamic> json) =>
    ProductVariant(
      id: json['id'] as String,
      title: json['title'] as String,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      ean: json['ean'] as String?,
      upc: json['upc'] as String?,
      inventoryQuantity: (json['inventoryQuantity'] as num?)?.toInt(),
      allowBackorder: json['allowBackorder'] as bool?,
      manageInventory: json['manageInventory'] as bool?,
      hsCode: json['hsCode'] as String?,
      originCountry: json['originCountry'] as String?,
      midCode: json['midCode'] as String?,
      material: json['material'] as String?,
      weight: (json['weight'] as num?)?.toInt(),
      length: (json['length'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => ProductVariantPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductVariantToJson(ProductVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'ean': instance.ean,
      'upc': instance.upc,
      'inventoryQuantity': instance.inventoryQuantity,
      'allowBackorder': instance.allowBackorder,
      'manageInventory': instance.manageInventory,
      'hsCode': instance.hsCode,
      'originCountry': instance.originCountry,
      'midCode': instance.midCode,
      'material': instance.material,
      'weight': instance.weight,
      'length': instance.length,
      'height': instance.height,
      'width': instance.width,
      'prices': instance.prices,
    };

ProductVariantPrice _$ProductVariantPriceFromJson(Map<String, dynamic> json) =>
    ProductVariantPrice(
      id: json['id'] as String,
      currencyCode: json['currencyCode'] as String,
      amount: (json['amount'] as num).toInt(),
      regionId: json['regionId'] as String?,
    );

Map<String, dynamic> _$ProductVariantPriceToJson(
  ProductVariantPrice instance,
) => <String, dynamic>{
  'id': instance.id,
  'currencyCode': instance.currencyCode,
  'amount': instance.amount,
  'regionId': instance.regionId,
};

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      handle: json['handle'] as String?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool?,
      isInternal: json['isInternal'] as bool?,
      rank: (json['rank'] as num?)?.toInt(),
      parentCategoryId: json['parentCategoryId'] as String?,
    );

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'handle': instance.handle,
      'description': instance.description,
      'isActive': instance.isActive,
      'isInternal': instance.isInternal,
      'rank': instance.rank,
      'parentCategoryId': instance.parentCategoryId,
    };
