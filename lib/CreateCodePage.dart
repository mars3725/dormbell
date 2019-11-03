import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:qr/qr.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateCodePage extends StatefulWidget {
  @override
  _CreateCodePageState createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  String roomName = "Volhacks";
  String name = "Matt Mohandiss";
  List<int> imgData;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  StorageReference storageRef;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            title: Center(
                child: Text("Create Code", style: TextStyle(fontSize: 24.0)))),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            imgData != null
                ? Container()
                : Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Row(children: <Widget>[
                      Text("Room Name: "),
                      Flexible(child: TextField(
                        onChanged: (value) {
                          roomName = value;
                        },
                      )),
                    ])),
            imgData != null
                ? Container()
                : Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Row(children: <Widget>[
                      Text("Name: "),
                      Flexible(child: TextField(
                        onChanged: (value) {
                          name = value;
                        },
                      )),
                    ])),
            imgData == null
                ? Container()
                : Image.memory(Uint8List.fromList(imgData)),
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
                    int pixelSize = 8, borderSize = 8;
                    int imageSize =
                        (qrCode.moduleCount * pixelSize) + borderSize * 2;
                    Img.Image img = Img.Image(imageSize, imageSize);
                    img = img.fill(Colors.white.value);
                    for (int x = 0; x < qrCode.moduleCount; x++) {
                      for (int y = 0; y < qrCode.moduleCount; y++) {
                        if (qrCode.isDark(x, y)) {
                          int xPos = (x * pixelSize) + borderSize;
                          int yPos = (y * pixelSize) + borderSize;
                          img = Img.fillRect(img, xPos, yPos, xPos + pixelSize,
                              yPos + pixelSize, Colors.black.value);
                        }
                      }
                    }
                    setState(() => imgData = Img.encodePng(img));
                    FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://dormbell-ce20b.appspot.com');
                    String id = Random().nextDouble().toString();
                    storageRef = storage.ref().child(id+'.jpg');
                    storageRef.putData(imgData);

                    final DocumentReference docRef = Firestore.instance.collection(user.uid).document(name);
                    docRef.get().then((snapshot) {
                      storageRef.getDownloadURL().then((url) => urls.add(url));
                      docRef.setData({'url': url}, merge: true);
                    });
                  });
                } else {
                  if (storageRef != null) storageRef.getDownloadURL().then(
                          (url) => Share.share(url, subject: roomName));
                }
              },
              child:
                  imgData == null ? Text("Create QR Code") : Text("Share Code"),
            )
          ],
        )));
  }
}
