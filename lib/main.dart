import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hp_multiplayer_trivia/View/HomeScreen.dart';
import 'package:hp_multiplayer_trivia/View/LoginScreen.dart';
import 'package:hp_multiplayer_trivia/View/QuestionScreen.dart';
import 'package:hp_multiplayer_trivia/View/RegisterScreen.dart';
import 'package:hp_multiplayer_trivia/View/LoadingScreen.dart';
import 'package:hp_multiplayer_trivia/globals.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Firebase Analytics Demo',
      theme: ThemeData(
//        brightness: Brightness.dark,
        accentColor: mild_blue,
        primarySwatch: darker_blue,
//        scaffoldBackgroundColor: mild_blue,
        fontFamily: 'Hind',
        primaryTextTheme: TextTheme(
          headline6: TextStyle(fontSize: 40.0, fontFamily: "HP",color: Colors.white),
          headline1: TextStyle(fontSize: 65.0, fontFamily: "HP"),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: "Dum1",color: Colors.white),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: "Dum1",color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/': (context) => LoadingScreen(),
      },
    );
  }
}
