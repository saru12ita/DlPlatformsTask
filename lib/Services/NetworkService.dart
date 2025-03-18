//NetworkServices files

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String baseUrl = 'https://api.dl.surf/api/account'; // Base URL for account-related APIs

  // Register function
  Future<bool> register(String fullName, String email, String password, String referredByCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'), // Fixed URL
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
      } else {
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

// Login function

Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Parsed response data: $responseData');

      String? accessToken;
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        final tokenMatch = RegExp(r'access_token=([^;]+)').firstMatch(cookies);
        if (tokenMatch != null) {
          accessToken = tokenMatch.group(1);
          print('Access token received from set-cookie header');
        }
      }

      if (accessToken == null && responseData.containsKey('accessToken')) {
        accessToken = responseData['accessToken'];
        print('Access token received from response body');
      }

      if (accessToken == null) {
        return {'status': 'error', 'message': 'Access token not found. Please log in again.'};
      }

      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'userId', value: responseData['data']['id'].toString());
      await storage.write(key: 'username', value: responseData['data']['username']);

      return {
        'status': 'success',
        'message': 'Login successful',
        'accessToken': accessToken,
        'userId': responseData['data']['id'],
        'username': responseData['data']['username'],
      };
    } else {
      return {'status': 'error', 'message': 'Invalid credentials or account status'};
    }
  } catch (e) {
    print('Error during login: $e');
    return {'status': 'error', 'message': 'Login failed due to a network error: $e'};
  }
}



  // Email validation function (Handles token validation)
  Future<Map<String, dynamic>> validateEmail(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate-email/'), // Adjust the URL if needed
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
        }),
      );

      print('Email validation response status: ${response.statusCode}');
      print('Email validation response body: ${response.body}');

      if (response.statusCode == 200) {
        // Handle successful validation
        return {'status': 'success', 'message': 'Email validated successfully'};
      } else {
        // Handle invalid token or other errors
        return {'status': 'error', 'message': 'Invalid token or token expired'};
      }
    } catch (e) {
      print('Error during email validation: $e');
      return {'status': 'error', 'message': 'Email validation failed due to network error'};
    }
  }

  // Fetching files using stored token
  Future<Map<String, dynamic>> getFilesAndFolders() async {
    try {
      final String? token = await storage.read(key: 'access_token'); // Consistent key
      if (token == null) {
        print('No access token found. Please login again.');
        return {'status': 'error', 'message': 'No access token found. Please login again.'};
      }

      final response = await http.get(
        Uri.parse('https://api.dl.surf/api/file/folder-structure/'), // Fixed URL
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
    await storage.delete(key: 'access_token'); // Consistent key
    print('User logged out successfully');
  }
}
