import 'package:flutter/material.dart';
import 'package:motivationalthoughts/auth/authentication.dart';

class HomePageAdmin extends StatefulWidget {
  HomePageAdmin({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


    );
  }
}
