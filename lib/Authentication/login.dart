//Login Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dlplatforms_task/Services/NetworkService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dlplatforms_task/Authentication/signup.dart';

class LoginController extends GetxController {
  var rememberMe = false.obs;
}

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final NetworkService networkService = NetworkService();
  final FlutterSecureStorage storage = FlutterSecureStorage(); // Secure storage

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Method to handle login
  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      // Perform login using the NetworkService
      var loginResult = await networkService.login(email, password);

      if (loginResult['status'] == 'success') {
        // If login is successful, store the access token securely
        String? accessToken = loginResult['access_token'];  // This should be the correct path to access token
        if (accessToken != null) {
          await storage.write(key: 'accessToken', value: accessToken);
          Get.snackbar('Success', 'Login successful');
          Get.offNamed('/dlfiles'); // Navigate to DLFiles screen after successful login
        } else {
          Get.snackbar('Error', 'Access token not found.');
        }
      } else {
        // If login fails, display message
        Get.snackbar('Error', loginResult['message'] ?? 'Login failed',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Handle error in case of network issues or unexpected errors
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Check if the user is authenticated
  Future<void> checkAuthentication() async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      Get.snackbar('Error', 'No access token found. Please login again.');
      Get.offNamed('/login');  // Redirect to login screen if no token
    } else {
      Get.offNamed('/dlfiles');  // Navigate to the next screen if token exists
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0.4,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 64, 23, 227),
                      const Color.fromARGB(255, 64, 23, 227)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 180),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "dl.surf",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Don't have an account yet? ",
                              style: TextStyle(fontSize: 15)),
                          GestureDetector(
                            onTap: () => Get.to(() => RegisterScreen()),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          labelText: "Username or Email",
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          labelText: "Password",
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.rememberMe.value = value!;
                                },
                              )),
                          Text("Remember me"),
                          Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 64, 23, 227),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: loginUser, // Call the login function
                          child: Text("Login",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5,
        size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.70, size.width,
        size.height * 0.85);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

