import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hp_multiplayer_trivia/View/HomeScreen.dart';
import 'package:hp_multiplayer_trivia/View/QuestionScreen.dart';
import 'package:hp_multiplayer_trivia/globals.dart';

class SearchingScreen extends StatefulWidget {
  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> with WidgetsBindingObserver {

//  void initState() {
//    super.initState();
//
//  }

  CollectionReference userDoc = FirebaseFirestore.instance.collection('matchmaking');

  Future<void> cancelMatchmaking() {
    return userDoc
        .doc(globalUser.uid)
        .delete()
        .then((value) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          ),
      print('Canceled')
    }).catchError((error) => print('Unable to delete document.'));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void dispose() {
    cancelMatchmaking();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('State change detected! 🔨');
    print(state);
    if(state == AppLifecycleState.paused) {
      cancelMatchmaking();
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('matchmaking').doc(globalUser.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.exists) {
            var userDocument = snapshot.data;
            //print(userDocument.data().containsKey('gameID'));
            print(userDocument);
            if(userDocument['gameID'] != 'none') {
              print('Not none!');
              print('Document data: $userDocument');
              WidgetsBinding.instance.addPostFrameCallback((_){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionScreen(userDocument['gameID'])),
                );
              });

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff141e30), Color(0xff243b55)]
                  ),
                ),
              );
            }
          }
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xff141e30), Color(0xff243b55)])
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Searching For Opponent', style: TextStyle(fontSize: convW(24,context), color: Colors.white),),

                CircularProgressIndicator(
                  color: Colors.amber,
                ),
                ElevatedButton(onPressed: cancelMatchmaking, child: Text('Cancel'))
              ],
            ),
          );
        }
      ),
    );
  }
}
