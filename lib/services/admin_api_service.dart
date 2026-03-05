import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApiService {
  static const String baseUrl =
      "https://farmer-app-u46w.onrender.com/api/users";

  static Future<List<String>> getPendingPhysicalVerificationUsers(
      String role,
      ) async {
    final url = Uri.parse("$baseUrl/pending/physical");

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    List<String> filteredUsers = [];

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        final List<dynamic> usersList = data["data"];
        for (var user in usersList) {
          if (role == "all" || user["role"] == role) {
            filteredUsers.add(user["_id"]);
          }
        }
        return filteredUsers;
      } else {
        throw Exception(data["message"] ?? "Failed to fetch user data");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }
}
