import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/wishlist_service.dart';
import '../models/wishlist_model.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistService wishlistService;

  WishlistBloc({required this.wishlistService}) : super(WishlistInitial()) {
    on<FetchWishlist>(_onFetchWishlist);
    on<ToggleWishlistItem>(_onToggleWishlist);
  }

  Future<void> _onFetchWishlist(
      FetchWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final items = await wishlistService.fetchWishlist();
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError("Failed to load wishlist: $e"));
    }
  }

  Future<void> _onToggleWishlist(
      ToggleWishlistItem event, Emitter<WishlistState> emit) async {
    try {
      await wishlistService.toggleWishlist(event.productId);
      final items = await wishlistService.fetchWishlist();
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError("Failed to update wishlist: $e"));
    }
  }
}
