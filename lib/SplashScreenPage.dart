//import 'dart:html';
//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_demo/HomePage.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new HomePage(),
      title: Text(
        'Detector de Melanoma',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
      ),
      image: Image.asset("assets/splash.png"),
      photoSize: 170,
      backgroundColor: Colors.white,
      loaderColor: Colors.orange,
      loadingText: Text(
        'By Perez Saldivar \n TESE',
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );
  }
}
