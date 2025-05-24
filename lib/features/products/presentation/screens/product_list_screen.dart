import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/navigation/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/product_list_bloc.dart';
import '../bloc/product_list_event.dart';
import '../bloc/product_list_state.dart';
import '../widgets/product_list_card.dart';

@RoutePage()
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductListBloc _productListBloc;
  late final ScrollController _scrollController;
  int _selectedBottomNavIndex = 0; // 0: Home, 1: Wishlist, 2: Cart

  @override
  void initState() {
    super.initState();
    _productListBloc = serviceLocator<ProductListBloc>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Fetch products when screen loads
    _productListBloc.add(const FetchProductsRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _productListBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _productListBloc.add(FetchMoreProductsRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),

            // Products List
            Expanded(
              child: BlocProvider(
                create: (context) => _productListBloc,
                child: BlocBuilder<ProductListBloc, ProductListState>(
                  builder: (context, state) {
                    if (state is ProductListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductListError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.error,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                _productListBloc.add(
                                  RefreshProductsRequested(),
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is ProductListLoaded) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          _productListBloc.add(RefreshProductsRequested());
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 80,
                          ), // Account for bottom nav
                          itemCount:
                              state.products.length +
                              (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.products.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final product = state.products[index];
                            return ProductListCard(
                              product: product,
                              onTap: () {
                                context.router.push(
                                  ProductDetailRoute(
                                    productId: product.id.toString(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome and Logout Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Welcome Message
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Username', // TODO: Get from auth state
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Logout Button
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(LogoutButtonPressed());
                  context.router.pushAndPopUntil(
                    const WelcomeRoute(),
                    predicate: (route) => false,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.logout,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Log out',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Fake Store Title
          Text(
            'Fake Store',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home
          _buildBottomNavItem(
            context,
            selectedAsset: 'assets/home.png',
            unselectedAsset: 'assets/home-unselected.png',
            isSelected: _selectedBottomNavIndex == 0,
            onTap: () {
              setState(() {
                _selectedBottomNavIndex = 0;
              });
            },
          ),

          // Wishlist
          _buildBottomNavItem(
            context,
            selectedAsset: 'assets/wishlist.png',
            unselectedAsset: 'assets/wishlist-unselected.png',
            isSelected: _selectedBottomNavIndex == 1,
            onTap: () {
              setState(() {
                _selectedBottomNavIndex = 1;
              });
              context.router.push(const WishlistRoute());
            },
          ),

          // Cart
          _buildBottomNavItem(
            context,
            selectedAsset: 'assets/cart.png',
            unselectedAsset: 'assets/cart-unselected.png',
            isSelected: _selectedBottomNavIndex == 2,
            onTap: () {
              setState(() {
                _selectedBottomNavIndex = 2;
              });
              context.router.push(const CartRoute());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context, {
    required String selectedAsset,
    required String unselectedAsset,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.6,
          child: Image.asset(
            isSelected ? selectedAsset : unselectedAsset,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
