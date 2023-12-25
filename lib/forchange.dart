import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class forExample extends StatefulWidget {
  const forExample({Key? key}) : super(key: key);

  @override
  State<forExample> createState() => _forExampleState();
}

class _forExampleState extends State<forExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: (){

            }, child: Text('Check In')),
            ElevatedButton(onPressed: (){

            }, child: Text('Check Out'))
          ],
        ),
      ),
    );
  }
}
