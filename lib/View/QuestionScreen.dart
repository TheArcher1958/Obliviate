import 'package:flutter/material.dart';
import '../Model/QuestionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../globals.dart';


class QuestionScreen extends StatefulWidget {
  final String gameID;
  QuestionScreen(this.gameID, {Key key}): super(key: key);
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {
  var counter = 0;
  var iAnswered = false;
  var buttonsLocked = false;
  var ques = [];
  var myAnswers = [];
  var opponentAnswers = [];
  var _controller;
  var animation;
  DocumentReference gameStream;
  var buttonColors = [Colors.black26,Colors.black26,Colors.black26,Colors.black26];

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween(
        begin: 0.0,
        end: 1.0
    ).animate(_controller);

    print('gameID: ' + widget.gameID);

    gameStream = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    gameStream.snapshots().listen((querySnapshot) {
      var playerIDs = querySnapshot.data()['playersIds'];
      print(counter);

      var opponentsID = playerIDs[0] == globalUser.uid ? playerIDs[1] : playerIDs[0];

      // optimize this better in the future?
      opponentAnswers = (querySnapshot.data()['answers'][opponentsID]);
      ensureOpponentAnswered();
      if(ques.length == 0 || ques.isEmpty) {
        setState(() {
          ques = querySnapshot.data()['questions'];
        });
      }

    });
    super.initState();
  }


  void ensureOpponentAnswered() {
    if(opponentAnswers != null) {
      if (opponentAnswers.length == counter + 1 &&
          myAnswers.length == counter + 1 && iAnswered == false) {
        iAnswered = true;
        Future.delayed(Duration(seconds: 1), () {
          _controller.value = 0.0;
          setState(() {
            print('switching it up!');
            counter += 1;
            iAnswered = false;
            buttonsLocked = false;
            buttonColors =
            [Colors.black26, Colors.black26, Colors.black26, Colors.black26];
          });
        });
      }
    }
  }

  void switchQuestion(optionText, i) {
    setState(() {
      buttonsLocked = true;
    });
    if(optionText == ques[counter]['answer']) {
      setState(() {
        buttonColors[i] = Colors.green;
      });
    } else {
      setState(() {
        buttonColors[i] = Colors.red;
      });
    }
    myAnswers.add(i);
    gameStream.update({'answers.' + globalUser.uid: myAnswers})
        .then((value) => ensureOpponentAnswered())
        .catchError((error) => print("Failed to update user: $error"));
  }




  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(ques.length == 0 || ques.isEmpty) {
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
    } else {
      _controller.forward();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
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
              children:
              [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: Padding(
                    key: ValueKey<int>(counter),
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(ques[counter]['question'],
                          style: TextStyle(color: Colors.white, fontSize: 22,),),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Column(
                  children: new List.generate(
                    ques[counter]['options'].length, (i) =>
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (Widget child,
                            Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: Padding(key: ValueKey<int>(counter),
                          padding: const EdgeInsets.all(14.0),
                          child: SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: AnimatedContainer(
                              color: buttonColors[i],
                              duration: Duration(milliseconds: 300),
                              child: ElevatedButton(style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(Colors.transparent)),
                                  onPressed: () {
                                    if (!buttonsLocked) {
                                      switchQuestion(
                                          ques[counter]['options'][i], i);
                                    } else {
                                      return null;
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 14, 8, 14),
                                    child: Text(ques[counter]['options'][i],
                                      style: TextStyle(fontSize: 17),),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),),
                ),
              ],
            ),
          ),
        ),
      );
    }

  }
}
