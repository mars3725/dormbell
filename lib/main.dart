// Matt Mohandiss
//Benjamin Greenberg
//Daniel Troutman
//Tucker Miles....
import 'package:dormbell/HomePage.dart';
import 'package:dormbell/OtherPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc/nfc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(),
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.lightBlue,
          accentColor: Colors.redAccent.shade700,
          accentColorBrightness: Brightness.light,
        ),
        routes: <String, WidgetBuilder>{
          '/OtherPage': (BuildContext context) => OtherPage(),
        });
  }
}

