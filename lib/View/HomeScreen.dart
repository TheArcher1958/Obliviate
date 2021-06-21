import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hp_multiplayer_trivia/View/CreditsScreen.dart';
import 'package:hp_multiplayer_trivia/View/GamemodesScreen.dart';
import 'package:hp_multiplayer_trivia/View/GetInvolvedScreen.dart';
import 'package:hp_multiplayer_trivia/View/LeaderboardsScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart';
import 'LoadingScreen.dart';
import 'SettingsScreen.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 1;
  List<Widget> listScreens;

  void _launchURL(_url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    listScreens = [
      LeaderBoardsScreen(),
      GamemodesScreen(),
      SettingsScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) => {
      Future.delayed(Duration(milliseconds: 500)).then((_) {

        if (globalUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xff303c42),
            content: Text(
              !globalUser.isAnonymous
                  ? 'Logged in as ${globalUser.displayName}'
                  : 'Logged in as Guest',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ));
        }
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Obliviate',style: TextStyle(fontSize: convW(40,context))),
        elevation: 0,
      ),
      body: listScreens[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          currentIndex: tabIndex,
          onTap: (int index) {
            if (this.mounted) {
              setState(() {
                tabIndex = index;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              label: 'Play',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ]),
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff141e30), Color(0xff243b55)]
            ),
          ),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                color: Colors.amber,
                  image: DecorationImage(image: AssetImage("images/Logo.png"),scale: convH(4.5,context),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              SizedBox(height: convH(10,context),),
              ListTile(
                leading: Icon(Icons.person_remove, color: Colors.white,),
                title: Text('Sign Out',style: TextStyle(fontSize: convW(16,context), color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                  if(globalUser.isAnonymous) {
                    FirebaseAuth.instance.signOut();
                  } else {
                    GoogleSignIn().signOut();
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoadingScreen()),
                  );
                },
              ),
//              ListTile(
//                leading: Icon(Icons.info, color: Colors.white,),
//                title: Text('App Info',style: TextStyle(fontSize: 16, color: Colors.white, )),
//                onTap: () {
//                  Navigator.of(context).pop();
//                },
//              ),
              ListTile(
                leading: Icon(Icons.public, color: Colors.white,),
                title: Text('Get Involved',style: TextStyle(fontSize: convW(16,context), color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetInvolvedScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.people, color: Colors.white,),
                title: Text('Credits',style: TextStyle(fontSize: convW(16,context), color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreditsScreen()),
                  );
                },
              ),
//              ListTile(
//                leading: Icon(Icons.security, color: Colors.white,),
//                title: Text('Privacy Policy',style: TextStyle(fontSize: 16, color: Colors.white, )),
//                onTap: () {
//                  Navigator.of(context).pop();
//                },
//              ),
              ListTile(
                leading: Image(image: AssetImage('images/Discord-Logo-White.png'), width: convW(28,context),),
                title: Text('Join Our Discord',style: TextStyle(fontSize: convW(16,context), color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                  _launchURL('https://discord.gg/P28VVMQBja');
                },
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.white,),
                title: Text('Rate Us',style: TextStyle(fontSize: convW(16,context), color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                  _launchURL('https://discord.gg/P28VVMQBja');
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
