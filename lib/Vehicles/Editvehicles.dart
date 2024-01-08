
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:school_driver/Utils/Appurls/appurl.dart';
import 'package:school_driver/Utils/Utils.dart';

import '../Login and Signup/Profile.dart';
import '../Widgets/buttons.dart';
import '../Widgets/text_field.dart';
import '../constents.dart';
import 'dart:io';


class EditVehicle extends StatefulWidget {
  int vehicle_id;
  EditVehicle({required this.vehicle_id, super.key});

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  List<dynamic> vehiclesDetails = [];
  final vehicleName = TextEditingController();
  final driverName = TextEditingController();
  final vehicleNumber = TextEditingController();
  final capacity = TextEditingController();
  final image = TextEditingController();
  String? photoUrl;
  File? _image;

  Future<void> vehicleHistory() async {
    try {
      print('Calling vehicleHistory...');
      Map<String, dynamic> data = {'driver_id': Utils.userLoggedId};
      final response = await http.post(
        Uri.parse(AppUrl.myVehiclesProfile),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          vehiclesDetails.clear();
          vehiclesDetails = responseData['data'];
        });
        print('helooooooooo');
        // print(vehiclesDetails['name']);
        print('4444444444444444');
        // print('vehicle details list is : ${vehiclesDetailsmap['photo']}');
        print('response data of vehicle history is :${responseData}');
      } else {
        // Error handling
        print('Error - Status Code: ${response.statusCode}');
        print('Error - Response Body: ${response.body}');
      }
    } catch (error) {
      // General error handling
      print('Error during API request: $error');
    }
  }

  Future<void> editVehicle() async {
    final Map<String, dynamic> data = {
      'vehicle_id': widget.vehicle_id,
      'seat_capacity': int.parse(capacity.text),
      'vehicle_no': vehicleNumber.text,
      // 'photo':
      // "https://imgd-ct.aeplcdn.com/370x208/n/cw/ec/130591/fronx-exterior-right-front-three-quarter-109.jpeg?isig=0&q=80",
      'vehicle_name': vehicleName.text,
    };

    try {
      final response = await http
          .put(
        Uri.parse(AppUrl.editVehicle),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      )
          .timeout(Duration(seconds: 10)); // Add a timeout for the request.

      print('URL: ${AppUrl.editVehicle}');
      print('Request Data: ${jsonEncode(data)}');

      if (response.statusCode == 200) {

        Navigator.pop(context);
        vehicleHistory();
        Utils.flushBarErrorMessage(
            'Vehicle edited successfully !', context, Colors.green);
        vehicleHistory();
        print('Post request successful!');
        print('Response: ${response.body}');
        // You might want to return something here or notify the UI about success.
      } else {
        print('Failed to post data. Error code: ${response.statusCode}');
        print('Error message: ${response.body}');
        // You might want to throw an exception here or notify the UI about the failure.
      }
    } catch (error) {
      print('Error during the HTTP request: $error');
      // Handle specific exceptions or rethrow the error if needed.
      // You might want to notify the UI about the error.
    }
  }

  //geting single vehicle details
  Future<void> getvehicledata() async {
    print('This Function called');

    Map<String, dynamic> data = {
      "vehicle_id": int.parse(widget.vehicle_id.toString()),
    };

    final response = await http.post(
      Uri.parse(AppUrl.getVehicleData),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );


    print("Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      try {
        var responseData = jsonDecode(response.body);
        print("AAAAAAA: $responseData");

        // setState(() {
          vehicleName.text = responseData['data'][0]['vehicle_name'];
          vehicleNumber.text = responseData['data'][0]['vehicle_no'];
          capacity.text = responseData['data'][0]['seat_capacity'].toString();
        photoUrl = responseData['data'][0]['photo'];
        // });
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      print("POST request failed with status: ${response.statusCode}");
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    print('passed id is:${widget.vehicle_id}');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu, color: textColor1),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(Utils.photURL == null
                    ? 'https://images.unsplash.com/photo-1480455624313-e'
                    '29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
                    'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'
                    : Utils.photURL.toString()),
              ),
            ),
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: FutureBuilder(
            future: getvehicledata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While data is loading
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If an error occurs
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                // If data is successfully loaded
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back,color: Colors.black,),),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Edit Vehicles',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 23),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    Container(
                      width: 324,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            if (photoUrl != null) // Display the photo if available
                              Image.network(
                                photoUrl!,
                                width: 100, // Set the width as needed
                                height: 100, // Set the height as needed
                              ),
                            MyTextFieldWidget(
                              controller: vehicleName,
                              labelName: 'Vehicle Name',
                              validator: () {},
                            ),
                            SizedBox(height: 10),
                            MyTextFieldWidget(
                              controller: vehicleNumber,
                              labelName: 'Vehicle Number',
                              validator: () {},
                            ),
                            SizedBox(height: 10),
                            MyTextFieldWidget(
                              controller: capacity,
                              labelName: 'Capacity',
                              validator: () {},
                            ),
                            SizedBox(height: 10),
                            if (_image != null)
                              Text(
                                'Selected Image: ${_image!.path.split('/').last}',
                                style: TextStyle(color: Colors.black),
                              )
                            else
                              Text('No image selected', style: TextStyle(color: Colors.black)),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: SizedBox(
                                width: 323.0,
                                height: 40.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final imageSource = await showDialog<ImageSource>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Text("Select the image source"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, ImageSource.camera),
                                            child: Text("Camera"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, ImageSource.gallery),
                                            child: Text("Gallery"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (imageSource != null) {
                                      final pickedFile =
                                      await ImagePicker().getImage(source: imageSource);
                                      if (pickedFile != null) {
                                        setState(() {
                                          _image = File(pickedFile.path);
                                        });
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: checkIncolor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: Colors.white), // Camera icon
                                      SizedBox(width: 8), // Space between icon and text
                                      Text(
                                        "Vehicle",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            MyButtonWidget(
                              buttonName: 'Save',
                              bgColor: startTripColor,
                              onPressed: () {
                                editVehicle();
                              },
                            )
                          ],
                        ),
                      ),
                    ),


                  ],
                );
              }
            },
          ),

        ),
      ),
    );
  }
}