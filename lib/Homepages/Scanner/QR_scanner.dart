import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Homepages/Scanner/qrscansmaple.dart';
import 'package:school_driver/Utils/Appurls/appurl.dart';
import 'package:school_driver/Utils/Utils.dart';
import '../../Login and Signup/Profile.dart';
import '../../Widgets/buttons.dart';
import '../../constents.dart';
import '../../forchange.dart';

class Scanpage extends StatefulWidget {
  final int tripID;
  final String ? enddstop;
  final String? endstop;

  Scanpage({required this.tripID, this.endstop,this.enddstop});

  @override
  State<Scanpage> createState() => _ScanpageState();
}

class _ScanpageState extends State<Scanpage> {
  bool isTripEnded = false;

  Future<void> endTrip(String endstop,int tripid) async {
    // Your request payload
    Map<String, dynamic> requestBody = {
      "ending_stop": endstop, // Use an empty string if endstop is null
      "id": tripid,
      "status":"reached"

    };

    try {
      final response = await http.post(
        Uri.parse(AppUrl.endTrip),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );
print('WWWWW${jsonEncode(requestBody)}');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Trip Ended!');
        setState(() {
          isTripEnded = true;
        });
        print('API call success: ${response.body}');
      } else {
        Fluttertoast.showToast(msg: 'Trip Ending Failed!');
        print('API call failed with status ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  Future<bool> _onWillPop() async {
    if (!isTripEnded) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text('You cannot exit until the trip is ended.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await endTrip(widget.enddstop.toString(),int.parse(Utils.masterTripid.toString()));
                if (isTripEnded) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(),
                    ),
                  );
                }
              },
              child: Text('End Trip'),
            ),
          ],
        ),
      ) ??
          false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    print('0000000000');
    print("enddstop is:${widget.enddstop}");
    print("endstop is:${widget.endstop}");
    print("id is:${widget.tripID}");
    print('0000000');

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Your trip started'),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    Utils.photURL == null
                        ? 'https://images.unsplash.com/photo-1480455624313-e29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
                        'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'
                        : Utils.photURL.toString(),
                  ),
                ),
              ),
            )
          ],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 130,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrCodeSample(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: scanColor2,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 184,
                          width: 184,
                          decoration: BoxDecoration(
                            color: scanColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              'Scan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  MyButtonWidget(
                    buttonName: 'End Trip',
                    bgColor: pinkColor,
                    onPressed: () async {
                      print('End Trip button pressed....');
                      await endTrip(widget.enddstop.toString(),int.parse(Utils.masterTripid.toString()));
                      if (isTripEnded) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
