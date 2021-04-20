import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hp_multiplayer_trivia/View/SearchingForMatchScreen.dart';
import 'package:hp_multiplayer_trivia/globals.dart';

class GamemodesScreen extends StatefulWidget {
  @override
  _GamemodesScreenState createState() => _GamemodesScreenState();
}

grabQuestion() {
  CollectionReference questions = FirebaseFirestore.instance.collection('questions');
  questions.get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["question"]);
    });
  });
}


CollectionReference matches = FirebaseFirestore.instance.collection('matchmaking');
Future<void> addUser() {
  return matches
      .doc(globalUser.uid)
      .set({
    'userID': globalUser.uid,
    'rank': 0,
    'gameID': 'none',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  })
      .then((value) =>
      print("User Added")
  ).catchError((error) => print("Failed to add user: $error"));
}



class _GamemodesScreenState extends State<GamemodesScreen> {
  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              grabQuestion();
            },
            child: Text('Demo'),
          ),
          ElevatedButton(
            onPressed: () async {
              await addUser();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchingScreen()),
              );
            },
            child: Text('Matching'),
          ),
        ],
      ),
    );
  }
}
