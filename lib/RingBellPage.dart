import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Map<String, dynamic> data;
  GlobalKey<QrCameraState> cameraState = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraState.currentState != null) cameraState.currentState.restart();
    return Scaffold(key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(title: Center(child: Text("Generate Code", style: TextStyle(fontSize: 24.0)))),
        body: Center(
          child: Stack(children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: QrCamera(
                  key: cameraState,
                  notStartedBuilder: (context) => Container(),
                  onError: (context, error) => GestureDetector(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.notifications_off, size: 150.0, color: Colors.white),
                            Text("Error Starting Camera. Tap to retry.", style: TextStyle(color: Colors.white))
                          ]),
                      onTap: ()=> cameraState.currentState.restart()),
                  qrCodeCallback: (code) {
                    if (data == null) {
                      data = json.decode(code);
                      showDialog(context: context, barrierDismissible: false,
                          builder: (context) => mainDialog());
                    }
                  },
                )),
            Align(alignment: Alignment.bottomCenter,
                child: Padding(padding: EdgeInsets.all(25.0),
                    child: GestureDetector(
                        child: Icon(Icons.add, color: Colors.white, size: 100.0),
                        onTap: () => Navigator.of(context).pushNamed('/CreateCodePage'))))]),
        ));
  }

  AlertDialog mainDialog() {
    return AlertDialog(
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
            FirebaseAuth.instance.currentUser().then((user) {
              HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "ringUser");
              callable.call({
                'ownerID': data["ownerID"],
                'ringerName': user.displayName,
              });
              data = null;
              Navigator.of(context).pop();
            });
          },
        ),
        FlatButton(child: Text('Message'),
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(context: context, barrierDismissible: false,
                builder: (context) => messageDialog());
          },
        )
      ],
    );
  }

  messageDialog() {
    String message = "Default Message";
    return AlertDialog(
        title: Text("Message to "+data['roomName']),
        content: TextField(onChanged: (value)=> message = value),
        actions: <Widget>[
          FlatButton(child: Text("Cancel"),
              onPressed: () {
                data = null;
                Navigator.of(context).pop();}),
          FlatButton(child: Text("Send"),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((user) {
                  HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "messageUser");
                  callable.call({
                    'ownerID': data["ownerID"],
                    'message': message,
                    'ringerName': user.displayName,
                  });
                  data = null;
                  Navigator.of(context).pop();
                });
              }),
        ]);
  }
}