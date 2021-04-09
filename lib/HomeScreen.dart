import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Obliviate'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff141e30), Color(0xff243b55)])
          ),
          child: Column(
            children: [
              Text('Hi')
            ],
          ),
        ),
      ),
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
          ],
        ),
      ),
    );
  }
}
