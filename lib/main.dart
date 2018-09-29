// Matt Mohandiss
//Benjamin Greenberg
//Daniel Troutman
//Tucker Miles....
import 'package:dormbell/CreateCodePage.dart';
import 'package:dormbell/HomePage.dart';
import 'package:dormbell/RingBellPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: CameraPage(),
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.lightBlue,
          accentColor: Colors.redAccent.shade700,
          accentColorBrightness: Brightness.light,
        ),
        routes: <String, WidgetBuilder>{
          '/CreateCodePage': (BuildContext context) => CreateCodePage(),
          '/RingBellPage': (BuildContext context) => CameraPage(),
        });
  }
}

