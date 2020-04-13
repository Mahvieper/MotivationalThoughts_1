import 'package:flutter/material.dart';

import 'auth/authentication.dart';
import 'screens/auth_screen.dart';
import 'screens/root_page.dart';
import 'screens/splash_screen.dart';

void main() => runApp(new MaterialApp(home:MyApp(),
  routes: <String, WidgetBuilder>{
    '/LoginPage': (BuildContext context) => new LoginPage(),
  '/RootPage': (BuildContext context) => new RootPage(auth: new Auth())
  },
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
  ),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}