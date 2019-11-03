import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dormbell/code.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:qr/qr.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CodesListPage extends StatefulWidget {
  @override
  _CodesListPageState createState() => _CodesListPageState();
}

class _CodesListPageState extends State<CodesListPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
                child: Text("My Codes", style: TextStyle(fontSize: 24.0)))),
        body: FutureBuilder<QuerySnapshot>(future: FirebaseAuth.instance.currentUser().then((user) => Firestore.instance.collection(user.uid).getDocuments()),
        builder: (context, snapshot) => snapshot.hasData? ListView.separated(
            itemBuilder: (context, index) => Padding(padding: EdgeInsets.all(25), child:
            Center(child: GestureDetector(child: Text(snapshot.data.documents[index].documentID, style: TextStyle(fontSize: 32)),
            onTap: () => Navigator.of(context).pushNamed('/ShareCode', arguments: Code(
                roomName: snapshot.data.documents[index].documentID))))),
            separatorBuilder: (context, index) => Divider(),
            itemCount: snapshot.data.documents.length) : Center(child: CircularProgressIndicator())));
  }
}
