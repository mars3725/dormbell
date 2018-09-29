import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateCodePage extends StatefulWidget {
  @override
  _CreateCodePageState createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  String title = "Title here";
  Widget qrCode = Container();
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
            TextField(textAlign: TextAlign.center, controller: TextEditingController(text: title) ,onChanged: (value) {
              title = value;
            },),
            FlatButton(
              onPressed: () {
                setState(() {
                  qrCode = QrImage(
                    data: title,
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