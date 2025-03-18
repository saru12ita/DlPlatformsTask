import 'package:dlplatforms_task/Services/NetworkService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailValidationScreen extends StatefulWidget {
  @override
  _EmailValidationScreenState createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  final NetworkService networkService = NetworkService();
  bool isValidating = false;
  String? token;
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    // Extract the token from the URL query parameters
    token = Uri.base.queryParameters['token']; 
    if (token != null) {
      // Start the validation process if token is found in URL
      validateEmail(token!);
    } else {
      setState(() {
        statusMessage = 'Invalid token. Please check your email link.';
      });
    }
  }

  // Call NetworkService to validate the email token
  void validateEmail(String token) async {
    setState(() {
      isValidating = true;
      statusMessage = 'Validating...';
    });

    final result = await networkService.validateEmail(token);

    if (result['status'] == 'success') {
      setState(() {
        statusMessage = result['message'];
      });
      // After successful validation, navigate to the DL Files screen (or any other screen)
      Get.offNamed('/dlfiles'); // Navigate to the DL Files screen
    } else {
      setState(() {
        statusMessage = result['message'] ?? 'Unknown error during validation.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Validation'),
      ),
      body: Center(
        child: isValidating
            ? CircularProgressIndicator()
            : Text(statusMessage),
      ),
    );
  }
}
