import 'dart:typed_data';

import 'package:share/share.dart';
import 'package:flutter/material.dart';

import 'code.dart';

class CodeSharePage extends StatefulWidget {

  @override
  _CodeSharePageState createState() => _CodeSharePageState();
}

class _CodeSharePageState extends State<CodeSharePage> {
  Code code;

  @override
  Widget build(BuildContext context) {
    code = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
            title: Center(
                child: Text("Share Code", style: TextStyle(fontSize: 24.0)))),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.memory(Uint8List.fromList(code.imgData)),
                RaisedButton(
                  onPressed: () => Share.share(code.url, subject: code.roomName),
                  child: Text("Share Code"),
                )
              ],
            )));
  }
}
