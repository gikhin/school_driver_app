import 'package:flutter/material.dart';
import 'package:school_driver/Homepages/Homepage.dart';
import 'package:school_driver/Homepages/Scanner/QR_scanner.dart';
import 'package:school_driver/Homepages/Trips/my_trips.dart';
import 'package:school_driver/Widgets/buttons.dart'; // Import the missing file


import '../../constents.dart'; // Import the missing file

class SelectTrip extends StatefulWidget {
  const SelectTrip({Key? key}) : super(key: key);

  @override
  State<SelectTrip> createState() => _SelectTripState();
}

class _SelectTripState extends State<SelectTrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Select Trip Location',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu, color: textColor1),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1480455624313-e'
                      '29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
                      'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
            ),
          )
        ],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
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
                                        child: Text('GVM LP School'),
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
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            height: 52,
                            width: 154,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: startTripColor),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Scanpage(),));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyTrips(),));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
