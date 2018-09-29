import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:advanced_share/advanced_share.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:image/image.dart' as Img;

class CreateCodePage extends StatefulWidget {
  @override
  _CreateCodePageState createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  String roomName = "Room Name";
  String name = "Name";
  List<int> imgData;
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
                  final qrCode = QrCode(4, QrErrorCorrectLevel.L);
                  qrCode.addData(json.encode(data));

                  qrCode.make();
                  int pixelSize = 8;
                  Img.Image img = Img.Image(qrCode.moduleCount*pixelSize, qrCode.moduleCount*pixelSize);
                  img = img.fill(Colors.white.value);
                  for (int x = 0; x < qrCode.moduleCount; x++) {
                    for (int y = 0; y < qrCode.moduleCount; y++) {
                      if (qrCode.isDark(x, y)) img = Img.fillRect(img, x*pixelSize, y*pixelSize, x*pixelSize+pixelSize, y*pixelSize+pixelSize, Colors.black.value);
                    }
                  }
                  imgData = Img.encodePng(img);
                });
              },
              child:
                Text("Create QR Code"),
            ),
            imgData == null? Container() : Image.memory(Uint8List.fromList(imgData)),
            imgData == null? Container() : FlatButton(
                onPressed: () {
                  var str = base64Encode(imgData);
                  AdvancedShare.generic(msg: roomName, url: "data:image/png;base64, "+str).then((response) {
                    if (response == 0) print("failed to share code");
                    else if (response == 1) print("success sharing code");
                    else if (response == 2) print("application isn't installed");
                  });
                },
                child: Text("Share Code"))
          ],
        )));
  }
}