
import 'package:flutter/material.dart';
import 'package:motivationalthoughts/auth/authentication.dart';

class HomePageUser extends StatefulWidget {
  HomePageUser({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
 /* Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot snapshot = await firestore.collection("itemOne").getDocuments();
    return snapshot.documents;
  }*/

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
