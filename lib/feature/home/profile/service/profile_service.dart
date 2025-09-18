import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/profile_model.dart';

class ProfileService {
  final String baseUrl = 'https://skilltestflutter.zybotechlab.com/api/';

  Future<ProfileModel> fetchProfile({String? token}) async {
    final url = Uri.parse('${baseUrl}user-data/');
    final headers = token != null
        ? <String, String>{'Authorization': 'Bearer $token'}
        : <String, String>{};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
