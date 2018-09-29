import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  final bool silentSignIn;
  AuthPage({this.silentSignIn = false}) {
    if (silentSignIn) GoogleAuth().silentSignIn();
  }

  @override
  _AuthPageState createState() => _AuthPageState();
}