import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class ProductCategory {
  final String id;
  final String name;
  final String? description;
  final String? handle;
  final String? mpath;
  final bool isActive;
  final bool isInternal;
  final String? parentCategoryId;
  final List<ProductCategory>? categoryChildren;
  final int rank;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.handle,
    this.mpath,
    required this.isActive,
    required this.isInternal,
    this.parentCategoryId,
    this.categoryChildren,
    required this.rank,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);

  // Helper methods for UI
  bool get hasChildren =>
      categoryChildren != null && categoryChildren!.isNotEmpty;

  String get displayName => name;

  String get iconUrl {
    // Mock icon URLs based on category name for demo
    final categoryIcons = {
      'electronics': 'https://via.placeholder.com/50x50/2196F3/FFFFFF?text=📱',
      'clothing': 'https://via.placeholder.com/50x50/E91E63/FFFFFF?text=👕',
      'books': 'https://via.placeholder.com/50x50/FF9800/FFFFFF?text=📚',
      'home': 'https://via.placeholder.com/50x50/4CAF50/FFFFFF?text=🏠',
      'sports': 'https://via.placeholder.com/50x50/FF5722/FFFFFF?text=⚽',
      'beauty': 'https://via.placeholder.com/50x50/9C27B0/FFFFFF?text=💄',
      'toys': 'https://via.placeholder.com/50x50/FFC107/FFFFFF?text=🧸',
      'automotive': 'https://via.placeholder.com/50x50/607D8B/FFFFFF?text=🚗',
    };

    final lowerName = name.toLowerCase();
    for (final key in categoryIcons.keys) {
      if (lowerName.contains(key)) {
        return categoryIcons[key]!;
      }
    }

    return 'https://via.placeholder.com/50x50/9E9E9E/FFFFFF?text=📦';
  }
}

@JsonSerializable()
class CategoryResponse {
  final List<ProductCategory> productCategories;
  final int count;
  final int offset;
  final int limit;

  CategoryResponse({
    required this.productCategories,
    required this.count,
    required this.offset,
    required this.limit,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
