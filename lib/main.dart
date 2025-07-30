import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/home_controller.dart';
import 'controllers/product_detail_controller.dart';
import 'controllers/search_controller.dart';
import 'controllers/category_controller.dart';
import 'utils/theme_manager.dart';
import 'views/home_view.dart';
import 'views/product_detail_view.dart';
import 'views/search_view.dart';
import 'views/category_view.dart';

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
    Get.put(HomeController());
    Get.put(ProductDetailController());
    Get.put(ProductSearchController());
    Get.put(CategoryController());

    return GetMaterialApp(
      title: 'OneMart - Server Driven UI',
      theme: ThemeManager.materialTheme,
      debugShowCheckedModeBanner: false,
      home: const MainAppShell(),
      getPages: [
        GetPage(name: '/home', page: () => const MainAppShell()),
        GetPage(
          name: '/product-detail',
          page: () =>
              ProductDetailView(productId: Get.parameters['productId'] ?? ''),
        ),
        GetPage(
          name: '/search',
          page: () => SearchView(initialQuery: Get.parameters['query']),
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
    const HomeView(),
    const PlaceholderPage(title: 'Cart'),
    const PlaceholderPage(title: 'My Orders'),
    const PlaceholderPage(title: 'Overview'),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart_outlined),
      activeIcon: Icon(Icons.shopping_cart),
      label: 'Cart',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: 'My Orders',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Overview',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
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
