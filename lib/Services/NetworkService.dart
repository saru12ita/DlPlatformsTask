//Networkservices files

import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  // Base URL for the API
  final String baseUrl = 'https://api.dl.surf/api/account/';

  // Register method
  Future<bool> register(String fullName, String email, String password, String referredByCode) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'fullname': fullName,
          'password': password,
          'referred_by_code': referredByCode,
        }),
      );

      if (response.statusCode == 200) {
        // Successful registration
        return true;
      } else {
        // Registration failed
        print('Failed to register: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Successful login
        return true;
      } else {
        // Login failed
        print('Failed to login: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Fetch files and folders from the folder structure endpoint
  Future<Map<String, dynamic>> getFilesAndFolders() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.dl.surf/api/file/folder-structure/'),
        headers: {
          'Content-Type': 'application/json',
          // You may need to include an authorization token if required by your API
          // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        // Parse and return the response
        return jsonDecode(response.body);
      } else {
        // Handle failed request
        print('Failed to fetch files and folders: ${response.body}');
        return {};
      }
    } catch (e) {
      print('Error fetching files and folders: $e');
      return {};
    }
  }
}
