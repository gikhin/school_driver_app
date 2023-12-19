import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_driver/Homepages/Homepage.dart';

class Vehicle {
  final String licensePlate;

  Vehicle({
    required this.licensePlate,
  });
}

class DriverDetailsPage extends StatefulWidget {
  @override
  _DriverDetailsPageState createState() => _DriverDetailsPageState();
}

class _DriverDetailsPageState extends State<DriverDetailsPage> {
  File? _image;

  late TextEditingController _vehicleNumber;
  late TextEditingController _phoneNumber;
  late TextEditingController _seatsController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _vehicleNumber = TextEditingController();
    _phoneNumber = TextEditingController();
    _seatsController = TextEditingController();
  }

  @override
  void dispose() {
    _vehicleNumber.dispose();
    _phoneNumber.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  void _verifi() {
    if (_formKey.currentState!.validate()) {
      final newVehicle = Vehicle(
        licensePlate: _vehicleNumber.text,
      );

      // TODO: Implement logic to handle the new vehicle (e.g., save to database)
      _handleNewVehicle(newVehicle);

      // Clear all form fields
      _phoneNumber.clear();
      _vehicleNumber.clear();
      _seatsController.clear();

      // Reset the selected image
      setState(() {
        _image = null;
      });

      // Navigate to the Homepage
      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  void _handleNewVehicle(Vehicle newVehicle) {
    // TODO: Implement logic to handle the new vehicle (e.g., save to database)
    // You can add this logic based on your application's requirements.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Verification',
          style: TextStyle(color: Colors.black, fontFamily: 'LexendDeca'),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneNumber,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: 'Phone number',
                            hintText: 'Enter the phone number',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _vehicleNumber,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            labelText: 'Vehicle Number',
                            hintText: 'Enter the Vehicle Number',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a vehicle number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(right: 110.0),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: TextFormField(
                              controller: _seatsController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: 'Seats',
                                hintText: 'Enter capacity of seats',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter capacity of seats';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (_image != null)
                          Text(
                            'Selected Image: ${_image!.path.split('/').last}',
                            style: TextStyle(color: Colors.black),
                          )
                        else
                          Text('No image selected', style: TextStyle(color: Colors.black)),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            final imageSource = await showDialog<ImageSource>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Select the image source"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, ImageSource.camera),
                                    child: Text("Camera"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, ImageSource.gallery),
                                    child: Text("Gallery"),
                                  ),
                                ],
                              ),
                            );

                            if (imageSource != null) {
                              final pickedFile = await ImagePicker().getImage(source: imageSource);
                              if (pickedFile != null) {
                                setState(() {
                                  _image = File(pickedFile.path);
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Add your vehicle",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _verifi();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
