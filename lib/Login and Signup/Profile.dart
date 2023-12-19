import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Homepages/Homepage.dart';
import '../Utils/Appurls/appurl.dart';
import '../Widgets/buttons.dart';
import '../Widgets/text_field.dart';

import '../constents.dart';
import 'Login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final vehicleNumber = TextEditingController();

  Map<String, dynamic>? userData;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse(AppUrl.myVehiclesProfile);
    final requestBody = {"id": 4};

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      print('URL: $url');
      print('Request Body: ${jsonEncode(requestBody)}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (!data['error'] && data['success']) {
          setState(() {
            userData = data['data'][0];
            name.text = userData?['name'] ?? '';
            phoneNumber.text = userData?['phone_no'] ?? '';
            email.text = userData?['email'] ?? '';
            vehicleNumber.text = userData?['vehicle_no'] ?? '';
          });
        } else {
          print('Error fetching user data: ${data['message']}');
          // Handle error - Update UI to indicate an error
        }
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
        // Handle error - Update UI to indicate an error
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      // Handle error - Update UI to indicate an error
    }
  }

  Future<void> saveUserData() async {
    final url = Uri.parse(AppUrl.editDriver);
    final requestBody = {
      "driver_id": 4,
      "name": name.text,
      "email": email.text,
      "vehicle_no": vehicleNumber.text,
      "phone_no": phoneNumber.text,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      print('URL: $url');
      print('Request Body: ${jsonEncode(requestBody)}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Handle response data accordingly
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
        // Handle error - Update UI to indicate an error
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      // Handle error - Update UI to indicate an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu, color: textColor1),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
              child: CircleAvatar(
                backgroundColor: checkIncolor,
                child: Icon(Icons.home_filled, color: Colors.white),
              ),
            ),
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(radius: 45),
                  SizedBox(
                    width: 225,
                    child: MyTextFieldWidget(
                      labelName: 'Name',
                      controller: name,
                      enabled: isEditing,
                      validator: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyTextFieldWidget(
                labelName: 'Email',
                controller: email,
                enabled: isEditing,
                validator: () {},
              ),
              MyTextFieldWidget(
                labelName: 'Phone Number',
                controller: phoneNumber,
                enabled: isEditing,
                validator: () {},
              ),
              MyTextFieldWidget(
                labelName: 'Vehicle No',
                controller: vehicleNumber,
                enabled: isEditing,
                validator: () {},
              ),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 52,
                      width: 156,
                      child: MyButtonWidget(
                        buttonName: "Log out",
                        bgColor: pinkColor,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Loginpage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 52,
                      width: 156,
                      child: MyButtonWidget(
                        buttonName: isEditing ? "Save" : "Edit",
                        bgColor: isEditing ? Colors.teal : openScanner,
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                            if (!isEditing) {
                              saveUserData();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
