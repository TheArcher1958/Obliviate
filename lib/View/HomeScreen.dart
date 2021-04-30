import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hp_multiplayer_trivia/View/GamemodesScreen.dart';
import 'package:hp_multiplayer_trivia/View/GetInvolvedScreen.dart';
import 'package:hp_multiplayer_trivia/View/LeaderboardsScreen.dart';
import 'package:hp_multiplayer_trivia/View/questionTestScreen.dart';
import '../globals.dart';
import 'SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 1;
  List<Widget> listScreens;

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
        title: Text('Obliviate',style: TextStyle(fontSize: 40)),
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
                  image: DecorationImage(image: AssetImage("images/Logo.png"),scale: 5.0,
                    fit: BoxFit.none,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.person_remove, color: Colors.white,),
                title: Text('Sign Out',style: TextStyle(fontSize: 16, color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.white,),
                title: Text('App Info',style: TextStyle(fontSize: 16, color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.white,),
                title: Text('Rate Us',style: TextStyle(fontSize: 16, color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.people, color: Colors.white,),
                title: Text('Get Involved',style: TextStyle(fontSize: 16, color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.people, color: Colors.white,),
                title: Text('Credits',style: TextStyle(fontSize: 16, color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.security, color: Colors.white,),
                title: Text('Privacy Policy',style: TextStyle(fontSize: 16, color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Image(image: AssetImage('images/Discord-Logo-White.png'), width: 28,),
                title: Text('Join Our Discord',style: TextStyle(fontSize: 16, color: Colors.white, )),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
