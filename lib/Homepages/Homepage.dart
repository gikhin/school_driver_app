import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Homepages/Scanner/QR_scanner.dart';
import 'package:school_driver/Homepages/Scanner/qrscansmaple.dart';
import 'package:school_driver/Homepages/Trips/my_trips.dart';
import 'package:school_driver/Homepages/Trips/mytripsnew.dart';
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
  List<dynamic> tripDetails = [];

  String capitalize(String s) {
    if (s == null || s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }


  Future<void> tripHistoryFunction( ) async {
    print('caaleddd....');
    Map<String, dynamic> data ={
      'id':Utils.userLoggedId
    };
    final response = await http.post(
      Uri.parse(AppUrl.tripHistory),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(data),
    );
    print(response);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responsedata = jsonDecode(response.body);
      print(responsedata['data']);
      setState(() {
        tripDetails.clear();
        tripDetails.addAll(responsedata['data']);
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

  @override
  void initState() {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(),));
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
                Row(
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
                        SizedBox(
                          height: 45,
                          width: 195,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: startTripColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectTrip(),));
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Start Trip',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 45,
                          width: 195,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pinkColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyTrips(),));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('My Trips',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                                                      '${tripDetail['starting_stop'].toString().toUpperCase()}')
                                              ),
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
                                                  '${tripDetail['ending_stop'].toString().toUpperCase()}',
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
                                  tripDetail['status'] == 'reached' ? startTripColor : openScanner,
                                ),
                                onPressed: () {
                                  if (tripDetail['status'] != 'reached') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Scanpage()),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    tripDetail['status'] == 'reached' ? 'Start Again' : 'Open Scanner',
                                    style: TextStyle(fontWeight: FontWeight.bold),
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
