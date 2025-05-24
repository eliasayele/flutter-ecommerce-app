import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartContent extends StatefulWidget {
  const CartContent({super.key});

  @override
  State<CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  @override
  void initState() {
    super.initState();
    // Load cart when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCartRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cart Header
        _buildCartHeader(context),

        // Cart Content
        Expanded(
          child: BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CartLoaded) {
                  if (state.isEmpty) {
                    return _buildEmptyCart();
                  } else {
                    return _buildCartWithItems(state);
                  }
                } else if (state is CartError) {
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

  Widget _buildCartHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cart Title
          Text(
            'Cart',
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

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Start shopping to add items to your cart',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems(CartLoaded state) {
    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final cartItem = state.items[index];
              return _buildCartItem(cartItem, state.isUpdating);
            },
          ),
        ),

        // Cart Summary
        _buildCartSummary(state),
      ],
    );
  }

  Widget _buildCartItem(dynamic cartItem, bool isUpdating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(cartItem.product.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          context.read<CartBloc>().add(
            RemoveFromCartRequested(cartItem.product.id),
          );
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 24),
        ),
        child: GestureDetector(
          onTap: () {
            context.router.push(
              ProductDetailRoute(productId: cartItem.product.id.toString()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    cartItem.product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Product Details with Title and Quantity Controls
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        cartItem.product.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Quantity Controls (below title) - Unified rounded box
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrease Button
                            GestureDetector(
                              onTap: isUpdating
                                  ? null
                                  : () {
                                      if (cartItem.quantity > 1) {
                                        context.read<CartBloc>().add(
                                          UpdateQuantityRequested(
                                            productId: cartItem.product.id,
                                            quantity: cartItem.quantity - 1,
                                          ),
                                        );
                                      } else {
                                        context.read<CartBloc>().add(
                                          RemoveFromCartRequested(
                                            cartItem.product.id,
                                          ),
                                        );
                                      }
                                    },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    bottomLeft: Radius.circular(7),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            // Quantity
                            Container(
                              width: 40,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                cartItem.quantity.toString(),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),

                            // Increase Button
                            GestureDetector(
                              onTap: isUpdating
                                  ? null
                                  : () {
                                      context.read<CartBloc>().add(
                                        UpdateQuantityRequested(
                                          productId: cartItem.product.id,
                                          quantity: cartItem.quantity + 1,
                                        ),
                                      );
                                    },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(7),
                                    bottomRight: Radius.circular(7),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Price (far right position)
                Text(
                  '\$${cartItem.product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartSummary(CartLoaded state) {
    return Column(
      children: [
        // Divider
        Container(
          height: 1,
          color: Colors.grey.shade200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),

        // Cart Total and Checkout Row
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cart Total
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cart total',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${state.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Checkout Button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                height: 48,
                child: ElevatedButton(
                  onPressed: state.isUpdating
                      ? null
                      : () {
                          _showCheckoutDialog();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: state.isUpdating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Checkout',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                ),
              ),
            ],
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
              context.read<CartBloc>().add(LoadCartRequested());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CartBloc>().add(ClearCartRequested());
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

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: const Text('Checkout functionality coming soon!'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
