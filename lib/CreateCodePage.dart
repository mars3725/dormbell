import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateCodePage extends StatefulWidget {
  @override
  _CreateCodePageState createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  String location = "Location";
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
                  Text("Location:"),
                  Flexible(child: TextField(controller: TextEditingController(text: location) ,onChanged: (value) {
                    location = value;
                    },
                  )),
                ]
            )),
        Padding(padding: EdgeInsets.all(25.0), child: Row(
                children: <Widget>[
                  Text("Name:"),
                  Flexible(child: TextField(controller: TextEditingController(text: name) ,onChanged: (value) {
                    name = value;
                    },
                  )),
                ]
            )),
            FlatButton(
              onPressed: () {
                setState(() {
                  qrCode = QrImage(
                    data: "Location: " + location + "\nName: " + name,
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