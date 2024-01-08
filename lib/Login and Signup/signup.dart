import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Login%20and%20Signup/login.dart';
import 'package:school_driver/Verification/Verification.dart';
import 'package:school_driver/Widgets/buttons.dart';
import 'package:school_driver/Widgets/text_field.dart';
import 'package:school_driver/constents.dart';
import 'package:http/http.dart' as http;

import '../Utils/Appurls/appurl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileController = TextEditingController();
  bool _isPasswordVisible = false;


  Future<void> _registerUser() async {
    try {
      final Map<String, dynamic> requestData = {
        "name": nameController.text,
        "email": emailController.text,
        "password":passwordController.text,
        "mobile": mobileController.text,

      };

      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(AppUrl.register),
        headers: requestHeaders,
        body: jsonEncode(requestData),
      );
      print(requestData);

      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage(),));
        Fluttertoast.showToast(msg: 'User signup was successful.');

        print('successfullyyyyyy');
        final responseJson = json.decode(response.body);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error');
      print('Error fetching customer details: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body:       Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              MyTextFieldWidget(labelName: 'Name', controller: nameController, validator: (){},),
              MyTextFieldWidget(labelName: 'Email', controller: emailController, validator: (){},),
              MyTextFieldWidget(labelName: 'Phone Number', controller: mobileController, validator: (){},),

              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password'),
                  SizedBox(height: 10,),
                  Container(
                    width: 323.0,
                    height: 40.0,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off,color:Colors.black,),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),


                ],
              ),
              SizedBox(height: 20,),


              MyButtonWidget(buttonName: 'Sign Up', bgColor: Colors.purple.shade400, onPressed: (){
               _registerUser();
              }),

              TextButton(onPressed: () {

              }, child: TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage(),));

              }, child: Text('Already have an account?'))),
              // Column(
              //   children: [
              //     Text('Sign in with google'),
              //     IconButton(onPressed: () {
              //
              //     }, icon: Image.network('https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png')),
              //   ],
              // )
            ],

          ),
        ),
      ),
    );
  }
}
