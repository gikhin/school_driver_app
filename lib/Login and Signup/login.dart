import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Login%20and%20Signup/signup.dart';
import 'package:school_driver/Verification/Verification.dart';
import 'package:school_driver/Widgets/buttons.dart';
import 'package:school_driver/Widgets/text_field.dart';
import 'package:school_driver/constents.dart';
import 'package:http/http.dart' as http;

import '../Utils/Appurls/appurl.dart';
import '../Utils/Utils.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final userName = TextEditingController();
  final password = TextEditingController();

  Future<void> loginUser() async {
    final Map<String, String> data = {
      'userid': userName.text,
      'password': password.text,
    };

    try {
      final response = await http.post(
        Uri.parse(AppUrl.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        int userId = responseData['data']['id'];
        Utils.userLoggedName = responseData['data']['name'].toString();

        Utils.userLoggedId = userId;

        print('User ID: $userId');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
        Fluttertoast.showToast(msg: 'Welcome back!');
      } else {
        print('Error - Status Code: ${response.statusCode}');
        print('Error - Response Body: ${response.body}');
        Fluttertoast.showToast(msg: 'User ID or Password is incorrect.');
      }
    } catch (e) {

      print('Login failed: Exception - $e');
      Fluttertoast.showToast(msg: 'User ID or Password is incorrect.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30.0,),
              Center(child: Image.asset('assets/login.jpg')),
              SizedBox(height: 10.0,),
             MyTextFieldWidget(labelName: 'Email or username', controller: userName, validator: (){},),
             MyTextFieldWidget(labelName: 'Password', controller: password, validator: (){},),
              MyButtonWidget(buttonName: 'Login', bgColor: Colors.purple.shade400, onPressed: (){
                loginUser();
              }),
          
              TextButton(onPressed: () {
          
              }, child: TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage(),));
          
              }, child: Text('Dont have an account?'))),
              Column(
                children: [
                  Text('Sign in with google'),
                  IconButton(onPressed: () {
                    Utils.signInWithGoogle(context);
                  }, icon: Image.asset('assets/googleic.png')),
                ],
              )
            ],
          
          ),
        ),
      ),
    );
  }
}
