import 'package:flutter/material.dart';
import 'models/product_model.dart';
import 'models/banner_model.dart';
import 'services/api_service.dart';
import 'services/banner_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productFuture;
  late Future<List<BannerModel>> _bannerFuture;

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _productFuture = ApiService.fetchProducts();
    _bannerFuture = BannerService.fetchBanners();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _productFuture = ApiService.fetchProducts();
      });
    } else {
      setState(() {
        _isSearching = true;
        _productFuture = ApiService.searchProducts(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Search Bar inside body
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch("");
                      },
                    ),
                  ),
                  onSubmitted: _performSearch,
                ),
              ),
            ),

            // ✅ Banner Slider
            FutureBuilder<List<BannerModel>>(
              future: _bannerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: Text("Error: ${snapshot.error}")),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text("No banners available")),
                  );
                }

                final banners = snapshot.data!;
                return SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final imageUrl = banners[index].image ?? '';
                      if (imageUrl.isEmpty) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Center(child: Text("No Image")),
                        );
                      }
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(child: Text("Image not available")),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 45),

            // ✅ Product Grid (normal or search)
            FutureBuilder<List<Product>>(
              future: _productFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(_isSearching
                          ? "No products found for '${_searchController.text}'"
                          : "No products available"));
                }

                final products = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.featuredImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade300,
                                      child: const Center(child: Text("No Image")),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    product.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹${product.salePrice}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (product.discount != "0.00")
                                    Text(
                                      "${product.discount}% Off",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
