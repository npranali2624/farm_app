import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const String baseUrl =
      "https://farmer-app-u46w.onrender.com/api/users";

  // Send registration data and return parsed response
  static Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)["message"] ?? "Registration failed",
      );
    }
  }

  static Future<Map<String, dynamic>> loginUser(
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)["message"] ?? "Login failed");
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    const String hardcodedOtp = "507849";

    /// check locally first
    if (otp != hardcodedOtp) {
      return {"success": false, "message": "Invalid OTP"};
    }

    /// call backend only if OTP matches
    final response = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobile": mobile, "otp": otp}),
    );

    return jsonDecode(response.body);
  }
}
