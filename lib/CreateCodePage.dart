import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

class CreateCodePage extends StatefulWidget {
  @override
  _CreateCodePageState createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  String roomName = "Room Name";
  String name = "Name";
  Widget QRImage = Container();
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
                  Map<String, dynamic> data = {
                    "name": name,
                    "roomName": roomName,
                    "latitude": 0.0,
                    "longitude": 0.0
                  };
                  final qrCode = new QrCode(4, QrErrorCorrectLevel.L);
                  qrCode.addData(json.encode(data));
                  qrCode.make();
                  List<int> lst = List();
                  for (int x = 0; x < qrCode.moduleCount; x++) {
                    for (int y = 0; y < qrCode.moduleCount; y++) {
                      if (qrCode.isDark(y, x)) {
                        lst.add(255);
                      }
                      else {
                        lst.add(0);
                      }
                    }
                  }
                  QRImage = Image.memory(Uint8List.fromList(lst));
                });
              },
              child:
                Text("Create QR Code"),
            ),
            QRImage
          ],
        )));
  }
}