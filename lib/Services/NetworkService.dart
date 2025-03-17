//Networkservices files

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkService {
  final String baseUrl = "https://api.dl.surf/api";
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Login API
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/account/login/');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200) {
      // Assuming the token is returned in the response body
      final token = json.decode(response.body)['token'];
      await storage.write(key: 'auth_token', value: token); // Store token in local storage
      return true;
    } else {
      return false;
    }
  }

  // Register API
  Future<bool> register(String email, String fullname, String password, String referredByCode) async {
    final url = Uri.parse('$baseUrl/account/register/');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'fullname': fullname,
          'password': password,
          'referred_by_code': referredByCode,
        }));

    return response.statusCode == 200;
  }

  // Get Folder and Files API
  Future<Map<String, dynamic>?> getFolderAndFiles() async {
    final token = await storage.read(key: 'auth_token');
    final url = Uri.parse('$baseUrl/file/folder-structure/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token', // Send the token for authentication
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
