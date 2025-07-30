import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../models/ui_models.dart';
import '../parsers/json_parser.dart';
import '../utils/theme_manager.dart';
import '../utils/widget_mapper.dart';

class CategoryView extends StatefulWidget {
  final String categoryId;
  final String? categoryName;

  const CategoryView({super.key, required this.categoryId, this.categoryName});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  UIScreen? _categoryScreen;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategoryScreen();
  }

  Future<void> _loadCategoryScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load the category screen JSON
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/category_page.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _categoryScreen = UIScreen.fromJson(jsonData);
        _isLoading = false;
      });

      // Initialize the category controller
      if (mounted) {
        final controller = Get.find<CategoryController>();
        await controller.loadCategory(widget.categoryId);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load category: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName ?? 'Category'),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName ?? 'Category'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Failed to Load Category',
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
                onPressed: _loadCategoryScreen,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final controller = Get.find<CategoryController>();
          return Text(
            controller.category.value?.name ??
                widget.categoryName ??
                'Category',
          );
        }),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: Obx(() {
        final controller = Get.find<CategoryController>();

        if (controller.isLoading.value && controller.category.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Connection Error',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.error.value!,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return _buildCategoryContent(controller);
      }),
    );
  }

  Widget _buildCategoryContent(CategoryController controller) {
    return Column(
      children: [
        // Category header
        Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.category.value?.name ?? 'Category',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.category.value?.description ??
                          'Category description',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text('📦', style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ),

        // Filter and view controls
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Filter & Sort',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, size: 16),
                      onPressed: () {
                        _showFilterBottomSheet(context, controller);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: controller.viewType.value == 'grid'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.grid_view,
                        size: 16,
                        color: controller.viewType.value == 'grid'
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      onPressed: () {
                        controller.setViewType('grid');
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: controller.viewType.value == 'list'
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.list,
                        size: 16,
                        color: controller.viewType.value == 'list'
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      onPressed: () {
                        controller.setViewType('list');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Active filters
        if (controller.activeFilters.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.activeFilters.map((filter) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(filter),
                      onDeleted: () {
                        controller.removeFilter(filter);
                      },
                      backgroundColor: Colors.green[50],
                      deleteIconColor: Colors.green[700],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        const Divider(height: 1),

        // Products header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.productsCount} products found',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              GestureDetector(
                onTap: () => _showSortBottomSheet(context, controller),
                child: Row(
                  children: [
                    Text(
                      'Sort: ',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      _getSortLabel(controller.sortOption.value),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Products grid/list
        Expanded(child: _buildProductsView(controller)),
      ],
    );
  }

  Widget _buildProductsView(CategoryController controller) {
    if (controller.products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Products Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (controller.viewType.value == 'grid') {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          return WidgetMapper.buildProductCard(
            controller.products[index],
            context,
          );
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: WidgetMapper.buildProductCard(
              controller.products[index],
              context,
            ),
          );
        },
      );
    }
  }

  void _showFilterBottomSheet(
    BuildContext context,
    CategoryController controller,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.clearFilters();
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
    CategoryController controller,
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
                'featured',
                'price_low_high',
                'price_high_low',
                'name_asc',
                'newest',
              ].map((option) {
                return ListTile(
                  title: Text(_getSortLabel(option)),
                  trailing: controller.sortOption.value == option
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    controller.updateSortOption(option);
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
        return 'Featured';
    }
  }
}
