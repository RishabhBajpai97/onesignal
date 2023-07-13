import 'package:flutter/material.dart';
import 'package:onesignal/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            TextButton(
                onPressed: () async {
                  var user = await ApiService()
                      .SignUp(nameController.text, emailController.text);
                  print(user);
                },
                child: const Text("SignUp")),
            const Text("OR"),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/login");
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
