import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/products/presentation/bloc/product_list_bloc.dart';
import 'features/products/presentation/bloc/product_detail_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/wishlist/presentation/bloc/wishlist_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependency injection
  await configureDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider<ProductListBloc>(
          create: (context) => serviceLocator<ProductListBloc>(),
        ),
        BlocProvider<ProductDetailBloc>(
          create: (context) => serviceLocator<ProductDetailBloc>(),
        ),
        BlocProvider<CartBloc>(create: (context) => serviceLocator<CartBloc>()),
        BlocProvider<WishlistBloc>(
          create: (context) => serviceLocator<WishlistBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'E-Commerce App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
