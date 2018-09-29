import 'package:flutter/material.dart';

class RingBellPage extends StatefulWidget {
  @override
  _RingBellPageState createState() => _RingBellPageState();
}

class _RingBellPageState extends State<RingBellPage> {
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
            Text("Ring Bell")
          ],
        )));
  }
}