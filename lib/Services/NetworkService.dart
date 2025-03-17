/*

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
        // Registration failed - print status and data
        print('Failed to register: StatusCode: ${response.statusCode}, Response: ${response.data}');
        return false;
      }
    } catch (e) {
      // Handling DioError for more detailed debugging
      if (e is DioError) {
        // Dio specific error handling
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('DioError Response: ${e.response}');
        }
      } else {
        // General error handling
        print('Error during registration: $e');
      }
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
        return true;
      } else {
        // Login failed - print status and data
        print('Failed to login: StatusCode: ${response.statusCode}, Response: ${response.data}');
        return false;
      }
    } catch (e) {
      // Handling DioError for more detailed debugging
      if (e is DioError) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('DioError Response: ${e.response}');
        }
      } else {
        print('Error during login: $e');
      }
      return false;
    }
  }

  // Fetch files and folders from the folder structure endpoint (with cookies)
  Future<Map<String, dynamic>> getFilesAndFolders() async {
    try {
      final cookies = await cookieJar.loadForRequest(Uri.parse('https://api.dl.surf/api/file/folder-structure/'));

      final response = await dio.get(
        'https://api.dl.surf/api/file/folder-structure/',
        options: Options(
          headers: {
            'Cookie': cookies.isNotEmpty ? cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ') : '',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        print('Failed to fetch files and folders: StatusCode: ${response.statusCode}, Response: ${response.data}');
        return {};
      }
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('DioError Response: ${e.response}');
        }
      } else {
        print('Error fetching files and folders: $e');
      }
      return {};
    }
  }
}

*/


import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkService {
  final Dio dio = Dio();
  
  // Base URL for the API
  final String baseUrl = 'https://api.dl.surf/api/account/';
  
  // Constructor
  NetworkService() {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Register method
  Future<bool> register(String email, String fullname, String password, String referredByCode) async {
    try {
      final response = await dio.post(
        '${baseUrl}register/',
        data: {
          'email': email,
          'fullname': fullname,
          'password': password,
          'referred_by_code': referredByCode,
        },
      );
      
      if (response.statusCode == 200) {
        print('Registration successful');
        return true;
      } else {
        print('Failed to register: ${response.data}');
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
      final response = await dio.post(
        '${baseUrl}login/',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        print('Login successful');
        return true;
      } else {
        print('Failed to login: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Fetch file and folder structure
  Future<Map<String, dynamic>> getFilesAndFolders() async {
    try {
      final response = await dio.get(
        'https://api.dl.surf/api/file/folder-structure/',
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        print('Failed to fetch folder structure: ${response.data}');
        return {};
      }
    } catch (e) {
      print('Error fetching folder structure: $e');
      return {};
    }
  }
}
