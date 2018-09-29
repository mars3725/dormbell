import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateCodePage extends StatefulWidget {
  @override
  _CreateCodePageState createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  String roomName = "Room Name";
  String name = "Name";
  Widget qrCode = Container();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Code")),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(25.0), child: Row(
                children: <Widget>[
                  Text("Room Name: "),
                  Flexible(child: TextField(controller: TextEditingController(text: roomName) ,onChanged: (value) {
                    roomName = value;
                    },
                  )),
                ]
            )),
        Padding(padding: EdgeInsets.all(25.0), child: Row(
                children: <Widget>[
                  Text("Name: "),
                  Flexible(child: TextField(controller: TextEditingController(text: name) ,onChanged: (value) {
                    name = value;
                    },
                  )),
                ]
            )),
            FlatButton(
              onPressed: () {
                setState(() {
                  var data = QRData(name, roomName, 0, 0);
                  qrCode = QrImage(
                    data: jsonEncode(data),
                    size: 200.0,
                  );
                });
              },
              child:
                Text("Create QR Code"),
            ),
            qrCode
          ],
        )));
  }
}

class QRData {
  String roomName, message, owner;
  double latitude, longitude;

  QRData(this.owner, this.roomName, this.latitude, this.longitude, {this.message=""});
}