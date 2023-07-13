import 'package:flutter/material.dart';
import 'package:onesignal/friends_list.dart';
import 'package:onesignal/screens/login.dart';
import 'package:onesignal/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignupScreen(),
        "/users": (context) => FriendsList()
      },
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloggedIn = false;
  @override
  void initState() {
    getValues();
    super.initState();
  }

  void getValues() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      isloggedIn = prefs.getBool("loggedIn") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Push",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isloggedIn ? const FriendsList() : SignupScreen(),
    );
  }
}
