import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:image/image.dart' as Img;

class CreateCodePage extends StatefulWidget {
  @override
  _CreateCodePageState createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  String roomName = "Volhacks";
  String name = "Matt Mohandiss";
  List<int> imgData;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging().configure(onMessage: (message) async {
      print(message.toString());
      scaffoldKey.currentState.showSnackBar(
          SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(message['notification']['title']),
                Text(message['notification']['body']),
              ])));
    });
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("Create Code", style: TextStyle(fontSize: 24.0)))),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                imgData != null? Container() : Padding(padding: EdgeInsets.all(25.0), child: Row(
                    children: <Widget>[
                      Text("Room Name: "),
                      Flexible(child: TextField(onChanged: (value) {
                        roomName = value;
                      },
                      )),
                    ]
                )),
                imgData != null? Container() : Padding(padding: EdgeInsets.all(25.0), child: Row(
                    children: <Widget>[
                      Text("Name: "),
                      Flexible(child: TextField(onChanged: (value) {
                        name = value;
                      },
                      )),
                    ]
                )),
                imgData == null? Container() : Image.memory(Uint8List.fromList(imgData)),
                RaisedButton(
                  onPressed: () {
                    if (imgData == null) {
                      FirebaseAuth.instance.currentUser().then((user) {
                        Map<String, dynamic> data = {
                          "name": name,
                          "roomName": roomName,
                          "ownerID": user.uid.substring(0, 10)
                        };
                        final qrCode = QrCode(4, QrErrorCorrectLevel.L);
                        qrCode.addData(json.encode(data));

                        qrCode.make();
                        int pixelSize = 8;
                        Img.Image img = Img.Image(qrCode.moduleCount * pixelSize,
                            qrCode.moduleCount * pixelSize);
                        img = img.fill(Colors.white.value);
                        for (int x = 0; x < qrCode.moduleCount; x++) {
                          for (int y = 0; y < qrCode.moduleCount; y++) {
                            if (qrCode.isDark(x, y)) img = Img.fillRect(
                                img, x * pixelSize, y * pixelSize,
                                x * pixelSize + pixelSize, y * pixelSize + pixelSize,
                                Colors.black.value);
                          }
                        }
                        setState(() => imgData = Img.encodePng(img));
                      });
                    } else {
                      var str = base64Encode(imgData);
                      AdvancedShare.generic(msg: roomName, url: "data:image/png;base64, "+str).then((response) {
                        if (response == 0) print("failed to share code");
                        else if (response == 1) print("success sharing code");
                        else if (response == 2) print("application isn't installed");
                      });
                    }
                  },
                  child:
                  imgData == null? Text("Create QR Code") : Text("Share Code"),
                )
              ],
            )));
  }
}