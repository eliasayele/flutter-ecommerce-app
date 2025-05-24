import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_router.gr.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart' as cart_events;
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';
import '../widgets/wishlist_item_widget.dart';

@RoutePage()
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              if (state is WishlistLoaded && state.items.isNotEmpty) {
                return TextButton(
                  onPressed: () => _showClearWishlistDialog(),
                  child: const Text('Clear All'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<WishlistBloc, WishlistState>(
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistWithItems(WishlistLoaded state) {
    return Column(
      children: [
        // Header with item count
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                '${state.totalItems} ${state.totalItems == 1 ? 'item' : 'items'} in your wishlist',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        // Wishlist Items List
        Expanded(
          child: ListView.builder(
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
                      action: SnackBarAction(
                        label: 'View Cart',
                        textColor: Colors.white,
                        onPressed: () {
                          context.router.push(const CartRoute());
                        },
                      ),
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
