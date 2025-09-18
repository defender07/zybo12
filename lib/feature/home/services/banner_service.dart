import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/banner_model.dart';

class BannerService {
  static const String baseUrl = "http://skilltestflutter.zybotechlab.com/api/banners/";

  static Future<List<BannerModel>> fetchBanners() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load banners");
    }
  }
}
