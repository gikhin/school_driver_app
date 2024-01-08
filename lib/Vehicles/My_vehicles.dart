
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:school_driver/Utils/Appurls/appurl.dart';
import 'package:school_driver/Utils/Utils.dart';

import '../Login and Signup/Profile.dart';
import '../Widgets/buttons.dart';
import '../Widgets/text_field.dart';
import '../constents.dart';
import 'Editvehicles.dart';
import 'dart:io';

class Myvehicles extends StatefulWidget {
  const Myvehicles({Key? key}) : super(key: key);

  @override
  State<Myvehicles> createState() => _MyvehiclesState();
}

class _MyvehiclesState extends State<Myvehicles> {
  List<dynamic> vehiclesDetails = [];
  final vehicleName = TextEditingController();
  final driverName = TextEditingController();
  final vehicleNumber = TextEditingController();
  final capacity = TextEditingController();


  bool isLoading = false;

  int currentPage = 0;
  final PageController _pageController = PageController();

  File? _image;
  String? downURL;

  @override
  void dispose() {
    vehicleName.dispose();
    driverName.dispose();
    vehicleNumber.dispose();
    capacity.dispose();
    super.dispose();
  }

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

  @override
  void initState() {
    super.initState();
    // Fetch vehicle details when the widget initializes
    vehicleHistory();
  }

  // Future<void> addVehicles(File? image) async {
  //   print('hey prabu');
  //   try {
  //     if (image == null) {
  //       print('No image selected');
  //       // Handle the case where no image is selected
  //       return;
  //     }
  //
  //     final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     final Reference reference =
  //     FirebaseStorage.instance.ref().child('test/$fileName.jpg');
  //
  //     final UploadTask uploadTask = reference.putFile(image);
  //     final TaskSnapshot uploadSnapshot = await uploadTask.whenComplete(() {});
  //
  //     if (uploadSnapshot.state == TaskState.success) {
  //       final downloadUrl = await reference.getDownloadURL();
  //
  //       final Map<String, dynamic> data = {
  //         'driver_id': Utils.userLoggedId,
  //         'seat_capacity': int.parse(capacity.text),
  //         'vehicle_no': vehicleNumber.text,
  //         'photo': downloadUrl,
  //         'vehicle_name': vehicleName.text,
  //       };
  //
  //       final response = await http.post(
  //         Uri.parse(AppUrl.addVehicles),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(data),
  //       ).timeout(Duration(seconds: 10));
  //
  //       if (response.statusCode == 200) {
  //         Utils.flushBarErrorMessage(
  //             'Vehicle added successfull !', context, Colors.green);
  //         vehicleHistory();
  //         print('Post request successful!');
  //         print('Response: ${response.body}');
  //         // You might want to return something here or notify the UI about success.
  //       } else {
  //         print('Failed to post data. Error code: ${response.statusCode}');
  //         print('Error message: ${response.body}');
  //         // You might want to throw an exception here or notify the UI about the failure.
  //       }
  //     } else {
  //       print('Failed to upload image to Firebase Storage');
  //       // You might want to throw an exception here or notify the UI about the failure.
  //     }
  //   } catch (error) {
  //     print('Error during the HTTP request: $error');
  //     // Handle specific exceptions or rethrow the error if needed.
  //     // You might want to notify the UI about the error.
  //   }
  // }


  Future<void> uploadImageToFirebase(File? image) async {
    try {
      if (image == null) {
        Fluttertoast.showToast(msg: 'No image selected');
        print('No image selected');
        // Handle the case where no image is selected
        return;
      }

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference reference =
      FirebaseStorage.instance.ref().child('test/$fileName.jpg');

      final UploadTask uploadTask = reference.putFile(image);
      final TaskSnapshot uploadSnapshot = await uploadTask.whenComplete(() {});

      if (uploadSnapshot.state == TaskState.success) {
        final downloadUrl = await reference.getDownloadURL();
        print('downloadUrl is :${downloadUrl}');
        // onSuccess(downloadUrl); // Invoke the callback with the download URL
        setState(() {
          downURL = downloadUrl;
        });
        print('ssss${downURL}');
      } else {
        downURL = '';
        print('Failed to upload image to Firebase Storage');
        // You might want to throw an exception here or notify the UI about the failure.
      }
    } catch (error) {
      print('Error during image upload to Firebase Storage: $error');

    }
  }

  Future<void> addVehicles(String url) async {
    print('hey prabu');
    try {
        final Map<String, dynamic> data = {
          'driver_id': Utils.userLoggedId,
          'seat_capacity': int.parse(capacity.text),
          'vehicle_no': vehicleNumber.text,
          'photo': url,
          'vehicle_name': vehicleName.text,
        };

        final response = await http.post(
          Uri.parse(AppUrl.addVehicles),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        ).timeout(Duration(seconds: 10));
        print('$data');

        if (response.statusCode == 200) {
          Utils.flushBarErrorMessage(
              'Vehicle added successfully!', context, Colors.green);
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

    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            child: Column(
              children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(
                  'My Vehicles',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 23),
                ),
              ],
            ),
            // SizedBox(
            //   height: 150,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Center(
            //       child: Container(
            //         width: 324,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey.withOpacity(0.5),
            //               spreadRadius: 2,
            //               blurRadius: 5,
            //               offset: Offset(0, 3),
            //             ),
            //           ],
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: ListView.builder(
            //           itemCount: vehiclesDetails.length,
            //           itemBuilder: (context, index) {
            //             print(vehiclesDetails.length);
            //             final vehicleDetail = vehiclesDetails[index];
            //             // print('hey: ${vehicleDetail}0000');
            //             return Column(
            //               children: [
            //                 Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: CircleAvatar(
            //                         radius: 55.0,
            //                         backgroundImage: NetworkImage(vehiclesDetails[0]),
            //                       ),
            //                     ),
            //                     // Padding(
            //                     //   padding: const EdgeInsets.all(8.0),
            //                     //   child: Container(
            //                     //     decoration: BoxDecoration(
            //                     //       borderRadius: BorderRadius.circular(10.0),
            //                     //     ),
            //                     //     child:Image(image: AssetImage('${vehiclesDetailsmap['photo'].toString()}')),


//                     //     height: 105,
            //                     //     width: 93,
            //                     //   ),
            //                     // ),
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text('${vehiclesDetails[index]['name'].toString().toUpperCase()}'),
            //                         Text('${vehiclesDetails[index]['vehicle_no'].toString().toUpperCase()}'),
            //                         Text('${vehiclesDetails[index]['seat_capacity']}'),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             );
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
           vehiclesDetails.length == 0 ? Text('No vehicles added !') :Padding(
            padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          height: 150,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollUpdateNotification) {
                      setState(() {
                        currentPage =
                            (_pageController.page ?? 0).round();
                      });
                    }
                    return false;
                  },
                  child: FutureBuilder(
                    future:vehicleHistory(),
                    builder: (context,snapshot) {
                      return PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: vehiclesDetails.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                    height: 120,
                                    width: 120,
                                    child: Image.network(
                                        '${vehiclesDetails[index]['photo'].toString()}')),
                                SizedBox(width: 25.0,),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:MainAxisAlignment.spaceAround,
                                        children: [
                                          // Text('vehicle Name:${vehiclesDetails[0]}'),
                                          Text(
                                            'Vehicle Name:${vehiclesDetails[index]['vehicle_name'].toString().toUpperCase()}',
                                            style: TextStyle(fontWeight: FontWeight.bold),),


                                          Text(
                                            'Vehicle Number:${vehiclesDetails[index]['vehicle_no'].toString().toUpperCase()}',
                                            style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(
                                            'Seat Capacity:${vehiclesDetails[index]['seat_capacity']}',style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),),
                                          SizedBox(
                                            width:100,
                                            child: MyButtonWidget(buttonName: 'Edit',
                                                bgColor: scanColor,
                                                onPressed: (){
                                                  print('pressed edit icon.....');
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditVehicle(vehicle_id:int.parse(vehiclesDetails[index]['id'].toString())),));
                                                }),
                                          ),
                                          SizedBox(height: 20,),
                                          // ElevatedButton(onPressed: (){
                                          //   print('pressed edit icon.....');
                                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => EditVehicle(vehicle_id:vehiclesDetails[index]['id']),));
                                          // }, child: Text('Edit'))
                                        ],
                                      ),
                                      // Positioned(
                                      //   top:100,
                                      //   bottom:100,
                                      //   child: Align(
                                      //     child: Padding(
                                      //         padding: const EdgeInsets.only(bottom: 8.0),
                                      //         child: Container(
                                      //             decoration: BoxDecoration(
                                      //               color: scanColor,
                                      //             ),
                                      //             child: InkWell(
                                      //               onTap: (){
                                      //                 print('pressed edit icon.....');
                                      //                 Navigator.push(context, MaterialPageRoute(builder: (context) => EditVehicle(vehicle_id:int.parse(vehiclesDetails[index]['id'].toString())),));
                                      //               },
                                      //                 child: Icon(Icons.edit)))
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          });
                    }
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      vehiclesDetails.length,
                          (index) => buildDot(index),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 26),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Add Vehicles',
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
                child:ElevatedButton(
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
                      final pickedFile = await ImagePicker().getImage(source: imageSource);

                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                          uploadImageToFirebase(File(pickedFile.path));
                        });

                      } else {
                        // Handle the case where the user canceled image selection
                        print("User canceled image selection");
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
            // MyTextFieldWidget(
            //     controller: image,
            //     labelName: 'Image',
            //     validator: () {}),
            SizedBox(height: 20),
            Visibility(
              visible: downURL != null && downURL!.isNotEmpty,
              child: MyButtonWidget(
                buttonName: 'Add Now',
                bgColor: startTripColor,
                onPressed: () {
                  print('lllll');
                  addVehicles(downURL.toString());

                  vehicleName.clear();
                  vehicleNumber.clear();
                  capacity.clear();
                  downURL=null;
                },
              ),
            )
          ],
        ),
      ),
    ),
    ],
    ),
    ),
    ),
    );
  }

  Widget buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          _pageController.animateToPage(index,
              duration: Duration(microseconds: 500), curve: Curves.easeInOut);
        },
        child: Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index ? startTripColor : Colors.grey),
        ),
      ),
    );
  }
}