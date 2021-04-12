import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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


