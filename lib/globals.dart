import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:hp_multiplayer_trivia/View/LoadingScreen.dart';

User globalUser;
//Color darker_blue = Color(0xff141e30);
//Color mild_blue = Color(0xff243b55);
Map<int, Color> color = {
  50:Color.fromRGBO(136, 14, 79, .1),
  100:Color.fromRGBO(136, 14, 79, .2),
  200:Color.fromRGBO(136, 14, 79, .3),
  300:Color.fromRGBO(136, 14, 79, .4),
  400:Color.fromRGBO(136, 14, 79, .5),
  500:Color.fromRGBO(136, 14, 79, .6),
  600:Color.fromRGBO(136, 14, 79, .7),
  700:Color.fromRGBO(136, 14, 79, .8),
  800:Color.fromRGBO(136, 14, 79, .9),
  900:Color.fromRGBO(136, 14, 79, 1),
};
Map<int, Color> color2 = {
  50:Color.fromRGBO(136, 14, 79, .1),
  100:Color.fromRGBO(136, 14, 79, .2),
  200:Color.fromRGBO(136, 14, 79, .3),
  300:Color.fromRGBO(136, 14, 79, .4),
  400:Color.fromRGBO(136, 14, 79, .5),
  500:Color.fromRGBO(136, 14, 79, .6),
  600:Color.fromRGBO(136, 14, 79, .7),
  700:Color.fromRGBO(136, 14, 79, .8),
  800:Color.fromRGBO(136, 14, 79, .9),
  900:Color.fromRGBO(136, 14, 79, 1),
};
MaterialColor mild_blue = MaterialColor(0xff243b55, color);
MaterialColor darker_blue = MaterialColor(0xff141e30, color2);

double good_width = 392.7;
double good_height = 807.2;

double convW(before, context) {
  double modifier = before / good_width;
  return MediaQuery.of(context).size.width * modifier;
}
double convH(before, context) {
  double modifier = before / good_height;
  return MediaQuery.of(context).size.height * modifier;
}

//Future<bool> checkConnection(context) async {
//  var connection = await getConnectivity();
//  if(connection == false) {
//    _displayNoInternet(context);
//    return false;
//  } else {
//    return true;
//  }
//}
//
//Future<bool> getConnectivity() async {
//  try {
//    final result = await InternetAddress.lookup('example.com');
//    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//      print('Connected to example.com');
//      return true;
//    }
//  } on SocketException catch (_) {
//    return false;
//  }
//}



Future<void> displayNoInternet(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black26,
        title: const Text('Connection Failure', style: TextStyle(color: Colors.white),),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Unable to establish a connection.', style: TextStyle(color: Colors.white)),
              Text('Please make sure you are connected to the internet.', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

