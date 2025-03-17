//Networkservices files

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class NetworkService {
  final Dio dio = Dio();
  final CookieJar cookieJar = CookieJar(); // CookieJar for managing cookies
  
  // Base URL for the API
  final String baseUrl = 'https://api.dl.surf/api/account/';

  // Constructor to add CookieManager to Dio
  NetworkService() {
    dio.interceptors.add(CookieManager(cookieJar)); // Attach cookie manager to Dio
  }

  // Register method
  Future<bool> register(String fullName, String email, String password, String referredByCode) async {
    try {
      final response = await dio.post(
        '${baseUrl}register/',
        data: {
          'email': email,
          'fullname': fullName,
          'password': password,
          'referred_by_code': referredByCode,
        },
      );

      if (response.statusCode == 200) {
        // Successful registration
        print('Registration successful');
        return true;
      } else {
        // Registration failed
        print('Failed to register: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Login method (with cookie handling)
  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        '${baseUrl}login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        print('Login successful');
        // Cookies will be automatically stored in the cookie jar after a successful login
        return true;
      } else {
        // Login failed
        print('Failed to login: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Fetch files and folders from the folder structure endpoint (with cookies)
  Future<Map<String, dynamic>> getFilesAndFolders() async {
    try {
      // Get the cookies from the cookie jar and send them with the request
      final cookies = await cookieJar.loadForRequest(Uri.parse('https://api.dl.surf/api/file/folder-structure/'));

      final response = await dio.get(
        'https://api.dl.surf/api/file/folder-structure/',
        options: Options(
          headers: {
            'Cookie': cookies.isNotEmpty ? cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ') : '', // Send cookies if available
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse and return the response
        return response.data as Map<String, dynamic>;
      } else {
        // Handle failed request
        print('Failed to fetch files and folders: ${response.data}');
        return {};
      }
    } catch (e) {
      print('Error fetching files and folders: $e');
      return {};
    }
  }
}
