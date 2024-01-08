import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../Homepages/Homepage.dart';
import '../Utils/Appurls/appurl.dart';
import '../Utils/Utils.dart';
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

    List<String> suggetions = ['KL 65 A 123','KL 65 A 124','KL 65 A 125','KL 65 A 126',];
    List<String> getSuggestions(String query) {
      // You can replace this with your own logic to fetch suggestions
      return suggetions
          .where((element) =>
          element.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse(AppUrl.driverProfile);
    final requestBody = {
      "id": Utils.userLoggedId
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('driver data');
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is List) {
          handleListResponse(responseData);
        } else if (responseData is Map<String, dynamic>) {
          handleMapResponse(responseData);
        } else {
          // Handle unexpected response type
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

  void handleListResponse(List<dynamic> responseData) {
    if (responseData.isNotEmpty) {
      setState(() {
        userData = responseData[0];
        updateUI();
      });
    } else {
      // Handle empty list scenario
    }
  }

  void handleMapResponse(Map<String, dynamic> responseData) {
    setState(() {
      userData = responseData['data'];
      updateUI();
    });
  }

  void updateUI() {
    name.text = userData?['name'] ?? '';
    phoneNumber.text = userData?['phone_no'] ?? '';
    email.text = userData?['email'] ?? '';
    vehicleNumber.text = userData?['vehicle_no'] ?? '';
  }

  Future<void> saveUserData() async {
    final url = Uri.parse(AppUrl.editDriver);
    final requestBody = {
      "driver_id": Utils.userLoggedId,
      "name": name.text,
      "email": email.text,
      "vehicle_no": vehicleNumber.text,
      "phone": phoneNumber.text,
    };

    try {
      final response = await http.put(
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
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Updated Successfully');
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

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
                backgroundImage: NetworkImage(Utils.photURL == null ? 'https://images.unsplash.com/photo-1480455624313-e'
                    '29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
                    'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D': Utils.photURL.toString()),
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
              Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
                  Text('Profile',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(Utils.photURL == null ? 'https://images.unsplash.com/photo-1480455624313-e'
                        '29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
                        'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D': Utils.photURL.toString()),
                  ),
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
              // MyTextFieldWidget(
              //   labelName: 'Vehicle No',
              //   controller: vehicleNumber,
              //   enabled: isEditing,
              //   validator: () {},
              // ),


              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  SizedBox(
                  height: 52,
                  width: 156,
                  child: MyButtonWidget(
                    buttonName: "Log out",
                    bgColor: pinkColor,
                    onPressed: () {
                      Utils.signoutgoogle(context);
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
