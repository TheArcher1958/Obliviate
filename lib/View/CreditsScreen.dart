import 'package:flutter/material.dart';
import 'package:hp_multiplayer_trivia/globals.dart';

class CreditsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff141e30), Color(0xff243b55)]
            )
        ),
        child: Center(
          child: Text('Coming Soon', style: TextStyle(fontSize: convW(25, context), color: Colors.white, fontFamily: 'Lumos'),),
        ),
      ),
    );
  }
}
