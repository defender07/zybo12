import '../models/wishlist_model.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;
  WishlistLoaded(this.items);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}
