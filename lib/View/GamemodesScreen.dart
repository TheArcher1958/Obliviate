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
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff141e30), Color(0xff243b55)])
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
            child: Card(
              color: Color(0xff1a2a47),
              child: Padding(
                padding:  EdgeInsets.all(convW(8.0,context)),
                child: ListTile(

                  leading: Icon(Icons.lightbulb, color: Colors.amber,),
                  subtitle: Text('Multiplayer is the only mode right now, but more are coming soon!', style: TextStyle(color: Colors.white70,fontSize: convW(18,context))),
                ),
              ),
            ),
          ),

          SizedBox(height: convH(80,context),),

          SizedBox(
            width: convW(200,context),
            height: convH(70,context),
            child: ElevatedButton(
              style: ButtonStyle(elevation: MaterialStateProperty.all<double>(10.0),
                  backgroundColor: MaterialStateProperty.all<
                  Color>(Color(0xff6c59e6)),

              ),
              onPressed: () async {
                await addUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchingScreen()),
                );
              },
              child: Text('Multiplayer', style: TextStyle(fontSize: convW(24,context),fontWeight: FontWeight.bold),),
            ),
          ),

          SizedBox(height: convH(60,context),),

        ],
      ),
    );
  }
}
