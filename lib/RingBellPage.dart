import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String text = "QR Data Goes here once read";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Read Code")),
        body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: QrCamera(
            qrCodeCallback: (code) {
              var data = json.decode(code);
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text(data['roomName']),
                content: Text('Owner: '+data['name']),
                actions: <Widget>[
                  FlatButton(child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(child: Text('Ring'),
                    onPressed: () {
                      print("Ringing");
                    },
                  ),
                  FlatButton(child: Text('Message'),
                    onPressed: () {
                      print("Messaging");
                    },
                  )
                ],
              ));
            },
          )),
        ));
  }
}