import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:school_driver/Utils/Utils.dart';
import 'package:school_driver/constents.dart';
class QrCodeSample extends StatefulWidget {
  const QrCodeSample({Key? key}) : super(key: key);

  @override
  State<QrCodeSample> createState() => _QrCodeSampleState();
}

class _QrCodeSampleState extends State<QrCodeSample> {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Map<String,dynamic> student ={};

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async{
      setState(() {
        result = scanData;
      });
      try{
        print('result issssssss:${result?.code}');
        if(result != null){
          setState(() {
            Utils.link = result?.code;
          });
          await getStudentDetails(Utils.link);
          await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image(image: NetworkImage('${student['data']['avatar']}')),
                      Text('${student['data']['first_name']}'),
                      Text('${student['data']['last_name']}'),
                      Text('${student['data']['email']}'),
                      SizedBox(height: 20,),
                      Column(
                        children: [
                          Container(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: checkIncolor),
                              onPressed: () {},
                              child: Text('Check In'),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: checkOutcolor),
                              onPressed: () {},
                              child: Text('Check Out'),
                            ),
                          ),

                        ],
                      )

                    ],
                  ),
                ),
              );
            },
          );
        }else{
          print('scan error');
        }
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
        print(e.toString());
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }


  Future<Map<String, dynamic>> getStudentDetails(String link) async {
    try {
      var apiUrl = link;
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        student.clear();
        student.addAll(jsonDecode(response.body));
        print(student);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load data');
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                IconButton(onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                }, icon: Icon(Icons.flashlight_on,color: Colors.white,)),
              ],
            ),
            Expanded(
                flex: 4, child: _buildQrView(context)),
            FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    InkWell(
                      onTap: () async{
                        try{
                          await getStudentDetails(Utils.link);
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 350,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image(image: NetworkImage('${student['data']['avatar']}')),
                                      Text('${student['data']['first_name']}'),
                                      Text('${student['data']['last_name']}'),
                                      Text('${student['data']['email']}'),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(onPressed: (){

                                          }, child: Text('Check In')),
                                          ElevatedButton(onPressed: (){

                                          }, child: Text('Check Out'))
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
                          print(e.toString());
                        }

                    },
                      child: Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                    )
                  else
                    const Text('Scan code',style: TextStyle(color: Colors.white),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}





// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: <Widget>[
// Container(
// margin: const EdgeInsets.all(8),
// child: ElevatedButton(
// onPressed: () async {
// await controller?.toggleFlash();
// setState(() {});
// },
// child: FutureBuilder(
// future: controller?.getFlashStatus(),
// builder: (context, snapshot) {
// return Text('Flash: ${snapshot.data}');
// },
// )),
// ),
// Container(
// margin: const EdgeInsets.all(8),
// child: ElevatedButton(
// onPressed: () async {
// await controller?.flipCamera();
// setState(() {});
// },
// child: FutureBuilder(
// future: controller?.getCameraInfo(),
// builder: (context, snapshot) {
// if (snapshot.data != null) {
// return Text(
// 'Camera facing ${describeEnum(snapshot.data!)}');
// } else {
// return const Text('loading');
// }
// },
// )),
// )
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: <Widget>[
// Container(
// margin: const EdgeInsets.all(8),
// child: ElevatedButton(
// onPressed: () async {
// await controller?.pauseCamera();
// },
// child: const Text('pause',
// style: TextStyle(fontSize: 20)),
// ),
// ),
// Container(
// margin: const EdgeInsets.all(8),
// child: ElevatedButton(
// onPressed: () async {
// await controller?.resumeCamera();
// },
// child: const Text('resume',
// style: TextStyle(fontSize: 20)),
// ),
// )
// ],
// ),
