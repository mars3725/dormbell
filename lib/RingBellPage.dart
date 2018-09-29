import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class RingBellPage extends StatefulWidget {
  @override
  _RingBellPageState createState() => _RingBellPageState();
}

class _RingBellPageState extends State<RingBellPage> {
  String text = "QR Data Goes here once read";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          SizedBox(
          width: 300.0,
          height: 300.0,
          child: new QrCamera(
            qrCodeCallback: (code) {
              setState(() => text = code);
            },
          )),
            Text(text)
          ],
        )));
  }
}