//Signup section

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var isRememberMeChecked = false.obs;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
}

class SignupPage extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  "dl.surf",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text("Don't have an account yet?"),
                    TextButton(
                      onPressed: () {}, 
                      child: Text("Sign up", style: TextStyle(color: Colors.blue))
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username or Email",
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Obx(() => Checkbox(
                          value: controller.isRememberMeChecked.value,
                          onChanged: (value) {
                            controller.isRememberMeChecked.value = value!;
                          },
                        )),
                    Text("Remember me"),
                    Spacer(),
                    TextButton(
                      onPressed: () {}, 
                      child: Text("Forgot Password?", style: TextStyle(color: Colors.blue))
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      // Perform signup logic here
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
