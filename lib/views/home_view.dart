import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/ui_models.dart';
import '../parsers/json_parser.dart';
import '../utils/theme_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UIScreen? _homeScreen;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHomeScreen();
  }

  Future<void> _loadHomeScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load the home screen JSON with proper null safety checks
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/home_page.json',
      );

      // Parse JSON with null safety
      final dynamic decodedJson = json.decode(jsonString);
      if (decodedJson == null) {
        throw Exception('JSON file is empty or invalid');
      }

      final Map<String, dynamic>? jsonData =
          decodedJson as Map<String, dynamic>?;
      if (jsonData == null) {
        throw Exception('JSON structure is not a valid Map<String, dynamic>');
      }

      // Validate required fields
      if (!jsonData.containsKey('screenId') ||
          !jsonData.containsKey('components')) {
        throw Exception('JSON missing required fields: screenId or components');
      }

      if (kDebugMode) {
        debugPrint('[HomeView] ===== HOME JSON UI =====');
        debugPrint(
          '[HomeView] JSON Content: ${jsonString.substring(0, 500)}...',
        );
        debugPrint('[HomeView] Screen ID: ${jsonData['screenId']}');
        debugPrint(
          '[HomeView] Components Count: ${jsonData['components']?.length ?? 0}',
        );
        debugPrint('[HomeView] ===========================');
      }

      setState(() {
        _homeScreen = UIScreen.fromJson(jsonData);
        _isLoading = false;
      });

      // Initialize the home controller
      if (mounted) {
        final homeController = Get.find<HomeController>();
        await homeController.initializeHome();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load home screen: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
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
                onPressed: _loadHomeScreen,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_homeScreen == null) {
      return const Scaffold(body: Center(child: Text('No content available')));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadHomeScreen();
          if (mounted) {
            final homeController = Get.find<HomeController>();
            if (mounted) {
              await homeController.refresh();
            }
          }
        },
        child: Obx(() {
          final homeController = Get.find<HomeController>();

          if (homeController.isLoading.value && _homeScreen == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (homeController.error.value != null) {
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
                      homeController.error.value!,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => homeController.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return _buildHomeContent();
        }),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: JsonUIParser.parseScreen(_homeScreen!, context),
    );
  }
}

// Custom widgets for specific home components
class HomeCarousel extends StatelessWidget {
  final List<String> images;
  final bool autoPlay;
  final int autoPlayInterval;
  final bool showIndicators;
  final double height;

  const HomeCarousel({
    super.key,
    required this.images,
    this.autoPlay = true,
    this.autoPlayInterval = 3,
    this.showIndicators = true,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    // This would use the WidgetMapper.buildCarousel implementation
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('Carousel Component')),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final String title;
  final bool isHorizontal;
  final bool showViewAll;
  final int limit;

  const ProductGrid({
    super.key,
    required this.title,
    this.isHorizontal = true,
    this.showViewAll = false,
    this.limit = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: ThemeManager.getTextStyle('headline5')),
                if (showViewAll)
                  TextButton(
                    onPressed: () {
                      // Handle view all
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
          ),
        ],
        Container(
          height: isHorizontal ? 280 : null,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            final controller = Get.find<HomeController>();

            if (controller.products.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            if (isHorizontal) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: controller.products[index]);
                },
              );
            } else {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: controller.products[index]);
                },
              );
            }
          }),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic
  product; // Using dynamic for now, would be Product in real implementation

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12.0),
      child: Card(
        elevation: ThemeManager.getElevation('low'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ThemeManager.getBorderRadius('medium'),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      ThemeManager.getBorderRadius('medium'),
                    ),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(ThemeManager.getSpacing('sm')),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Product',
                      style: ThemeManager.getTextStyle(
                        'body2',
                      ).copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$29.99',
                      style: ThemeManager.getTextStyle('body2').copyWith(
                        color: ThemeManager.getColor('success'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: ThemeManager.getColor('warning'),
                          size: 12,
                        ),
                        Text(
                          '4.5',
                          style: ThemeManager.getTextStyle('caption'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final double height;
  final VoidCallback? onTap;

  const PromoBanner({
    super.key,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.height = 150.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
        horizontal: ThemeManager.getSpacing('md'),
        vertical: ThemeManager.getSpacing('sm'),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ThemeManager.getBorderRadius('medium'),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image, color: Colors.grey, size: 50),
              ),
            ),
            Container(color: Colors.black.withValues(alpha: 0.3)),
            if (title != null || subtitle != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: ThemeManager.getTextStyle(
                          'headline5',
                        ).copyWith(color: Colors.white),
                      ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: ThemeManager.getTextStyle(
                          'body2',
                        ).copyWith(color: Colors.white),
                      ),
                    ],
                  ],
                ),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ],
        ),
      ),
    );
  }
}
