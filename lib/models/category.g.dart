// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      handle: json['handle'] as String?,
      mpath: json['mpath'] as String?,
      isActive: json['isActive'] as bool,
      isInternal: json['isInternal'] as bool,
      parentCategoryId: json['parentCategoryId'] as String?,
      categoryChildren: (json['categoryChildren'] as List<dynamic>?)
          ?.map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      rank: (json['rank'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'handle': instance.handle,
      'mpath': instance.mpath,
      'isActive': instance.isActive,
      'isInternal': instance.isInternal,
      'parentCategoryId': instance.parentCategoryId,
      'categoryChildren': instance.categoryChildren,
      'rank': instance.rank,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      productCategories: (json['productCategories'] as List<dynamic>)
          .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'productCategories': instance.productCategories,
      'count': instance.count,
      'offset': instance.offset,
      'limit': instance.limit,
    };
