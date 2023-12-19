import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Login%20and%20Signup/login.dart';
import 'package:school_driver/Verification/Verification.dart';
import 'package:school_driver/Widgets/buttons.dart';
import 'package:school_driver/Widgets/text_field.dart';
import 'package:school_driver/constents.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final userName = TextEditingController();
  final confirmPassword = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:       Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextFieldWidget(labelName: 'Email or username', controller: userName, validator: (){},),
            MyTextFieldWidget(labelName: 'Password', controller: password, validator: (){},),
            MyTextFieldWidget(labelName: 'Confirm Password', controller: confirmPassword, validator: (){},),
            MyButtonWidget(buttonName: 'Login', bgColor: openScanner, onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(),));
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
    );
  }
}
