import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart' as cart_events;
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';
import 'wishlist_item_widget.dart';

class WishlistContent extends StatefulWidget {
  const WishlistContent({super.key});

  @override
  State<WishlistContent> createState() => _WishlistContentState();
}

class _WishlistContentState extends State<WishlistContent> {
  @override
  void initState() {
    super.initState();
    // Load wishlist and cart when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistBloc>().add(LoadWishlistRequested());
      context.read<CartBloc>().add(cart_events.LoadCartRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wishlist Header
        _buildWishlistHeader(context),

        // Wishlist Content
        Expanded(
          child: BlocListener<WishlistBloc, WishlistState>(
            listener: (context, state) {
              if (state is WishlistError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                if (state is WishlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WishlistLoaded) {
                  if (state.isEmpty) {
                    return _buildEmptyWishlist();
                  } else {
                    return _buildWishlistWithItems(state);
                  }
                } else if (state is WishlistError) {
                  return _buildErrorState(state.message);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Wishlist Title
          Text(
            'Wishlist',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight, // Yellowish background
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Log out',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Save items you like to your wishlist',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistWithItems(WishlistLoaded state) {
    return Column(
      children: [
        // Wishlist Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final wishlistItem = state.items[index];
              return WishlistItemWidget(
                wishlistItem: wishlistItem,
                isUpdating: state.isUpdating,
                onRemove: () {
                  context.read<WishlistBloc>().add(
                    RemoveFromWishlistRequested(wishlistItem.product.id),
                  );
                },
                onAddToCart: () {
                  // Add to cart
                  context.read<CartBloc>().add(
                    cart_events.AddToCartRequested(
                      product: wishlistItem.product,
                    ),
                  );

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${wishlistItem.product.title} added to cart!',
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 100, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<WishlistBloc>().add(LoadWishlistRequested());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showClearWishlistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text(
          'Are you sure you want to remove all items from your wishlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<WishlistBloc>().add(ClearWishlistRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
