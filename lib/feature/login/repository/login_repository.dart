import 'dart:convert';

import '../../../configure/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storeage/shared_prefs.dart';
import '../model/login_response.dart';

class LoginRepository {
  Future<LoginResponse> verifyUser(String phoneNumber) async {
    final response = await ApiClient.post(
      AppConstants.verifyEndpoint,
      body: jsonEncode({
        "first_name": "Test",
        "last_name": "User",
        "phone_number": phoneNumber,
      }),
    );

    if (response["statusCode"] == 200) {
      final data = response["body"];
      final loginResponse = LoginResponse.fromJson(data);

      await SharedPrefs.saveToken(loginResponse.token);
      return loginResponse;
    } else {
      throw Exception(response["body"]["detail"] ?? "Something went wrong");
    }
  }
}
