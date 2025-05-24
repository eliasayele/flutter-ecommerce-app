
# 🛒 Flutter E-Commerce App

A modern, feature-rich e-commerce mobile application built with Flutter, implementing Clean Architecture, BLoC pattern, and comprehensive state management with data persistence.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-FF6B35?style=for-the-badge)

## 📱 Features

| Image 1 | Image 2 |
|---------|---------|
| ![image](https://github.com/user-attachments/assets/1cfbc613-2c48-4b82-bc81-6940ff1701fb) | ![image](https://github.com/user-attachments/assets/47c2281f-9cb9-465f-9b35-8a512144d7f2) |
| ![image](https://github.com/user-attachments/assets/e575e2fe-18dd-43c9-ac9d-dff0f3e179d7) | ![image](https://github.com/user-attachments/assets/1d6636b1-1c02-412a-b1da-40d5996079d4) |
| ![image](https://github.com/user-attachments/assets/4bca2a32-05c2-4215-aed6-6e128861a5f4) | ![image](https://github.com/user-attachments/assets/cf160173-8414-45dc-8b30-e9d59b6913c3) |


### 🔐 Authentication System
- **User Login** with username/password validation
- **Session Persistence** using SharedPreferences
- **Auto-login** on app restart
- **Username Display** in home screen header
- **Secure Logout** with data cleanup

### 🛍️ Product Management
- **Product Catalog** fetched from Fake Store API
- **Product Details** with Hero animations
- **Image Optimization** with loading states
- **Error Handling** with retry mechanisms
- **Navigation** between product list and details

### 🛒 Shopping Cart
- **Add/Remove Items** with quantity management
- **Slide-to-Delete** functionality using Dismissible
- **Cart Persistence** survives app restarts
- **Quantity Controls** with unified design
- **Auto-clear** on user logout
- **Navigation** to product details from cart

### ❤️ Wishlist System
- **Heart Icon Toggle** for adding/removing items
- **Wishlist Persistence** using SharedPreferences
- **Clean UI Design** with flat cards
- **Quick Add to Cart** from wishlist
- **Real-time Updates** across app

### 🎨 Modern UI/UX
- **Figma-based Design System** with 16 custom colors
- **Google Fonts** (Urbanist) throughout the app
- **Asset-based Navigation** with custom icons
- **Flat Design** with consistent border radius
- **Responsive Layout** optimized for mobile

## 🏗️ Architecture

### Clean Architecture
The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── di/               # Dependency Injection
│   ├── navigation/       # Auto Route Configuration
│   └── theme/           # App Theme & Colors
├── features/
│   ├── auth/
│   │   ├── data/        # Models, Repositories, DataSources
│   │   ├── domain/      # Entities, Repository Interfaces
│   │   └── presentation/ # Screens, Widgets, BLoC
│   ├── products/        # Product Management
│   ├── cart/           # Shopping Cart
│   ├── wishlist/       # Wishlist Functionality
│   ├── home/           # Tab Navigation
│   ├── welcome/        # Welcome Screen
│   └── splash/         # Splash & Auth Check
└── main.dart
```

### Design Patterns
- **Repository Pattern** - Data abstraction layer
- **BLoC Pattern** - Predictable state management
- **Singleton Pattern** - Shared instances (Cart, Wishlist)
- **Factory Pattern** - Object creation (Models)

## 🔧 Technical Stack

### State Management
```yaml
flutter_bloc: ^8.1.6        # BLoC pattern implementation
equatable: ^2.0.5           # Value equality for states
```

### Dependency Injection
```yaml
injectable: ^2.4.4          # Code generation for DI
get_it: ^8.0.2             # Service locator
```

### Code Generation
```yaml
freezed: ^2.5.7            # Immutable data classes
json_annotation: ^4.9.0    # JSON serialization
build_runner: ^2.4.13      # Code generation runner
auto_route: ^9.2.2         # Declarative routing
```

### Network & Storage
```yaml
dio: ^5.7.0               # HTTP client
shared_preferences: ^2.3.2 # Local storage
```

### UI & Fonts
```yaml
google_fonts: ^6.2.1      # Custom fonts
```

## 🌐 API Integration

### Fake Store API
- **Base URL**: `https://fakestoreapi.com`
- **Endpoints**:
  - `GET /products` - Fetch all products
  - `POST /auth/login` - User authentication
- **Response Handling**: Proper error states and loading indicators
- **Data Models**: Auto-generated with Freezed

```dart
// Example API call
@RestApi(baseUrl: 'https://fakestoreapi.com')
abstract class ApiService {
  @GET('/products')
  Future<List<ProductModel>> getProducts();
}
```

## 🎨 Design System

### Color Palette (Figma-defined)
```dart
class AppColors {
  // Primary Colors
  static const primary = Color(0xFFDAA520);
  static const primaryLight = Color(0xFFF4E4BC);
  static const primaryAccent = Color(0xFFFFF2CC);
  
  // Semantic Colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  
  // Text Colors
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  
  // Background Colors
  static const backgroundPrimary = Color(0xFFFFFFFF);
  static const backgroundSecondary = Color(0xFFF9FAFB);
}
```

### Typography
- **Font Family**: Urbanist (Google Fonts)
- **Weight Variants**: 400, 500, 600, 700
- **Consistent Sizing**: 10px - 24px scale

## 🗄️ Data Persistence

### SharedPreferences Storage
```dart
// Authentication
'auth_token' -> String         # JWT token
'auth_username' -> String      # User identifier

// Shopping Cart
'cart_items' -> JSON String    # Serialized cart items

// Wishlist
'wishlist_items' -> JSON String # Serialized wishlist items
```

### JSON Serialization
```dart
// Freezed-based models
@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required ProductModel product,
    required int quantity,
  }) = _CartItemModel;
  
  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}
```

## 🔄 State Management Flow

### BLoC Pattern Implementation
```dart
// Events
abstract class CartEvent extends Equatable {}
class AddToCartRequested extends CartEvent {
  final ProductModel product;
  final int quantity;
}

// States  
abstract class CartState extends Equatable {}
class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final bool isUpdating;
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;
  
  CartBloc(this._repository) : super(CartInitial()) {
    on<AddToCartRequested>(_onAddToCartRequested);
  }
}
```

## 🛠️ Build Tools & Code Generation

### Build Runner Commands
```bash
# Generate all code (routes, JSON, DI)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes (development)
dart run build_runner watch

# Clean generated files
dart run build_runner clean
```

### Generated Files
- **Auto Route**: `app_router.gr.dart`
- **Freezed Models**: `*.freezed.dart`
- **JSON Serialization**: `*.g.dart`
- **Dependency Injection**: `service_locator.config.dart`

## 📱 Navigation System

### Auto Route Configuration
```dart
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: '/', initial: true),
    AutoRoute(page: WelcomeRoute.page, path: '/welcome'),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: HomeRoute.page, path: '/home'),
    AutoRoute(page: ProductDetailRoute.page, path: '/product/:productId'),
  ];
}
```

### Navigation Flow
1. **Splash Screen** → Auth check → Route to Home/Welcome
2. **Welcome Screen** → Login Screen → Home Screen
3. **Home Screen** → Tab Navigation (Products/Wishlist/Cart)
4. **Product Detail** → Add to Cart/Wishlist

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/ecommerce_app.git

# Navigate to project directory
cd ecommerce_app

# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Demo Credentials
```
Username: mor_2314
Password: 83r5^_
```

## 📂 Project Structure

```
lib/
├── core/
│   ├── di/
│   │   ├── service_locator.dart          # GetIt configuration
│   │   └── service_locator.config.dart   # Generated DI
│   ├── navigation/
│   │   ├── app_router.dart               # Route definitions
│   │   └── app_router.gr.dart            # Generated routes
│   └── theme/
│       ├── app_theme.dart                # Theme configuration
│       └── app_colors.dart               # Color palette
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/              # API calls
│   │   │   └── repositories/             # Repository implementation
│   │   ├── domain/
│   │   │   ├── repositories/             # Repository interface
│   │   │   └── usecases/                 # Business logic
│   │   └── presentation/
│   │       ├── bloc/                     # BLoC files
│   │       └── screens/                  # UI screens
│   ├── products/                         # Product feature
│   ├── cart/                            # Cart feature
│   ├── wishlist/                        # Wishlist feature
│   ├── home/                            # Home navigation
│   ├── welcome/                         # Welcome screen
│   └── splash/                          # Splash screen
├── assets/                              # Images & fonts
└── main.dart                           # App entry point
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

**Built with ❤️ and Flutter**
