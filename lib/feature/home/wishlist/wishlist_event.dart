abstract class WishlistEvent {}

class FetchWishlist extends WishlistEvent {}

class ToggleWishlistItem extends WishlistEvent {
  final int productId;
  ToggleWishlistItem(this.productId);
}
