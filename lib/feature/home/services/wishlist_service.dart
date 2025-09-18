import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/storeage/shared_prefs.dart';
import '../models/wishlist_model.dart';

class WishlistService {
  static const String baseUrl = "https://skilltestflutter.zybotechlab.com/api";

  /// Fetch Wishlist with debug and flexible parsing
  Future<List<WishlistItem>> fetchWishlist() async {
    final token = await SharedPrefs.getToken();
    if (token == null) throw Exception("No token found. Please login again.");

    final url = Uri.parse("$baseUrl/wishlist/");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("📝 Wishlist GET Status: ${response.statusCode}");
    print("📝 Wishlist GET Response: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // ✅ Handle different response formats
      List<dynamic> itemsData = [];

      if (decoded is List) {
        itemsData = decoded;
      } else if (decoded is Map<String, dynamic> && decoded.containsKey("wishlist")) {
        itemsData = decoded["wishlist"];
      }

      if (itemsData.isEmpty) {
        print("🟡 Wishlist is empty");
        return [];
      }

      final items = itemsData.map((json) => WishlistItem.fromJson(json)).toList();
      print("✅ Wishlist fetched: ${items.length} items");
      return items;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Invalid or expired token");
    } else {
      throw Exception("Failed to load wishlist: ${response.statusCode}");
    }
  }

  /// Add / Remove from Wishlist (FIXED toggle issue)
  Future<void> toggleWishlist(int productId) async {
    final token = await SharedPrefs.getToken();
    if (token == null) throw Exception("No token found. Please login again.");

    final url = Uri.parse("$baseUrl/add-remove-wishlist/");

    // ✅ Fixed key to match backend expectation
    final body = jsonEncode({"product_id": productId});
    print("📝 Wishlist POST Body: $body");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("📝 Wishlist POST Status: ${response.statusCode}");
    print("📝 Wishlist POST Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data["message"] != null) {
        print("❤️ Wishlist toggle response: ${data["message"]}");
      } else {
        print("⚠️ Unknown response: $data");
      }
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      final message = errorData['error'] ?? 'Bad request';
      throw Exception("⚠️ Wishlist toggle failed: $message");
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Invalid or expired token");
    } else {
      throw Exception("Failed to toggle wishlist: ${response.statusCode}");
    }
  }
}
