import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../Login and Signup/Profile.dart';
import '../../Utils/Appurls/appurl.dart';
import '../../Utils/Utils.dart';
import '../../Widgets/buttons.dart';
import '../../constents.dart';
import '../Scanner/QR_scanner.dart';
import 'my_trips.dart';


class SelectTrip extends StatefulWidget {
  const SelectTrip({Key? key}) : super(key: key);

  @override
  State<SelectTrip> createState() => _SelectTripState();
}

class _SelectTripState extends State<SelectTrip> {
  List<dynamic> drivertrips = [];

  Future<void> getstops() async {
    Map<String, dynamic> data = {
      'driver_id': Utils.userLoggedId,
    };
    try {
      print('its tryed....');
      print('body is::${jsonEncode(data)}');
      final response = await http.post(
        Uri.parse(AppUrl.getNewStop),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      print('status code :${response.statusCode}');
      if (response.statusCode == 200) {
        print('gggggg');
        print('Response: ${response.body}');
        var responseData = jsonDecode(response.body);
        setState(() {
          drivertrips.clear();
          drivertrips.addAll(responseData['data']);
        });

        for (var trip in drivertrips) {
          var stopList = trip['stop'] as List<dynamic>;
          var formattedStops = stopList.map((stop) => stop['name']).toList();
          print('Trip ID: ${trip['id']}, School Name: ${trip['school_name']}, Stops: $formattedStops');
        }

        print('ssssssssss');
      } else {
        print('Failed to make POST request. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during POST request: $error');
    }
  }
  Future<void> startTrip(String stopName,int tripID, BuildContext context) async {
    // Your request payload
    Map<String, dynamic> requestBody = {
      "starting_stop": stopName,
      "status": "started",
      "driver_id": Utils.userLoggedId,
    };

    try {
      final response = await http.post(
        Uri.parse(AppUrl.master_Trip),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        Fluttertoast.showToast(msg: 'Your Trip Started!');
        Utils.flushBarErrorMessage(jsonResponse['message'], context, Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Scanpage(tripID: tripID)),
        );

        print('API call success: ${response.body}');
      } else {
        // Handle error response
        print('API call failed with status ${response.statusCode}');
        print('Response body: ${response.body}');

        // Optionally, handle different error scenarios based on status codes
        if (response.statusCode == 404) {
          // Handle 404 Not Found
        } else {
          // Handle other error scenarios
        }
      }
    } catch (error) {
      // Handle exceptions
      print('Error during API call: $error');

      // Optionally, show an error message to the user
      Utils.flushBarErrorMessage('An error occurred', context, Colors.red);
    }
  }

  // Future<void> deleteTrip(int driverTripId) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(AppUrl.deleteTrip),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode({'driver_tripid': driverTripId}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);
  //       Utils.flushBarErrorMessage(responseData['message'], context, Colors.green);
  //       print('Trip deleted successfully: ${response.body}');
  //       // Refresh the trip history after deletion
  //       fetchTripHistory();
  //     } else {
  //       // Handle error
  //       print('Error - Status Code: ${response.statusCode}');
  //       print('Error - Response Body: ${response.body}');
  //       // You might want to show an error message to the user
  //     }
  //   } catch (error) {
  //     // Handle other types of errors (e.g., network issues)
  //     print('Error: $error');
  //     // Show a generic error message to the user
  //   }
  // }

  Future<Map<String, dynamic>> deletetrip(int tripid) async {
    print('delete trip funciton called.....');

    Map<String,dynamic> data = {
      "stop_id":tripid
    };
    try {

      // Make the POST request
      final response = await http.delete(
        Uri.parse(AppUrl.deletingTrip),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Trip Successfully Deleted !');

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


  @override
  void initState() {
    super.initState();
    // fetchTripHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: Icon(Icons.menu, color: textColor1),
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back)),
                    Text(
                      'Select Trip Location',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 23),
                    ),
                  ],
                ),
                FutureBuilder(
                    future:getstops() ,
                    builder: (context,snapshot) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: drivertrips.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration:BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10.0,
                                    spreadRadius: -15,
                                    offset: Offset(
                                      -2,
                                      -2,
                                    ),
                                  )
                                ]
                            ),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExpansionTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(Icons.home),
                                            Expanded(
                                              child: Text(
                                                '${drivertrips[index]['school_name'].split(',')[0]}',
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: drivertrips[index]['stop'].length,
                                        itemBuilder: (context, subIndex) {
                                          if (subIndex < drivertrips[index]['stop'].length) {
                                            return ListTile(
                                              title: Text('${drivertrips[index]['stop'][subIndex]}' ?? ''),
                                            );
                                          } else {
                                            return SizedBox.shrink(); // or any other placeholder widget
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 154,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: pinkColor),
                                          onPressed: () {
                                            print('ddddddd:${drivertrips[index]['id']}');
                                            print('delete btn clicked');
                                            deletetrip(int.parse(drivertrips[index]['id'].toString()));
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width: 154,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: scanColor),
                                          onPressed: () {
                                            print('for trip id is:${drivertrips[index]['id']}');
                                            startTrip(drivertrips[index]['stop'][0],drivertrips[index]['id'], context);
                                          },
                                          child: Text('Start'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                    }
                ),
                SizedBox(
                  height: 52,
                  width: 324,
                  child: MyButtonWidget(
                    buttonName: 'Add More Trip',
                    bgColor: checkOutcolor,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyTrips(),));
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
