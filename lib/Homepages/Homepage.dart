import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Homepages/Scanner/QR_scanner.dart';
import 'package:school_driver/Homepages/Scanner/qrscansmaple.dart';
import 'package:school_driver/Homepages/Trips/my_trips.dart';
// import 'package:school_driver/Homepages/Trips/mytripsnew.dart';
import 'package:school_driver/Homepages/Trips/startTrip.dart';
import 'package:school_driver/Login%20and%20Signup/Profile.dart';
import 'package:school_driver/Utils/Appurls/appurl.dart';
import 'package:school_driver/Utils/Utils.dart';
import 'package:school_driver/Vehicles/My_vehicles.dart';
import 'package:school_driver/constents.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Position _currentPosition;

  List<dynamic> tripDetails = [];

  List<dynamic> tripslist = [];
  List<dynamic> vehicleslist = [];

  bool isVehicle = true;
  bool isTrip = true;

  String capitalize(String s) {
    if (s == null || s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<void> tripHistoryFunction() async {
    print('caaleddd....');
    Map<String, dynamic> data = {'id': Utils.userLoggedId};
    final response = await http.post(
      Uri.parse(AppUrl.tripHistory),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responsedata = jsonDecode(response.body);
      print(responsedata['data']);
      List<dynamic> completeDriverTrips =
          responsedata['data']['complete_drivertrips'];
      for (var trip in completeDriverTrips) {
        print('Trip ID: ${trip['id']}');
        print('Starting Stop: ${trip['starting_stop']}');
        print('Ending Stop: ${trip['ending_stop']}');
        print('Status: ${trip['status']}');
        print('Driver Check-in: ${trip['driver_checkin']}');
        print('Driver Checkout: ${trip['driver_checkout']}');
        print('Driver ID: ${trip['driver_id']}');
      }
      setState(() {
        tripDetails.clear();
        tripDetails.addAll(completeDriverTrips);
      });
      print('hey....');
      // Successful API call
      print('API Response: ${response.body}');
    } else {
      // Error handling
      print('Error - Status Code: ${response.statusCode}');
      print('Error - Response Body: ${response.body}');
    }
  }

  //function to get current location
  Future<void> _getCurrentLocation() async {
    print('get current location is called....');
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  void _startLocationUpdates() {
    const oneMinute = Duration(minutes: 1);
    Timer.periodic(oneMinute, (Timer timer) {
      _getCurrentLocation();
      uploadCordinates();
    });
  }

  Future<void> uploadCordinates() async {
    print('uploading cordinates....');
    Map<String, dynamic> data = {
      'driver_id': Utils.userLoggedId,
      'latitude': _currentPosition.latitude.toString(),
      'longitude': _currentPosition.longitude.toString()
    };
    final response = await http.post(
      Uri.parse(AppUrl.addCordinates),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    print(jsonEncode(data));
    print(response);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('upload coordinates is successfully....');
      // Successful API call
      print('API Response: ${response.body}');
    } else {
      // Error handling
      print('Error - Status Code: ${response.statusCode}');
      print('Error - Response Body: ${response.body}');
    }
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await _requestLocationPermission();
    } else if (permission == LocationPermission.deniedForever) {
      // Handle case where user denied permission permanently
      // You might want to redirect the user to settings
      // to enable location manually
    } else {
      _startLocationUpdates();
    }
  }

  Future<void> checkingNewUser() async {
    print('checkingNewUser api is:${AppUrl.checkingNewUser}');
    Map<String, dynamic> bodydata = {"driver_id": Utils.userLoggedId};
    final response = await http.post(
      Uri.parse(AppUrl.checkingNewUser),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(bodydata),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        tripslist.clear();
        vehicleslist.clear();
        tripslist = responseData['data']['find_addedStop'];
        vehicleslist = responseData['data']['driver_vehicle'];
        print('tripsList:${tripslist}');
        print('vehicleslist:${vehicleslist}');
        print('driver_vehicle:${responseData['data']['driver_vehicle']}');
        print(
            'driver_vehicle length is:${responseData['data']['driver_vehicle'].length}');
        print(
            'added stop length:${responseData['data']['find_addedStop'].length}');
        if (responseData['data']['driver_vehicle'].length <= 0) {
          print('length is zero');
          isVehicle = false;
          isTrip = false;
          print('isvehicle values :${isVehicle}');
        } else {
          isVehicle = true;
          isTrip = true;
        }
        if (responseData['data']['find_addedStop'].length <= 0) {
          isTrip = false;
          print('isTrip values :${isTrip}');
        } else {
          isTrip = true;
        }
        print('555555555555555555');
      });

      print('responseData of checking Driver is: ${responseData}');
      print('POST request successful!');
      print('Response: ${response.body}');
    } else {
      print('6666666666');
      print('POST request failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle case where user denied permission
      // You may display a dialog or message to explain why
    } else if (permission == LocationPermission.deniedForever) {
      // Handle case where user denied permission permanently
      // You might want to redirect the user to settings
      // to enable location manually
    } else {
      _startLocationUpdates();
    }
  }

  @override
  void initState() {
    _checkLocationPermission();
    _getCurrentLocation();
    _startLocationUpdates();
    // TODO: implement initState
    tripHistoryFunction();
    super.initState();
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Hi ',
                        style: TextStyle(
                            color: textColor1,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      // Text(
                      //   '${Utils.userLoggedName.toString()}',
                      //   style: TextStyle(
                      //       color: openScanner,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 18),
                      // ),
                      Text(
                        '${capitalize(Utils.userLoggedName.toString())}',
                        style: TextStyle(
                          color: openScanner,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Have a ',
                        style: TextStyle(
                            color: textColor1,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'QuickSand',
                            fontSize: 18),
                      ),
                      Text(
                        'good day...',
                        style: TextStyle(
                            color: scanColor,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'QuickSand',
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: checkingNewUser(),
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Image.network(
                                'https://plus.unsplash.com/premium_photo-1670491584909-fad9d3a4f66d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3w'
                                'xMjA3fDB8MHxzZWFyY2h8MTN8fHNjaG9vbCUyMGJ1c3xlbnwwfHwwfHx8MA%3D%3D',
                                fit: BoxFit.cover,
                              ),
                              height: 180,
                              width: 130,
                              decoration: BoxDecoration(
                                color: scanColor2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              vehicleslist.length == 0
                                  ? SizedBox(
                                  height: 45,
                                  width: 195,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: addvehicleColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Myvehicles(),
                                            ));
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Add Vehicle',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )
                                  : tripslist.length ==0
                                  ? SizedBox(
                                  height: 45,
                                  width: 195,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: startTripColorlight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Fluttertoast.showToast(msg: 'Add Trip First !');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Start Trip',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )
                                  :SizedBox(
                                  height: 45,
                                  width: 195,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: startTripColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectTrip(),
                                            ));
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Start Trip',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                      SizedBox(height: 20.0,),
                      SizedBox(
                            height: 45,
                            width: 195,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: checkIncolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Myvehicles(),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('My Vehicles',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                              SizedBox(height: 20.0,),
                              vehicleslist.length == 0
                                  ? SizedBox(
                                height: 45,
                                width: 195,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: pinkColorLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(6.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg: 'Add Vehicle First !');
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyTrips(),));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Add Trips',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              )
                                  : tripslist.length == 0
                                      ? SizedBox(
                                  height: 45,
                                  width: 195,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: pinkColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Fluttertoast.showToast(
                                      //     msg: 'Add Vehicle First !');
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyTrips(),));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Add Trips',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )
                                      : SizedBox(
                                  height: 45,
                                  width: 195,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: pinkColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyTrips(),
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('My Trips',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ],
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Trip History',
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: tripDetails.length,
                      itemBuilder: (context, index) {
                        print(tripDetails.length);
                        print(tripDetails);
                        final tripDetail = tripDetails[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: SizedBox(
                                  height: 112.5,
                                  width: 324.875,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.school_outlined,
                                                color: Colors.blue,
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                        tripDetail['starting_stop'] == null? 'Starting stop' : '${tripDetail['starting_stop'].toString().toUpperCase().split(',')[0]}')),
                                            ],
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.pink,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  tripDetail['ending_stop'] == null? 'Ending stop' :  '${tripDetail['ending_stop'].toString().toUpperCase()}',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 55,
                              width: 330,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      tripDetail['status'] == 'reached'
                                          ? startTripColor
                                          : openScanner,
                                ),
                                onPressed: () {
                                  if (tripDetail['status'] != 'reached') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Scanpage(
                                                tripID: tripDetail['id'],
                                              )),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    tripDetail['status'] == 'reached'
                                        ? 'Start Again'
                                        : 'Open Scanner',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
