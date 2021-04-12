import 'package:flutter/material.dart';
import 'globals.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int tabIndex = 1;
  List<Widget> listScreens;

  @override
  void initState() {
    super.initState();
    listScreens = [
      Text('Account'),
      Text('Play'),
      Text('Settings'),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) => {
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        if (globalUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xff303c42),
            content: Text(globalUser.displayName != "" ? 'Logged in as ${globalUser.displayName}' : 'Logged in as Guest',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ));
        }
      }
      )
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Obliviate'),
        elevation: 0,
      ),
      body: listScreens[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
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
              icon: Icon(Icons.person),
              label: 'Account',
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
        child: Column(
          children: [
            TextButton(
              onPressed: () {Navigator.pushNamed(context, "/loading");},
              child: Text('LoadingScreen'),
            ),
            TextButton(
              onPressed: () {Navigator.pushNamed(context, "/login");},
              child: Text('LoginScreen'),
            ),
            TextButton(
              onPressed: () {Navigator.pushNamed(context, "/question");},
              child: Text('QuestionScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
