import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  final bool silentSignIn;

  AuthPage({this.silentSignIn = false}) {
    if (silentSignIn) GoogleAuth().silentSignIn();
  }

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loading;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loading = false;
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      print("Auth State Changed For User: ${user.toString()}");
      if (user != null) {
        String topic = user.uid.substring(0, 10);
        print("Subscribed to topic: " + topic);
        FirebaseMessaging().subscribeToTopic(topic);
        FirebaseMessaging().configure(onMessage: (message) async {
          print(message.toString());
          ScaffoldState scaffoldState =
              Scaffold.of(context);
          if (scaffoldState != null) {
            scaffoldState.showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content:
                    Column(children: <Widget>[
                  Text(message['notification']['title']),
                  Text(message['notification']['body']),
                ])));
          } else
            print("Could not find scaffold to show message");
        });
        loading = false;
        Navigator.of(context).pushNamed('/RingBellPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(50.0),
                child: Image.asset("assets/logo.png",
                    width: 200.0, color: Theme.of(context).primaryColor)),
            loading
                ? CircularProgressIndicator()
                : Column(children: <Widget>[
                    RaisedButton.icon(
                        icon:
                            Image.asset("assets/googleLogo.png", height: 50.0),
                        label: Text("Sign In With Google",
                            style: TextStyle(color: Colors.grey)),
                        color: Colors.white,
                        onPressed: () {
                          setState(() => loading = true);
                          FirebaseAuth.instance.currentUser().then((user) {
                            if (user == null) {
                              GoogleAuth()
                                  .interactiveSignIn()
                                  .then((user) async {
                                loading = false;
                                Navigator.of(context)
                                    .pushNamed('/RingBellPage');
                              });
                            } else {
                              loading = false;
                              Navigator.of(context).pushNamed('/RingBellPage');
                            }
                          });
                        }),
                  ])
          ],
        )));
  }
}

class GoogleAuth {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> interactiveSignIn() async {
    FirebaseUser user;
    try {
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthResult result = await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
      user = result.user;
      print("User ${user.displayName} signed in with interface");
    } catch (error) {
      print("Silent sign in error: $error");
    }
    return user;
  }

  silentSignIn() async {
    GoogleSignInAccount googleUser = await googleSignIn.signInSilently();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthResult result = await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
      FirebaseUser user = result.user;
      print("User ${user.displayName} signed in silently");
    }
  }
}
