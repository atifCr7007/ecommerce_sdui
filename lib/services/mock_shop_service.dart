import 'package:ecommerce_sdui/models/shop.dart';
import 'package:ecommerce_sdui/models/shop_theme.dart';

/// Mock service for shop data with custom themes
class MockShopService {
  static final MockShopService _instance = MockShopService._internal();
  factory MockShopService() => _instance;
  MockShopService._internal();

  /// List of 10 diverse mock shops with unique themes
  static final List<Shop> _mockShops = [
    Shop(
      id: 'shop_001',
      name: 'Spice Garden Restaurant',
      description: 'Authentic Indian cuisine with traditional spices and flavors',
      logo: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=800&h=400&fit=crop',
      rating: 4.5,
      reviewCount: 1250,
      category: 'food',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_001', 'prod_002', 'prod_003'],
      contact: ShopContact(
        email: 'contact@spicegarden.com',
        phone: '+91 98765 43210',
        website: 'https://spicegarden.com',
        address: ShopAddress(
          street: '123 MG Road',
          city: 'Bangalore',
          state: 'Karnataka',
          country: 'India',
          zipCode: '560001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_002',
      name: 'TechZone Electronics',
      description: 'Latest gadgets and electronics with warranty and support',
      logo: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800&h=400&fit=crop',
      rating: 4.2,
      reviewCount: 890,
      category: 'electronics',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_004', 'prod_005', 'prod_006'],
      contact: ShopContact(
        email: 'support@techzone.com',
        phone: '+91 87654 32109',
        website: 'https://techzone.com',
        address: ShopAddress(
          street: '456 Commercial Street',
          city: 'Mumbai',
          state: 'Maharashtra',
          country: 'India',
          zipCode: '400001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_003',
      name: 'Fashion Forward',
      description: 'Trendy clothing and accessories for modern lifestyle',
      logo: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=400&fit=crop',
      rating: 4.7,
      reviewCount: 2100,
      category: 'clothing',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_007', 'prod_008', 'prod_009'],
      contact: ShopContact(
        email: 'hello@fashionforward.com',
        phone: '+91 76543 21098',
        website: 'https://fashionforward.com',
        address: ShopAddress(
          street: '789 Fashion Street',
          city: 'Delhi',
          state: 'Delhi',
          country: 'India',
          zipCode: '110001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_004',
      name: 'Green Grocery',
      description: 'Fresh organic vegetables and fruits delivered daily',
      logo: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&h=400&fit=crop',
      rating: 4.3,
      reviewCount: 750,
      category: 'food',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_010', 'prod_011', 'prod_012'],
      contact: ShopContact(
        email: 'orders@greengrocery.com',
        phone: '+91 65432 10987',
        website: 'https://greengrocery.com',
        address: ShopAddress(
          street: '321 Green Valley',
          city: 'Pune',
          state: 'Maharashtra',
          country: 'India',
          zipCode: '411001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_005',
      name: 'BookWorm Paradise',
      description: 'Vast collection of books, novels, and educational materials',
      logo: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&h=400&fit=crop',
      rating: 4.6,
      reviewCount: 1500,
      category: 'books',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_013', 'prod_014', 'prod_015'],
      contact: ShopContact(
        email: 'info@bookwormparadise.com',
        phone: '+91 54321 09876',
        website: 'https://bookwormparadise.com',
        address: ShopAddress(
          street: '654 Library Lane',
          city: 'Chennai',
          state: 'Tamil Nadu',
          country: 'India',
          zipCode: '600001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 400)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_006',
      name: 'Home Decor Studio',
      description: 'Beautiful home decor items and furniture for modern homes',
      logo: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&h=400&fit=crop',
      rating: 4.4,
      reviewCount: 980,
      category: 'home_garden',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_016', 'prod_017', 'prod_018'],
      contact: ShopContact(
        email: 'design@homedecorstudio.com',
        phone: '+91 43210 98765',
        website: 'https://homedecorstudio.com',
        address: ShopAddress(
          street: '987 Design District',
          city: 'Hyderabad',
          state: 'Telangana',
          country: 'India',
          zipCode: '500001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 250)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_007',
      name: 'Sports Arena',
      description: 'Complete sports equipment and fitness gear for athletes',
      logo: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=400&fit=crop',
      rating: 4.1,
      reviewCount: 650,
      category: 'sports',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_019', 'prod_020', 'prod_021'],
      contact: ShopContact(
        email: 'gear@sportsarena.com',
        phone: '+91 32109 87654',
        website: 'https://sportsarena.com',
        address: ShopAddress(
          street: '147 Sports Complex',
          city: 'Kolkata',
          state: 'West Bengal',
          country: 'India',
          zipCode: '700001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_008',
      name: 'Beauty Bliss',
      description: 'Premium beauty products and cosmetics for all skin types',
      logo: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&h=400&fit=crop',
      rating: 4.8,
      reviewCount: 1800,
      category: 'beauty',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_022', 'prod_023', 'prod_024'],
      contact: ShopContact(
        email: 'care@beautybliss.com',
        phone: '+91 21098 76543',
        website: 'https://beautybliss.com',
        address: ShopAddress(
          street: '258 Beauty Boulevard',
          city: 'Ahmedabad',
          state: 'Gujarat',
          country: 'India',
          zipCode: '380001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_009',
      name: 'Toy Kingdom',
      description: 'Educational and fun toys for children of all ages',
      logo: 'https://images.unsplash.com/photo-1558877385-1c4b6e0b6e4e?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1558877385-1c4b6e0b6e4e?w=800&h=400&fit=crop',
      rating: 4.5,
      reviewCount: 1100,
      category: 'toys',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_025', 'prod_026', 'prod_027'],
      contact: ShopContact(
        email: 'fun@toykingdom.com',
        phone: '+91 10987 65432',
        website: 'https://toykingdom.com',
        address: ShopAddress(
          street: '369 Toy Street',
          city: 'Jaipur',
          state: 'Rajasthan',
          country: 'India',
          zipCode: '302001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
    ),
    Shop(
      id: 'shop_010',
      name: 'Auto Parts Hub',
      description: 'Genuine auto parts and accessories for all vehicle types',
      logo: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=200&h=200&fit=crop',
      bannerImage: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=800&h=400&fit=crop',
      rating: 4.0,
      reviewCount: 420,
      category: 'automotive',
      isVerified: true,
      isActive: true,
      featuredProductIds: ['prod_028', 'prod_029', 'prod_030'],
      contact: ShopContact(
        email: 'parts@autopartshub.com',
        phone: '+91 09876 54321',
        website: 'https://autopartshub.com',
        address: ShopAddress(
          street: '741 Auto Street',
          city: 'Coimbatore',
          state: 'Tamil Nadu',
          country: 'India',
          zipCode: '641001',
        ),
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    ),
  ];

  /// Shop themes mapped by shop ID
  static final Map<String, ShopTheme> _shopThemes = {
    'shop_001': ShopTheme.simple(
      primaryColor: '#FF6B35',
      secondaryColor: '#FF8E53',
      backgroundColor: '#FFF8F5',
      textColor: '#2C1810',
      deliveryTime: '25-35 min',
      specialOffer: 'Free delivery on orders above ₹199',
    ),
    'shop_002': ShopTheme.simple(
      primaryColor: '#2196F3',
      secondaryColor: '#64B5F6',
      backgroundColor: '#F3F9FF',
      textColor: '#0D47A1',
      deliveryTime: '1-2 days',
      specialOffer: '1 year warranty on all products',
    ),
    'shop_003': ShopTheme.simple(
      primaryColor: '#E91E63',
      secondaryColor: '#F06292',
      backgroundColor: '#FCE4EC',
      textColor: '#880E4F',
      deliveryTime: '2-3 days',
      specialOffer: 'Buy 2 Get 1 Free on selected items',
    ),
    'shop_004': ShopTheme.simple(
      primaryColor: '#4CAF50',
      secondaryColor: '#81C784',
      backgroundColor: '#F1F8E9',
      textColor: '#1B5E20',
      deliveryTime: '2-4 hours',
      specialOffer: 'Fresh guarantee or money back',
    ),
    'shop_005': ShopTheme.simple(
      primaryColor: '#795548',
      secondaryColor: '#A1887F',
      backgroundColor: '#EFEBE9',
      textColor: '#3E2723',
      deliveryTime: '3-5 days',
      specialOffer: 'Free bookmark with every purchase',
    ),
    'shop_006': ShopTheme.simple(
      primaryColor: '#9C27B0',
      secondaryColor: '#BA68C8',
      backgroundColor: '#F3E5F5',
      textColor: '#4A148C',
      deliveryTime: '5-7 days',
      specialOffer: 'Free interior consultation',
    ),
    'shop_007': ShopTheme.simple(
      primaryColor: '#FF5722',
      secondaryColor: '#FF8A65',
      backgroundColor: '#FBE9E7',
      textColor: '#BF360C',
      deliveryTime: '1-3 days',
      specialOffer: 'Free fitness consultation',
    ),
    'shop_008': ShopTheme.simple(
      primaryColor: '#F44336',
      secondaryColor: '#EF5350',
      backgroundColor: '#FFEBEE',
      textColor: '#B71C1C',
      deliveryTime: '1-2 days',
      specialOffer: 'Free beauty tips and tutorials',
    ),
    'shop_009': ShopTheme.simple(
      primaryColor: '#FFEB3B',
      secondaryColor: '#FFF176',
      backgroundColor: '#FFFDE7',
      textColor: '#F57F17',
      deliveryTime: '2-4 days',
      specialOffer: 'Educational games included',
    ),
    'shop_010': ShopTheme.simple(
      primaryColor: '#607D8B',
      secondaryColor: '#90A4AE',
      backgroundColor: '#ECEFF1',
      textColor: '#263238',
      deliveryTime: '3-5 days',
      specialOffer: 'Installation support available',
    ),
  };

  /// Get all shops
  List<Shop> getAllShops() {
    return List.from(_mockShops);
  }

  /// Get shop by ID
  Shop? getShopById(String shopId) {
    try {
      return _mockShops.firstWhere((shop) => shop.id == shopId);
    } catch (e) {
      return null;
    }
  }

  /// Get shops by category
  List<Shop> getShopsByCategory(String category) {
    return _mockShops.where((shop) => shop.category == category).toList();
  }

  /// Get top rated shops
  List<Shop> getTopRatedShops({int limit = 5}) {
    final sortedShops = List<Shop>.from(_mockShops);
    sortedShops.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedShops.take(limit).toList();
  }

  /// Get featured shops
  List<Shop> getFeaturedShops({int limit = 3}) {
    return _mockShops.where((shop) => shop.isVerified).take(limit).toList();
  }

  /// Get shop theme by shop ID
  ShopTheme? getShopTheme(String shopId) {
    return _shopThemes[shopId];
  }

  /// Get all shop themes
  Map<String, ShopTheme> getAllShopThemes() {
    return Map.from(_shopThemes);
  }

  /// Search shops by name or description
  List<Shop> searchShops(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _mockShops.where((shop) {
      return shop.name.toLowerCase().contains(lowercaseQuery) ||
          shop.description.toLowerCase().contains(lowercaseQuery) ||
          shop.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get marketplace response with all shops
  MarketplaceResponse getMarketplaceResponse() {
    return MarketplaceResponse(
      shops: getAllShops(),
      totalShops: _mockShops.length,
      message: 'Successfully loaded ${_mockShops.length} shops',
    );
  }
}
