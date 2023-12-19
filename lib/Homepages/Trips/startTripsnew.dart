// import 'package:flutter/material.dart';
//
// import '../../constents.dart';
//
// class SelectTrip extends StatefulWidget {
//   const SelectTrip({Key? key}) : super(key: key);
//
//   @override
//   State<SelectTrip> createState() => _SelectTripState();
// }
//
// class _SelectTripState extends State<SelectTrip> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text( 'Select Trip Location',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
//         backgroundColor: Colors.white,
//         leading: Icon(Icons.menu,color:textColor1),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CircleAvatar(
//               backgroundImage: NetworkImage('https://images.unsplash.com/photo-1480455624313-e'
//                   '29b44bbfde1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid='
//                   'M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
//             ),
//           )
//         ],
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             ListView.builder(
//               itemCount: 2,
//               itemBuilder: (context, index) {
//               return Column(
//                 children: [
//
//                 ],
//               );
//             },)
//
//           ],
//         ),
//       ),
//     );
//   }
// }
