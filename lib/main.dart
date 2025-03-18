import 'package:dlplatforms_task/Authentication/login.dart';
import 'package:dlplatforms_task/Authentication/signup.dart';
import 'package:dlplatforms_task/Allfiles/dlfiles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signup', // Set LoginPage as the default screen
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => RegisterScreen()),
        GetPage(name: '/dlfiles', page: () => AccessFileScreen()),  // Add your screen to display files
      ],
    );
  }
}




