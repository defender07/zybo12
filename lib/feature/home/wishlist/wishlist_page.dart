import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/wishlist_model.dart';
import '../services/wishlist_service.dart';
import 'wishlist_bloc.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      WishlistBloc(wishlistService: WishlistService())..add(FetchWishlist()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Wishlist")),
        body: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WishlistLoaded) {
              if (state.items.isEmpty) {
                return const Center(child: Text("No items in wishlist"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  item.featuredImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹${item.salePrice}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              item.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Delegate toggle action to BLoC
                              context.read<WishlistBloc>().add(
                                ToggleWishlistItem(item.id),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            if (state is WishlistError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
