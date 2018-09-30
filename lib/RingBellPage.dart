import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Map<String, dynamic> data;
  GlobalKey<QrCameraState> cameraState = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraState.currentState != null) cameraState.currentState.restart();
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("Generate Code", style: TextStyle(fontSize: 24.0)))),
        body: Center(
        child: Stack(children: <Widget>[
          SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: QrCamera(
            key: cameraState,
            qrCodeCallback: (code) {
              if (data == null) {
                data = json.decode(code);
                showDialog(context: context, barrierDismissible: false, builder: (context) =>
                    AlertDialog(
                      title: Text(data['roomName']),
                      content: Text('Owner: ' + data['name']),
                      actions: <Widget>[
                        FlatButton(child: Text('Cancel'),
                          onPressed: () {
                          data = null;
                          Navigator.of(context).pop();
                          },
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
              }
            },
          )),
          Align(alignment: Alignment.bottomRight,
              child: Padding(padding: EdgeInsets.all(50.0), child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 72.0),
                  onPressed: () => Navigator.of(context).pushNamed('/CreateCodePage'))))]),
        ));
  }
}