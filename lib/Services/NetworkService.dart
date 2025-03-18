// NetworkService.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String baseUrl = 'https://api.dl.surf/api/account/';

  // Register function
  Future<bool> register(String fullName, String email, String password, String referredByCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'fullname': fullName.trim(),
          'password': password,
          'referred_by_code': referredByCode,
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Registration successful');
        return true;
      } else if (response.statusCode == 400 && jsonDecode(response.body)['status'] == 'success') {
        print('Registration successful. Please verify your email.');
        return true;
      } else {
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Login function (Stores Token Properly)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 201) { // Check for 201 status code
        final responseData = jsonDecode(response.body);

        // Extract token from response (token might be in the cookies or header)
        final String? accessToken = responseData['access_token']; // Make sure to check the actual response format

        if (accessToken != null && accessToken.isNotEmpty) {
          await storage.write(key: 'accessToken', value: accessToken);
          print('Login successful, Token Stored: $accessToken');
          return {'status': 'success', 'accessToken': accessToken};
        } else {
          return {'status': 'error', 'message': 'Access token missing in response'};
        }
      } else {
        return {'status': 'error', 'message': 'Invalid credentials or account status'};
      }
    } catch (e) {
      print('Error during login: $e');
      return {'status': 'error', 'message': 'Login failed due to a network error'};
    }
  }

  // Fetching files using stored token
  Future<Map<String, dynamic>> getFilesAndFolders() async {
    try {
      final String? token = await storage.read(key: 'accessToken');
      if (token == null) {
        print('No access token found. Please login again.');
        return {'status': 'error', 'message': 'No access token found. Please login again.'};
      }

      final response = await http.get(
        Uri.parse('https://api.dl.surf/api/file/folder-structure/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Get files and folders response status: ${response.statusCode}');
      print('Get files and folders response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Fetched files and folders successfully');
        return {'status': 'success', 'data': jsonDecode(response.body)};
      } else {
        return {'status': 'error', 'message': 'Failed to fetch files and folders'};
      }
    } catch (e) {
      print('Error during file fetch: $e');
      return {'status': 'error', 'message': 'Failed to fetch files due to a network error'};
    }
  }

  // Logout function (Clears Token)
  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    print('User logged out successfully');
  }
}
