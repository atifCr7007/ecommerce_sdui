import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductSearchController extends GetxController {
  // Base URLs - In production, these would come from environment variables
  static const String _baseUrl = 'https://medusa-public-api.herokuapp.com';

  // State variables - GetX observables
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final RxList<Product> searchResults = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString sortOption = 'relevance'.obs;
  final RxList<String> activeFilters = <String>[].obs;
  Timer? _debounceTimer;

  // Getters
  int get resultsCount => searchResults.length;

  // Search functionality
  void updateSearchQuery(String query) {
    searchQuery.value = query;

    // Debounce search to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        performSearch();
      } else {
        clearResults();
      }
    });
  }

  Future<void> performSearch() async {
    if (searchQuery.value.isEmpty) {
      clearResults();
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      await _fetchSearchResults();
    } catch (e) {
      error.value = 'Search failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch search results from API
  Future<void> _fetchSearchResults() async {
    try {
      String url = '$_baseUrl/store/products';

      final queryParams = <String, String>{
        'q': searchQuery.value,
        'limit': '20',
      };

      if (selectedCategory.value.isNotEmpty) {
        queryParams['category_id[]'] = selectedCategory.value;
      }

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
          // Default to relevance (no specific order parameter)
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

        searchResults.value = productList
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error searching products: $e');
      // Use mock search results for demo purposes
      searchResults.value = _getMockSearchResults();
    }
  }

  // Filter and sort functionality
  void updateCategory(String categoryId) {
    selectedCategory.value = categoryId;
    _updateActiveFilters();

    if (searchQuery.value.isNotEmpty) {
      performSearch();
    }
  }

  void updateSortOption(String newSortOption) {
    sortOption.value = newSortOption;

    if (searchQuery.value.isNotEmpty) {
      performSearch();
    }
  }

  void addFilter(String filter) {
    if (!activeFilters.contains(filter)) {
      activeFilters.add(filter);

      if (searchQuery.value.isNotEmpty) {
        performSearch();
      }
    }
  }

  void removeFilter(String filter) {
    activeFilters.remove(filter);

    if (searchQuery.value.isNotEmpty) {
      performSearch();
    }
  }

  void clearFilters() {
    activeFilters.clear();
    selectedCategory.value = '';
    sortOption.value = 'relevance';

    if (searchQuery.value.isNotEmpty) {
      performSearch();
    }
  }

  void clearResults() {
    searchResults.clear();
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    activeFilters.clear();
    selectedCategory.value = '';
    sortOption.value = 'relevance';
    error.value = null;
  }

  // Get popular searches or suggestions
  List<String> getSearchSuggestions() {
    return [
      'Headphones',
      'Smartphone',
      'Laptop',
      'T-shirt',
      'Sneakers',
      'Watch',
      'Camera',
      'Books',
    ];
  }

  // Get recent searches (would be stored locally in a real app)
  List<String> getRecentSearches() {
    return ['wireless headphones', 'running shoes', 'coffee maker'];
  }

  void _updateActiveFilters() {
    activeFilters.clear();

    if (selectedCategory.value.isNotEmpty) {
      activeFilters.add('Category: ${selectedCategory.value}');
    }

    if (sortOption.value != 'relevance') {
      String sortLabel = _getSortLabel(sortOption.value);
      activeFilters.add('Sort: $sortLabel');
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
        return 'Relevance';
    }
  }

  // Mock search results for demo purposes
  List<Product> _getMockSearchResults() {
    final mockResults = <Product>[];

    // Generate mock results based on search query
    final queryLower = searchQuery.value.toLowerCase();
    final resultCount = queryLower.contains('headphone')
        ? 8
        : queryLower.contains('phone')
        ? 12
        : queryLower.contains('shirt')
        ? 15
        : 6;

    for (int i = 0; i < resultCount; i++) {
      mockResults.add(
        Product(
          id: 'search_result_$i',
          title:
              '${searchQuery.value.isNotEmpty ? searchQuery.value : 'Product'} ${i + 1}',
          description:
              'Search result for "${searchQuery.value}" - Product ${i + 1}',
          thumbnail:
              'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=${Uri.encodeComponent(searchQuery.value)}+${i + 1}',
          images: [
            ProductImage(
              id: 'search_img_$i',
              url:
                  'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=${Uri.encodeComponent(searchQuery.value)}+${i + 1}',
            ),
          ],
          variants: [
            ProductVariant(
              id: 'search_variant_$i',
              title: 'Default Variant',
              prices: [
                ProductVariantPrice(
                  id: 'search_price_$i',
                  currencyCode: 'USD',
                  amount: (1500 + (i * 200)), // Varying prices
                ),
              ],
            ),
          ],
        ),
      );
    }

    return mockResults;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
