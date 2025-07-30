# OneMart - Server-Driven UI Ecommerce App

A modern, production-ready ecommerce mobile application built with Flutter, featuring Server-Driven UI (SDUI) architecture, GetX state management, and Medusa Commerce integration.

## 🚀 Features

### Core Functionality
- **Server-Driven UI**: Dynamic UI rendering from JSON configurations
- **Product Catalog**: Browse products with categories, search, and filtering
- **Shopping Cart**: Add/remove items, quantity management
- **Product Details**: Comprehensive product information with image galleries
- **Category Navigation**: Hierarchical category browsing
- **Search**: Real-time product search with filters

### Technical Features
- **GetX State Management**: Reactive state management with observables
- **Mock Data System**: Comprehensive mock data for development and testing
- **Service Layer Architecture**: Clean separation of concerns with API abstraction
- **Kong Gateway Integration**: Production-ready API gateway configuration
- **Responsive Design**: Optimized for various screen sizes
- **Error Handling**: Robust error handling with fallback mechanisms
- **Caching**: Intelligent caching for improved performance

## 🏗️ Architecture

### Project Structure
```
lib/
├── models/              # Data models with JSON serialization
├── controllers/         # GetX controllers for state management
├── services/           # API service layer (Medusa integration)
├── views/              # UI screens and reusable widgets
│   ├── screens/        # Main application screens
│   └── widgets/        # Reusable UI components
├── mock_data/          # Mock data system
├── json_ui/            # Server-driven UI definitions
├── utils/              # Utilities, parsers, and helpers
└── config/             # Configuration files
```

### Key Components

#### 1. Server-Driven UI (SDUI)
- **JSON-based UI definitions** stored in `lib/json_ui/`
- **Dynamic widget rendering** via `JsonUIParser`
- **Component mapping** through `WidgetMapper`
- **Theme support** with configurable colors and styles

#### 2. State Management (GetX)
- **Reactive observables** (RxBool, RxList, RxString, etc.)
- **Dependency injection** with Get.put() and Get.find()
- **Route management** with named routes
- **Memory management** with automatic disposal

#### 3. Service Layer
- **ApiService**: Base HTTP client with retry logic and caching
- **ProductService**: Product-specific API operations
- **CategoryService**: Category management and hierarchy
- **CartService**: Shopping cart operations
- **MockDataService**: Development and testing data

#### 4. Configuration Management
- **Environment-based settings** via `AppConfig`
- **Feature flags** for development/production
- **Kong Gateway routes** for API management
- **Mock/Real data switching**

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- iOS Simulator / Android Emulator
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ecommerce_sdui
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Configuration

#### Environment Variables
Set these environment variables for different configurations:

```bash
# Development (default)
export USE_MOCK_DATA=true
export ENABLE_DEBUG_MODE=true

# Production
export USE_MOCK_DATA=false
export MEDUSA_API_URL=https://your-medusa-api.com
export USE_KONG_GATEWAY=true
export KONG_GATEWAY_URL=https://your-kong-gateway.com
```

#### Mock Data vs Real API
- **Development**: Uses mock data by default (`AppConfig.useMockData = true`)
- **Production**: Configure real Medusa API endpoints
- **Testing**: Seamless switching between mock and real data
# ecommerce_sdui
