import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../models/ui_models.dart';
import '../parsers/json_parser.dart';
import '../utils/theme_manager.dart';
import '../utils/widget_mapper.dart';

class SearchView extends StatefulWidget {
  final String? initialQuery;

  const SearchView({super.key, this.initialQuery});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  UIScreen? _searchScreen;
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSearchScreen();

    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final searchController = Get.find<ProductSearchController>();
        searchController.updateSearchQuery(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSearchScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load the search screen JSON
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/search_page.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _searchScreen = UIScreen.fromJson(jsonData);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load search screen: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Search'), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Search'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Failed to Load Search',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadSearchScreen,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Obx(() {
        final searchController = Get.find<ProductSearchController>();
        return Column(
          children: [
            // Custom search bar
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (query) {
                          searchController.updateSearchQuery(query);
                        },
                        onSubmitted: (query) {
                          searchController.performSearch();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: () {
                        _showFilterBottomSheet(context, searchController);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            if (searchController.activeFilters.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: searchController.activeFilters.map((filter) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(filter),
                          onDeleted: () {
                            searchController.removeFilter(filter);
                          },
                          backgroundColor: Colors.blue[50],
                          deleteIconColor: Colors.blue[700],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            const Divider(height: 1),

            // Search results
            Expanded(child: _buildSearchResults(searchController)),
          ],
        );
      }),
    );
  }

  Widget _buildSearchResults(ProductSearchController searchController) {
    if (searchController.searchQuery.value.isEmpty) {
      return _buildSearchSuggestions(searchController);
    }

    if (searchController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchController.error.value != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Search Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                searchController.error.value!,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => searchController.performSearch(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (searchController.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${searchController.resultsCount} results found',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              Row(
                children: [
                  Text(
                    'Sort by: ',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: () =>
                        _showSortBottomSheet(context, searchController),
                    child: Text(
                      _getSortLabel(searchController.sortOption.value),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Results grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: searchController.searchResults.length,
            itemBuilder: (context, index) {
              return WidgetMapper.buildProductCard(
                searchController.searchResults[index],
                context,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions(ProductSearchController searchController) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: searchController.getRecentSearches().map((search) {
              return ActionChip(
                label: Text(search),
                onPressed: () {
                  _searchController.text = search;
                  searchController.updateSearchQuery(search);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Popular Searches',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: searchController.getSearchSuggestions().map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  _searchController.text = suggestion;
                  searchController.updateSearchQuery(suggestion);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    ProductSearchController searchController,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Category', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['All', 'Electronics', 'Clothing', 'Books', 'Home']
                    .map((category) {
                      final isSelected =
                          searchController.selectedCategory.value ==
                          category.toLowerCase();
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          searchController.updateCategory(
                            selected ? category.toLowerCase() : '',
                          );
                          Navigator.pop(context);
                        },
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      searchController.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(
    BuildContext context,
    ProductSearchController searchController,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sort By', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...[
                'relevance',
                'price_low_high',
                'price_high_low',
                'name_asc',
                'newest',
              ].map((option) {
                return ListTile(
                  title: Text(_getSortLabel(option)),
                  trailing: searchController.sortOption.value == option
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    searchController.updateSortOption(option);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getSortLabel(String sortOption) {
    switch (sortOption) {
      case 'price_low_high':
        return 'Price: Low to High';
      case 'price_high_low':
        return 'Price: High to Low';
      case 'name_asc':
        return 'Name: A to Z';
      case 'newest':
        return 'Newest First';
      default:
        return 'Relevance';
    }
  }
}
