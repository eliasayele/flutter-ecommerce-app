// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:ecommerce_app/features/auth/presentation/screens/login_screen.dart'
    as _i3;
import 'package:ecommerce_app/features/cart/presentation/screens/cart_screen.dart'
    as _i1;
import 'package:ecommerce_app/features/home/presentation/screens/home_screen.dart'
    as _i2;
import 'package:ecommerce_app/features/products/presentation/screens/product_detail_screen.dart'
    as _i4;
import 'package:ecommerce_app/features/products/presentation/screens/product_list_screen.dart'
    as _i5;
import 'package:ecommerce_app/features/splash/presentation/screens/splash_screen.dart'
    as _i6;
import 'package:ecommerce_app/features/welcome/presentation/screens/welcome_screen.dart'
    as _i7;
import 'package:ecommerce_app/features/wishlist/presentation/screens/wishlist_screen.dart'
    as _i8;
import 'package:flutter/material.dart' as _i10;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    CartRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.CartScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginScreen(),
      );
    },
    ProductDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProductDetailRouteArgs>(
        orElse: () => ProductDetailRouteArgs(
          productId: pathParams.getString('productId'),
        ),
      );
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ProductDetailScreen(
          key: args.key,
          productId: args.productId,
        ),
      );
    },
    ProductListRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ProductListScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SplashScreen(),
      );
    },
    WelcomeRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.WelcomeScreen(),
      );
    },
    WishlistRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.WishlistScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.CartScreen]
class CartRoute extends _i9.PageRouteInfo<void> {
  const CartRoute({List<_i9.PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ProductDetailScreen]
class ProductDetailRoute extends _i9.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i10.Key? key,
    required String productId,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(key: key, productId: productId),
         rawPathParams: {'productId': productId},
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static const _i9.PageInfo<ProductDetailRouteArgs> page =
      _i9.PageInfo<ProductDetailRouteArgs>(name);
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({this.key, required this.productId});

  final _i10.Key? key;

  final String productId;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i5.ProductListScreen]
class ProductListRoute extends _i9.PageRouteInfo<void> {
  const ProductListRoute({List<_i9.PageRouteInfo>? children})
    : super(ProductListRoute.name, initialChildren: children);

  static const String name = 'ProductListRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SplashScreen]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i7.WelcomeScreen]
class WelcomeRoute extends _i9.PageRouteInfo<void> {
  const WelcomeRoute({List<_i9.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i8.WishlistScreen]
class WishlistRoute extends _i9.PageRouteInfo<void> {
  const WishlistRoute({List<_i9.PageRouteInfo>? children})
    : super(WishlistRoute.name, initialChildren: children);

  static const String name = 'WishlistRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}
