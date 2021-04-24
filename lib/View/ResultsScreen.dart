import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';

import '../globals.dart';

class ResultsScreen extends StatefulWidget {
  final List myAnswers;
  final List opponentAnswers;
  final List ques;
  ResultsScreen(this.myAnswers,this.opponentAnswers,this.ques, {Key key}): super(key: key);
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with TickerProviderStateMixin {

  var cardVisible = true;
  var myAnswers;
  var opponentAnswers;
  var ques;

  Color getColorOfAnswer(text, i) {
    if(text == ques[i]['answer']) return Colors.green;
    else return Colors.red;
  }
  IconData getIconOfAnswer(text, i) {
    if(text == ques[i]['answer']) return Icons.check;
    else return Icons.clear;
  }

  List<IconData> getScoreIcon() {
    var score1 = getScoresResults()[0];
    var score2 = getScoresResults()[1];
    if(score1 == score2) {
      return [Icons.star, Icons.star];
    } else if (score1 > score2) {
      return [Icons.star, Icons.star_outline];
    } else {
      return [Icons.star_outline, Icons.star];
    }
  }

  List<Color> getScoreColor() {
    var score1 = getScoresResults()[0];
    var score2 = getScoresResults()[1];
    if(score1 == score2) {
      return [Colors.green, Colors.green];
    } else if (score1 > score2) {
      return [Colors.green, Colors.red];
    } else {
      return [Colors.red, Colors.green];
    }
  }

  List<int> getScoresResults() {
    var myScore = 0;
    var opponentsScore = 0;
    for(var i = 0; i < ques.length; i++) {
      if(myAnswers[i] == ques[i]['options'].indexOf(ques[i]['answer']) && myAnswers[i] != -1) {
        myScore += 1;
      }
      if(opponentAnswers[i] == ques[i]['options'].indexOf(ques[i]['answer']) && opponentAnswers[i] != -1) {
        opponentsScore += 1;
      }
    }
    return [myScore, opponentsScore];
  }

  CollectionReference userDoc = FirebaseFirestore.instance.collection('matchmaking');
  Future<void> deleteMatchmakingDoc() {
    return userDoc
        .doc(globalUser.uid)
        .delete()
        .then((value) => {

    }).catchError((error) => print('Unable to delete document.'));
  }

  @override
    void initState() {
      myAnswers = widget.myAnswers;
      opponentAnswers = widget.opponentAnswers;
      ques = widget.ques;


      deleteMatchmakingDoc();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Results',style: TextStyle(fontSize: 22, fontFamily: 'Lumos')),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xff141e30), Color(0xff243b55)])
        ),
        child: ListView(
          children: <Widget>[

            Visibility(
              visible: cardVisible,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Card(
                    color: Color(0xff1a2a47),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const ListTile(

                            leading: Icon(Icons.lightbulb, color: Colors.white,),
                            title: Text('Did you know?', style: TextStyle(color: Colors.white),),
                            subtitle: Text('Swipe each card to the right to see your result. Swipe to the left to see your opponents result.', style: TextStyle(color: Colors.white70)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text('Close', style: TextStyle(color: Colors.white)),
                              onPressed: () {setState(() {
                                cardVisible = false;
                              });},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 70,
              child: Slidable(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Color(0xff141e30),
                    child: ListTile(
                      title: Text(
                        'Scores',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  ),
                ), actionPane: SlidableScrollActionPane(),
                actions: [
                  IconSlideAction(
                    caption: getScoresResults()[0].toString() + '/' + ques.length.toString(),
                    icon: getScoreIcon()[0],
                    color: getScoreColor()[0],
                    closeOnTap: false,
                  )
                ],
                secondaryActions: [
                  IconSlideAction(
                    icon: getScoreIcon()[1],
                    color: getScoreColor()[1],
                    caption: getScoresResults()[1].toString() + '/' + ques.length.toString(),
                    closeOnTap: false,
                  )
                ],
              ),
            ),

            for (var index in [for(var i=0; i<10; i+=1) i])
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Slidable(
                actionExtentRatio: 2/5,
                child: Container(
//                          height: 60,
                  color: Color(0xff141e30),
                  child: ListTile(
//                          tileColor: Color(0xff141e30),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ques[index]['question'],
//                              overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  ),
                ), actionPane: SlidableScrollActionPane(),
                actions: [
                  IconSlideAction(
                    caption: myAnswers[index] != -1 ? ques[index]['options'][myAnswers[index]] : 'N/A',
                    color: getColorOfAnswer(myAnswers[index] != -1 ? ques[index]['options'][myAnswers[index]] : 'N/A', index),
                    closeOnTap: false,
                    icon: getIconOfAnswer(myAnswers[index] != -1 ? ques[index]['options'][myAnswers[index]] : 'N/A', index),
                  )
                ],
                secondaryActions: [
                  IconSlideAction(
                    color: getColorOfAnswer(opponentAnswers[index] != -1 ? ques[index]['options'][opponentAnswers[index]] : 'N/A', index),
                    caption: opponentAnswers[index] != -1 ? ques[index]['options'][opponentAnswers[index]] : 'N/A',
                    closeOnTap: false,
                    icon: getIconOfAnswer(opponentAnswers[index] != -1 ? ques[index]['options'][opponentAnswers[index]] : 'N/A', index),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
