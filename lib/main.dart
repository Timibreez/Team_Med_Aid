import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//pages
import 'package:team_med/general/homePage.dart';
import 'package:team_med/session/splahScreen.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: Colors.lightBlueAccent[800],));
    return MaterialApp(theme: ThemeData(
        primarySwatch: Colors.lightBlue
      ),
      home:SplashScreenPage(),
    );
  }
}



  



