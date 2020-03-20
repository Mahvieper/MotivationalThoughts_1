import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(new MaterialApp(home:MyApp(),
  routes: <String, WidgetBuilder>{
    '/LoginPage': (BuildContext context) => new LoginPage()
  },
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
      primarySwatch: Colors.teal,
      backgroundColor: Colors.teal
  ),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}