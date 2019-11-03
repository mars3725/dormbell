import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dormbell/CodesListPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:image/image.dart' as Img;

import 'code.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Map<String, dynamic> data;
  GlobalKey<QrCameraState> cameraState = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (cameraState.currentState != null) cameraState.currentState.restart();
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: QrCamera(
                  key: cameraState,
                  notStartedBuilder: (context) => Container(),
                  onError: (context, error) {
                    setState(() {});
                    return GestureDetector(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Icon(Icons.notifications_off, size: 150.0, color: Colors.white), Text("Error Starting Camera. Tap to retry.", style: TextStyle(color: Colors.white))]),
                        onTap: () => cameraState.currentState.restart());
                  },
                  qrCodeCallback: (code) {
                    if (data == null) {
                      data = json.decode(code);
                      showDialog(context: context, barrierDismissible: false, builder: (context) => scannedDialog());
                    }
                  },
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: GestureDetector(                     child: Icon(Icons.add, color: Colors.white, size: 85.0),
                      //onTap: () => Navigator.of(context).pushNamed('/CreateCodePage')
                      onTap: () => showDialog(context: context, builder: (context) => newCodeDialog()))),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: GestureDetector(
                    child: Icon(Icons.storage, color: Colors.white, size: 80.0),
                      //onTap: () => Navigator.of(context).pushNamed('/CreateCodePage')
                      onTap: () => showDialog(context: context, builder: (context) => CodesListPage()))),
            )
          ]),
        ));
  }

  String newRoomName, newName;

  AlertDialog newCodeDialog() => AlertDialog(
        title: Text('New Code'),
        content: Column(children: <Widget>[
          TextField(decoration: InputDecoration(labelText: 'Room Name'), onChanged: (val) => newRoomName = val),
          TextField(decoration: InputDecoration(labelText: 'Your Name'), onChanged: (val) => newName = val),
        ]),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              data = null;
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
              child: Text('Create'),
              onPressed: () {
                createCode(newName, newRoomName).then((code) {
                  newName = null;
                  newRoomName = null;
                  Navigator.of(context).popAndPushNamed('/ShareCode', arguments: code);
                });
              })
        ],
      );

  Future<Code> createCode(name, roomName) async {
    Code code = Code(name: name, roomName: roomName);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Map<String, dynamic> data = {"name": name, "roomName": roomName, "ownerID": user.uid.substring(0, 10)};
    final qrCode = QrCode(4, QrErrorCorrectLevel.L);
    qrCode.addData(json.encode(data));

    qrCode.make();
    int pixelSize = 8, borderSize = 8;
    int imageSize = (qrCode.moduleCount * pixelSize) + borderSize * 2;
    Img.Image img = Img.Image(imageSize, imageSize);
    img = img.fill(Colors.white.value);
    for (int x = 0; x < qrCode.moduleCount; x++) {
      for (int y = 0; y < qrCode.moduleCount; y++) {
        if (qrCode.isDark(x, y)) {
          int xPos = (x * pixelSize) + borderSize;
          int yPos = (y * pixelSize) + borderSize;
          img = Img.fillRect(img, xPos, yPos, xPos + pixelSize, yPos + pixelSize, Colors.black.value);
        }
      }
    }
    List<int> imgData = Img.encodePng(img);
    code.imgData = imgData;
    FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://dormbell-ce20b.appspot.com');
    String id = Random().nextDouble().toString();
    StorageReference storageRef = storage.ref().child(id + '.jpg');
    await storageRef.putData(imgData).onComplete;

    final DocumentReference docRef = Firestore.instance.collection(user.uid).document(name);
    //DocumentSnapshot snapshot = await docRef.get();
    List<String> urls = List();
    //if (snapshot != null) urls = snapshot.data['urls'];
    String url = await storageRef.getDownloadURL();
    code.url = url;
    //docRef.updateData({'urls': urls});
    docRef.setData({
      'roomName': code.roomName,
      'name': code.name,
      'url': code.url
    });
    return code;
  }

  AlertDialog scannedDialog() => AlertDialog(
        title: Text(data['roomName']),
        content: Text('Owner: ' + data['name']),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              data = null;
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Ring'),
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
          FlatButton(
            child: Text('Message'),
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(context: context, barrierDismissible: false, builder: (context) => messageDialog());
            },
          )
        ],
      );

  messageDialog() {
    String message = "Default Message";
    return AlertDialog(title: Text("Message to " + data['roomName']), content: TextField(onChanged: (value) => message = value), actions: <Widget>[
      FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            data = null;
            Navigator.of(context).pop();
          }),
      FlatButton(
          child: Text("Send"),
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
