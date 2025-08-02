import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/home_controller.dart';
import 'controllers/product_detail_controller.dart';
import 'controllers/search_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/marketplace_controller.dart';
import 'utils/theme_manager.dart';
import 'controllers/orders_controller.dart';
import 'views/home_view.dart';
import 'views/shop_home_view.dart';
import 'views/product_detail_view.dart';
import 'views/search_view.dart';

import 'views/cart_view.dart';
import 'views/checkout_view.dart';
import 'views/marketplace_view.dart';
import 'views/shop_view.dart';
import 'views/bookmarks_view.dart';
import 'views/orders_view.dart';
import 'views/order_confirmation_view.dart';
import 'views/new_home_view.dart';
import 'views/shops_tab_view.dart';
import 'views/instant_items_view.dart';
import 'views/take_away_view.dart';
import 'views/reorder_view.dart';
import 'views/category_view.dart';
import 'views/offers_view.dart';
import 'views/shop_detail_view.dart';
import 'common/floating_cart_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load theme from JSON
  await ThemeManager.loadTheme();

  runApp(const OneMartApp());
}

class OneMartApp extends StatelessWidget {
  const OneMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controllers
    Get.put(FavoritesController());
    Get.put(CartController());
    Get.put(HomeController());
    Get.put(ProductDetailController());
    Get.put(ProductSearchController());
    Get.put(CategoryController());
    Get.put(MarketplaceController());
    Get.put(OrdersController());

    return GetMaterialApp(
      title: 'OneMart - Server Driven UI',
      theme: ThemeManager.materialTheme,
      debugShowCheckedModeBanner: false,
      home: const MainAppShell(),
      getPages: [
        GetPage(
          name: '/home',
          page: () {
            final shopId = Get.parameters['shopId'];
            final shopName = Get.parameters['shopName'];

            // If shop parameters are provided, show shop home view
            if (shopId != null && shopId.isNotEmpty) {
              return ShopHomeView(shopId: shopId, shopName: shopName);
            }

            // Otherwise show regular home view
            return HomeView(shopId: shopId);
          },
        ),
        GetPage(
          name: '/product-detail',
          page: () =>
              ProductDetailView(productId: Get.parameters['productId'] ?? ''),
        ),
        GetPage(
          name: '/search',
          page: () => SearchView(initialQuery: Get.parameters['query']),
        ),
        GetPage(name: '/cart', page: () => const CartView()),
        GetPage(name: '/checkout', page: () => const CheckoutView()),
        GetPage(name: '/marketplace', page: () => const MarketplaceView()),
        GetPage(
          name: '/shop/:shopId',
          page: () => ShopView(shopId: Get.parameters['shopId'] ?? ''),
        ),
        GetPage(
          name: '/shop-detail',
          page: () => ShopDetailView(shopId: Get.parameters['shopId'] ?? ''),
        ),
        GetPage(
          name: '/flash-sale',
          page: () => const PlaceholderPage(title: 'Flash Sale'),
        ),
        GetPage(
          name: '/new-arrivals',
          page: () => const PlaceholderPage(title: 'New Arrivals'),
        ),
        GetPage(
          name: '/summer-sale',
          page: () => const PlaceholderPage(title: 'Summer Sale'),
        ),
        GetPage(
          name: '/black-friday',
          page: () => const PlaceholderPage(title: 'Black Friday'),
        ),
        GetPage(
          name: '/promotional-offers',
          page: () => const PlaceholderPage(title: 'Promotional Offers'),
        ),
        GetPage(
          name: '/order-confirmation',
          page: () => const OrderConfirmationView(),
        ),
        GetPage(
          name: '/category',
          page: () => CategoryView(
            categoryId: Get.parameters['categoryId'] ?? '',
            categoryName: Get.parameters['categoryName'],
          ),
        ),
        GetPage(
          name: '/offers',
          page: () => const OffersView(),
        ),
      ],
    );
  }
}

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NewHomeView(),
    const ShopsTabView(),
    const InstantItemsView(),
    const TakeAwayView(),
    const ReorderView(),
  ];

  List<BottomNavigationBarItem> get _bottomNavItems {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.store_outlined),
        activeIcon: Icon(Icons.store),
        label: 'Shops',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.flash_on_outlined),
        activeIcon: Icon(Icons.flash_on),
        label: 'Instant Items',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.takeout_dining_outlined),
        activeIcon: Icon(Icons.takeout_dining),
        label: 'Take Away',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.refresh_outlined),
        activeIcon: Icon(Icons.refresh),
        label: 'Reorder',
      ),
    ];
  }

  Widget _buildCartIcon(CartController cartController, bool isActive) {
    final itemCount = cartController.totalQuantity;

    return Stack(
      children: [
        Icon(isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined),
        if (itemCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                itemCount > 99 ? '99+' : itemCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  AppBar? _buildAppBar(BuildContext context) {
    // Most new views handle their own app bars or use slivers
    // Only show app bar for specific tabs that need it
    switch (_currentIndex) {
      case 0: // Home
        return AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'OneMart',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                // Handle notifications
              },
            ),
          ],
        );
      case 1: // Shops - uses SliverAppBar
      case 2: // Instant Items
      case 3: // Take Away
      case 4: // Reorder
        return null; // These views handle their own app bars
      default:
        return AppBar(
          backgroundColor: Colors.white,
          title: const Text('OneMart'),
          centerTitle: true,
          elevation: 0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
          const FloatingCartWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: _bottomNavItems,
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'This page is under construction',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
