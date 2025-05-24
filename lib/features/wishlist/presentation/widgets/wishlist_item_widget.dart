import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_router.gr.dart';
import '../../../wishlist/presentation/bloc/wishlist_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_event.dart';
import '../../data/models/wishlist_item_model.dart';

class WishlistItemWidget extends StatelessWidget {
  final WishlistItemModel wishlistItem;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;
  final bool isUpdating;

  const WishlistItemWidget({
    super.key,
    required this.wishlistItem,
    required this.onRemove,
    required this.onAddToCart,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    final product = wishlistItem.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.05,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.router.push(
            ProductDetailRoute(productId: product.id.toString()),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Row(
                children: [
                  const SizedBox(width: 6),
                  // Product Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 24,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text content with right padding for heart icon
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 40,
                          ), // Space for heart icon
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Title
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Price
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isUpdating ? null : onAddToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Heart Icon - positioned at top right
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () {
                    context.read<WishlistBloc>().add(
                      RemoveFromWishlistRequested(product.id),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
