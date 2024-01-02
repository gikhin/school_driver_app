import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Utils/Appurls/appurl.dart';

class QrCodeSample extends StatefulWidget {
  String? tripId;
  QrCodeSample({this.tripId,Key? key}) : super(key: key);

  @override
  State<QrCodeSample> createState() => _QrCodeSampleState();
}

class _QrCodeSampleState extends State<QrCodeSample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Student? student;
  Map<String, dynamic> studentResponse = {};
  bool isBottomsheetOpen = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      try {
        print('result issssssss:${result?.code}');
        if (result != null && !isBottomsheetOpen) {
            String qrData  = result!.code!;
            // Directly update the UI with the scanned data
            await getstudentDatas(qrData);
            showBottomSheetIfNeeded(qrData);
        } else {
          print('scan error');
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to fetch data')));
        print(e.toString());
      }
    });
  }

  Future<void> getstudentDatas(String student_id) async {
    print('student details function called with id :$student_id');
    try {
      // Make the POST request
      var url = 'http://52.66.145.37:3005/student/detail/$student_id';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('url is:$url');
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        // Parse the response JSON if needed
        // Map<String, dynamic> responseBody = json.decode(response.body);
        setState(() {
          studentResponse = jsonDecode(response.body);
          print('students Response is :$studentResponse');
        });
        // Perform actions with the response data
        // print('Response: $responseBody');
      } else {
        // Handle the error if the request was not successful
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  //checkin function
  Future<Map<String, dynamic>> checkinfunction(String student_id) async {
    Map<String,dynamic> jsonData = {
      "st_id":int.parse(student_id.toString()),
      "driver_trip_id":int.parse(widget.tripId.toString()),
      "status":"started"
    };
    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(AppUrl.checkIn),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      print('check in body:${jsonEncode(jsonData)}');

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('check in function');
        // Parse the response JSON
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      } else {
        // Handle the error if the request was not successful
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      throw Exception('Failed to post data');
    }
  }

  //checkout function
  Future<Map<String, dynamic>> checkoutfunction(String student_id) async {
    Map<String,dynamic> jsonData = {
      "id":int.parse(student_id.toString()),
      "status":"reached"
    };
    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(AppUrl.checkOut),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      print('check in body:${jsonEncode(jsonData)}');

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('check in function');
        // Parse the response JSON
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      } else {
        // Handle the error if the request was not successful
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      throw Exception('Failed to post data');
    }
  }

  void showBottomSheetIfNeeded(String student_id) {
    // Perform any logic based on the scanned data to determine if bottom sheet is needed
    bool isDataAvailable = true; // Replace with your logic

    if (isDataAvailable && !isBottomsheetOpen)  {
      isBottomsheetOpen = true;
      // getstudentDatas(student_id);
       showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // String id = jsonData['ID'] ?? 'SceneMwone';
          return FutureBuilder(
            future: getstudentDatas(student_id),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),);
              }else{
                isBottomsheetOpen = false;
                return SizedBox(
                  height: 250,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Text('$student_id'),

                        Column(
                          children: [
                            Text('Name:${studentResponse['data']['name'].toString().toUpperCase()}',style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('School:${studentResponse['data']['school']['school_name'].toString().toUpperCase()}',style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Class:${studentResponse['data']['class_category'].toString().toUpperCase()}',style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print('checkin ...pressed....');
                                checkinfunction(student_id);
                                Navigator.pop(context);
                              },
                              child: Text('Check In'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('checkout pressed...');
                                checkoutfunction(student_id);
                                Navigator.pop(context);
                              },
                              child: Text('Check Out'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          );
        },
      );
    }
  }


  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: _buildQrView(context),
            ),
          ],
        ),
      ),
    );
  }
}


class Student {
  final int id;
  final String name;
  final String photo;
  final String school;
  final String classCategory;
  final int parentId;
  final Address address;
  final String vehicle;

  Student({
    required this.id,
    required this.name,
    required this.photo,
    required this.school,
    required this.classCategory,
    required this.parentId,
    required this.address,
    required this.vehicle,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      school: json['school'],
      classCategory: json['class_category'],
      parentId: json['parent_id'],
      address: Address.fromJson(json['address']),
      vehicle: json['vehicle'],
    );
  }
}

class Address {
  final String place;
  final String homeName;

  Address({
    required this.place,
    required this.homeName,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      place: json['place'],
      homeName: json['home_name'],
    );
  }
}
