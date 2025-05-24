import 'package:equatable/equatable.dart';

import '../../data/models/wishlist_item_model.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItemModel> items;
  final bool isUpdating;

  const WishlistLoaded({required this.items, this.isUpdating = false});

  @override
  List<Object?> get props => [items, isUpdating];

  // Calculate total items count
  int get totalItems => items.length;

  // Check if wishlist is empty
  bool get isEmpty => items.isEmpty;

  // Check if a specific product is in wishlist
  bool isInWishlist(int productId) {
    return items.any((item) => item.product.id == productId);
  }

  WishlistLoaded copyWith({List<WishlistItemModel>? items, bool? isUpdating}) {
    return WishlistLoaded(
      items: items ?? this.items,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WishlistStatusLoaded extends WishlistState {
  final int productId;
  final bool isInWishlist;

  const WishlistStatusLoaded({
    required this.productId,
    required this.isInWishlist,
  });

  @override
  List<Object?> get props => [productId, isInWishlist];
}
