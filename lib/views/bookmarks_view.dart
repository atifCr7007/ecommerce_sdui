import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/favorites_controller.dart';
import '../models/ui_models.dart';
import '../models/product.dart';
import '../utils/json_ui_parser.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});

  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  UIScreen? _bookmarksScreen;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookmarksScreen();
  }

  Future<void> _loadBookmarksScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      if (kDebugMode) {
        debugPrint('[BookmarksView] Loading bookmarks screen JSON...');
      }

      // Load the bookmarks screen JSON with better error handling
      String jsonString;
      try {
        jsonString = await rootBundle.loadString(
          'assets/json_ui/bookmarks.json',
        );
        if (kDebugMode) {
          debugPrint(
            '[BookmarksView] Successfully loaded bookmarks.json (${jsonString.length} characters)',
          );
        }
      } catch (assetError) {
        if (kDebugMode) {
          debugPrint('[BookmarksView] Asset loading error: $assetError');
        }
        throw Exception('Failed to load bookmarks.json asset: $assetError');
      }

      // Parse JSON with validation
      Map<String, dynamic> jsonData;
      try {
        jsonData = json.decode(jsonString) as Map<String, dynamic>;
        if (kDebugMode) {
          debugPrint('[BookmarksView] Successfully parsed JSON data');
        }
      } catch (parseError) {
        if (kDebugMode) {
          debugPrint('[BookmarksView] JSON parsing error: $parseError');
        }
        throw Exception('Failed to parse bookmarks.json: $parseError');
      }

      // Validate required fields
      if (!jsonData.containsKey('screenId') ||
          !jsonData.containsKey('components')) {
        throw Exception(
          'Invalid bookmarks.json structure: missing required fields',
        );
      }

      // Create UI screen model
      UIScreen bookmarksScreen;
      try {
        bookmarksScreen = UIScreen.fromJson(jsonData);
        if (kDebugMode) {
          debugPrint('[BookmarksView] Successfully created UIScreen model');
        }
      } catch (modelError) {
        if (kDebugMode) {
          debugPrint(
            '[BookmarksView] UIScreen model creation error: $modelError',
          );
        }
        throw Exception('Failed to create bookmarks screen model: $modelError');
      }

      setState(() {
        _bookmarksScreen = bookmarksScreen;
        _isLoading = false;
      });

      if (kDebugMode) {
        debugPrint('[BookmarksView] Bookmarks screen loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BookmarksView] Error loading bookmarks screen: $e');
      }
      setState(() {
        _error = 'Failed to load bookmarks: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bookmarks'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadBookmarksScreen,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_bookmarksScreen == null) {
      return const Scaffold(
        appBar: null,
        body: Center(child: Text('No content available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookmarks'),
        centerTitle: true,
        actions: [
          Obx(() {
            final favoritesController = Get.find<FavoritesController>();
            if (favoritesController.hasFavorites) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'clear':
                      _showClearBookmarksDialog(favoritesController);
                      break;
                    case 'share':
                      _shareBookmarksList(favoritesController);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 8),
                        Text('Share List'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Clear All', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        final favoritesController = Get.find<FavoritesController>();

        if (favoritesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => favoritesController.refresh(),
          child: _buildBookmarksContent(favoritesController),
        );
      }),
    );
  }

  Widget _buildBookmarksContent(FavoritesController favoritesController) {
    // Create a custom parser that can handle bookmarks-specific data
    return BookmarksJsonParser.parseScreen(
      _bookmarksScreen!,
      context,
      favoritesController,
    );
  }

  void _showClearBookmarksDialog(FavoritesController favoritesController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: const Text(
          'Are you sure you want to remove all bookmarks? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              favoritesController.clearAllFavorites();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _shareBookmarksList(FavoritesController favoritesController) async {
    try {
      final favorites = favoritesController.favorites;
      if (favorites.isEmpty) return;

      final shareText =
          '''
My Favorite Products from OneMart

${favorites.map((product) => '• ${product.title} - ${product.displayPrice}').join('\n')}

Total: ${favorites.length} items

Check out these amazing products on OneMart!
#OneMart #Favorites #Shopping
'''
              .trim();

      await Share.share(
        shareText,
        subject: 'My OneMart Favorites (${favorites.length} items)',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share bookmarks list',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

// Custom parser for bookmarks screen that can inject favorites data
class BookmarksJsonParser {
  static Widget parseScreen(
    UIScreen screen,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    // Handle the root component properly - it should be a scrollview
    if (screen.components.isNotEmpty) {
      return _parseComponent(
        screen.components.first,
        context,
        favoritesController,
      );
    }

    return const Center(child: Text('No content available'));
  }

  static Widget _parseComponent(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    // Handle special bookmarks components by ID first
    switch (component.id) {
      case 'bookmarks_count':
        return _buildBookmarksCount(component, context, favoritesController);
      case 'bookmarks_grid':
        return _buildBookmarksGrid(component, context, favoritesController);
      case 'bookmarks_grid_container':
        return _buildBookmarksGridContainer(
          component,
          context,
          favoritesController,
        );
      case 'empty_bookmarks_state':
        return _buildEmptyBookmarksState(
          component,
          context,
          favoritesController,
        );
      case 'bookmarks_actions':
        return _buildBookmarksActions(component, context, favoritesController);
      case 'clear_bookmarks_button':
        return _buildClearBookmarksButton(
          component,
          context,
          favoritesController,
        );
      case 'share_bookmarks_button':
        return _buildShareBookmarksButton(
          component,
          context,
          favoritesController,
        );
      default:
        // For components with children, parse them recursively
        if (component.children != null && component.children!.isNotEmpty) {
          final parsedChildren = component.children!.map((child) {
            return _parseComponent(child, context, favoritesController);
          }).toList();

          // Use standard parser but handle children properly
          return _buildComponentWithChildren(
            component,
            parsedChildren,
            context,
          );
        }

        // Use the standard JSON UI parser for leaf components
        return JsonUIParser.parseComponent(component, context);
    }
  }

  static Widget _buildBookmarksCount(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    final count = favoritesController.favoritesCount;
    final text = count == 1 ? '1 item' : '$count items';

    return Text(
      text,
      style: TextStyle(
        fontSize: (component.properties['fontSize'] as num?)?.toDouble() ?? 14,
        color: _parseColor(component.properties['color']),
      ),
    );
  }

  static Widget _buildBookmarksGrid(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    final favorites = favoritesController.favorites;
    if (favorites.isEmpty) {
      if (kDebugMode) {
        debugPrint('[BookmarksView] No favorites to display in grid');
      }
      return const SizedBox.shrink();
    }

    if (kDebugMode) {
      debugPrint(
        '[BookmarksView] Building grid with ${favorites.length} favorites',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal cross axis count based on screen width
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = screenWidth > 600 ? 3 : 2;
        final itemWidth =
            (screenWidth - (16 * 2) - (12 * (crossAxisCount - 1))) /
            crossAxisCount;
        final childAspectRatio =
            itemWidth / (itemWidth * 1.3); // Adjust height ratio

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return _buildBookmarkCard(product, favoritesController, context);
            },
          ),
        );
      },
    );
  }

  static Widget _buildBookmarkCard(
    Product product,
    FavoritesController favoritesController,
    BuildContext context,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          // Navigate to product detail
          Get.toNamed('/product/${product.id}');
        },
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.displayPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (kDebugMode) {
                              debugPrint(
                                '[BookmarksView] Removing from favorites: ${product.title}',
                              );
                            }
                            favoritesController.removeFromFavorites(product.id);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
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

  static Widget _buildBookmarksGridContainer(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    final favorites = favoritesController.favorites;
    if (favorites.isEmpty) {
      return const SizedBox.shrink();
    }

    // Parse children and show the bookmarks grid
    final parsedChildren =
        component.children?.map((child) {
          return _parseComponent(child, context, favoritesController);
        }).toList() ??
        [];

    return Container(
      constraints: BoxConstraints(
        minHeight:
            (component.properties['minHeight'] as num?)?.toDouble() ?? 200,
      ),
      child: Column(children: parsedChildren),
    );
  }

  static Widget _buildEmptyBookmarksState(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    final favorites = favoritesController.favorites;
    if (favorites.isNotEmpty) {
      return const SizedBox.shrink();
    }

    // Parse children for empty state
    final parsedChildren =
        component.children?.map((child) {
          return _parseComponent(child, context, favoritesController);
        }).toList() ??
        [];

    return Container(
      padding: _parsePadding(component.properties['padding']),
      alignment: Alignment.center,
      child: Column(children: parsedChildren),
    );
  }

  static Widget _buildBookmarksActions(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    final favorites = favoritesController.favorites;
    if (favorites.isEmpty) {
      return const SizedBox.shrink();
    }

    // Parse children for bookmarks actions
    final parsedChildren =
        component.children?.map((child) {
          return _parseComponent(child, context, favoritesController);
        }).toList() ??
        [];

    return Container(
      margin: _parseMargin(component.properties['margin']),
      padding: _parsePadding(component.properties['padding']),
      decoration: BoxDecoration(
        color: _parseColor(component.properties['backgroundColor']),
        borderRadius: BorderRadius.circular(
          (component.properties['borderRadius'] as num?)?.toDouble() ?? 0,
        ),
      ),
      child: Column(children: parsedChildren),
    );
  }

  static Widget _buildClearBookmarksButton(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    return SizedBox(
      height: (component.properties['height'] as num?)?.toDouble() ?? 40,
      width: (component.properties['width'] as num?)?.toDouble() ?? 120,
      child: ElevatedButton(
        onPressed: () => _handleClearBookmarks(context, favoritesController),
        style: ElevatedButton.styleFrom(
          backgroundColor: _parseColor(component.properties['backgroundColor']),
          foregroundColor: _parseColor(component.properties['textColor']),
        ),
        child: Text(
          component.properties['text']?.toString() ?? 'Clear All',
          style: TextStyle(
            fontSize:
                (component.properties['fontSize'] as num?)?.toDouble() ?? 14,
          ),
        ),
      ),
    );
  }

  static Widget _buildShareBookmarksButton(
    UIComponent component,
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    return SizedBox(
      height: (component.properties['height'] as num?)?.toDouble() ?? 40,
      width: (component.properties['width'] as num?)?.toDouble() ?? 120,
      child: ElevatedButton(
        onPressed: () => _handleShareBookmarks(context, favoritesController),
        style: ElevatedButton.styleFrom(
          backgroundColor: _parseColor(component.properties['backgroundColor']),
          foregroundColor: _parseColor(component.properties['textColor']),
        ),
        child: Text(
          component.properties['text']?.toString() ?? 'Share List',
          style: TextStyle(
            fontSize:
                (component.properties['fontSize'] as num?)?.toDouble() ?? 14,
          ),
        ),
      ),
    );
  }

  static void _handleClearBookmarks(
    BuildContext context,
    FavoritesController favoritesController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: const Text(
          'Are you sure you want to remove all bookmarks? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              favoritesController.clearAllFavorites();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static void _handleShareBookmarks(
    BuildContext context,
    FavoritesController favoritesController,
  ) async {
    try {
      final favorites = favoritesController.favorites;
      if (favorites.isEmpty) return;

      final shareText =
          '''
My Favorite Products from OneMart

${favorites.map((product) => '• ${product.title} - ${product.displayPrice}').join('\n')}

Total: ${favorites.length} items

Check out these amazing products on OneMart!
#OneMart #Favorites #Shopping
'''
              .trim();

      await Share.share(
        shareText,
        subject: 'My OneMart Favorites (${favorites.length} items)',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share bookmarks list',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  static Widget _buildComponentWithChildren(
    UIComponent component,
    List<Widget> children,
    BuildContext context,
  ) {
    switch (component.type.toLowerCase()) {
      case 'scrollview':
        return SingleChildScrollView(child: Column(children: children));
      case 'column':
        return Column(
          mainAxisAlignment: _parseMainAxisAlignment(
            component.properties['mainAxisAlignment'],
          ),
          crossAxisAlignment: _parseCrossAxisAlignment(
            component.properties['crossAxisAlignment'],
          ),
          children: children,
        );
      case 'row':
        return Row(
          mainAxisAlignment: _parseMainAxisAlignment(
            component.properties['mainAxisAlignment'],
          ),
          crossAxisAlignment: _parseCrossAxisAlignment(
            component.properties['crossAxisAlignment'],
          ),
          children: children,
        );
      case 'container':
        return Container(
          height: (component.properties['height'] as num?)?.toDouble(),
          width: (component.properties['width'] as num?)?.toDouble(),
          margin: _parseMargin(component.properties['margin']),
          padding: _parsePadding(component.properties['padding']),
          decoration: BoxDecoration(
            color: _parseColor(component.properties['backgroundColor']),
            borderRadius: BorderRadius.circular(
              (component.properties['borderRadius'] as num?)?.toDouble() ?? 0,
            ),
          ),
          alignment: _parseAlignment(component.properties['alignment']),
          child: children.isNotEmpty ? children.first : null,
        );
      case 'padding':
        final padding =
            component.properties['padding'] as Map<String, dynamic>?;
        return Padding(
          padding: _parsePadding(padding),
          child: children.isNotEmpty ? children.first : null,
        );
      case 'expanded':
        return Expanded(
          child: children.isNotEmpty ? children.first : const SizedBox(),
        );
      default:
        return Column(children: children);
    }
  }

  // Helper methods for parsing properties
  static Color? _parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    if (colorValue is String) {
      if (colorValue.startsWith('#')) {
        return Color(
          int.parse(colorValue.substring(1), radix: 16) + 0xFF000000,
        );
      }
    }
    return null;
  }

  static EdgeInsets _parsePadding(Map<String, dynamic>? padding) {
    if (padding == null) return EdgeInsets.zero;

    if (padding.containsKey('all')) {
      return EdgeInsets.all((padding['all'] as num).toDouble());
    }

    final horizontal = (padding['horizontal'] as num?)?.toDouble() ?? 0;
    final vertical = (padding['vertical'] as num?)?.toDouble() ?? 0;

    return EdgeInsets.only(
      top: (padding['top'] as num?)?.toDouble() ?? vertical,
      bottom: (padding['bottom'] as num?)?.toDouble() ?? vertical,
      left: (padding['left'] as num?)?.toDouble() ?? horizontal,
      right: (padding['right'] as num?)?.toDouble() ?? horizontal,
    );
  }

  static EdgeInsets _parseMargin(Map<String, dynamic>? margin) {
    if (margin == null) return EdgeInsets.zero;

    if (margin.containsKey('all')) {
      return EdgeInsets.all((margin['all'] as num).toDouble());
    }

    return EdgeInsets.only(
      top: (margin['top'] as num?)?.toDouble() ?? 0,
      bottom: (margin['bottom'] as num?)?.toDouble() ?? 0,
      left: (margin['left'] as num?)?.toDouble() ?? 0,
      right: (margin['right'] as num?)?.toDouble() ?? 0,
    );
  }

  static MainAxisAlignment _parseMainAxisAlignment(dynamic alignment) {
    if (alignment == null) return MainAxisAlignment.start;
    if (alignment is String) {
      switch (alignment.toLowerCase()) {
        case 'center':
          return MainAxisAlignment.center;
        case 'end':
          return MainAxisAlignment.end;
        case 'spacebetween':
          return MainAxisAlignment.spaceBetween;
        case 'spacearound':
          return MainAxisAlignment.spaceAround;
        case 'spaceevenly':
          return MainAxisAlignment.spaceEvenly;
        default:
          return MainAxisAlignment.start;
      }
    }
    return MainAxisAlignment.start;
  }

  static CrossAxisAlignment _parseCrossAxisAlignment(dynamic alignment) {
    if (alignment == null) return CrossAxisAlignment.start;
    if (alignment is String) {
      switch (alignment.toLowerCase()) {
        case 'center':
          return CrossAxisAlignment.center;
        case 'end':
          return CrossAxisAlignment.end;
        case 'stretch':
          return CrossAxisAlignment.stretch;
        default:
          return CrossAxisAlignment.start;
      }
    }
    return CrossAxisAlignment.start;
  }

  static Alignment? _parseAlignment(dynamic alignment) {
    if (alignment == null) return null;
    if (alignment is String) {
      switch (alignment.toLowerCase()) {
        case 'center':
          return Alignment.center;
        case 'topleft':
          return Alignment.topLeft;
        case 'topright':
          return Alignment.topRight;
        case 'bottomleft':
          return Alignment.bottomLeft;
        case 'bottomright':
          return Alignment.bottomRight;
        default:
          return null;
      }
    }
    return null;
  }
}
