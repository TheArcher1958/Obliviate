import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hp_multiplayer_trivia/globals.dart';

import 'HomeScreen.dart';
import 'LoginScreen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  bool caught = false;
  @override
  void initState() {
    super.initState();
    print(caught);
    if(caught == true) {
      return;
    }


    Future.delayed(Duration(seconds: 1), () {
      if(!caught) {
        caught = true;
        FirebaseAuth.instance
            .authStateChanges()
            .listen((User user) {
          if (user == null) {
            print('User is currently signed out!');
            //Navigator.pushNamed(context, "/login");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            print('User is signed in!');
            globalUser = user;
            //Navigator.pushNamed(context, "/home");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff141e30), Color(0xff243b55)])
        ),
        //child:
      ),
    );
  }
}
