import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiService
{
  static const String baseUrl = "https://farmer-app-u46w.onrender.com/api/users";

  /// Fetch user details by ID
  static Future<Map<String, dynamic>> getUserById(String userId) async {
    final url = Uri.parse("$baseUrl/$userId");

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        return Map<String, dynamic>.from(data["data"]);
      } else {
        throw Exception(data["message"] ?? "Failed to fetch user data");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  /// Fetch all users
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        final List users = data["data"];
        return users
            .map<Map<String, dynamic>>((user) => Map<String, dynamic>.from(user))
            .toList();
      } else {
        throw Exception(data["message"] ?? "Failed to fetch users");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  /// Fetch users by role (farmer, agent, admin)
  static Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    final allUsers = await getAllUsers();
    return allUsers
        .where((user) =>
    (user["role"] ?? "").toString().toLowerCase() == role.toLowerCase())
        .toList();
  }
}