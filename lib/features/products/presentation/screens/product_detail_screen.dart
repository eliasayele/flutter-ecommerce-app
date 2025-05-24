import 'package:auto_route/auto_route.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart' as cart_events;
import '../../../wishlist/presentation/bloc/wishlist_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_event.dart'
    as wishlist_events;
import '../../../wishlist/presentation/bloc/wishlist_state.dart'
    as wishlist_states;
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_event.dart';
import '../bloc/product_detail_state.dart';

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, @pathParam required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailBloc _productDetailBloc;

  @override
  void initState() {
    super.initState();
    _productDetailBloc = serviceLocator<ProductDetailBloc>();
    _productDetailBloc.add(
      FetchProductDetailRequested(int.parse(widget.productId)),
    );

    // Load wishlist to ensure we have the current state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistBloc>().add(wishlist_events.LoadWishlistRequested());
    });
  }

  @override
  void dispose() {
    _productDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _productDetailBloc,
        child: BlocListener<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {
            if (state is AddToCartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is ProductDetailError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              if (state is ProductDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductDetailError) {
                return _buildErrorWidget(state.error);
              } else if (state is ProductDetailLoaded) {
                return _buildProductDetail(context, state);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _productDetailBloc.add(
                  FetchProductDetailRequested(int.parse(widget.productId)),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context, ProductDetailLoaded state) {
    final product = state.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA), // Grayish background
      body: Stack(
        children: [
          // Main Content with Image
          Positioned.fill(
            top: MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                // Top Section with Image
                // Spacer(),
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 90, bottom: 20),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Hero(
                          tag: 'product-viewer-${product.id}',
                          child: Image.network(
                            height: 204,
                            width: 264,
                            product.image,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Spacer(),
                // Bottom Section with Product Details
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 20,
                        right: 20,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.black.withValues(alpha: 0.75),
                                ),
                          ),
                          const SizedBox(height: 8),

                          // Category
                          Text(
                            product.category,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFF303539),
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.rate.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text(
                                ' ${product.rating.count} Reviews',
                                style: const TextStyle(
                                  color: Color(0xFFA6A6AA),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),

                // Price and Add to Cart Section with Yellowish Background (End-to-End)
                Container(
                  width: double.infinity,
                  color: AppColors.primaryAccent,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: ElevatedButton(
                            onPressed: state.isAddingToCart
                                ? null
                                : () {
                                    context.read<CartBloc>().add(
                                      cart_events.AddToCartRequested(
                                        product: product,
                                      ),
                                    );
                                    _productDetailBloc.add(
                                      AddToCartRequested(productId: product.id),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: state.isAddingToCart
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Navigation (Back Button and Heart Icon)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => context.router.maybePop(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24,
                  ),
                ),

                // Heart Icon (Wishlist)
                BlocBuilder<WishlistBloc, wishlist_states.WishlistState>(
                  builder: (context, wishlistState) {
                    bool isInWishlist = false;
                    if (wishlistState is wishlist_states.WishlistLoaded) {
                      isInWishlist = wishlistState.isInWishlist(product.id);
                    }

                    return GestureDetector(
                      onTap: () {
                        if (isInWishlist) {
                          context.read<WishlistBloc>().add(
                            wishlist_events.RemoveFromWishlistRequested(
                              product.id,
                            ),
                          );
                        } else {
                          context.read<WishlistBloc>().add(
                            wishlist_events.AddToWishlistRequested(
                              product: product,
                            ),
                          );
                        }
                      },
                      child: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.black,
                        size: 24,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
