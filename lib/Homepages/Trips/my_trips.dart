import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Homepages/Scanner/QR_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Utils/Appurls/appurl.dart';
import 'package:school_driver/Utils/Utils.dart';

import '../../Widgets/buttons.dart';
import '../../Widgets/text_field.dart';
import '../../constents.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({Key? key}) : super(key: key);

  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  final schoolName = TextEditingController();
  final schoolNameController =  TextEditingController();
  final stopNameController = TextEditingController();
  List<TripEntry> tripEntries = [];
  List<TextEditingController>stopControllers = [];
  List<dynamic> drivertrips = [];

  ///api functions
  Future<void> addStop() async {
    Map<String, dynamic> data = {
      'id': Utils.userLoggedId,
      'stops': tripEntries
    };
    try {
      final response = await http.post(
        Uri.parse(AppUrl.addingNewStopsBydriver),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print('Adding stops successful');
        // Handle the response if needed
      } else {
        print('Failed to add stops. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        // Handle errors here
      }
    } catch (error) {
      print('Error during adding stops: $error');
      // Handle exceptions here
    }
  }


  Future<void> getstops() async {
    Map<String, dynamic> data = {
      'driver_id':Utils.userLoggedId,
    };
    try {
      print('its tryed....');
      print('body is::${jsonEncode(data)}');
      final response = await http.post(
        Uri.parse(AppUrl.getNewStop),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Add any additional headers if required
        },
        body: jsonEncode(data),
      );
      print('status code :${response.statusCode}');
      if (response.statusCode == 200) {
        print('gggggg');
        print('Response: ${response.body}');
        var responseData = jsonDecode(response.body);

          drivertrips.clear();
          drivertrips.addAll(responseData['data']);
          print('drivertrips...................:${drivertrips}');
        
        print('ssssssssss');
        // You can handle the response here
      } else {
        print('Failed to make POST request. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        // You can handle errors here
      }
    } catch (error) {
      print('Error during POST request: $error');
      // You can handle exceptions here
    }
  }

///StartTrip
  Future<void> startTrip() async {
    // Your request payload
    Map<String, dynamic> requestBody = {
      "starting_stop": "kozhikode",
      "status": "started",
      "driver_id": 1,
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
        // Successful response, handle accordingly
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

  ///end of api functions
  @override
  void initState() {
    // TODO: implement initState
    getstops();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu,color:textColor1),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1480455624313-e'
                  '29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
                  'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),

            ),
          )
        ],
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Text( 'My Trips',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),)),
            // SizedBox(height: 500,
            //   child: ListView.builder(
            //       itemCount: 1,
            //       itemBuilder: (context, index) {
            //         return Column(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Card(
            //                 child: SizedBox(
            //                   height: 80,
            //                   width: 330,
            //                   child: Column(
            //                     children: [
            //                       ListTile(
            //                         title: Row(
            //                           children: [
            //                             Icon(Icons.school_outlined,color: Colors.blue,),
            //                             Padding(
            //                               padding: const EdgeInsets.all(8.0),
            //                               child: Text('GVM LP School'),
            //                             ),
            //                           ],
            //                         ),
            //
            //                       ),
            //
            //                     ],
            //                   ),
            //
            //                 ),
            //               ),
            //             ),
            //             Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            //               children: [
            //                 SizedBox(
            //                     height: 52,
            //                     width: 154,
            //                     child: MyButtonWidget(buttonName: 'Delete',bgColor: pinkColor,onPressed: (){},)),
            //                 SizedBox(
            //                     height: 52,
            //                     width: 154,
            //                     child: MyButtonWidget(buttonName: 'Start',bgColor: startTripColor,onPressed: (){},))
            //               ],
            //             ),
            //           ],
            //         );
            //       }
            //   ),
            // ),
            // Container(
            //   width: 324,
            //   height: 250,
            //   decoration: BoxDecoration(color: Colors.white,
            //     borderRadius: BorderRadius.circular(6),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.3),
            //         spreadRadius: 2,
            //         blurRadius: 5,
            //         offset: Offset(0, 3),
            //       ),
            //     ],
            //
            //
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       children: [
            //         MyTextFieldWidget(controller:schoolName,labelName: 'School Name', validator: (){}, ),
            //         SizedBox(height: 10,),
            //         MyTextFieldWidget(controller:schoolName,labelName: 'Stops', validator: (){},),
            //
            //         SizedBox(height: 20,),
            //
            //         MyButtonWidget(buttonName: 'Add Stop',bgColor: checkIncolor,onPressed: (){},)
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20,),
            // MyButtonWidget(buttonName: 'Add Now',bgColor: startTripColor,onPressed: (){
            //
            // },)
            FutureBuilder(
              future:getstops() ,
              builder: (context,snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount:drivertrips.length,
                  itemBuilder: (context,index) {
                    // TripEntry tripEntry = tripEntries[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                            title:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration:BoxDecoration(
                                color: Colors.white,
                                boxShadow:[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.home),
                                  Text('${drivertrips[index]['school_name']}',style: TextStyle(color: Colors.black),),
                                ],
                              ),
                            ),
                          ),
                        ) ,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount:1,
                              itemBuilder: (context,subIndex) {
                                return Text('${drivertrips[index]['stop']}');
                              }
                            )
                          ],
                        ),

                      ],
                      // children: [
                      //   ...tripEntries.map((tripEntry) =>
                      //       Padding(
                      //     padding: const EdgeInsets.all(15.0),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color:Colors.white,
                      //         boxShadow:[
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.3),
                      //             spreadRadius: 2,
                      //             blurRadius: 5,
                      //             offset: Offset(0, 3),
                      //           ),
                      //         ]
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: SizedBox(
                      //           child: ExpansionTile(
                      //             title: Row(
                      //               children: [
                      //                 Icon(Icons.home),
                      //                 Text(tripEntry.schoolName,style: TextStyle(color: Colors.black
                      //                 ),),
                      //               ],
                      //             ),
                      //             children: [
                      //               for(String stop in tripEntry.stopNames)
                      //                 SizedBox(
                      //                   child: ListTile(
                      //                     title: Text(stop,style: TextStyle(color: Colors.black),),
                      //                   ),
                      //                 )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )),
                      //   SizedBox(height: 20.0,),
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       SizedBox(width: 154,height: 50,
                      //         child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: pinkColor),
                      //             onPressed: (){
                      //           setState(() {
                      //             tripEntries.removeAt(index);
                      //           });
                      //         }, child: Text('Delete')),
                      //       ),
                      //       SizedBox(height: 50,width: 154,
                      //           child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: scanColor),
                      //               onPressed: (){
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => Scanpage(),));
                      //               }, child: Text('Start'))),
                      //     ],
                      //   )
                      // ],
                    );
                  }
                );
              }
            ),
            SizedBox(height: 20.0,),
            Text('Add New Trip'),
            SizedBox(height: 20.0,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(

                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 23.0),
                              child: Text('School Name'),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 296,
                                  height: 40,
                                  child: TextFormField(
                                    controller: schoolNameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: fillColor,
                                      border: InputBorder.none, // Remove border
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 23.0),
                              child: Text('Stops'),
                            ),
                            for (int i = 0; i < stopControllers.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 23.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          controller: stopControllers[i],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: fillColor,
                                            border: InputBorder.none, // Remove border
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          stopControllers.removeAt(i);
                                        });
                                      },
                                      icon: Icon(Icons.remove, color: Colors.red),
                                    )
                                  ],
                                ),
                              ),
                            SizedBox(height: 10),

                          ],
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 296,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: checkIncolor),
                            onPressed: () {
                              setState(() {
                                stopControllers.add(TextEditingController());
                                addStop();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                Text('Add Stop'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,)
                    ],
                  ),
                ),
              ),
            ),

            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: scanColor),
                onPressed: (){
              // startTrip();
              setState(() {
                tripEntries.add(
                  TripEntry(schoolName: schoolNameController.text,
                        stopNames: stopControllers.map((controller) => controller.text).toList(),
                  ),
                );
                print('tirpentrieees:${tripEntries}');
                addStop();
                stopControllers.clear();
                schoolNameController.clear();
              });

              stopControllers.forEach((controller) => controller.clear());
            }, child: Text('Add Now'))
          ],
        ),
      ),

    );
  }

}

class TripEntry {
  final String schoolName;
  final List<String> stopNames;

  TripEntry({required this.schoolName, required this.stopNames});
}