import 'package:flutter/material.dart';
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Login%20and%20Signup/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: false,
        fontFamily: 'QuickSand',
        primarySwatch: Colors.blue,
      ),
      home: Loginpage(),
    );
  }
}

