import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            Expanded(child: Padding(padding: EdgeInsets.all(25.0),
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/CreateCodePage'),
                  child: Text("Create Bell"),))),
            Expanded(child: Padding(padding: EdgeInsets.all(25.0),
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/RingBellPage'),
                  child: Text("Ring Bell"),)))
          ],
        )));
  }
}