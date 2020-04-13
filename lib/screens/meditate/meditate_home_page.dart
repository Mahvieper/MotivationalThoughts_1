import 'package:flutter/material.dart';

import 'screens/homepage.dart';

class MeditatePage extends StatefulWidget {
  MeditatePage({Key key, this.isAdmin})
      : super(key: key);

  final bool isAdmin;
  @override
  _MeditatePageState createState() => _MeditatePageState();
}

class _MeditatePageState extends State<MeditatePage> {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(isAdmin: widget.isAdmin,);
  }
}
