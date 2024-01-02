import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Homepages/Scanner/qrscansmaple.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Utils/Appurls/appurl.dart';
import 'package:school_driver/Utils/Utils.dart';

import '../../Widgets/buttons.dart';
import '../../constents.dart';
import '../../forchange.dart';

class Scanpage extends StatefulWidget {
  int tripID;
  String? endstop;
  Scanpage({required this.tripID,this.endstop});

  @override
  State<Scanpage> createState() => _ScanpageState();
}

class _ScanpageState extends State<Scanpage> {

  Future<void> endTrip(int trip_id,String endstop) async {
    // Your request payload
    Map<String, dynamic> requestBody = {
      "ending_stop": widget.endstop,
      "id":widget.tripID,
    };

    try {
      final response = await http.post(
        Uri.parse(AppUrl.endTrip),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );
      print('the end trip body is:${jsonEncode(requestBody)}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Trip Ended!');
        print('end stop successfull....');
        // Successful response, handle accordingly
        print('API call success: ${response.body}');
      } else {
        Fluttertoast.showToast(msg: 'Trip Ending Failed!');
        // Handle error response
        print('API call failed with status ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error during API call: $error');
    }
  }
  @override
  void initState() {
    print('passed value is :${widget.tripID}');
    print('passed end stop is :${widget.endstop}');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text( 'Your Trip Started',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu,color:textColor1),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:CircleAvatar(
              backgroundImage: NetworkImage(Utils.photURL == null ? 'https://images.unsplash.com/photo-1480455624313-e'
                  '29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
                  'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D': Utils.photURL.toString()),
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
                SizedBox(height: 130,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>QrCodeSample(),));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: scanColor2,
                        borderRadius: BorderRadius.circular(200)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 184,
                        width: 184,
                        decoration: BoxDecoration(
                            color: scanColor,
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: Center(child: Text('Scan',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 250,),
                MyButtonWidget(buttonName: 'End Trip', bgColor: pinkColor,onPressed: (){
                  print('end stop pressed....');
                  endTrip(widget.tripID,widget.endstop.toString());
                  Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Homepage(),));
                }),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
