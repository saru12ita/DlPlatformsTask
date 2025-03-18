

// NetworkService.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkService {
  final Dio dio = Dio();
  final CookieJar cookieJar = CookieJar(); // CookieJar for managing cookies
  final FlutterSecureStorage storage = FlutterSecureStorage(); // Secure storage for tokens

  // Base URL for the API
  final String baseUrl = 'https://api.dl.surf/api/account/';

  // Constructor to add CookieManager to Dio
  NetworkService() {
    dio.interceptors.add(CookieManager(cookieJar)); // Attach cookie manager to Dio
  }

  // ✅ Register User
  Future<bool> register(String fullName, String email, String password, String referredByCode) async {
    try {
      final response = await dio.post(
        '${baseUrl}register/',
        data: {
          'email': email.trim(),
          'fullname': fullName.trim(),
          'password': password,
          'referred_by_code': referredByCode,
        },
      );

      // Check if registration is successful or the server asks for email verification
      if (response.statusCode == 200) {
        print('✅ Registration successful');
        return true;
      } else if (response.statusCode == 400 && response.data['status'] == 'success') {
        // If the server returns 400 but still indicates registration success
        print('✅ Registration successful. Please check your email to verify your account.');
        return true;
      } else if (response.statusCode == 400 && response.data['status'] == 'error') {
        if (response.data['message'].contains('email: user with this Email already exists')) {
          print('❌ Email already exists. Please use a different email address.');
        }
        return false;
      } else {
        print('❌ Registration failed: ${response.data}');
        return false;
      }
    } catch (e) {
      _handleDioError(e, 'Registration');
      return false;
    }
  }

  // ✅ Login User
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '${baseUrl}login/',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        // Check if the user has been approved or verified
        bool isVerified = response.data['is_api_approved'] ?? false;

        if (!isVerified) {
          print('❌ Account not verified. Please check your email to verify your account.');
          return {'status': 'error', 'message': 'Account not verified. Please verify your email.'};
        }

        if (response.data['access_token'] != null) {
          final String accessToken = response.data['access_token']; // Extract access token
          await storage.write(key: 'accessToken', value: accessToken); // Store token securely
          print('✅ Login successful, Token Stored: $accessToken');
          return {'status': 'success', 'accessToken': accessToken}; // Return access token
        } else {
          return {'status': 'error', 'message': 'Missing access token from response'};
        }
      } else {
        print('❌ Login failed: ${response.data}');
        return {'status': 'error', 'message': 'Invalid credentials or account status'};
      }
    } catch (e) {
      _handleDioError(e, 'Login');
      return {'status': 'error', 'message': 'Login failed due to a network error'};
    }
  }

  // ✅ Fetch files & folders with authentication
  Future<Map<String, dynamic>> getFilesAndFolders() async {
    try {
      final String? token = await storage.read(key: 'accessToken'); // Retrieve token
      if (token == null) {
        print('❌ No access token found. Please login again.');
        return {'status': 'error', 'message': 'No access token found. Please login again.'};
      }

      final response = await dio.get(
        'https://api.dl.surf/api/file/folder-structure/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Attach token to request
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Fetched files and folders successfully');
        return {'status': 'success', 'data': response.data};
      } else {
        print('❌ Failed to fetch files and folders: ${response.data}');
        return {'status': 'error', 'message': 'Failed to fetch files and folders'};
      }
    } catch (e) {
      _handleDioError(e, 'Fetching Files');
      return {'status': 'error', 'message': 'Failed to fetch files due to a network error'};
    }
  }

  // ✅ Logout (Clears Token & Cookies)
  Future<void> logout() async {
    await storage.delete(key: 'accessToken'); // Remove token from storage
    await cookieJar.deleteAll(); // Clear cookies
    print('✅ User logged out successfully');
  }

  // 🚨 Error Handling
  void _handleDioError(dynamic error, String operation) {
    if (error is DioError) {
      if (error.response != null) {
        switch (error.response?.statusCode) {
          case 400:
            print('❌ Bad Request: ${error.response?.data}');
            break;
          case 401:
            print('❌ Unauthorized: ${error.response?.data}');
            break;
          case 403:
            print('❌ Forbidden: ${error.response?.data}');
            break;
          case 404:
            print('❌ Not Found: ${error.response?.data}');
            break;
          case 500:
            print('❌ Server Error: ${error.response?.data}');
            break;
          default:
            print('❌ DioError in $operation: ${error.message}');
        }
      } else {
        print('❌ No response received. Network error or timeout.');
      }
    } else {
      print('❌ Error in $operation: $error');
    }
  }
}
