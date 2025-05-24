import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Splash Route (Initial) - checks auth status
    AutoRoute(page: SplashRoute.page, path: '/', initial: true),

    // Welcome Route
    AutoRoute(page: WelcomeRoute.page, path: '/welcome'),

    // Login Route
    AutoRoute(page: LoginRoute.page, path: '/login'),

    // Home Route (Main Tab Navigation)
    AutoRoute(page: HomeRoute.page, path: '/home'),

    // Product Routes
    AutoRoute(page: ProductDetailRoute.page, path: '/product/:productId'),

    // Cart Route
    AutoRoute(page: CartRoute.page, path: '/cart'),

    // Wishlist Route
    AutoRoute(page: WishlistRoute.page, path: '/wishlist'),
  ];
}
