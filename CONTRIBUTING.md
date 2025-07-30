# Contributing to OneMart SDUI

Thank you for your interest in contributing to OneMart! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues
1. **Search existing issues** to avoid duplicates
2. **Use issue templates** when available
3. **Provide detailed information**:
   - Flutter/Dart version
   - Device/OS information
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots/logs if applicable

### Submitting Pull Requests
1. **Fork the repository**
2. **Create a feature branch** from `main`
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following our coding standards
4. **Test your changes** thoroughly
5. **Commit with clear messages**
6. **Push to your fork**
7. **Create a Pull Request**

## 📋 Development Guidelines

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format code
- Run `flutter analyze` to check for issues
- Maintain consistent naming conventions

### Architecture Patterns
- **GetX for State Management**: Use reactive observables (Rx variables)
- **Service Layer**: Keep business logic in service classes
- **Separation of Concerns**: Controllers handle state, Services handle data
- **Dependency Injection**: Use Get.put() and Get.find() appropriately

### File Organization
```
lib/
├── models/              # Data models only
├── controllers/         # State management logic
├── services/           # Business logic and API calls
├── views/              # UI components
│   ├── screens/        # Full screen widgets
│   └── widgets/        # Reusable components
├── utils/              # Helper functions and utilities
└── config/             # Configuration and constants
```

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private members**: `_leadingUnderscore`

### GetX Best Practices

#### Controllers
```dart
class ExampleController extends GetxController {
  // Use Rx variables for reactive state
  final RxBool isLoading = false.obs;
  final RxList<Item> items = <Item>[].obs;
  final RxString error = ''.obs;
  
  // Initialize in onInit
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  // Clean up in onClose
  @override
  void onClose() {
    // Dispose resources
    super.onClose();
  }
}
```

#### Views
```dart
class ExampleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<ExampleController>();
      
      if (controller.isLoading.value) {
        return CircularProgressIndicator();
      }
      
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return ItemWidget(item: controller.items[index]);
        },
      );
    });
  }
}
```

### Testing Guidelines

#### Unit Tests
- Test all business logic in services
- Test controller state changes
- Mock external dependencies
- Aim for >80% code coverage

```dart
void main() {
  group('ProductService', () {
    late ProductService productService;
    late MockApiService mockApiService;
    
    setUp(() {
      mockApiService = MockApiService();
      productService = ProductService(apiService: mockApiService);
    });
    
    test('should fetch products successfully', () async {
      // Arrange
      when(mockApiService.get(any)).thenAnswer(
        (_) async => {'products': []},
      );
      
      // Act
      final result = await productService.fetchProducts();
      
      // Assert
      expect(result.products, isEmpty);
    });
  });
}
```

#### Widget Tests
- Test UI components in isolation
- Test user interactions
- Test different states (loading, error, success)

```dart
void main() {
  testWidgets('ProductCard displays product information', (tester) async {
    // Arrange
    final product = Product(id: '1', title: 'Test Product');
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ProductCard(product: product),
      ),
    );
    
    // Assert
    expect(find.text('Test Product'), findsOneWidget);
  });
}
```

### Server-Driven UI Guidelines

#### JSON Structure
- Use consistent component types
- Provide fallback values
- Validate JSON schemas
- Document component properties

```json
{
  "type": "product_card",
  "id": "featured_product_1",
  "properties": {
    "productId": "prod_123",
    "showPrice": true,
    "showRating": false
  },
  "action": {
    "type": "navigate",
    "route": "/product-detail",
    "parameters": {
      "productId": "prod_123"
    }
  }
}
```

#### Component Development
1. **Add component type** to `JsonUIParser`
2. **Implement builder method** with proper error handling
3. **Update `WidgetMapper`** if needed
4. **Document component properties**
5. **Add tests** for the component

### API Integration

#### Service Implementation
```dart
class NewService {
  final ApiService _apiService;
  
  NewService({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();
  
  Future<List<Item>> fetchItems() async {
    try {
      final response = await _apiService.get('/items');
      return (response['items'] as List)
          .map((json) => Item.fromJson(json))
          .toList();
    } catch (e) {
      throw ServiceException('Failed to fetch items: $e');
    }
  }
}
```

#### Error Handling
- Use custom exception classes
- Provide meaningful error messages
- Implement retry logic where appropriate
- Log errors for debugging

### Mock Data Guidelines

#### Creating Mock Data
- Mirror real API response structure
- Use realistic data values
- Include edge cases (empty lists, null values)
- Maintain consistency across mock files

```dart
List<Product> generateMockProducts(int count) {
  return List.generate(count, (index) {
    return Product(
      id: 'mock_product_$index',
      title: 'Mock Product ${index + 1}',
      price: 1000 + (index * 500),
      // ... other properties
    );
  });
}
```

## 🔍 Code Review Process

### Before Submitting
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] No analyzer warnings
- [ ] Documentation updated
- [ ] Screenshots for UI changes

### Review Criteria
- **Functionality**: Does it work as expected?
- **Code Quality**: Is it readable and maintainable?
- **Performance**: Are there any performance concerns?
- **Security**: Are there any security implications?
- **Testing**: Are there adequate tests?

## 🚀 Release Process

### Version Numbering
We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist
- [ ] All tests pass
- [ ] Documentation updated
- [ ] Version number bumped
- [ ] Changelog updated
- [ ] Release notes prepared

## 📞 Getting Help

### Communication Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and discussions
- **Code Reviews**: Feedback on pull requests

### Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart)
- [Medusa Documentation](https://docs.medusajs.com/)

## 🙏 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- GitHub contributors page

Thank you for contributing to OneMart! 🎉
