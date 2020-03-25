import 'package:flutter/material.dart';
import 'package:motivationalthoughts/auth/authentication.dart';
import 'package:motivationalthoughts/screens/HomePageAdmin.dart';

import 'HomePageUser.dart';
import 'auth_screen.dart';


enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _userRole = "";
  String authUserEmail = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          authUserEmail = user?.email;
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        widget.auth.getCurrentUser().then((user) {
          setState(() {
            if (user != null) {
              authUserEmail = user?.email;
              _userId = user?.uid;
            }
            authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
          });
        });
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      authUserEmail = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return new LoginPage(
            auth: widget.auth,
            loginCallback: loginCallback,
        );
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {

          if(authUserEmail.contains("vmahesh161@gmail.com") || authUserEmail.contains("prdookie@gmail.com")) {
            return new HomePageAdmin(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          } else {
            return new HomePageUser(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          }

        }

        else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}