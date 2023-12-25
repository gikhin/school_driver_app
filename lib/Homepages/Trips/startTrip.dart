import 'dart:convert';

import 'package:flutter/material.dart';
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
  List<dynamic> tripDetails = [];

  Future<void> fetchTripHistory() async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.tripHistory),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': Utils.userLoggedId}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          tripDetails = List.from(responseData['data']);
        });
      } else {
        // Handle error
        print('Error - Status Code: ${response.statusCode}');
        print('Error - Response Body: ${response.body}');
        // You might want to show an error message to the user
      }
    } catch (error) {
      // Handle other types of errors (e.g., network issues)
      print('Error: $error');
      // Show a generic error message to the user
    }
  }
  Future<void> startTrip(stopname) async {
    // Your request payload
    Map<String, dynamic> requestBody = {
      "starting_stop": stopname,
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
        var responses = jsonDecode(response.body);
        Utils.flushBarErrorMessage(responses['message'], context, Colors.green);
        print('API call success: ${response.body}');
      } else {
        // Handle error response
        print('API call failed with status ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error during API call: $error');
    }
  }

  Future<void> deleteTrip(int driverTripId) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.deleteTrip),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'driver_tripid': driverTripId}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage(responseData['message'], context, Colors.green);
        print('Trip deleted successfully: ${response.body}');
        // Refresh the trip history after deletion
        fetchTripHistory();
      } else {
        // Handle error
        print('Error - Status Code: ${response.statusCode}');
        print('Error - Response Body: ${response.body}');
        // You might want to show an error message to the user
      }
    } catch (error) {
      // Handle other types of errors (e.g., network issues)
      print('Error: $error');
      // Show a generic error message to the user
    }
  }


  @override
  void initState() {
    super.initState();
    fetchTripHistory();
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
      body: Center(
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
            Expanded(
              child: ListView.builder(
                itemCount: tripDetails.length,
                itemBuilder: (context, index) {
                  final tripDetail = tripDetails[index];
                  return Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: SizedBox(
                            height: 80,
                            width: 330,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.school_outlined, color: Colors.blue),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            '${tripDetail['starting_stop'].toString().toUpperCase()}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 52,
                            width: 154,
                            child: MyButtonWidget(
                              buttonName: 'Delete',
                              bgColor: pinkColor,
                              onPressed: () {
                                deleteTrip(tripDetail['driver_tripid']);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 52,
                            width: 154,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: startTripColor),
                              onPressed: () {startTrip(tripDetail['starting_stop'].toString().toUpperCase());
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Scanpage()));
                              },
                              child: Text('Start'),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 52,
              width: 324,
              child: MyButtonWidget(
                buttonName: 'Add More Trip',
                bgColor: checkOutcolor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyTrips()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
