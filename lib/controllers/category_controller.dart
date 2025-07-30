import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart' as cat;

class CategoryController extends GetxController {
  // Base URLs - In production, these would come from environment variables
  static const String _baseUrl = 'https://medusa-public-api.herokuapp.com';

  // State variables - GetX observables
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final Rxn<cat.ProductCategory> category = Rxn<cat.ProductCategory>();
  final RxList<Product> products = <Product>[].obs;
  final RxString sortOption = 'featured'.obs;
  final RxString viewType = 'grid'.obs; // 'grid' or 'list'
  final RxList<String> activeFilters = <String>[].obs;
  final RxMap<String, dynamic> filterOptions = <String, dynamic>{}.obs;

  // Getters
  int get productsCount => products.length;

  // Load category and its products
  Future<void> loadCategory(String categoryId) async {
    isLoading.value = true;
    error.value = null;

    try {
      await Future.wait([
        _fetchCategory(categoryId),
        _fetchCategoryProducts(categoryId),
      ]);
    } catch (e) {
      error.value = 'Failed to load category: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch category details
  Future<void> _fetchCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/store/product-categories/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categoryData = data['product_category'];
        if (categoryData != null) {
          category.value = cat.ProductCategory.fromJson(categoryData);
        } else {
          throw Exception('Category not found');
        }
      } else {
        throw Exception('Failed to fetch category: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching category: $e');
      // Use mock data for demo purposes
      category.value = _getMockCategory(categoryId);
    }
  }

  // Fetch products in category
  Future<void> _fetchCategoryProducts(String categoryId) async {
    try {
      String url = '$_baseUrl/store/products';

      final queryParams = <String, String>{
        'category_id[]': categoryId,
        'limit': '50',
      };

      // Add sorting parameter
      switch (sortOption.value) {
        case 'price_low_high':
          queryParams['order'] = 'variants.prices.amount';
          break;
        case 'price_high_low':
          queryParams['order'] = '-variants.prices.amount';
          break;
        case 'name_asc':
          queryParams['order'] = 'title';
          break;
        case 'name_desc':
          queryParams['order'] = '-title';
          break;
        case 'newest':
          queryParams['order'] = '-created_at';
          break;
        default:
          // Default to featured (no specific order parameter)
          break;
      }

      url +=
          '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productList = data['products'] as List<dynamic>? ?? [];

        products.value = productList
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch category products: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching category products: $e');
      // Use mock data for demo purposes
      products.value = _getMockCategoryProducts(categoryId);
    }
  }

  // Sort functionality
  void updateSortOption(String newSortOption) {
    sortOption.value = newSortOption;
    _updateActiveFilters();

    if (category.value != null) {
      _fetchCategoryProducts(category.value!.id);
    }
  }

  // View type toggle
  void toggleViewType() {
    viewType.value = viewType.value == 'grid' ? 'list' : 'grid';
  }

  void setViewType(String newViewType) {
    if (newViewType == 'grid' || newViewType == 'list') {
      viewType.value = newViewType;
    }
  }

  // Filter functionality
  void addFilter(String filterKey, String filterValue) {
    final filterString = '$filterKey: $filterValue';
    if (!activeFilters.contains(filterString)) {
      activeFilters.add(filterString);
      _updateFilterOptions(filterKey, filterValue);

      if (category.value != null) {
        _fetchCategoryProducts(category.value!.id);
      }
    }
  }

  void removeFilter(String filter) {
    activeFilters.remove(filter);
    _removeFilterFromOptions(filter);

    if (category.value != null) {
      _fetchCategoryProducts(category.value!.id);
    }
  }

  void clearFilters() {
    activeFilters.clear();
    filterOptions.clear();
    sortOption.value = 'featured';

    if (category.value != null) {
      _fetchCategoryProducts(category.value!.id);
    }
  }

  // Refresh category data
  Future<void> refresh() async {
    if (category.value != null) {
      await loadCategory(category.value!.id);
    }
  }

  void _updateActiveFilters() {
    // Remove sort filter if exists
    activeFilters.removeWhere((filter) => filter.startsWith('Sort:'));

    if (sortOption.value != 'featured') {
      String sortLabel = _getSortLabel(sortOption.value);
      activeFilters.add('Sort: $sortLabel');
    }
  }

  void _updateFilterOptions(String key, String value) {
    if (!filterOptions.containsKey(key)) {
      filterOptions[key] = <String>[];
    }

    final List<String> values = filterOptions[key] as List<String>;
    if (!values.contains(value)) {
      values.add(value);
    }
  }

  void _removeFilterFromOptions(String filter) {
    final parts = filter.split(': ');
    if (parts.length == 2) {
      final key = parts[0];
      final value = parts[1];

      if (filterOptions.containsKey(key)) {
        final List<String> values = filterOptions[key] as List<String>;
        values.remove(value);

        if (values.isEmpty) {
          filterOptions.remove(key);
        }
      }
    }
  }

  String _getSortLabel(String sortOption) {
    switch (sortOption) {
      case 'price_low_high':
        return 'Price: Low to High';
      case 'price_high_low':
        return 'Price: High to Low';
      case 'name_asc':
        return 'Name: A to Z';
      case 'name_desc':
        return 'Name: Z to A';
      case 'newest':
        return 'Newest First';
      default:
        return 'Featured';
    }
  }

  // Mock data methods for demo purposes
  cat.ProductCategory _getMockCategory(String categoryId) {
    final categoryNames = {
      'electronics': 'Electronics',
      'clothing': 'Clothing & Fashion',
      'books': 'Books & Media',
      'home': 'Home & Garden',
      'sports': 'Sports & Outdoors',
    };

    final categoryDescriptions = {
      'electronics':
          'Latest gadgets, smartphones, laptops, and electronic accessories',
      'clothing':
          'Trendy fashion, clothing, shoes, and accessories for all occasions',
      'books': 'Books, magazines, audiobooks, and educational materials',
      'home': 'Home decor, furniture, kitchen appliances, and garden supplies',
      'sports':
          'Sports equipment, fitness gear, and outdoor adventure products',
    };

    final name = categoryNames[categoryId] ?? 'Category';
    final description =
        categoryDescriptions[categoryId] ?? 'Category description';

    return cat.ProductCategory(
      id: categoryId,
      name: name,
      description: description,
      isActive: true,
      isInternal: false,
      rank: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  List<Product> _getMockCategoryProducts(String categoryId) {
    final mockProducts = <Product>[];
    final productCount = 15 + (categoryId.hashCode % 10);

    for (int i = 0; i < productCount; i++) {
      mockProducts.add(
        Product(
          id: '${categoryId}_product_$i',
          title: '${category.value?.name ?? 'Category'} Product ${i + 1}',
          description:
              'High-quality product from ${category.value?.name ?? 'this category'} collection. Perfect for your needs.',
          thumbnail:
              'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=${Uri.encodeComponent(category.value?.name ?? 'Product')}+${i + 1}',
          images: [
            ProductImage(
              id: '${categoryId}_img_$i',
              url:
                  'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=${Uri.encodeComponent(category.value?.name ?? 'Product')}+${i + 1}',
            ),
          ],
          variants: [
            ProductVariant(
              id: '${categoryId}_variant_$i',
              title: 'Default Variant',
              prices: [
                ProductVariantPrice(
                  id: '${categoryId}_price_$i',
                  currencyCode: 'USD',
                  amount: (2000 + (i * 300)), // Varying prices
                ),
              ],
            ),
          ],
          // categories field removed due to type conflict
        ),
      );
    }

    return mockProducts;
  }

  // Reset controller state
  void reset() {
    category.value = null;
    products.clear();
    sortOption.value = 'featured';
    viewType.value = 'grid';
    activeFilters.clear();
    filterOptions.clear();
    error.value = null;
    isLoading.value = false;
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
