import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../wishlist/presentation/bloc/wishlist_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_event.dart';
import '../../../wishlist/presentation/bloc/wishlist_state.dart';
import '../../data/models/product_model.dart';

class ProductListCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductListCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05), // More grayish background
        borderRadius: BorderRadius.circular(10), // Radius 10
        // Remove shadow
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Row(
                children: [
                  // Product Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.backgroundSecondary,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.backgroundSecondary,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 24,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Product Details
                  Expanded(
                    child: Padding(
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
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Category
                          Text(
                            product.category,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),

                          const SizedBox(height: 8),

                          // Rating
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.black),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.rate.toStringAsFixed(2),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Price
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Wishlist Heart Icon - positioned at top right
              Positioned(
                top: -4,
                right: -4,
                child: BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    bool isInWishlist = false;
                    if (state is WishlistLoaded) {
                      isInWishlist = state.isInWishlist(product.id);
                    }

                    return GestureDetector(
                      onTap: () {
                        if (isInWishlist) {
                          context.read<WishlistBloc>().add(
                            RemoveFromWishlistRequested(product.id),
                          );
                        } else {
                          context.read<WishlistBloc>().add(
                            AddToWishlistRequested(product: product),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isInWishlist
                              ? Colors.red.shade400
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
