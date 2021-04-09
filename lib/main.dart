
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hp_multiplayer_trivia/HomeScreen.dart';
import 'package:hp_multiplayer_trivia/LoginScreen.dart';
import 'package:hp_multiplayer_trivia/RegisterScreen.dart';
import 'package:hp_multiplayer_trivia/LoadingScreen.dart';
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
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: "Hind",color: Colors.white),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: "Hind",color: Colors.white),
        ),
//        textTheme: TextTheme(
//          headline6: TextStyle(fontSize: 72.0, fontFamily: "HP"),
//          headline1: TextStyle(fontSize: 72.0, fontFamily: "HP"),
//          bodyText2: TextStyle(fontSize: 14.0, fontFamily: "Hind"),
//        ),
      ),
      home: HomeScreen(),
      routes: {
        //'/homeTab': (context) => FirstScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/loading': (context) => LoadingScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Column(children: [
                      Text(document.data()['name']),
                      Text(document.data()['age']),
                    ],);
                  }).toList(),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Loading Screen'),
            )
          ],
        ),
      ),
    );
  }
}