import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static Future<Map<String, dynamic>> post(String url, {Object? body}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: body,
      );

      print("📡 POST $url");
      print("Status Code: ${response.statusCode}");
      print("Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        return {
          "statusCode": response.statusCode,
          "body": jsonDecode(response.body),
        };
      } else {
        // Try to decode JSON even on errors, otherwise return plain text
        try {
          return {
            "statusCode": response.statusCode,
            "body": jsonDecode(response.body),
          };
        } catch (_) {
          return {
            "statusCode": response.statusCode,
            "body": {"detail": response.body},
          };
        }
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
