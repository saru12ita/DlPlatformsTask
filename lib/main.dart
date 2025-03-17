/*
import 'package:dlplatforms_task/Allfiles/dlfiles.dart';
import 'package:dlplatforms_task/Authentication/login.dart';
import 'package:dlplatforms_task/Authentication/signup.dart';
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
      initialRoute: '/signup', // Set SignupPage as the default screen
      getPages: [
       GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => RegisterScreen()),
        GetPage(name: '/dlfiles', page: () => AccessFileScreen()),

      ],
    );
  }
}

*/


import 'package:dlplatforms_task/Services/NetworkService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final NetworkService _networkService = NetworkService();

  // Login function
  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    bool success = await _networkService.login(email, password);
    if (success) {
      // Navigate to the next screen (e.g., file structure or dashboard)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FileStructureScreen()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to Register screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referredCodeController = TextEditingController();
  final NetworkService _networkService = NetworkService();

  // Register function
  void _register() async {
    String email = _emailController.text;
    String fullname = _fullnameController.text;
    String password = _passwordController.text;
    String referredByCode = _referredCodeController.text;

    bool success = await _networkService.register(email, fullname, password, referredByCode);
    if (success) {
      // Navigate to login screen
      Navigator.pop(context);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _fullnameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _referredCodeController,
              decoration: InputDecoration(labelText: 'Referred By Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class FileStructureScreen extends StatelessWidget {
  final NetworkService _networkService = NetworkService();

  // Fetch files and folders
  Future<Map<String, dynamic>> _fetchFilesAndFolders() async {
    return await _networkService.getFilesAndFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Structure'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchFilesAndFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No files available.'));
          }

          var files = snapshot.data!['files'] ?? [];
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(files[index]['name'] ?? 'Unknown'),
                subtitle: Text(files[index]['description'] ?? 'No description'),
              );
            },
          );
        },
      ),
    );
  }
}
