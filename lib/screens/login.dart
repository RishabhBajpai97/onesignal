import 'package:flutter/material.dart';
import 'package:onesignal/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  void navigate() {
    Navigator.of(context).pushNamed("/users");
  }

  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            TextButton(
              onPressed: () async {
                var user = await ApiService().Login(emailController.text);
                print(user);
                if (user != null && user != "User not found") {
                  var prefs = await SharedPreferences.getInstance();
                  print(user["name"]);
                  prefs.setString("name", user["name"]);
                  prefs.setString("email", user["email"]);
                  prefs.setString("id", user["id"]);
                  prefs.setBool("loggedIn", true);
                  navigate();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(user),
                      behavior: SnackBarBehavior.floating,
                      showCloseIcon: true,
                      closeIconColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                "Login",
              ),
            ),
            const Text("OR"),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/signup");
                },
                child: const Text("SignUp"))
          ],
        ),
      ),
    );
  }
}
