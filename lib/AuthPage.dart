import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:squaad/Backend.dart';
import 'package:squaad/data/UserData.dart';
import 'package:squaad/pages/CreateProfilePage.dart';

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

  @override
  void initState() {
    super.initState();
    loading = false;

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      print("Auth State Changed For User: ${user.toString()}");
      if (user != null) {
        Backend.getUserData().then((userData) {
          if (userData != null) {
            updateMetadata(userData).whenComplete(() {
              print("PRESENTING MAIN");
              setState(() => loading = false);
              Navigator.of(context).pushNamed('/MainRoute');
            });
          }
        });
      }
    });
  }

  Future updateMetadata(UserData userData) async {
    try {
      var location = await Location().getLocation();
      userData.location = Geohash.encode(
          location['latitude'], location['longitude'],
          codeLength: 6);
    } catch (PlatformException){
      print('Could not update location');
    }
    userData.loginTimestamp = DateTime.now();
    return userData.setLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(50.0),
                child: Image.asset("assets/logo.png",
                    width: 200.0, color: Theme.of(context).primaryColor)),
            loading? CircularProgressIndicator() :
            Column(children: <Widget>[
              RaisedButton.icon(
                  icon: Image.asset("assets/googleLogo.png", height: 50.0),
                  label: Text("Sign In With Google",
                      style: TextStyle(color: Colors.grey)),
                  color: Colors.white,
                  onPressed: () {
                    setState(() => loading = true);
                    GoogleAuth().interactiveSignIn().then((user) async {
                      if ((await Backend.getUserData()) == null) {
                        setState(() => loading = false);
                        print("CREATING USER");
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CreateProfilePage(user)));
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
      GoogleSignInAccount googleUser =
      await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      user = await FirebaseAuth.instance.signInWithGoogle(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
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

      FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      print("User ${user.displayName} signed in silently");
    }
  }
}

class TwitterAuth {
  //TODO: Implement twitter authentication
}

class FacebookAuth {
  //TODO: Implement facebook authentication
}
