import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hp_multiplayer_trivia/View/HomeScreen.dart';
import 'package:hp_multiplayer_trivia/View/QuestionScreen.dart';
import 'package:hp_multiplayer_trivia/globals.dart';

class SearchingScreen extends StatefulWidget {
  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {

  void initState() {
    super.initState();

  }

  CollectionReference userDoc = FirebaseFirestore.instance.collection('matchmaking');

  Future<void> cancelMatchmaking() {
    return userDoc
        .doc(globalUser.uid)
        .delete()
        .then((value) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          )
    }).catchError((error) => print('Unable to delete document.'));
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('matchmaking').doc(globalUser.uid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.exists) {
          var userDocument = snapshot.data;
          //print(userDocument.data().containsKey('gameID'));

          if(userDocument['gameID'] != 'none') {
            print('Not none!');
            print('Document data: $userDocument');
            WidgetsBinding.instance.addPostFrameCallback((_){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QuestionScreen([])),
              );
            });

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
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
              CircularProgressIndicator(
                color: Colors.amber,
              ),
              ElevatedButton(onPressed: cancelMatchmaking, child: Text('Cancel'))
            ],
          ),
        );
      }
    );
  }
}
