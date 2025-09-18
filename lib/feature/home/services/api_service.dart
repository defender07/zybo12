import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = "http://skilltestflutter.zybotechlab.com/api";

  // ✅ Fetch all products
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/products/"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // ✅ Search products by quer
  static Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(Uri.parse("$baseUrl/search/?query=$query"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to search products");
    }
  }
}
