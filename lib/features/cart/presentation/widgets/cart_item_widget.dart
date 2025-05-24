import 'package:flutter/material.dart';

import '../../data/models/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final bool isUpdating;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cartItem.product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    cartItem.product.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Category
                  Text(
                    cartItem.product.category.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price per item
                  Text(
                    '\$${cartItem.product.price.toStringAsFixed(2)} each',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Quantity Controls and Total
                  Row(
                    children: [
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrease Button
                            InkWell(
                              onTap: isUpdating ? null : onDecrease,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(8),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: isUpdating
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),

                            // Quantity Display
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Text(
                                '${cartItem.quantity}',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),

                            // Increase Button
                            InkWell(
                              onTap: isUpdating ? null : onIncrease,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(8),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: isUpdating
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Total Price
                      Text(
                        '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete Button
            IconButton(
              onPressed: isUpdating ? null : onRemove,
              icon: Icon(
                Icons.delete_outline,
                color: isUpdating ? Colors.grey : Colors.red.shade400,
              ),
              tooltip: 'Remove from cart',
            ),
          ],
        ),
      ),
    );
  }
}
